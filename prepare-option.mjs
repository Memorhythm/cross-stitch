import assert from 'node:assert/strict';
import {execFileSync} from 'node:child_process';
import {readFileSync,writeFileSync,mkdirSync,copyFileSync,readdirSync,statSync} from 'node:fs';
import {createHash} from 'node:crypto';
assert.equal(process.env.GITHUB_ACTIONS,'true');assert.equal(process.platform,'linux');
const run=(exe,args)=>execFileSync(exe,args,{encoding:'utf8',maxBuffer:64e6,stdio:['ignore','pipe','pipe']});
assert.equal(run('calcit',['-v']).trim(),'0.30.1');run('calcit',['docs','agents','--contract']);
const typeTree=v=>Array.isArray(v)?v[0]==='{}'?['{}',...v.slice(1).map(typeTree).sort((a,b)=>a[0].localeCompare(b[0]))]:v.map(typeTree):v;
const norm=v=>Array.isArray(v)?v.map(norm):v&&typeof v==='object'?Object.fromEntries(Object.entries(v).map(([k,x])=>[k,k==='__edn_set'?x.map(norm).sort((a,b)=>JSON.stringify(a).localeCompare(JSON.stringify(b))):k==='schema'?typeTree(x):norm(x)])):v;
const q=(...args)=>{const r=JSON.parse(run('calcit',['calcit.cirru','query',...args,'--format','json']));assert.deepEqual(r.diagnostics||[],[]);return norm(r.data);};
const p=JSON.parse(readFileSync('reviewed-source.json'));assert.equal(p.operations.length,2);assert.equal(p.before.defs.length,21);
const blob=()=>run('git',['hash-object','calcit.cirru']).trim(),guard=()=>{for(const[f,h]of Object.entries(p.ordinaryBlobs))assert.equal(run('git',['hash-object',f]).trim(),h,f);};
const views=()=>{const v={config:q('config'),namespaces:[],defs:[]};for(const ns of q('ns').namespaces){const info=q('ns',ns);v.namespaces.push(info);const names=run('calcit',['query','defs',ns]).split('\n').filter(x=>/^  \S/.test(x)).map(x=>x.trim().split(' ')[0]);assert.equal(names.length,info.definition_count);for(const n of names)v.defs.push(q('def',ns+'/'+n));}return v;};
mkdirSync('acceptance',{recursive:true});assert.equal(blob(),p.blob);guard();
const producer=q('def','respo.ffi.browser/query-selector'),field=(d,k)=>d.schema.find(x=>Array.isArray(x)&&x[0]===k)?.[1];
assert.deepEqual(field(producer,':args'),['[]',"'String"]);assert.equal(field(producer,':return')[0],'::');assert.equal(field(producer,':return')[1],"'Option");
writeFileSync('acceptance/option-producer.json',JSON.stringify(producer));writeFileSync('acceptance/unwrap-implementation.json',JSON.stringify(q('def','calcit.core/option:unwrap')));
writeFileSync('acceptance/operations.json',JSON.stringify(p.operations));const args=['edit','transaction','--file','acceptance/operations.json','--format','json'];
const preview=JSON.parse(run('calcit',[...args,'--dry-run']));assert.ok(preview.scoped_revision);assert.equal(blob(),p.blob);writeFileSync('acceptance/preview.json',JSON.stringify(preview));
function source(phase,expected){const v=views();writeFileSync('acceptance/'+phase+'-source.json',JSON.stringify(v));assert.deepEqual(v,norm(expected));const s=q('schema','app.main/render-app!');assert.deepEqual(typeTree(s.tree),typeTree(p.schemaInput));writeFileSync('acceptance/'+phase+'-schema.json',JSON.stringify(s));}
function gate(phase){
  const original=blob(),log=(name,args)=>{try{const text=run('calcit',args);writeFileSync('acceptance/'+phase+'-'+name,text);return text;}catch(e){writeFileSync('acceptance/'+phase+'-'+name,e.stdout||'');writeFileSync('acceptance/'+phase+'-'+name+'.stderr',e.stderr||'');throw e;}};
  assert.equal(JSON.parse(log('canonical.json',['edit','transaction','--code','[["edit","format"]]','--dry-run','--format','json'])).changed,false);
  const strict=JSON.parse(log('strict.json',['fix','--workflow','strict','--verify','--format','json']));assert.equal(strict.data.workflow.status,'passed');assert.deepEqual(strict.diagnostics,[]);
  const all=JSON.parse(log('all.json',['--check-only','--all-defs','--format','json']));assert.equal(all.data.status,'passed');assert.deepEqual(all.diagnostics||[],[]);
  log('public.json',['--check-only','--ns','app.main','--ns','app.schema','--ns','app.util','--ns','app.updater','--ns','app.comp.container','--summary-only','--format','json']);
  const tests=JSON.parse(log('tests.json',['test','--require-match','--summary-only','--format','json']));for(const k of ['selected','executed','passed'])assert.equal(tests[k],2);assert.equal(tests.failed,0);
  writeFileSync('acceptance/'+phase+'-build.log',run('yarn',['build']));
  const files=[];function visit(dir){for(const n of readdirSync(dir).sort()){const f=dir+'/'+n;if(statSync(f).isDirectory())visit(f);else if(f.endsWith('.mjs'))files.push({path:f,sha256:createHash('sha256').update(readFileSync(f)).digest('hex')});}}visit('js-out');writeFileSync('acceptance/'+phase+'-js.json',JSON.stringify(files));
  if(phase==='after'){const old=JSON.parse(readFileSync('acceptance/before-js.json'));assert.deepEqual(files.map(f=>f.path),old.map(f=>f.path));const changed=files.filter((f,i)=>f.sha256!==old[i].sha256).map(f=>f.path);assert.ok(changed.every(f=>f==='js-out/app.main.mjs'));writeFileSync('acceptance/changed-js.json',JSON.stringify(changed));}
  guard();assert.equal(blob(),original);
}
source('before',p.before);gate('before');source('before',p.before);guard();assert.equal(blob(),p.blob);
writeFileSync('acceptance/applied.json',run('calcit',[...args,'--expect-revision',preview.scoped_revision]));source('after',p.expected);gate('after');source('after',p.expected);guard();
writeFileSync('acceptance/summary.json',JSON.stringify({repo:p.repo,base:p.base,beforeBlob:p.blob,afterBlob:blob(),definitions:21,namespaces:7,changedDefinitions:1,operations:2,nativeTestsBeforeAndAfter:2,ordinaryFilesPreserved:Object.keys(p.ordinaryBlobs).length,limits:p.limits}));
mkdirSync('prepared-source',{recursive:true});copyFileSync('calcit.cirru','prepared-source/calcit.cirru');

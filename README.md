
Cross Stitch
----

演示页面：http://repo.tiye.me/jiyinyiyong/cross-stitch/

### 本轮使用者影响

挂载点查询改用 Option 的 `.unwrap` 方法，不再显式调用内部 `option:unwrap`。
查询目标、缺少挂载点时的抛错、DOM/SVG 渲染和表格交互不变；不增加 fallback、
强转或新依赖，继续使用正式 Calcit/procs 0.30.1，不发布新版本。
现有 Demo 的存档写入/恢复缺口另见 [#14](https://github.com/Memorhythm/cross-stitch/issues/14)，
本次不修改存储策略，也不把写法维护当作该问题已解决。

### 开发与验证

项目使用 Respo 原生 DOM/SVG 渲染，无需 React 或 ReactDOM。当前 Calcit CLI / procs 配对为正式 **0.30.1**，Node.js 24 与 Yarn 4.18.0；依赖采用精确正式 Respo 0.16.124、UI 0.8.0 与 js-ffi 0.2.5。浏览器随机数、存储和事件通过 `js-ffi.browser` 调用，挂载点使用 Respo 自身的 DOM 接口；SVG 直接使用公共 `create-element`，不把 Element 或属性 Map 强转成 Component / DomProps。

更新依赖后执行 `caps --strict --ci`、`caps verify --toolchain` 和 `yarn install --immutable`。使用 `calcit test --require-match` 运行原定义附带测试，`yarn dev` 先编译再启动 Vite，修改 Calcit 时在另一终端运行 `yarn watch`，无需 concurrently。`yarn build` 编译一次并读取 `VITE_BASE_URL`（默认相对路径），`yarn release` 强制相对路径并完成编译，不依赖残留 js-out。

仅维护 `calcit.cirru` / `deps.cirru`，CI 禁止 compact/package 回流。生产 CDN 前缀和原服务器 `dist/*` 路径不变，PR 使用 `pr/<编号>/<run>/<attempt>/` 隔离。COS Action v1.2.0 内置 verify 校验公开内容和 HTML 引用，不新增项目校验脚本。上传排队、不取消；生产发布前检查当前 main，过期构建同时跳过 COS 和服务器同步。CI 检查 canonical、全部定义、完整 strict、公开合同及原测试。本次本地验收未运行 Caps；开发者仍须按上述步骤安装依赖以创建模块链接，CI 独立解析依赖。

### 许可协议

MIT


Cross Stitch
----

演示页面：http://repo.tiye.me/jiyinyiyong/cross-stitch/

### 开发与验证

项目基于 [calcit-reacher-workflow](https://github.com/mvc-works/calcit-reacher-workflow)，使用正式 Calcit/procs 0.27.0、Node.js 24 与 Yarn 4.18.0。浏览器 DOM、事件、存储和随机数通过 `js-ffi.browser` 调用；保留在 `:js-ffi` 内的接口只用于 Respo SVG 元素集成。

更新依赖后执行 `caps --strict --ci`、`caps verify --toolchain` 和 `yarn install --immutable`。使用 `calcit test --require-match` 运行原定义附带测试，`yarn dev` 先编译再启动 Vite，修改 Calcit 时在另一终端运行 `yarn watch`，无需 concurrently。`yarn build` 编译一次并读取 `VITE_BASE_URL`（默认相对路径），`yarn release` 强制相对路径并完成编译，不依赖残留 js-out。

仅维护 `calcit.cirru` / `deps.cirru`，CI 禁止 compact/package 回流。生产 CDN 前缀和原服务器 `dist/*` 路径不变，PR 使用 `pr/<编号>/<run>/<attempt>/` 隔离。COS Action v1.2.0 内置 verify 校验公开内容和 HTML 引用，不新增项目校验脚本。上传排队、不取消；生产发布前检查当前 main，过期构建同时跳过 COS 和服务器同步。CI 保留 canonical、入口、公开合同及原测试，不重复运行迁移诊断。

### 许可协议

MIT

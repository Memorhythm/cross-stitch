Cross Stitch
----

演示页面：http://repo.tiye.me/jiyinyiyong/cross-stitch/

### 本轮使用者影响

开发和 CI 工具链升级为正式 Calcit / procs **0.32.1**，同步新的类型标注语法。原有 SVG 图案、Change 按钮、名义 `Op` 入口和存储行为保留，不发布新的项目版本。渲染回调增加明确的 `Op -> Unit` 类型适配，仍转交原有受检 dispatch，不把入口放宽为 Dynamic。

现有 Demo 的存档写入/恢复缺口另见 [#14](https://github.com/Memorhythm/cross-stitch/issues/14)，本次不修改存储策略，也不把迁移当作该问题已解决。

### 开发与验证

项目使用 Respo 原生 DOM/SVG 渲染，无需 React 或 ReactDOM。使用 Node.js 24、Yarn 4.18.0，直接依赖为精确正式 Respo 0.17.1、UI 0.9.0、js-ffi 0.2.9；其已发布依赖图仍包含 Router 0.9.0-alpha.4，不声称整个依赖图已全部转为正式版。浏览器随机数、存储和事件通过 `js-ffi.browser` 调用，挂载点使用 Respo 自身的 DOM 接口；SVG 直接使用公共 `create-element`，不把 Element 或属性 Map 强转成 Component / DomProps。

更新依赖后执行 `caps --strict --ci`、`caps verify --toolchain` 和 `yarn install --immutable`。npm 新解析版本的等待时间为 60 分钟，不设置单包豁免；已有锁定版本不会重新计算等待时间。使用 `calcit test --require-match` 运行原定义附带测试，`yarn dev` 先编译再启动 Vite，修改 Calcit 时在另一终端运行 `yarn watch`，无需 concurrently。`yarn build` 编译一次并读取 `VITE_BASE_URL`（默认相对路径），`yarn release` 强制相对路径并完成编译，不依赖残留 js-out。

本轮本地已通过 Caps 严格解析与工具链校验、immutable 安装、canonical、144 项全定义检查、完整 strict、17 项公开定义检查及原有两项测试。相对路径构建及实际浏览器显示、Change 回调和刷新已验收：页面显示 64 个网格与 2048 条 SVG 线段，控制台无警告或错误；未验收真实存档。原来的 `:version` updater 分支仍返回原 Store，不将按钮验收描述为新增业务状态变更。

仅维护 `calcit.cirru` / `deps.cirru`，CI 禁止 compact/package 回流。生产 CDN 前缀和原服务器 `dist/*` 路径不变，PR 使用 `pr/<编号>/<run>/<attempt>/` 隔离。五个 Action 采用精确正式 tag；接受 tag 可移动的维护取舍。COS Action v1.2.0 内置 verify 校验公开内容和 HTML 引用，不新增项目校验脚本。上传排队、不取消；生产发布前检查当前 main，过期构建同时跳过 COS 和服务器同步。CI 保留 canonical、全部定义、完整 strict、公开合同及原测试。

上游函数类型兼容问题已附纯 core 最小复现报告到 [Calcit #2499](https://github.com/calcit-lang/calcit/issues/2499)。本项目使用显式类型适配，不修改编译器规则或降低门禁。

### 许可协议

MIT

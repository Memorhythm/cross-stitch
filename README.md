
Cross Stitch
----

演示页面：http://repo.tiye.me/jiyinyiyong/cross-stitch/

### 开发与验证

项目基于 [calcit-reacher-workflow](https://github.com/mvc-works/calcit-reacher-workflow)，使用 Calcit 0.24.3 和 `calcit-lang/js-ffi`。浏览器 DOM、事件、存储和随机数通过 `js-ffi.browser` 调用；保留在 `:js-ffi` 内的接口只用于 Respo SVG 元素集成。

更新依赖后执行 `caps --strict --ci`、`caps verify --toolchain` 和 `yarn install --immutable`。使用 `calcit calcit.cirru test --require-match` 运行定义附带的测试，使用 `calcit calcit.cirru js` 与 `yarn vite build --base=./` 检查浏览器产物。

### 许可协议

MIT

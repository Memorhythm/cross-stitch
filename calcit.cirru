
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |respo-ui.calcit/
      :type-slots $ {} $ :dispatch-op |app.schema/Op
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-container (store)
            let
                metrics $ :metrics store
              div
                {} $ :style ui/global
                comp-field metrics
                button
                  {} (:style ui/button)
                    :on-click $ fn (e d!)
                      d! $ Op :version
                  <> |Change
          :examples $ []
          :schema $ quote $ Fn app.schema/Store (-> respo.schema/Component)
        'comp-field $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-field (metrics)
            create-element :svg
              {} (:width |320) (:height |320)
                :style $ {} $ :cursor |none
              , & $ expand-grid (:grid-size metrics) (:grid-size metrics)
                fn (x y) (comp-sudoku metrics x y)
          :examples $ []
          :schema $ quote $ Fn app.schema/Metrics (-> respo.schema/Component)
        'comp-sudoku $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-sudoku (metrics x y)
            let
                cell-padding $ :cell-padding metrics
                cell-margin $ :cell-margin metrics
                cell-size $ :cell-size metrics
                stroke-size $ :stroke-size metrics
                stroke-width $ :stroke-width metrics
                duration $ :duration metrics
                bg-color $ :background-color metrics
                radius $ :radius metrics
                cell-length $ + (* 2 cell-padding) (* cell-size stroke-size)
                cell-area-length $ + cell-length $ * 2 cell-margin
                from-x $ * x cell-area-length
                from-y $ * y cell-area-length
                sx $ + from-x cell-padding cell-margin
                sy $ + from-y cell-padding cell-margin
                mk-lines $ fn (prefix offset)
                  hint-fn $ Fn String Number $ -> (List respo.schema/Element)
                  expand-grid cell-size cell-size $ fn (a b)
                    create-element :line $ {}
                      :key $ str prefix a |: b
                      :x1 $ + sx $ * (+ a offset) stroke-size
                      :y1 $ + sy $ * b stroke-size
                      :x2 $ + sx $ * stroke-size (+ a 1)
                      :y2 $ + sy $ * stroke-size (+ b 1)
                      :stroke |white
                      :strokeWidth stroke-width
                      :opacity $ random-opacity
                      :style $ {}
                        :transition-duration $ str duration |ms
                        :transition-timing-function |linear
                lines-a $ mk-lines | 0
                lines-b $ mk-lines |n- 1
                rect-el $ create-element :rect $ {}
                  :x $ + from-x cell-margin
                  :y $ + from-y cell-margin
                  :width cell-length
                  :height cell-length
                  :fill bg-color
                  :rx radius
              create-element :g
                {} $ :style $ {} (:cursor |none)
                , & $ concat ([] rect-el) lines-a lines-b
          :examples $ []
          :schema $ quote $ Fn app.schema/Metrics Number Number (-> respo.schema/Component)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require
            respo.core :refer $ defcomp div button <> create-element
            respo-ui.core :as ui
            app.util :refer $ expand-grid random-opacity
            app.schema :refer $ Op Metrics Store
    'app.config $ %{} 'FileEntry
      :defs $ {}
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def dev?
            = |dev $
              get-env |mode
              , .unwrap-or |release
          :examples $ []
          :schema $ quote Bool
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def site
            {} (:storage |cross-stitch) (:title "|Cross Stitch") (:icon |http://cdn.tiye.me/logo/mvc-works.png)
          :examples $ []
          :schema $ quote $ Map Tag String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *store schema/store
          :examples $ []
          :schema $ quote $ Ref app.schema/Store
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (raw-op)
            reset! *store $ updater @*store $ decode-map-as raw-op 'app.schema/Op
            , &unit
          :examples $ []
          :schema $ quote $ Fn Dynamic (-> Unit) (:features :js-ffi)
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! () (render-app!)
            add-watch! *store :changes $ fn (s prev) (render-app!)
            browser/add-event-listener! |beforeunload $ fn (_event) (persist-storage!)
            println "|App started."
          :examples $ []
          :schema $ quote $ Fn (-> Unit)
        'persist-storage! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn persist-storage! ()
            browser/storage-set! |cross-stitch $ format-cirru-edn @*store
          :examples $ []
          :schema $ quote $ Fn (-> Unit)
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! () (render-app!)
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :js-ffi)
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            let
                target $ .unwrap $ dom/query-selector |.app
              render-with! target
                fn () $ comp-container @*store
                fn (op)
                  hint-fn $ Fn app.schema/Op (-> Unit) (:features :js-ffi)
                  dispatch! op
          :examples $ []
          :schema $ quote $ Fn (-> Unit)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            app.updater :refer $ updater
            app.schema :as schema
            app.comp.container :refer $ comp-container
            respo.core :refer $ render-with!
            js-ffi.browser :as browser
            respo.ffi.browser :as dom
    'app.schema $ %{} 'FileEntry
      :defs $ {}
        'Metrics $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Metrics (:stroke-size 'Number) (:stroke-width 'Number) (:cell-margin 'Number) (:cell-padding 'Number) (:cell-size 'Number) (:grid-size 'Number) (:background-color 'String) (:duration 'Number) (:radius 'Number)
          :examples $ []
          :schema $ quote StructDef
        'Op $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum Op (:version) (:hydrate-storage 'app.schema/Store)
          :examples $ []
          :schema $ quote EnumDef
        'Store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Store (:metrics 'app.schema/Metrics)
          :examples $ []
          :schema $ quote StructDef
        'metrics $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def metrics
            Metrics :stroke-size 6 :stroke-width 2 :cell-margin 2 :cell-padding 4 :cell-size 4 :grid-size 8 :background-color "|rgb(214,6,38)" :duration 500 :radius 4
          :examples $ []
          :schema $ quote app.schema/Metrics
        'store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def store (Store :metrics metrics)
          :examples $ []
          :schema $ quote app.schema/Store
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.schema
    'app.updater $ %{} 'FileEntry
      :defs $ {} $ 'updater
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn updater (store op)
            match op
              (:version) store
              (:hydrate-storage data) data
              _ $ do (eprintln |Unknown-op: op) store
          :examples $ []
          :schema $ quote $ Fn app.schema/Store app.schema/Op (-> app.schema/Store)
          :tests $ [] $ %{} 'TestEntry (:name |typed-storage-hydration)
            :code $ quote $ let
                next-store $ Store :metrics $ Metrics :stroke-size 6 :stroke-width 2 :cell-margin 2 :cell-padding 4 :cell-size 4 :grid-size 4 :background-color "|rgb(214,6,38)" :duration 500 :radius 4
              assert= app.schema/store $ updater app.schema/store $ Op :version
              assert= next-store $ updater app.schema/store $ Op :hydrate-storage next-store
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
          :require $ app.schema :refer $ Op Store Metrics
    'app.util $ %{} 'FileEntry
      :defs $ {}
        'expand-grid $ %{} 'CodeEntry
          :doc "|按 x 外层、y 内层的稳定顺序生成网格结果；返回元素类型由回调决定，支持 Component 和原生 Element，不进行类型强转。"
          :code $ quote $ defn expand-grid (x y f)
            -> (range x)
              mapcat $ fn (xi)
                -> (range y)
                  map $ fn (yi) ([] xi yi)
              map $ fn (pair)
                f
                  .unwrap $ first pair
                  .unwrap $ last pair
          :examples $ []
          :schema $ quote $ Fn Number Number
            Fn Number Number $ -> T
            -> $ List T
            :generics T
          :tests $ [] $ %{} 'TestEntry (:name |coordinate-order-and-generic-results)
            :code $ quote $ do
              assert= ([] 0 1 10 11)
                expand-grid 2 2 $ fn (x y)
                  + (* x 10) y
              assert= ([] |00 |01 |10 |11)
                expand-grid 2 2 $ fn (x y) (str x y)
              assert= ([])
                expand-grid 0 2 $ fn (x y) (+ x y)
        'random-opacity $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn random-opacity ()
            if
              > (browser/random) 0.5
              , 1 0
          :examples $ []
          :schema $ quote $ Fn (-> Number)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.util
          :require $ js-ffi.browser :as browser

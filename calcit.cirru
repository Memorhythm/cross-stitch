
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!)
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
                      d! $ :: Op :version
                  , |Change
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] 'app.schema/Store
        'comp-field $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-field (metrics)
            hint-fn $ {}
              :args $ [] 'app.schema/Metrics
              :return 'respo.schema/Component
            svg-element :svg
              {} (:width |320) (:height |320)
                :style $ {} $ :cursor |none
              , & $ expand-grid (:grid-size metrics) (:grid-size metrics)
                fn (x y) (comp-sudoku metrics x y)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] 'app.schema/Metrics
        'comp-sudoku $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-sudoku (metrics x y)
            hint-fn $ {}
              :args $ [] 'app.schema/Metrics 'Number 'Number
              :return 'respo.schema/Component
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
                  hint-fn $ {}
                    :args $ [] 'String 'Number
                    :return $ :: 'List 'respo.schema/Component
                  expand-grid cell-size cell-size $ fn (a b)
                    svg-element :line $ {}
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
                rect-el $ svg-element :rect $ {}
                  :x $ + from-x cell-margin
                  :y $ + from-y cell-margin
                  :width cell-length
                  :height cell-length
                  :fill bg-color
                  :rx radius
              svg-element :g
                {} $ :style $ {} (:cursor |none)
                , & $ concat ([] rect-el) lines-a lines-b
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] 'app.schema/Metrics 'Number 'Number
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require
            respo.core :refer $ defcomp div button
            respo-ui.core :as ui
            app.util :refer $ expand-grid random-opacity svg-element
            app.schema :refer $ Op Metrics Store
    'app.config $ %{} 'FileEntry
      :defs $ {}
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def dev?
            = |dev $
              get-env |mode
              , .unwrap-or |release
          :examples $ []
          :schema $ :: 'Bool
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def site
            {} (:storage |cross-stitch) (:title "|Cross Stitch") (:icon |http://cdn.tiye.me/logo/mvc-works.png)
          :examples $ []
          :schema $ :: 'Map 'Tag 'String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defatom *store schema/store
          :examples $ []
          :schema $ :: 'Ref 'app.schema/Store
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op)
            reset! *store $ updater @*store op
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'app.schema/Op
            :features $ #{} :js-ffi
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! () (render-app!)
            add-watch *store :changes $ fn (s prev) (render-app!)
            js/window.addEventListener |beforeunload persist-storage!
            println "|App started."
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'persist-storage! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn persist-storage! ()
            .setItem js/localStorage |cross-stitch $ format-cirru-edn @*store
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! () (render-app!)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            let
                target $ js/document.querySelector |.app
              render-with! target
                fn () $ comp-container @*store
                , dispatch!
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            app.updater :refer $ updater
            app.schema :as schema
            app.comp.container :refer $ comp-container
            respo.core :refer $ render-with!
    'app.schema $ %{} 'FileEntry
      :defs $ {}
        'Metrics $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Metrics (:stroke-size 'Number) (:stroke-width 'Number) (:cell-margin 'Number) (:cell-padding 'Number) (:cell-size 'Number) (:grid-size 'Number) (:background-color 'String) (:duration 'Number) (:radius 'Number)
          :examples $ []
          :schema $ :: 'Enum
        'Op $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum Op (:version) (:hydrate-storage 'Dynamic)
          :examples $ []
          :schema $ :: 'Enum
        'Store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Store (:metrics 'app.schema/Metrics)
          :examples $ []
          :schema $ :: 'Enum
        'metrics $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def metrics
            Metrics :stroke-size 6 :stroke-width 2 :cell-margin 2 :cell-padding 4 :cell-size 4 :grid-size 8 :background-color "|rgb(214,6,38)" :duration 500 :radius 4
          :examples $ []
          :schema $ :: 'app.schema/Metrics
        'store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def store (Store :metrics metrics)
          :examples $ []
          :schema $ :: 'app.schema/Store
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
          :schema $ :: 'Fn $ {} (:return 'app.schema/Store)
            :args $ [] 'app.schema/Store 'app.schema/Op
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
    'app.util $ %{} 'FileEntry
      :defs $ {}
        'expand-grid $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn expand-grid (x y f)
            assert-type
              -> (range x)
                mapcat $ fn (xi)
                  hint-fn $ {}
                    :args $ [] 'Number
                    :return $ :: 'List $ :: 'List 'Number
                  -> (range y)
                    map $ fn (yi) ([] xi yi)
                map $ fn (pair) (f & pair)
              :: 'List 'respo.schema/Component
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'Number 'Number $ :: 'Fn
              {} (:return 'respo.schema/Component)
                :args $ [] 'Number 'Number
            :return $ :: 'List 'respo.schema/Component
        'random-opacity $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn random-opacity ()
            if
              > (.random js/Math) 0.5
              , 1 0
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ []
            :features $ #{} :js-ffi
        'return-component $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn return-component (x)
            hint-fn $ {}
              :args $ [] 'Dynamic
              :return 'respo.schema/Component
              :features $ #{} :js-ffi
            assert-type x 'respo.schema/Component
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] 'Dynamic
            :features $ #{} :js-ffi
        'svg-element $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn svg-element (tag props & children)
            hint-fn $ {}
              :args $ [] 'Tag 'Dynamic
              :rest 'Dynamic
              :return 'respo.schema/Component
            return-component $ create-element tag (svg-props props) & children
          :examples $ []
          :schema $ :: 'Fn $ {} (:rest 'Dynamic) (:return 'respo.schema/Component)
            :args $ [] 'Tag 'Dynamic
        'svg-props $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn svg-props (m)
            hint-fn $ {}
              :args $ [] 'Dynamic
              :return 'respo.schema/DomProps
              :features $ #{} :js-ffi
            assert-type m 'respo.schema/DomProps
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/DomProps)
            :args $ [] 'Dynamic
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.util
          :require $ respo.core :refer $ create-element

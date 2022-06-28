
{} (:package |app)
  :configs $ {} (:init-fn |app.main/main!) (:reload-fn |app.main/reload!) (:version |0.0.1)
    :modules $ [] |reacher/ |respo-ui.calcit/
  :entries $ {}
  :files $ {}
    |app.comp.container $ {}
      :defs $ {}
        |comp-container $ quote
          defn comp-container (props ? children)
            let
                store $ .-store props
                state $ .-state props
                dispatch! $ .-dispatch props
              div
                {} $ :style
                  merge ui/global $ {}
                div ({}) (comp-field state)
                button
                  {} (:style ui/button)
                    :onClick $ fn (event) (dispatch! :version nil)
                  , "\"Change"
        |comp-field $ quote
          defn comp-field (props ? children)
            let
                version $ .-version props
              tag* :svg
                {} (:width 320) (:height 320)
                  :style $ {} (:cursor "\"none")
                , & $ expand-grid (:grid-size metrics) (:grid-size metrics)
                  fn (x y)
                    wrap-comp comp-sudoku $ js-object (:x x) (:y y) (:version version)
        |comp-sudoku $ quote
          defn comp-sudoku (props & children)
            let-sugar
                x $ .-x props
                y $ .-y props
                state $ .-state props
                dispatch! $ .-dispatch props
                version $ .-version props
                ({} stroke-size stroke-width cell-margin cell-padding cell-size grid-size background-color duration radius) metrics
                cell-length $ + (* 2 cell-padding) (* cell-size stroke-size)
                cell-area-length $ + cell-length (* 2 cell-margin)
                from-x $ * x cell-area-length
                from-y $ * y cell-area-length
                sx $ + from-x cell-padding cell-margin
                sy $ + from-y cell-padding cell-margin
              tag* :g
                {}
                  :onMouseEnter $ fn (event)
                    ; dispatch! $ inc state
                  :style $ {} (:cursor "\"none")
                tag* :rect $ {}
                  :x $ + from-x cell-margin
                  :y $ + from-y cell-margin
                  :width cell-length
                  :height cell-length
                  :fill background-color
                  :rx radius
                , &
                  expand-grid cell-size cell-size $ fn (a b)
                    tag* :line $ {}
                      :key $ str a "\":" b
                      :x1 $ + sx (* a stroke-size)
                      :y1 $ + sy (* b stroke-size)
                      :x2 $ + sx
                        * stroke-size $ + a 1
                      :y2 $ + sy
                        * stroke-size $ + b 1
                      :stroke "\"white"
                      :strokeWidth stroke-width
                      :opacity $ random-opacity
                      :style $ {}
                        :transition-duration $ str duration "\"ms"
                        :transition-timing-function "\"linear"
                  , & $ expand-grid cell-size cell-size
                    fn (a b)
                      tag* :line $ {}
                        :key $ str "\"n-" a "\":" b
                        :x1 $ + sx
                          * (+ a 1) stroke-size
                        :y1 $ + sy (* b stroke-size)
                        :x2 $ + sx (* stroke-size a)
                        :y2 $ + sy
                          * stroke-size $ + b 1
                        :stroke "\"white"
                        :stroke-width stroke-width
                        :opacity $ random-opacity
                        :style $ {}
                          :transition-duration $ str duration "\"ms"
                          :transition-timing-function "\"linear"
      :ns $ quote
        ns app.comp.container $ :require
          app.config :refer $ dev?
          "\"react" :as React
          "\"react-dom" :as ReactDOM
          reacher.core :refer $ wrap-comp div input span button tag* a dispatch! get-state get-value
          respo-ui.core :as ui
          app.util :refer $ expand-grid random-opacity
          app.schema :refer $ metrics
    |app.config $ {}
      :defs $ {}
        |dev? $ quote
          def dev? $ = "\"dev" (get-env "\"mode" "\"release")
        |site $ quote
          def site $ {} (:storage "\"cross-stitch") (:title "\"Cross Stitch") (:icon "\"http://cdn.tiye.me/logo/mvc-works.png")
      :ns $ quote
        ns app.config $ :require
          [] app.util :refer $ [] get-env!
    |app.main $ {}
      :defs $ {}
        |*store $ quote (defatom *store schema/store)
        |dispatch! $ quote
          defn dispatch! (op op-data)
            when config/dev? $ println op (pr-str op-data)
            let
                op-id $ shortid/generate
                op-time $ js/Date.now
              reset! *store $ updater @*store op op-data op-id op-time
        |main! $ quote
          defn main! ()
            if ssr? $ do nil
            ; register-dispatcher! $ "#()" dispatch! %1 %2
            render-app!
            add-watch *store :changes $ fn (s p) (render-app!)
            js/window.addEventListener "\"beforeunload" persist-storage!
            js/setInterval persist-storage! $ * 1000 60
            println "\"App started."
        |mount-target $ quote
          def mount-target $ createRoot (js/document.querySelector |.app)
        |persist-storage! $ quote
          defn persist-storage! () $ .setItem js/localStorage (:storage config/site) (pr-str @*store)
        |reload! $ quote
          defn reload! () (println "\"Code updated.") (render-app!)
        |render-app! $ quote
          defn render-app! () $ .!render mount-target
            wrap-comp comp-container $ js-object (:store @*store) (:state 0) (:dispatch dispatch!)
        |ssr? $ quote
          def ssr? $ some? (js/document.querySelector |meta.respo-ssr)
      :ns $ quote
        ns app.main $ :require
          [] app.updater :refer $ [] updater
          [] app.schema :as schema
          [] app.config :as config
          [] "\"react" :as React
          [] "\"react-dom/client" :refer $ createRoot
          [] app.comp.container :refer $ [] comp-container
          [] reacher.core :refer $ [] register-dispatcher! wrap-comp
          [] "\"shortid" :as shortid
    |app.schema $ {}
      :defs $ {}
        |metrics $ quote
          def metrics $ {} (:stroke-size 6) (:stroke-width 2) (:cell-margin 2) (:cell-padding 4) (:cell-size 4) (:grid-size 8) (:background-color "\"rgb(214,6,38)") (:duration 500) (:radius 4)
        |store $ quote
          def store $ {}
            :tasks $ {}
        |task $ quote
          def task $ {} (:id nil) (:text "\"") (:time nil) (:done? false)
      :ns $ quote (ns app.schema)
    |app.updater $ {}
      :defs $ {}
        |updater $ quote
          defn updater (store op op-data op-id op-time)
            case-default op
              do (println "\"unknown op:" op) store
              :version store
              :hydrate-storage op-data
      :ns $ quote
        ns app.updater $ :require ([] app.schema :as schema)
    |app.util $ {}
      :defs $ {}
        |expand-grid $ quote
          defn expand-grid (x y f)
            -> (range x)
              mapcat $ fn (xi)
                -> (range y)
                  map $ fn (yi) ([] xi yi)
              map $ fn (pair) (f & pair)
        |random-opacity $ quote
          defn random-opacity () $ if
            > (.random js/Math) 0.5
            , 1 0
      :ns $ quote (ns app.util)

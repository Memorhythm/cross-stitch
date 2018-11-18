
(ns app.schema )

(def metrics
  {:stroke-size 6,
   :stroke-width 2,
   :cell-margin 2,
   :cell-padding 4,
   :cell-size 4,
   :grid-size 8,
   :background-color "rgb(214,6,38)",
   :duration 500,
   :radius 4})

(def store {:tasks {}})

(def task {:id nil, :text "", :time nil, :done? false})

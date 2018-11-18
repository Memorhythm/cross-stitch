
(ns app.comp.container
  (:require [hsl.core :refer [hsl]]
            [clojure.string :as string]
            [app.config :refer [dev?]]
            ["react" :as React]
            ["react-dom" :as ReactDOM]
            [reacher.core
             :refer
             [create-comp div input span button tag* a adorn dispatch! get-state get-value]]
            [respo-ui.core :as ui]
            [reacher.comp :refer [=< comp-inspect]]
            [app.util :refer [expand-grid random-opacity]]
            [app.schema :refer [metrics]])
  (:require-macros [clojure.core.strint :refer [<<]]))

(def comp-sudoku
  (create-comp
   {:key-fn (fn [x y version] (str x ":" y)), :name :app-sudoku}
   (fn [[x y version] _ _]
     (let [{stroke-size :stroke-size,
            stroke-width :stroke-width,
            cell-margin :cell-margin,
            cell-padding :cell-padding,
            cell-size :cell-size,
            grid-size :grid-size,
            bg :background-color,
            duration :duration,
            radius :radius} metrics
           cell-length (+ (* 2 cell-padding) (* cell-size stroke-size))
           cell-area-length (+ cell-length (* 2 cell-margin))
           from-x (* x cell-area-length)
           from-y (* y cell-area-length)
           sx (+ from-x cell-padding cell-margin)
           sy (+ from-y cell-padding cell-margin)]
       (tag*
        :g
        {}
        (tag*
         :rect
         {:x (+ from-x cell-margin),
          :y (+ from-y cell-margin),
          :width cell-length,
          :height cell-length,
          :fill bg,
          :rx radius})
        (expand-grid
         cell-size
         cell-size
         (fn [a b]
           (tag*
            :line
            {:key (str a ":" b),
             :x1 (+ sx (* a stroke-size)),
             :y1 (+ sy (* b stroke-size)),
             :x2 (+ sx (* stroke-size (+ a 1))),
             :y2 (+ sy (* stroke-size (+ b 1))),
             :stroke "white",
             :strokeWidth 2,
             :opacity (random-opacity),
             :style (adorn
                     {:transition-duration (<< "~{duration}ms"),
                      :transition-timing-function "linear"})})))
        (expand-grid
         cell-size
         cell-size
         (fn [a b]
           (tag*
            :line
            {:key (str a ":" b),
             :x1 (+ sx (* (+ a 1) stroke-size)),
             :y1 (+ sy (* b stroke-size)),
             :x2 (+ sx (* stroke-size a)),
             :y2 (+ sy (* stroke-size (+ b 1))),
             :stroke "white",
             :stroke-width 2,
             :opacity (random-opacity),
             :style (adorn
                     {:transition-duration (<< "~{duration}ms"),
                      :transition-timing-function "linear"})}))))))))

(def comp-field
  (create-comp
   {:name :app-field}
   (fn [[version] _ _]
     (tag*
      :svg
      {:width 320, :height 320}
      (expand-grid
       (:grid-size metrics)
       (:grid-size metrics)
       (fn [x y] (comp-sudoku x y version)))))))

(def comp-container
  (create-comp
   {:state 0, :name :app-container}
   (fn [[store] state mutate!]
     (div
      {:style (adorn ui/global {})}
      (div {} (comp-field state))
      (button
       {:style (adorn ui/button), :onClick (fn [event] (mutate! (inc state)))}
       "Change")))))

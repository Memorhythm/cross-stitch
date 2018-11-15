
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
            [app.util :refer [expand-grid]]))

(def comp-sudoku
  (create-comp
   {:key-fn (fn [x y] (str x ":" y)), :name :app-sudoku}
   (fn [[x y] _ _]
     (let [sx (* x 44), sy (* y 44)]
       (tag*
        :g
        {}
        (tag* :rect {:x (- sx 2), :y (- sy 2), :width 40, :height 40, :fill (hsl 0 80 80)})
        (expand-grid
         3
         3
         (fn [a b]
           (tag*
            :line
            {:key (str a ":" b),
             :x1 (+ sx (* a 12)),
             :y1 (+ sy (* b 12)),
             :x2 (+ sx (* 12 (+ a 1))),
             :y2 (+ sy (* 12 (+ b 1))),
             :stroke "white",
             :stroke-width 2})))
        (expand-grid
         3
         3
         (fn [a b]
           (tag*
            :line
            {:key (str a ":" b),
             :x1 (+ sx (* (+ a 1) 12)),
             :y1 (+ sy (* b 12)),
             :x2 (+ sx (* 12 a)),
             :y2 (+ sy (* 12 (+ b 1))),
             :stroke "white",
             :stroke-width 2}))))))))

(def comp-field
  (create-comp
   {:name :app-field}
   (fn [[store] _ _]
     (tag* :svg {:width 400, :height 400} (expand-grid 4 4 (fn [x y] (comp-sudoku x y)))))))

(def comp-container
  (create-comp
   {:state nil, :name :app-container}
   (fn [[store] state mutate!]
     (div {:style (adorn ui/global {})} "Containers2")
     (comp-field))))

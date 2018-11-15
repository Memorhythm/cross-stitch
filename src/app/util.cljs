
(ns app.util )

(defn expand-grid [x y f]
  (map (fn [xs] (apply f xs)) (for [x (range x), y (range y)] [x y])))

(defn get-env! [property] (aget (.-env js/process) property))

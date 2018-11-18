
(ns app.util )

(defn expand-grid [x y f]
  (map (fn [xs] (apply f xs)) (for [x (range x), y (range y)] [x y])))

(defn get-env! [property] (aget (.-env js/process) property))

(defn random-opacity [] (if (> (.random js/Math) 0.5) 1 0))

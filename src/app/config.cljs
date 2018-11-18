
(ns app.config (:require [app.util :refer [get-env!]]))

(def bundle-builds #{"release" "local-bundle"})

(def dev?
  (if (exists? js/window)
    (do ^boolean js/goog.DEBUG)
    (not (contains? bundle-builds (get-env! "mode")))))

(def site
  {:storage "cross-stitch",
   :dev-ui "http://localhost:8100/main-eva.css",
   :release-ui "http://cdn.tiye.me/favored-fonts/main-eva.css",
   :cdn-url "http://cdn.tiye.me/cross-stitch/",
   :cdn-folder "tiye.me:cdn/cross-stitch",
   :title "Cross Stitch",
   :icon "http://cdn.tiye.me/logo/mvc-works.png",
   :upload-folder "tiye.me:repo/jiyinyiyong/cross-stitch/"})

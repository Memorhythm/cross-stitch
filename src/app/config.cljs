
(ns app.config (:require [app.util :refer [get-env!]]))

(def bundle-builds #{"release" "local-bundle"})

(def dev?
  (if (exists? js/window)
    (do ^boolean js/goog.DEBUG)
    (not (contains? bundle-builds (get-env! "mode")))))

(def site
  {:storage "reacher",
   :dev-ui "http://localhost:8100/main-eva.css",
   :release-ui "http://cdn.tiye.me/favored-fonts/main-eva.css",
   :cdn-url "http://cdn.tiye.me/reacher-workflow/",
   :cdn-folder "tiye.me:cdn/reacher-workflow",
   :title "Reacher Workflow",
   :icon "http://cdn.tiye.me/logo/respo.png",
   :upload-folder "tiye.me:repo/mvc-works/reacher-workflow/"})

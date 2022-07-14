(setq user-full-name "Daniele Fongo"
      user-mail-address "danielefongo@gmail.com")

(setq doom-theme 'doom-one
      doom-font (font-spec :size 16)
      doom-big-font (font-spec :size 20))

(setq org-directory "~/org/")

(setq display-line-numbers-type t)

(setq +workspaces-on-switch-project-behavior t)

;; projectile
(setq projectile-project-search-path '(("~/programming" . 3))
      projectile-auto-discover t)

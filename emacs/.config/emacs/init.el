;; init.el --- Personal Emacs configuration -*- lexical-binding: t; -*-


;;; Commentary:

;; Author: Ali Bozorgzadeh
;; 2023 - 2026


;;; Code:

(when (version< emacs-version "31")
  (error "Detected Emacs %s but only 31 and higher is supported"
         emacs-version))

(add-to-list 'load-path
             (concat user-emacs-directory "lisp"))
(add-to-list 'load-path
             (concat user-emacs-directory "lisp/plugins"))
(add-to-list 'custom-theme-load-path
             (concat user-emacs-directory "themes"))



(let ((debug-on-error t)
      (debug-on-quit t)
      ;; Every require/load looks at this, so removing it gets us a small
      ;; performance improvement. However we do want it set after loading
      ;; everything, so we use `let' so these variables will return to normal
      ;; after this block.
      (file-name-handler-alist nil))

  ;;
  ;;;; Configurations

  (require 'rc-core)             ; Core stuff that needed before anything else.
  (require 'rc-ui)               ; UI-related or anything about Visual of Emacs.
  (require 'rc-editor)           ; Editing-related stuff.
  (require 'rc-search)           ; Search-related stuff.
  (require 'rc-history)          ; Back-ups, recentf, saveplace, undo/redo, ...
  (require 'rc-dired)            ; Dired and speedbar settings.
  (require 'rc-completion)       ; Completion everywhere.

  (require 'rc-prog)

  (require 'rc-lang)                    ; Spell checking and input methods.
  (require 'rc-prose)                   ; Text-Mode, Org-Mode, ...
  (require 'rc-tex)                     ; TeX, AucTeX, RefTeX, Citar, ...

  (require 'rc-web)                     ; Internet, Vpn, RSS, ...
  (require 'rc-vcs)                     ; VCS-related stuff (mostly magit).

  (require 'rc-missing-majors)       ; Markdown, TOML, JSON, CMake, Gnuplot, ...

  ;;
  ;;;; My plugins

  (require 'plug-music)
)



(provide 'init)
;;; init.el ends here

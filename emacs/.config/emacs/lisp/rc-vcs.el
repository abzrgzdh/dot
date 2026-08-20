;;; rc-vcs.el  -*- lexical-binding: t; -*-


;;; Commentary:

;; Version control & project management

;;; Code:


;; Handle symlinks
(use-package emacs
  :ensure nil
  :demand t
  :config
  ;; Follow symlinks straight into version-controlled files instead of
  ;; asking every time.
  (setq vc-follow-symlinks t))



;; `magit': the definitive text-based Git porcelain for Emacs.
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))



;; `project': Emacs' built-in project-awareness library, used here mostly
;; to recognize project roots that aren't plain Git repos.
(use-package project
  :ensure nil
  :config
  (setq project-vc-extra-root-markers '(".project" ".bare"))
  (setopt project-switch-commands #'project-dired))



;; `editorconfig': respects any `.editorconfig' file in a project so
;; indentation/line-ending style stays consistent across editors and
;; contributors.
(use-package editorconfig
  :ensure nil
  :config
  (editorconfig-mode 1))



;; `ediff': side-by-side diff/merge tool.
(use-package ediff
  :defer t
  :ensure nil
  :custom
  ;; Plain, single-frame side-by-side layout instead of a separate
  ;; control frame -- much friendlier in tiling WMs and terminals.
  (ediff-split-window-function 'split-window-horizontally)
  (ediff-window-setup-function 'ediff-setup-window-plain)
  (ediff-keep-variants nil)
  (ediff-make-buffers-readonly-at-startup nil)
  (ediff-merge-revisions-with-ancestor t)
  (ediff-show-clashes-only t))



(provide 'rc-vcs)
;;; rc-vcs.el ends here.

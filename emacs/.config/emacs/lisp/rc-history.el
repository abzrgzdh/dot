;;; rc-history.el  -*- lexical-binding: t; -*-


;;; Commentary:

;; History related to files, buffers, and undo/redo.

;;; Code:


;; `recentf': tracks recently opened files so you can jump back to them
;; without hunting through directories.
(use-package recentf
  :defer t
  :ensure nil
  :preface
  (defun rc/ido-recentf-open ()
    "Use `ido-completing-read' to open a recently visited file.\n
     https://www.masteringemacs.org/article/find-files-faster-recent-files-package"
    (interactive)
    (if (find-file (ido-completing-read "Find recent file: " recentf-list))
        (message "Opening file...")
      (message "Aborting")))

  :hook (after-init . recentf-mode)
  :bind ("C-x C-r" . recentf-open)
  :config
  ;; Remote file will be kept without testing if they still exists
  ;; Source - https://stackoverflow.com/a/2069425
  (setq recentf-keep '(file-remote-p file-readable-p))

  (setopt recentf-save-file (locate-user-emacs-file "recentf"))
  (setopt recentf-max-saved-items 300)
  (setopt recentf-max-menu-items 15)
  (setopt recentf-auto-cleanup (if (daemonp) 300 'never))
  (setopt recentf-exclude (list "^/\\(?:ssh\\|su\\|sudo\\)?:"
                                (locate-user-emacs-file "elpa")
                                (expand-file-name "~/quicklisp/dists"))))


;; `saveplace': reopening a file drops you back at the last place you were
;; editing, instead of at the top.
(use-package saveplace
  :demand t
  :ensure nil
  :hook (after-init . save-place-mode)
  :config
  (setopt save-place-limit 600)
  (setopt save-place-file (locate-user-emacs-file "places"))
  (save-place-mode 1))



;; NOTE: history persistence (minibuffer history, kill-ring, etc.) is
;; handled by `psession' further down instead of the built-in `savehist',
;; which caused "wrong-type-argument" errors in this setup.  A couple of
;; earlier attempts at `savehist' configuration are kept below purely for
;; reference:
;; (use-package savehist
;;   :config
;;   (setq savehist-additional-variables '(search-ring regexp-search-ring))
;;   (setq history-length 300
;;         savehist-autosave-interval nil
;;         history-delete-duplicates t
;;         savehist-save-minibuffer-history t)
;;   (savehist-mode 1))
;; (use-package savehist
;;   :init
;;   (savehist-mode 1)
;;   :custom
;;   (history-length 1000)
;;   (savehist-autosave-interval 300)
;;   (savehist-additional-variables '(kill-ring search-ring regexp-search-ring)))



;; Session/history persistence
;;
;; `psession': persists minibuffer history, kill-ring, registers, etc.  across
;; Emacs restarts.  Used instead of the built-in `savehist' (see the note in the
;; "Files" section above for why).
(use-package psession
  :ensure t
  :init
  (setq psession-object-to-save-alist
        '((minibuffer-history        . "minibuffer-history.el")
          (shell-command-history     . "shell-command-history.el")
          ;; (ido-buffer-history        . "ido-buffer-history.el")
          (ido-file-history          . "ido-file-history.el")
          (project--dir-history      . "project--dir-history.el")
          (extended-command-history  . "extended-command-history.el")
          (regexp-search-ring        . "regexp-search-ring.el")
          (kill-ring                 . "kill-ring.el")
          (register-alist            . "register-alist.el")))
  :config
  (psession-savehist-mode 1)
  (psession-autosave-mode 1)
  (psession-mode 1)
  ;; These hooks caused issues in this setup (see original notes) -- keep
  ;; them removed explicitly rather than just never adding them, so it's
  ;; clear this was a deliberate choice if `psession' changes its
  ;; defaults in a future version.
  (dolist (fn '(psession--dump-some-buffers-to-list
                psession--restore-some-buffers
                psession-save-last-winconf
                psession-restore-last-winconf))
    (remove-hook 'kill-emacs-hook fn)
    (remove-hook 'emacs-startup-hook fn)))



;; `files': tame the various auto-generated files Emacs likes to scatter
;; around a project (lockfiles, backups, autosaves).
(use-package files
  :ensure nil
  :config
  ;; Lockfiles (`.#foo.txt') can confuse tools like `npm start' into
  ;; thinking a file is being edited by someone else.
  (setq create-lockfiles nil)
  (setq auto-save-default nil)
  (setq auto-save-list-file-prefix nil)
  (setq make-backup-files nil))



;; `autorevert': keep buffers in sync with what's actually on disk, e.g.
;; after a `git checkout' or an external editor's changes.
(use-package autorevert
  :ensure nil
  :config
  (setq auto-revert-interval 2)
  (setq auto-revert-check-vc-info t)
  (setq global-auto-revert-non-file-buffers t)
  (setq auto-revert-verbose nil)
  (global-auto-revert-mode +1))



;; `undo-fu': a thin wrapper around Emacs' native undo system that adds a
;; conventional, linear undo/redo (as opposed to stock Emacs' "undoing an
;; undo is itself undoable" tree behavior).
(use-package undo-fu
  :ensure t
  :bind (("C-/"  . undo-fu-only-undo)
         ("M-_"  . undo-fu-only-redo)))



;; `undo-fu-session': persists undo history to disk between Emacs
;; sessions, so `C-/' still works after restarting Emacs.
(use-package undo-fu-session
  :init
  (setq undo-fu-session-directory "~/.config/emacs/undo")
  (setq undo-fu-session-incompatible-files
        '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'" "/TODO.md\\'"))
  :config
  (undo-fu-session-global-mode))



;; `vundo': visualizes the undo history as a navigable tree -- handy when
;; `undo-fu''s linear model isn't enough and you need to see branches.
(use-package vundo
  :bind ("C-x C-u" . vundo))



;; Earlier this config used `undo-tree' instead of `undo-fu'/`vundo'.
;; Kept here in case I ever want to switch back:
;; (use-package undo-tree
;;   :config
;;   (global-undo-tree-mode 1)
;;   (setq undo-tree-auto-save-history t)
;;   (setq undo-tree-history-directory-alist '(("." . "~/.config/emacs/undo")))
;;   (make-directory (expand-file-name "~/.config/emacs/undo") t))



(provide 'rc-history)
;;; rc-history.el ends here.

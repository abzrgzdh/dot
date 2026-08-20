;; early-init.el -*- lexical-binding: t; -*-


;;; Commentary:

;; Emacs HEAD (27+) introduces early-init.el, which is run before init.el,
;; before package and UI initialization happens. Disabling UI elements and
;; adding some performance optimizations in here can result in an improvement in
;; startup time.  [1]

;; References:
;; 1. github:belack/dotfiles


;;; Code:

;; Make the warnings buffer only appear on errors. We set this as early as
;; possible to try and catch everything.  [1]
(setq warning-minimum-level :error)

;; The garbage collector runs whenever allocation crosses `gc-cons-threshold'
;; (default: a tiny 800KB).  Emacs' startup allocates a lot in a short window,
;; so a low threshold means many needless GC pauses while loading packages.  We
;; raise it drastically here and lower it back down to a sane, still-generous
;; value once startup is complete (see the very bottom of this file).  [1]
(setq gc-cons-threshold most-positive-fixnum)
(defun rc--restore-gc-cons-threshold ()
  (setq gc-cons-threshold (* 16 1024 1024)))
(add-hook 'emacs-startup-hook #'rc--restore-gc-cons-threshold)


;; ;; In Emacs 27+, package initialization occurs before `user-init-file' is
;; ;; loaded, but after `early-init-file'. We handle package initialization, so we
;; ;; must prevent Emacs from doing it early!  [1]
;; (setq package-enable-at-startup nil)
;; (advice-add #'package--ensure-init-file :override #'ignore)

;; Prevent the glimpse of un-styled Emacs by disabling these UI elements early.
;; [1]
;; (menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode -1)
(mouse-wheel-mode 1)

;; ;; Resizing the Emacs frame can be a terribly expensive part of changing the
;; ;; font. By inhibiting this, we easily halve startup times with fonts that are
;; ;; larger than the system default.
;; (setq frame-inhibit-implied-resize t)

;;; Problem with citar: Error loading autoloads: (void-function cl-defsubst)
;; grep the elpa directory.
(require 'cl-lib)

;; early-init.el ends here.

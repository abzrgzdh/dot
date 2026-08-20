;;; rc-core.el -*- lexical-binding: t; -*-

;;; Commentary:

;; References:
;; 1. github:belak/dotfiles

;;; Code:


(require 'rc-package)                   ; Initialize use-package
(require 'rc-benchmark)                 ; Benchmark package initialization
(require 'rc-platform)                  ; Os-dependent stuff



;;
;;; Custom

;; This point Emacs' "Customize" UI at its own file instead of dumping
;; auto-generated `custom-set-variables' blocks into this file. It keeps
;; hand-written config and machine-generated config cleanly separated.
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)



;; Encoding
;;
(use-package emacs
  :ensure nil
  :demand t
  :config
  ;; UTF-8 as the default encoding
  (set-charset-priority 'unicode)
  (prefer-coding-system 'utf-8)
  (setq locale-coding-system 'utf-8))



;; Emacs Server
;;
;; Start emacs server if it's not already started or there is not a daemon
;; process.
(use-package server
  :ensure nil
  :config
  (unless (or (daemonp)
              (server-running-p))
    (message "Starting server")
    (server-start)))



(provide 'rc-core)
;;; rc-core.el ends here.

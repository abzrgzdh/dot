;;; rc-platform.el  -*- lexical-binding: t; -*-


;; `proced' is a command to view all processes in Emacs.
(use-package proced
  :ensure nil
  :init
  (setq-default proced-format 'verbose)
  (setq proced-auto-update-flag t
        proced-auto-update-interval 3
        proced-enable-color-flag t))



;; Setting PATH
;;
;; When Emacs is launched from Finder or the Dock, it may not inherit the PATH
;; configured by system default shell. This is particulary needed for builds
;; that include JIT as it needs to find some binaries that are not in the
;; default system PATH.
(use-package emacs
  :ensure nil
  :if (memq system-type '(darwin)); gnu/linux))
  :init
  (dolist (dir '("/opt/homebrew/bin"
                 "/opt/homebrew/sbin"
                 "/opt/homebrew/opt/curl/bin"
                 "/opt/homebrew/opt/coreutils/libexec/gnubin"))
    (setenv "PATH"
            (concat dir path-separator (getenv "PATH")))
    (add-to-list 'exec-path dir)))



;; Remap the Mac's Command key to Emacs' Meta modifier.
;;
;; This choice matches most people's muscle memory better than the Option key,
;; which is left free for typing special/international characters.  Guarded by
;; `system-type' so these variables (which only mean anything on the macOS/NS
;; port) are never set on Linux/Windows.
(use-package emacs
  :ensure nil
  :demand t
  :if (memq system-type '(darwin)); gnu/linux))
  :config
  (when (eq system-type 'darwin)
    (setq mac-option-key-is-meta nil
          mac-command-key-is-meta t
          mac-command-modifier 'meta
          mac-option-modifier 'none)))



(provide 'rc-platform)
;;; rc-platform.el ends here

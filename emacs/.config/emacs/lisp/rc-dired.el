;;; rc-dired.el  -*- lexical-binding: t; -*-



;; `dired': the built-in directory browser/file manager.
(use-package dired
  :ensure nil
  :defer t
  :bind (:map dired-mode-map
              ("K" . dired-kill-subdir))
  :config
  (setq dired-listing-switches
        "-aGFhlv --group-directories-first --time-style=long-iso")
  ;; When two dired windows are open, default copy/rename targets to the
  ;; other window rather than always the current directory.
  (setq dired-dwim-target t)
  ;; Avoid piling up dired buffers -- opening a new directory replaces
  ;; the old one instead of stacking.
  (setq dired-kill-when-opening-new-dired-buffer t))

;; `dired-subtree', which allows dired to show content of a directory in a
;; subtree in the current dired buffer.
(use-package dired-subtree
  :ensure t
  :after (dired)
  :bind (:map dired-mode-map
              ([tab] . dired-subtree-toggle)
              ([backtab] . dired-subtree-toggle))
  :config
  (setq dired-subtree-use-backgrounds nil))



;; `speedbar', a directory explorer similar to dired
(use-package speedbar
  :ensure nil
  :if (> emacs-major-version 30)
  :commands (speedbar)
  :config
  ;; Without `speedbar-prefer-window' the `speedbar' shows up in a separate
  ;; frame, which I consider practical.
  (setq speedbar-prefer-window t)

  ;; No bitmap icons, thanks! A non-nil value here refers to the `cdr' of each
  ;; `speedbar-expand-image-button-alist', so in theory we can still make this
  ;; look prettier, which I might do in the future.
  (setq speedbar-use-images nil))



(provide 'rc-dired)
;;; rc-dired.el ends here.

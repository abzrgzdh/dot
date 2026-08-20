;;; rc-lang.el  -*- lexical-binding: t; -*-


;;; Commentary:

;; Stuff related to language (e.g., spelling) and input methods.

;;; Code:


;; ;; `flyspell': the classic, `ispell'/`aspell'-backed spell checker.  Kept
;; ;; around alongside `jinx' (below) for prose-heavy modes.
;; (use-package flyspell
;;   :ensure nil
;;   :hook ((org-mode markdown-mode text-mode) . flyspell-mode)
;;   :bind
;;   ;; Toggle spell-check, but behave differently depending on context:
;;   ;; full-buffer flyspell in prose modes, comment/string-only flyspell in
;;   ;; programming modes (so it doesn't flag identifiers as typos).
;;   ("C-x x s" . (lambda ()
;;                  (interactive)
;;                  (if (derived-mode-p 'prog-mode)
;;                      (if flyspell-mode
;;                          (flyspell-mode -1)
;;                        (flyspell-prog-mode))
;;                    (flyspell-mode 'toggle))))
;;   :config
;;   (setq flyspell-issue-message-flag nil)
;;   (setq ispell-program-name "aspell")
;;   (setq ispell-dictionary "en_US"))



;; `jinx': a fast, modern, multi-language spell checker built on `libenchant'
;; (Debian/Ubuntu package: `libenchant-2-dev', Macos: `enchant').  Checks
;; several languages at once and skips code comments/strings sensibly.
(use-package jinx
  :defer t
  :demand t
  :hook ((text-mode) . jinx-mode)
  :bind
  (("C-c s c" . jinx-correct)
   ("C-;"     . jinx-correct)
   ("C-c s a" . jinx-correct-all)
   ("C-c s l" . jinx-languages)
   ("C-c s s" . jinx-mode)
   ("C-c s n" . jinx-next)
   ("C-M-;"   . jinx-next)
   ("C-c s p" . jinx-previous))
  :config
  (setq jinx-languages "en_US en_GB fa fr de"
        jinx-camel-modes '(prog-mode)
        jinx-delay 0.1)

  ;; ;; Don't check comments/strings in programming modes -- too noisy.
  ;; (setq jinx-exclude-faces
  ;;       '((prog-mode font-lock-comment-face font-lock-string-face)))
  )



;; Input method toggle (for typing accented/French characters, etc.)
;; `toggle-input-method' remembers the last method used, or falls back to
;; `default-input-method' below.
(use-package emacs
  :ensure nil
  :demand t
  :bind
  ("<f2>" . toggle-input-method)
  :config
  (setq default-input-method "farsi-isiri-9147"))





(provide 'rc-lang)
;;; rc-lang.el ends here.

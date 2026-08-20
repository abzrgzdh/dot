;;; rc-missing-majors.el  -*- lexical-binding: t; -*-


;; `markdown-mode'
(use-package markdown-mode
  :after edit-indirect
  :mode (("\\.md\\'" . gfm-mode))
  :custom
  (markdown-enable-math t)
  (markdown-enable-html t)
  (markdown-enable-wiki-links t)
  (markdown-asymmetric-header t)
  (markdown-nested-imenu-heading-index t)
  (markdown-fontify-code-blocks-natively t)
  :config
  (with-eval-after-load 'markdown-mode
    ;; Fenced code blocks tagged with these languages get fontified using
    ;; the given major mode instead of being left as plain text.
    (add-to-list 'markdown-code-lang-modes '("console" . sh-mode))
    (add-to-list 'markdown-code-lang-modes '("foam" . c++-mode))
    (add-to-list 'markdown-code-lang-modes '("math" . latex-mode)))

  ;; `edit-indirect': lets you edit a fenced code block (or any region) in
  ;; its own buffer, running the appropriate major mode -- used by
  ;; `markdown-mode' for editing code blocks with full language support.
  (use-package edit-indirect
    :ensure t
    :commands edit-indirect))



;; `gnuplot'
(use-package gnuplot
  :mode (("\\.gp\\'"      . gnuplot-mode)
         ("\\.gnuplot\\'" . gnuplot-mode)
         ("\\.plt\\'"     . gnuplot-mode)
         ("\\.gpi\\'"     . gnuplot-mode)))



;; `cmake-mode'
(use-package cmake-mode
  :mode (("\\.cmake\\'"         . cmake-mode)
         ("CMakeLists\\.txt\\'" . cmake-mode)))


;; 
;; (use-package toml-mode
;;   :ensure t
;;   :demand t
;;   :mode (("\\.toml\\'" . toml-mode)))


;; 
;; (use-package json-mode
;;   :ensure t
;;   :mode (("\\.json\\'" . json-mode)))



(provide 'rc-missing-majors)
;;; rc-missing-majors.el ends here.

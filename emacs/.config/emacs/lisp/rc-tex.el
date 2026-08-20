;;; rc-tex.el -*- lexical-binding: t; -*-

;;; Commentary:

;; LaTeX (AUCTeX, CDLaTeX, RefTeX, Citar)

;;; Code:


;; `AUCTeX': the comprehensive LaTeX authoring package (this block is
;; named `latex' because that's the feature AUCTeX provides, but the
;; installable package is `auctex' -- hence the explicit `:ensure auctex'
;; override below).
(use-package latex
  :ensure auctex
  :hook (
         (LaTeX-mode . rc/preview-larger-previews)
         )
  :config
  ;; `TeX-normal-mode' (bound to `C-c C-n' by default) is more confusing
  ;; than useful day-to-day -- free up the key.
  (with-eval-after-load 'tex
    (define-key TeX-mode-map (kbd "C-c C-n") nil))

  ;;; --- LaTeX preview ------------------------------------------------------
  ;; cache preamble:    C-c C-p C-f
  ;; preview-document:  C-c C-p C-d
  ;; preview-buffer:    C-c C-p C-b
  (with-eval-after-load 'preview
    (add-to-list 'preview-gs-options "-dNEWPDF=false"))

  (defun rc/preview-larger-previews ()
    (setq preview-scale-function
          (lambda () (* 0.6 (funcall (preview-scale-from-face))))))

  ;; Don't hard-wrap lines while writing LaTeX -- breaking mid-sentence
  ;; makes diffs noisier for no real benefit.
  (add-hook 'TeX-mode-hook (lambda () (auto-fill-mode -1)))

  ;; Only "compose" (prettify) complete TeX command names, not partial
  ;; matches that happen to be a prefix of a longer command.
  (defun rc/prettify-tex-compose-p (start end _match)
    "Only prettify complete TeX commands."
    (let ((next (char-after end)))
      (or (null next)
          (not (or (and (>= next ?A) (<= next ?Z))
                    (and (>= next ?a) (<= next ?z))
                    (= next ?@))))))

  (add-hook 'LaTeX-mode-hook
            (lambda ()
              (setq-local prettify-symbols-compose-predicate
                          #'rc/prettify-tex-compose-p)
              (prettify-symbols-mode 1)))

  ;; ;; TeX-fold: fold long LaTeX macros/environments down to a readable
  ;; ;; summary.  `C-c C-o C-b'/`b' folds the buffer, `C-o' toggles at point.
  ;; (add-hook 'TeX-mode-hook
  ;;           (lambda ()
  ;;             (TeX-fold-mode 1)
  ;;             (TeX-fold-buffer)))
  ;; (setq TeX-fold-auto-reveal t)

  (setq-default TeX-PDF-mode t)
  (setq-default TeX-master nil)

  ;;; --- Bibliography -------------------------------------------------------
  (setq bibtex-dialect 'biblatex)
  (setq LaTeX-biblatex-use-Biber t)
  (setq-local TeX-command-BibTeX "Biber")

;;   ;;; --- Build & view ---------------------------------------------------
  ;; https://www.wangzerui.com/2017/02/20/setting-up-a-nice-environment-for-latex-on-macos/
  (add-hook 'LaTeX-mode-hook
            (lambda ()
              (push '("latexmk"
                       "latexmk -pdf %s -verbose -file-line-error -synctex=1 -interaction=nonstopmode -shell-escape -output-directory=build"
                       TeX-run-TeX nil t
                       :help "Run latexmk on file")
                    TeX-command-list)))
  (add-hook 'TeX-mode-hook (lambda () (setq TeX-command-default "latexmk")))

  (setq-default TeX-output-dir "build")
  (setq TeX-view-program-selection '((output-pdf "PDF Viewer")))

  ;; Skim.app is macOS-only; only point at it there.
  (when (eq system-type 'darwin)
    (setq TeX-view-program-list
          '(("PDF Viewer"
             "/Applications/Skim.app/Contents/SharedSupport/displayline -b %n %o %b"))))

  (setq TeX-source-correlate-method 'synctex
        TeX-source-correlate-mode t
        TeX-source-correlate-start-server t))


;; `cdlatex': fast entry of LaTeX math environments/symbols (e.g. typing
;; `sr' + Tab expands to a square-root template with point placed inside
;; it).
(use-package cdlatex
  :ensure t
  :after auctex
  :hook ((LaTeX-mode . turn-on-cdlatex)
         (org-mode . turn-on-cdlatex))
  :bind (:map cdlatex-mode-map
              ("M-f" . cdlatex-tab)
              ;; Make TAB available to normal completion/indentation.
              ("<tab>" . nil)
              ("TAB" . nil)))



;; `reftex': cross-reference/citation management for LaTeX (and Org, via
;; `turn-on-reftex').
(use-package reftex
  :ensure nil
  :hook ((LaTeX-mode      . turn-on-reftex)
         (reftex-toc-mode . reftex-toc-rescan))
  :config
  ;; So that RefTeX also recognizes \addbibresource. Note that you
  ;; can't use $HOME in path for \addbibresource but that "~"
  ;; works.
  ;; source - https://tex.stackexchange.com/a/54825
  (setq reftex-bibliography-commands '("bibliography" "nobibliography" "addbibresource"))

  (setq reftex-plug-into-auctex t)
  (setq reftex-cite-format 'biblatex)
  (eval-after-load 'reftex-vars
    '(setq reftex-cite-format
           '((?\C-m . "\\cite[]{%l}")
             (?f    . "\\footcite[][]{%l}")
             (?t    . "\\textcite[]{%l}")
             (?p    . "\\parencite[]{%l}")
             (?o    . "\\citepr[]{%l}")
             (?n    . "\\nocite{%l}")))))



;; `citar': quickly find and act on bibliographic references, and edit org,
;; markdown, and latex academic documents.
(use-package citar
  :ensure t

  :custom
  (citar-bibliography '("~/Documents/all_references.bib"))
  :config
  (require 'citar)
  (require 'citar-latex)
  (require 'citar-org)
  (require 'citar-capf)

  (advice-add 'citar-insert-citation :around
            (lambda (orig-fun &rest args)
              (let ((completion-auto-select t)
                    (completion-auto-help 'always))
                (apply orig-fun args))))

  (advice-add 'citar-capf :around
              (lambda (orig-fun &rest args)
                (let ((result (apply orig-fun args)))
                  ;; citar-capf returned non-nil => it's the backend that will fire
                  (when result
                    (setq completion-auto-select t
                          completion-auto-help 'always))
                  result)))

  (advice-add 'completion-at-point :around
              (lambda (orig-fun &rest args)
                (let ((saved-select completion-auto-select)
                      (saved-help   completion-auto-help))
                  (unwind-protect
                      (apply orig-fun args)
                    (setq completion-auto-select saved-select
                          completion-auto-help   saved-help)))))

  :hook
  ((LaTeX-mode . citar-capf-setup)
   (org-mode . citar-capf-setup)))

(use-package citar-latex
  :ensure nil
  :after citar)



(provide 'rc-tex)
;;; rc-tex.el ends here.

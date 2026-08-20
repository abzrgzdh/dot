;;; rc-search.el  -*- lexical-binding: t; -*-


;;; Commentary:

;; Search-(for words and files)-related stuff

;;; Code:


;; `isearch' builtin emacs search.
;; References - '("https://blog.chmouel.com/posts/emacs-isearch/")
(use-package isearch
  :defer t
  :ensure nil
  :preface
  (defun rc/occur-from-isearch ()
    (interactive)
    (let ((query (if isearch-regexp
               isearch-string
             (regexp-quote isearch-string))))
      (isearch-update-ring isearch-string isearch-regexp)
      (let (search-nonincremental-instead)
        (ignore-errors (isearch-done t t)))
      (occur query)))

  (defun rc/project-search-from-isearch ()
    "Does a project search from a search term."
    (interactive)
    (let ((query (if isearch-regexp
               isearch-string
             (regexp-quote isearch-string))))
      (isearch-update-ring isearch-string isearch-regexp)
      (let (search-nonincremental-instead)
        (ignore-errors (isearch-done t t)))
      (project-find-regexp query)))

  :bind
  (:map isearch-mode-map
        ("C-o" . rc/occur-from-isearch)
        ("C-M-f" . rc/project-search-from-isearch))

  :config
  ;; use selection to search
  (defadvice isearch-mode
      (around isearch-mode-default-string
              (forward &optional regexp op-fun recursive-edit word-p) activate)
    (if (and transient-mark-mode mark-active (not (eq (mark) (point))))
        (progn
          (isearch-update-ring (buffer-substring-no-properties (mark) (point)))
          (deactivate-mark)
          ad-do-it
          (if (not forward)
              (isearch-repeat-backward)
            (goto-char (mark))
            (isearch-repeat-forward)))
      ad-do-it)))



;; `avy' jump to the search results on screen using labels.
(use-package avy
  :ensure t
  :bind
  (:map isearch-mode-map ("C-j" . avy-isearch)))



;; `ffap' ("find file at point"): opens the file/URL under the cursor instead of
;; having to select and copy it yourself.
(use-package ffap
  :ensure nil
  :config
  (ffap-bindings)
  :bind
  ("M-s M-f" . find-file-at-point))



(provide 'rc-search)
;;; rc-search.el ends here.

;;; rc-prose.el  -*- lexical-binding: t; -*-

;;; Commentary:

;; Prose-related stuff. Basically Text-mode, Org-Mode, and note-taking-related
;; stuff (Denote).

;;; Code:


;; `text-mode' plain text mode.
;; source: Protesilaos Stavrou aka prot.
(use-package text-mode
  :ensure nil
  :mode "\\`\\(README\\|CHANGELOG\\|COPYING\\|LICENSE\\)\\'"
  :hook
  ((text-mode . turn-on-auto-fill)
   ;; Programming-mode comments/strings are still sentences: treat a
   ;; single space, not two, as ending a sentence there.
   (prog-mode . (lambda () (setq-local sentence-end-double-space t))))
  :config
  (setq sentence-end-double-space nil)
  (setq sentence-end-without-period nil)
  (setq colon-double-space nil)
  (setq use-hard-newlines nil)
  (setq adaptive-fill-mode t))



;; `org': the outliner/planner/literate-programming/everything package.
(use-package org
  :ensure nil
  :mode (("\\.org\\'"  . org-mode)
         ("TODO\\'"    . org-mode)
         ("README\\'"  . org-mode))
  :bind*
  (("C-c a"   . org-agenda)
   ("C-c c"   . org-capture)
   ("C-c C-w" . org-refile)
   (:map org-mode-map
         ("C-," . nil)
         ("C-;" . nil)))
  :config

  ;;; --- LaTeX export settings -------------------------------------------
  (with-eval-after-load 'ox-latex
    ;; No default ugly red box around links from `hyperref'.
    (add-to-list
     'org-latex-default-packages-alist
     "\\PassOptionsToPackage{hyperref}{hidelinks}")

    (add-to-list 'org-latex-classes
                 '("memoir"
                   "\\documentclass{memoir}"
                   ("\\chapter{%s}" . "\\chapter*{%s}")
                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

    (add-to-list 'org-latex-classes
                 '("koma-book"
                   "\\documentclass{scrbook}"
                   ("\\part{%s}" . "\\part{%s}")
                   ("\\chapter{%s}" . "\\chapter{%s}")
                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                   ("\\paragraph{%s}" . "\\paragraph*{%s}")))

    (add-to-list 'org-latex-classes
                 '("koma-article"
                   "\\documentclass{scrartcl}"
                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                   ("\\paragraph{%s}" . "\\paragraph*{%s}")
                   ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

  ;; --- org preview ---------------------------------------------
  ;; codes in this sub-section are from:
  ;; https://karthinks.com/software/scaling-latex-previews-in-emacs/

  (setq org-preview-latex-default-process 'dvisvgm)

  (defun rc/text-scale-adjust-latex-previews (&optional ARG)
    "Adjust the size of latex preview fragments when changing the
buffer's text scale."
    (pcase major-mode
      ('latex-mode
       (dolist (ov (overlays-in (point-min) (point-max)))
         (if (eq (overlay-get ov 'category)
                 'preview-overlay)
             (rc/text-scale--resize-fragment ov))))
      ('org-mode
       (dolist (ov (overlays-in (point-min) (point-max)))
         (if (eq (overlay-get ov 'org-overlay-type)
                 'org-latex-overlay)
             (rc/text-scale--resize-fragment ov))))))

  (defun rc/text-scale--resize-fragment (ov)
    (overlay-put
     ov 'display
     (cons 'image
           (plist-put
            (cdr (overlay-get ov 'display))
            :scale (+ 1.8 (* 0.25 text-scale-mode-amount))))))

  (add-hook 'text-scale-mode-hook #'rc/text-scale-adjust-latex-previews)
  (advice-add #'org-latex-preview :after #'rc/text-scale-adjust-latex-previews)

  ;;; --- General behavior --------------------------------------------------
  (setq org-startup-indented t)
  (setq org-hide-leading-stars t)
  (setq org-startup-folded t)
  ;; Don't split the current line when hitting `M-RET'; go to the end of
  ;; the line first, then insert the new heading/item.
  (setq org-M-RET-may-split-line '((default . nil)))
  (setq org-insert-heading-respect-content t)
  (setq org-log-into-drawer t)
  (setq org-log-done 'time)
  (setq org-archive-location "archive/%s_archive::")
  (setq org-archive-subtree-add-inherited-tags t)
  (setq org-tags-column -80)

  ;; Don't leave a blank line between a heading and its first list item
  ;; when `M-RET' is used.
  ;; https://emacs.stackexchange.com/a/22111
  (setcdr (assoc 'plain-list-item org-blank-before-new-entry) nil)

  (setq org-image-actual-width nil)
  (setq org-display-inline-images t)

  (setq org-directory "~/Documents/org")

  ;; Source - https://stackoverflow.com/a/22200624 (abo-abo)
  (setq org-refile-targets
        '((nil :maxlevel . 3)
          (org-agenda-files :maxlevel . 3)))

  ;; Allow a subtree to be refiled to top-most level heading, i.e., file-level
  ;; source: https://emacs.stackexchange.com/a/55025
  (setq org-refile-use-outline-path 'file)

  ;; Save affected buffers after refiling
  ;; source - https://emacs.stackexchange.com/a/50993
  (defun save-after-capture-refile ()
    (with-current-buffer (marker-buffer org-capture-last-stored-marker)
      (save-buffer)))
  (advice-add 'org-capture-refile :after 'save-after-capture-refile)

  ;;; --- Cosmetics --------------------------------------------------------
  (setq org-hide-emphasis-markers nil)  ; It's confusing at times
  (font-lock-add-keywords
   'org-mode
   '(("^ *\\([-]\\) "
      (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;;; --- Workflow states ----------------------------------------------------
  (setq org-todo-keywords
        '((sequence
           "TODO(t)" "LATER(l@/!)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELLED(c@/!)")))

  ;;; --- Capture --------------------------------------------------------
  (setq org-capture-use-agenda-date t)

  (setq org-capture-templates
        `(("t" "Tasks"
           entry (file ,(concat org-directory "/tasks.org"))
           "* TODO [#B] %? %^g\n"
           :empty-lines 0)))

  (setq org-tag-alist
        '(
          ;; Common
          (:startgroup . nil)
          ("@emacs" . ?E)
          ("@cfd" . ?C)
          ("@research" . ?R)
          ("@study" . ?s)
          ("@chore" . ?r)
          ("@meeting" . ?s)
          ("@reading" . ?r)
          (:endgroup . nil)

          ;; Git & GitHub
          (:startgroup . nil)
          ("@issue" . ?I)
          ("@bugfix" . ?B)
          ("@pr" . ?M)                 ; [M]: [M]erge request
          (:endgroup . nil)))

  ;;; --- Babel (in-buffer code execution) ----------------------------------
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python     . t)
     (shell      . t)
     (emacs-lisp . t)))

  (setq org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-confirm-babel-evaluate t)

  ;; --- org-agenda -------------------------------------
  (setq org-agenda-files (list org-directory))
  ;; following are taken from prot's config
  (setq org-agenda-span 'week)
  (setq org-agenda-start-on-weekday 6)  ; Saturday
  (setq org-agenda-confirm-kill t)
  (setq org-agenda-show-all-dates t)
  (setq org-agenda-show-outline-path nil)
  (setq org-agenda-window-setup 'current-window)
  (setq org-agenda-skip-comment-trees t)
  (setq org-agenda-menu-show-matcher t)
  (setq org-agenda-menu-two-columns nil)
  (setq org-agenda-sticky nil)
  (setq org-agenda-custom-commands-contexts nil)
  (setq org-agenda-max-entries nil)
  (setq org-agenda-max-todos nil)
  (setq org-agenda-max-tags nil)
  (setq org-agenda-max-effort nil)

  ;; --- org citation ----------------------------------
  ;; Global bibliography file(s)
  (setq org-cite-global-bibliography '("~/Documents/all_references.bib"))

  ;; Default export processors: biblatex for LaTeX, CSL for others (HTML, etc.)
  (setq org-cite-export-processors
        '((latex biblatex)   ; or '((latex (biblatex backend=biber,style=numeric)))
          (t csl)))

  (add-to-list 'org-file-apps '("\\.pdf" . "open -a Skim %s")))



;; `denote'
;; (info "(denote) Sample Configuration")
(use-package denote
  :ensure t
  ;; :hook (dired-mode . denote-dired-mode)
  :bind
  (("C-c n n" . denote)
   ("C-c n r" . denote-rename-file)
   ("C-c n l" . denote-link)
   ("C-c n b" . denote-backlinks)
   ("C-c n d" . denote-dired)
   ("C-c n g" . denote-grep))
  :config
  (setq denote-directory (expand-file-name "~/Documents/notes/"))
  ;; denote-known-keywords

  ;; Automatically rename Denote buffers when opening them so that
  ;; instead of their long file name they have, for example, a literal
  ;; "[D]" followed by the file's title.  Read the docstring of
  ;; `denote-rename-buffer-format' for how to modify this.
  (denote-rename-buffer-mode 1))



(provide 'rc-prose)
;;; rc-prose.el ends here.

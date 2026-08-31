;;; rc-prog.el  -*- lexical-binding: t; -*-


;; `paredit' Helps editing lisp code (or the AST) easier.
(use-package paredit
  :ensure t
  ;; :hook ((emacs-lisp-mode . paredit-mode))
  ;; :bind (
  ;;        ("M-<right>" . paredit-forward-slurp-sexp)
  ;;        ("M-<left>" . paredit-forward-slurp-sexp))
)



;; `hl-todo': highlights TODO/FIXME/etc. keywords (usually in comments) so
;; they actually stand out instead of blending into the rest of the text.
(use-package hl-todo
  :ensure t
  :hook (prog-mode . hl-todo-mode))



;; C / C++
;;
;; `cc-mode'
(use-package cc-mode
  :ensure nil
  :bind ( :map c-mode-base-map
          ;; I don't like c-electric indenting my code when insert the following
          ;; characters. This is done because occasionally I follow custom
          ;; indentation rules (e.g., in OpenFOAM or raylib, ...) and these
          ;; characters disrupt my editing flow by moving things around in an
          ;; undesirable way.
          ("/" . self-insert-command)
          (";" . self-insert-command)
          ("}" . self-insert-command)

          ("C-c C-;" . compile)
              ("C-;"     . recompile))
  :hook (
         ;; Use `//' comments in C, matching C++ convention.
         (c-mode-hook . (lambda () (c-toggle-comment-style -1)))
         (c++-mode-hook . (lambda () (setq electric-indent-inhibit nil))) ;; Why it's here??
         )
  :config
  (c-set-offset 'innamespace '-)

  (setq-default c-basic-offset 4
                c-default-style '((java-mode . "java")
                                   (awk-mode  . "awk")
                                   (c-mode    . "k&r")
                                   (c++-mode  . "bsd")))

  ;; Line up a closing paren with the line that opened it.
  (add-to-list 'c-offsets-alist '(arglist-close . c-lineup-close-paren))

  ;; NOTE: these two variables actually belong to `perl-mode'/`cperl-mode',
  ;; not `cc-mode' -- kept here unchanged from the original config, but
  ;; flagged in case you want to relocate them to a Perl-specific block.
  (setq cperl-indent-parens-as-block t)
  (setq perl-indent-parens-as-block t))



;; `etags': jump to symbol definitions using a project-wide `TAGS' file.
(use-package etags
  :ensure nil
  :preface
  (defun rc/visit-project-tags ()
    "Visit the TAGS file at the root of the current project, if any."
    (when-let* ((root (project-root (project-current))))
      (visit-tags-table (expand-file-name "TAGS" root))))
  :hook ((c-mode-hook c-ts-mode-hook) . rc/visit-project-tags)
  :config
  (setq tags-revert-without-query 1)
  (etags-regen-mode 1))                 ; or maybe (use-package etags-regen)



(provide 'rc-prog)
;;; rc-prog.el ends here.

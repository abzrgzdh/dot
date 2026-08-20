;;; rc-completion.el  -*- lexical-binding: t; -*-

;;; Commentary:


;; - in-buffer completion
;; - minibuffer completion
;; - binding help with whickey
;; - file path completion

;;; Code:

;; `ido': interactively-do, a fast fuzzy-matching completion UI for finding
;; files/switching buffers.
(use-package ido
  :ensure nil
  :bind (
         ("C-x f" . ignore)
         ("C-x C-b" . ido-switch-buffer)
         )
  :config
  (setq-default confirm-nonexistent-file-or-buffer nil)
  (setq ido-file-history t
        ido-use-faces t
        ido-default-buffer-method 'selected-window
        ido-auto-merge-work-directories-length -1
        ido-file-history t
        ido-enable-flex-matching t
        ido-everywhere t
        ido-use-filename-at-point nil
        ;; ido-use-virtual-buffers t
        ido-create-new-buffer 'always
        ido-file-extensions-order '(".vim" ".org" ".c" ".h" ".C" ".H" ".cpp" ".hpp" ".cc" ".hh"
                                    ".md" ".txt" ".py" ".emacs" ".xml" ".el" ".ini" ".cfg" ".cnf")
        ido-ignore-extensions t
        completion-ignored-extensions (append '(".rbc") completion-ignored-extensions))
  (ido-mode 1))



(use-package emacs
  :ensure nil
  :preface
  (defun rc/switch-to-completions-if-visible ()
    "If a *Completions* buffer is visible, switch focus to it."
    (interactive)
    (if (get-buffer-window "*Completions*" 0)
        (switch-to-completions)))
  :bind (("M-S-o" . rc/switch-to-completions-if-visible)
         ("C-M-g" . keyboard-escape-quit)))



(use-package completion-preview
  :ensure nil
  :demand t
  :bind
  ( :map completion-preview-active-mode-map
    ("M-i" . completion-preview-insert-word)
    ("M-n" . completion-preview-next-candidate)
    ("M-p" . completion-preview-prev-candidate)
    ("M-<return>" . completion-preview-insert)
    ;; With TAB we effectively defer to the *Completions* buffer to show more
    ;; completion candidates at once.
    ("<tab>" . completion-preview-complete))
  :config
  (setq completion-preview-minimum-symbol-length 2)
  (global-completion-preview-mode 1))



;; `minibuffer'
(use-package minibuffer
  :defer nil
  :ensure nil
  :bind (:map minibuffer-local-map
              ;; Cycle through completion candidates shown in the minibuffer.
              ("M-{" . minibuffer-previous-completion)
              ("M-}" . minibuffer-next-completion))
  :config
  ;; The following set of configurations are copied from this post by Prot:
  ;; https://protesilaos.com/codelog/2026-07-29-emacs-default-minibuffer-completion-overview/

  ;; Do not inform me about the default keybindings to select a
  ;; candidate.
  (setq completion-show-help nil)

  ;; Do not print messages in the echo area that pertain to
  ;; completion---those are distracting.
  (setq completion-show-inline-help t)

  ;; Show useful annotations in various minibuffer prompts (though the
  ;; `marginalia' package greatly improves this).
  (setq completions-detailed t)

  ;; Do not use rows and columns for completions: a single vertical
  ;; list is easier to follow.
  (setq completions-format 'vertical)

  ;; Put an upper limit to the Completions window, so that it does not
  ;; disorient me.
  (setq completions-max-height 12)

  ;; Rely on previous inputs to surface candidates towards the top of
  ;; the list (enable the built-in `savehist-mode' to persist
  ;; history).
  (setq completions-sort 'historical)

  ;; Show the Completions buffer if I hit TAB but there is no unique match yet.
  (setq completion-auto-help t)

  ;; Never switch to the Completions buffer when I type TAB, because I want to
  ;; select candidates while the minibuffer is still in focus, per
  ;; `minibuffer-visible-completions'.  This has the advantage of auto-updating
  ;; the completions as I type. TODO: update (I don't like neigher)
  (setq completion-auto-select nil
        minibuffer-visible-completions nil)

  ;; Those two are also relevant for the `completion-category-overrides', which I
  ;; cover elsewhere in this article.
  (setq completion-eager-display nil)
  (setq completion-eager-update t)

  ;; Pattern-matching styles to interpret our input in every context.
  ;; (setq completion-styles '(basic substring initials flex))

  ;; An exception to the above for the `file' category, where we
  ;; specifically want to use the `partial-completion' style:
  (setq completion-category-overrides
        '((file . ((styles partial-completion))))))



;;
;;; File Path Completion

(use-package emacs
  :ensure t
  :demand t
  :bind
  ;; Quick file-path completion in comint-derived buffers (shells, etc).
  ;;
  ;;TODO: add more explanation (not sure why I add this; there's also `C-M-/')
  ("C-x /" . comint-dynamic-complete-filename))



;; Which-Key Mode
;;
;; Shows a list of all the key you can press next.
(use-package which-key
  :ensure nil
  :demand t
  :config
  (which-key-mode 1))



(provide 'rc-completion)
;;; rc-completion.el ends here

;;; rc-ui.el -*- lexical-binding: t; -*-

;;; Commentary:

;; NOTE: Some of the configuration here are attached to the pseudo-package
;; `emacs' (a `use-package' convention for configuring built-in
;; variables/behavior), with `:ensure nil' since "emacs" itself is obviously not
;; installable.

;; TODO: rc/ -> rc-



;;
;;; Themes

(use-package emacs
  :ensure nil
  :demand t
  :config

  (setq modus-themes-mixed-fonts t
        modus-themes-italic-constructs t
        modus-themes-bold-constructs t)

  (load-theme 'modus-vivendi :no-confirm-loading))



;;
;;; Fonts

(use-package emacs
  :ensure nil
  :demand t
  :config
  (setq rc/font-name "hack nerd font")
  ;; (setq rc/font-weight 'semilight)
  (setq rc/font-size "18")
  (setq rc/font (concat rc/font-name "-" rc/font-size))
  (set-face-attribute 'default nil :font rc/font) ; :weight rc/font-weight)
  (add-to-list 'default-frame-alist `(font . ,rc/font)))



;;
;;; General, opinion-free-ish behavior tweaks.

(use-package emacs
  :ensure nil
  :demand t
  :bind
  ;; Prevent trackpad pinch-zoom and Ctrl+scroll from silently changing
  ;; the frame's font size while you're just trying to scroll.
  (("<pinch>" . ignore)
   ("<C-wheel-up>" . ignore)
   ("<C-wheel-down>" . ignore))
  :config
  ;; Skip the "Welcome to GNU Emacs" splash screen.
  (setq inhibit-startup-message t)

  ;; Silence the bell entirely instead of beeping/flashing on every minor
  ;; "error" (e.g. reaching buffer boundaries).
  (setq ring-bell-function 'ignore)

  ;; Use the echo-area y/n prompt instead of a graphical dialog box when
  ;; Emacs is running in a windowed environment.
  (setq use-dialog-box nil)

  ;; Confirm before quitting Emacs, but with a quick y/n prompt rather
  ;; than having to spell out "yes"/"no".
  (setq confirm-kill-emacs 'y-or-n-p)

  ;; Emacs 28+: answer all yes/no prompts with a single y/n keystroke.
  ;; (This supersedes the old `(defalias 'yes-or-no-p 'y-or-n-p)' trick,
  ;; which is redundant now and should not be used in modern Emacs.)
  (setopt use-short-answers t)

  ;; Don't leave subprocesses (compilation, shells, ...) prompting for
  ;; confirmation when killing Emacs.
  (setq confirm-kill-processes nil)

  ;; Keep point's screen position stable when scrolling.
  (setq scroll-preserve-screen-position t)

  ;; Bring the frame to the foreground on startup instead of opening
  ;; behind other windows.
  (select-frame-set-input-focus (selected-frame)))



;;
;;; Frame

(use-package emacs
  :ensure nil
  :demand t
  :init
  ;; Start maximized rather than at some arbitrary default size.
  (add-to-list 'initial-frame-alist '(fullscreen . maximized))

  ;; No window-manager decorations (title bar, borders...).  Commented out
  ;; because it's situational -- flip on if you want a borderless frame.
  ;; (add-to-list 'default-frame-alist '(undecorated . t))

  :config
  ;; Transparency.
  ;;
  ;; 100 == fully opaque for both the active and inactive frame.  Lower either
  ;; number for a see-through effect.
  (set-frame-parameter (selected-frame) 'alpha-background 100)
  (add-to-list 'default-frame-alist '(alpha 100 100)))



;; TODO
;;; Window

(use-package emacs
  :ensure nil
  :demand t
  :bind (
         ;; Delete other windows in the current column
         ;; source: saw this in a video by Prot:
         ;;         https://www.youtube.com/watch?v=1-UIzYPn38s
         ("C-x !" . delete-other-windows-vertically)

         ;; Switch to a buffer in the "other window".  NOTE: This is an easier
         ;; alternative to the default 'C-x 4 b' binding.
         ("C-x B" . switch-to-buffer-other-window)))



;;
;;; Display Buffer

(use-package emacs
  :ensure nil
  :demand t
  :config
  ;; Automatically select the window
  (setq display-buffer-alist
        '(;; Jump to the window containing the results of `occur'
          ((or . ((derived-mode . occur-mode)))
           (display-buffer-reuse-mode-window display-buffer-at-bottom)
           (body-function . (lambda (window &rest _) (select-window window)))
           (dedicated . t)
           (preserve-size . (t . t)))

          ;; Don't show modeline for the ancillary "*Completions*" buffer
          ("\\*Completions\\*"
           (display-buffer-reuse-mode-window display-buffer-at-bottom)
           (window-parameters . ((mode-line-format . none)))))))



;;
;;; Line numbers & mode line

(use-package display-line-numbers
  :ensure nil
  :hook
  ;; Relative line numbers only where they're actually useful: source
  ;; code buffers (handy for `d2j', `y3k'-style relative motions).
  (prog-mode . display-line-numbers-mode)
  :config
  (setq display-line-numbers-type 'relative)
  ;; Show the column number next to the line number in the mode line.
  (column-number-mode 1))



;;
;;; Whitespace
;; TODO

;; `whitespace': visually flags "negative space" issues -- trailing
;; whitespace, tabs, missing final newlines -- that are easy to miss but
;; often trip up diffs/linters.  Config courtesy of Protesilaos Stavrou.
(use-package whitespace
  :ensure nil
  :hook (prog-mode . whitespace-mode)
  :bind (("C-c z"   . delete-trailing-whitespace)
         ("C-x x w" . whitespace-mode))
  :config
  (setq whitespace-style
        '(face
          tabs
          newline
          tab-mark
          trailing
          missing-newline-at-eof
          space-after-tab::tab
          space-after-tab::space
          space-before-tab::tab
          space-before-tab::space)))



;;
;;; Hide Unwanted Minor Modes in Modeline
;; This is similar to diminish package (I remember, for some reasons, it
;; wouldn't work for some packages.)  Only for emacs 31 (TODO: add a
;; conditional).
;; source:
;; https://emacsredux.com/blog/2025/12/24/hide-minor-modes-in-the-modeline-in-emacs-31/
(use-package emacs
  :ensure nil
  :config
  (setq mode-line-collapse-minor-modes
        '(abbrev-mode
          flyspell-mode
          flyspell-prog-mode
          eldoc-mode
          jinx-mode
          beacon-mode
          which-key-mode
          whitespace-mode)))



(provide 'rc-ui)
;;; rc-ui.el ends here.

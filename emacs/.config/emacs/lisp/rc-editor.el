;;; rc-editor.el  -*- lexical-binding: t; -*-


;;; Commentary:

;; Indentation, Delsel, Selection, Parens highlighting, Pairing parens,
;; Yasnippet, Move-text, Visible mark, Beacon, View, Repeat, Expand region,
;; Multiple cursor, Midnight ...


;;
;;; Packages:


;;
;;; Misc.
;; TODO: disect.

(use-package emacs
  :ensure nil
  :demand t
  :config
  ;; Always end files with a trailing newline, and add one automatically
  ;; if a visited file is missing it.
  (setq require-final-newline t)

  ;; Default width used for filling paragraphs / the fill-column
  ;; indicator.
  (setq-default fill-column 80)

  ;; Enable the confusing `C-x n p' binding
  (put 'narrow-to-page 'disabled nil))



;;
;;; Indentation

(use-package emacs
  :demand t
  :ensure nil
  :config
  (setq-default indent-tabs-mode nil    ; Use spaces for indentation
                tab-width 4)            ; Use 4 spaces as shift width

  ;; Disable indenting the *current* line on RET; only the *new* line gets
  ;; indented.  (Still experimental for you -- flip this off if you find it gets
  ;; in the way.)
  (setq-default electric-indent-inhibit t)

  ;; Perform completion-at-point only after there's no more indentation action.
  ;; TODO: Move to completion-related config
  (setq tab-always-indent 'complete))



;; `delsel' typing while a region is selected replaces the region (standard,
;; "modern editor" behavior) instead of inserting before/after it.
(use-package delsel
  :ensure nil
  :hook (after-init . delete-selection-mode))



;;
;;; Selection behavior & custom editing commands

(use-package emacs
  :ensure nil
  :preface
  ;; --- Custom commands --------------------------------------------------
  ;; All of this config's hand-written commands are prefixed with `rc/' so
  ;; they can never collide with a command defined by some package.

  (defun rc/backward-delete-word (arg)
    "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times.  Unlike
`backward-kill-word', the deleted text is NOT pushed onto the
kill-ring -- this is a delete, not a kill."
    (interactive "p")
    (delete-region (point) (progn (backward-word arg) (point))))

  ;; TODO: given prefix it should open-line above
  (defun rc/open-line-below ()
    "Go to the end of the current line and open a new, indented line."
    (interactive)
    (end-of-line)
    (newline-and-indent))

  (defun rc/duplicate-line ()
    "Duplicate the current line, keeping point at the same column."
    (interactive)
    (let ((column (- (point) (pos-bol)))
          (line (let ((s (thing-at-point 'line t)))
                  (if s (string-remove-suffix "\n" s) ""))))
      (move-end-of-line 1)
      (newline)
      (insert line)
      (move-beginning-of-line 1)
      (forward-char column)))

  (defun rc/unfill-paragraph ()
    "Replace newline chars in the current paragraph with single spaces.
This is the inverse of `fill-paragraph': it joins a hard-wrapped
paragraph back into one long line."
    (interactive)
    (let ((fill-column most-positive-fixnum))
      (fill-paragraph nil)))

  (defun rc/insert-timestamp ()
    "Insert the current date and time at point."
    (interactive)
    (insert (format-time-string "(%Y-%m-%d %H:%M:%S)")))

  :init
  (transient-mark-mode 1)

  :bind
  (;; Word-wise deletion: `C-M-<backspace>' kills (goes to kill-ring),
   ;; `M-<backspace>' deletes (does not touch the kill-ring) -- mirrors
   ;; the kill/delete distinction Emacs already makes for characters.
   ("C-M-<backspace>" . backward-kill-word)
   ("M-<backspace>"   . rc/backward-delete-word)
   ("M-o"             . rc/open-line-below)
   ("C-,"             . rc/duplicate-line)
   ("C-c M-q"         . rc/unfill-paragraph)
   ("C-x t ."         . rc/insert-timestamp)
   ;; `M-`' switches focus to the next frame (uses the modern `kbd'
   ;; syntax rather than the old raw "\M-`" control-character escape).
   ("M-`"             . other-frame)))



;;
;;; Parens
;; TODO

;; `paren': highlights the matching parenthesis for the one under/near
;; point, so you can see at a glance which pair you're inside of.
(use-package paren
  :ensure nil
  :demand t
  :config
  (setq show-paren-delay 0.1)
  (setq show-paren-highlight-openparen t)
  (setq show-paren-style 'parenthesis)
  (setq show-paren-when-point-in-periphery nil)
  (setq show-paren-when-point-inside-paren t)
  (setq show-paren-when-point-in-periphery t)
  (setq show-paren-context-when-offscreen 'overlay)) ; Emacs 29+



;;
;;; Pair

;; `elec-pair': automatically inserts the closing bracket/quote when you
;; type the opening one, and lets you "type through" a closer instead of
;; inserting a duplicate.
(use-package elec-pair
  :ensure nil
  :hook (((prog-mode org-mode) . electric-pair-mode)
         (text-mode . rc/elec-pair-text-mode-setup)
         (org-mode  . rc/elec-pair-org-mode-setup))
  :preface
  (defun rc/elec-pair-add-pairs (pairs)
    (electric-pair-local-mode 1)
    (dolist (pair pairs)
      (add-to-list (make-local-variable 'electric-pair-pairs) pair)
      (add-to-list (make-local-variable 'electric-pair-text-pairs) pair)))

  (defun rc/elec-pair-text-mode-setup ()
    (rc/elec-pair-add-pairs
     '((?` . ?`))))

  (defun rc/elec-pair-org-mode-setup ()
    (rc/elec-pair-add-pairs
     '((?/ . ?/)
       (?= . ?=)
       (?~ . ?~))))

  :config
  ;; Don't auto-pair these characters even inside `electric-pair-mode' --
  ;; they cause more friction than they save.
  (with-eval-after-load 'elec-pair
    (when (boundp 'electric-pair-mode-map)
      (define-key electric-pair-mode-map "," 'self-insert-command)
      (define-key electric-pair-mode-map ":" 'self-insert-command)
      (define-key electric-pair-mode-map "(" 'self-insert-command)
      (define-key electric-pair-mode-map ")" 'self-insert-command)
      (define-key electric-pair-mode-map (kbd ">") #'self-insert-command)
      (define-key electric-pair-mode-map (kbd "<") #'self-insert-command)))

  (setq electric-pair-pairs '((?\{ . ?\})
                              (?\[ . ?\])))
  (setq electric-pair-preserve-balance t
        electric-pair-skip-whitespace nil
        electric-pair-delete-adjacent-pairs t
        electric-pair-open-newline-between-pairs nil
        electric-pair-skip-whitespace-chars '(9 10 32)
        electric-pair-skip-self 'electric-pair-default-skip-self)

  :bind
  ;; Delete a pair (the bracket after point, plus its match) in one go.
  ("M-(" . delete-pair))



;; `yasnippet': template/snippet expansion, used heavily by the CDLaTeX
;; integration below (and generally useful on its own).
(use-package yasnippet
  :demand t
  :ensure t
  :config
  (yas-global-mode 1)
  (setq yas-triggers-in-field t) ; allow expanding a snippet inside another
  (setq yas-snippet-dirs '("~/.config/emacs/snippets/"))

  (defun rc/yas-try-expanding-auto-snippets ()
    (when yas-minor-mode
      (let ((yas-buffer-local-condition ''(require-snippet-condition . auto)))
        (yas-expand))))
  (add-hook 'post-command-hook #'rc/yas-try-expanding-auto-snippets))



;;
;;; Move lines

;; `move-text': moves a line under the point, or all lines in the region, up and
;; down.
(use-package move-text
  :ensure t
  :demand t
  :bind
  ("C-S-n" . move-text-down)
  ("C-S-p" . move-text-up))



;; `visible-mark': puts a visible overlay on the mark, so you can see
;; where `C-SPC'/`C-x C-x' will jump back to.
(use-package visible-mark
  :ensure t
  :config
  (setq visible-mark-max 1)
  (global-visible-mark-mode 1))



;; `beacon': briefly flashes the cursor line after a big jump (switching
;; windows/buffers, scrolling...) so your eye never loses point.
(use-package beacon
  :ensure t
  :config
  (beacon-mode 1))



;; `view' View files in something similar to vim
(use-package view
  :ensure nil
  :defer t
  :config
  ;; Enable view-mode when entering read-only
  (setq view-read-only t)

  ;; Enhanced keybindings
  (with-eval-after-load 'view
    ;; More Emacs-ish keys

    ;; Navigation
    (define-key view-mode-map (kbd "n") 'next-line)
    (define-key view-mode-map (kbd "p") 'previous-line)
    (define-key view-mode-map (kbd "f") 'forward-char)
    (define-key view-mode-map (kbd "b") 'backward-char)

    ;; Beginning/end of line
    (define-key view-mode-map (kbd "a") 'beginning-of-line)
    (define-key view-mode-map (kbd "e") 'end-of-line)

    ;; Vim-ish keys

    ;; Quick exit to edit mode
    (define-key view-mode-map (kbd "i") 'View-exit)

    ;; Beginning/end of line (Vim style)
    (define-key view-mode-map (kbd "0") 'beginning-of-line)
    (define-key view-mode-map (kbd "$") 'end-of-line)

    ;; Beginning/end of buffers
    (define-key view-mode-map (kbd "g") 'beginning-of-buffer)
    (define-key view-mode-map (kbd "G") 'end-of-buffer)

    ;; Other bespoke bindings
    (define-key view-mode-map (kbd ";") 'other-window)

    (define-key view-mode-map (kbd "SPC") 'nil)))



;; `repeat' Repeat-mode
;;
;; After invoking a multi-key command once, lets you repeat it by pressing just
;; its last key (or `C-z') again.  It saves re-typing the whole key sequence for
;; things you do repeatedly in a row (e.g. `other-window').
(use-package repeat
  :ensure nil
  :hook (after-init . repeat-mode)
  :init
  (setq repeat-too-dangerous '(kills-this-buffer er/expand-region))
  :custom
  (repeat-exit-timeout 5))



;; `expand-region': grows the selected region by increasingly larger semantic
;; units (word -> sexp -> statement -> ...) with each press.
(use-package expand-region
  :ensure t
  :bind (("C-=" . er/expand-region)
         ("C-S-=" . er/contract-region)))



;; `multiple-cursors': edit several matching pieces of text at once.
(use-package multiple-cursors
  :ensure t
  :config
  (setq mc/always-run-for-all t)
  (setq mc/cmds-to-run-for-all t)
  :bind (("C->"         . mc/mark-next-like-this-symbol)
         ("C-<"         . mc/mark-previous-like-this-symbol)
         ("C-c C-<"     . mc/mark-all-like-this)
         ("C-S-c C-S-c" . mc/edit-lines)
         ("C-\""        . mc/skip-to-next-like-this)
         ("C-:"         . mc/skip-to-previous-like-this)))



;; `midnight' automatically clean up old buffers. This also provides a
;; midnight-hook which makes it possible to define cleanup functions.
;; source: github:belak/dotemacs
(use-package midnight
  :ensure nil
  :commands midnight-mode
  :hook (after-init . midnight-mode))



;;
;;; Functions


(defun belak/keyboard-quit-dwim (&optional interactive)
  "Do-What-I-Mean behaviour for a general `keyboard-quit'.

The generic `keyboard-quit' does not do the expected thing when
the minibuffer is open.  Whereas we want it to close the
minibuffer, even without explicitly focusing it.

The DWIM behaviour of this command is as follows:

- When the region is active, disable it.
- When the Completions buffer is selected, close it.
- When a minibuffer is open, but not focused, close the minibuffer.
- In every other case use the regular `keyboard-quit'.

This was originally from https://protesilaos.com/codelog/2024-11-28-basic-emacs-configuration/"
  (interactive)
  (cond ((region-active-p)
         (keyboard-quit))
        ((derived-mode-p 'completion-list-mode)
         (delete-completion-window))
        ((> (minibuffer-depth) 0)
         (abort-recursive-edit))
        (t
         (keyboard-quit))))
(global-set-key [remap keyboard-quit] #'belak/keyboard-quit-dwim)



(provide 'rc-editor)
;;; rc-editor.el ends here.

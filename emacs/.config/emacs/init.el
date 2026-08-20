;;; init.el --- Personal Emacs configuration -*- lexical-binding: t; -*-
;;
;; Author: Ali Bozorgzadeh
;;
;;; Commentary:
;;
;; This file is organized into clearly labeled, topical sections so that
;; related settings live together instead of being scattered by the order
;; they happened to be written in.  Every package is configured with
;; `use-package', and every `use-package' block carries a short comment
;; directly above it explaining:
;;
;;   WHAT the package/setting does
;;   WHY  it is here
;;   HOW  it is wired up (keys, hooks, etc.)
;;
;; search for the "sec:" tag to jump around, e.g. with `isearch' or `occur'
;;
;;; Code:


;;; sec:startup ----------------------------------------------------------
;;; Startup performance
;;; ----------------------------------------------------------------------
;;
;; The garbage collector runs whenever allocation crosses
;; `gc-cons-threshold' (default: a tiny 800KB).  Emacs' startup allocates a
;; lot in a short window, so a low threshold means many needless GC pauses
;; while loading packages.  We raise it drastically here and lower it back
;; down to a sane, still-generous value once startup is complete (see the
;; very bottom of this file).
;;
;; NOTE: the more modern place to do this trick is in a separate
;; `early-init.el' (loaded before the package system and UI even start up),
;; but everything is kept in this single `init.el' on purpose.
(setq gc-cons-threshold (* 50 1000 1000)) ; 50MB during startup


;;; sec:packages ---------------------------------------------------------
;;; Package management
;;; ----------------------------------------------------------------------
;;
;; WHAT: bootstrap `package.el' (Emacs' built-in package manager), add the
;;       MELPA archive (the most complete community package repository),
;;       and make sure `use-package' itself is available.
;; WHY:  everything below this point is declared with `use-package', so it
;;       has to exist before we can use it.
;; HOW:  `use-package-always-ensure' is set to `t' so that every
;;       `use-package' block below automatically installs its package if
;;       it's missing -- we no longer have to repeat `:ensure t' on every
;;       single third-party package (a repetitive pattern in the old
;;       config).  Built-in packages that ship with Emacs (e.g. `dired',
;;       `org', `paren'...) are NOT installable via `package.el', so those
;;       blocks explicitly opt out with `:ensure nil'.
(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

;; Make sure `use-package' itself is installed (it has shipped built in
;; since Emacs 29, but this keeps the file portable to older Emacsen too).
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)
(setq use-package-compute-statistics t)

(use-package benchmark-init
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))


;;; sec:defaults -----------------------------------------------------------
;;; Core sane defaults
;;; ----------------------------------------------------------------------
;;
;; General, opinion-free-ish behavior tweaks that don't belong to any one
;; package.  These are attached to the pseudo-package `emacs' (a
;; `use-package' convention for configuring built-in variables/behavior),
;; with `:ensure nil' since "emacs" itself is obviously not installable.
(use-package emacs
  :ensure nil
  :config
  ;; Use spaces for indentation
  (setq-default indent-tabs-mode nil)

  ;; Use 4 spaces as shift width
  (setq-default tab-width 4)

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

  ;; Follow symlinks straight into version-controlled files instead of
  ;; asking every time.
  (setq vc-follow-symlinks t)

  ;; Don't leave subprocesses (compilation, shells, ...) prompting for
  ;; confirmation when killing Emacs.
  (setq confirm-kill-processes nil)

  ;; Always end files with a trailing newline, and add one automatically
  ;; if a visited file is missing it.
  (setq require-final-newline t)

  ;; Keep point's screen position stable when scrolling.
  (setq scroll-preserve-screen-position t)

  ;; Default width used for filling paragraphs / the fill-column
  ;; indicator.
  (setq-default fill-column 80)

  ;; Disable indenting the *current* line on RET; only the *new* line
  ;; gets indented.  (Still experimental for you -- flip this off if you
  ;; find it gets in the way.)
  (setq-default electric-indent-inhibit t)

  ;; Bring the frame to the foreground on startup instead of opening
  ;; behind other windows.
  (select-frame-set-input-focus (selected-frame))

  :bind
  ;; Quick file-path completion in comint-derived buffers (shells, etc).
  ("C-x /" . comint-dynamic-complete-filename))

;; NOTE: `debug-on-error' is intentionally NOT enabled here.  Leaving it
;; permanently on turns every minor, harmless error into a full backtrace
;; buffer, which is noisy for day-to-day use.  Turn it on only while you're
;; actively debugging with `M-x toggle-debug-on-error' (or `C-u' that
;; command to debug specific error types).


;;; sec:macos ---------------------------------------------------------------
;;; macOS-only settings
;;; ----------------------------------------------------------------------
;;
;; WHAT: remap the Mac's Command key to Emacs' Meta modifier.
;; WHY:  matches most people's muscle memory better than the Option key,
;;       which is left free for typing special/international characters.
;; HOW:  guarded by `system-type' so these variables (which only mean
;;       anything on the macOS/NS port) are never set on Linux/Windows --
;;       setting them unconditionally, as the old config did, is harmless
;;       but misleading on other platforms.
(when (eq system-type 'darwin)
  (setq mac-option-key-is-meta nil
        mac-command-key-is-meta t
        mac-command-modifier 'meta
        mac-option-modifier 'none))


;;; sec:frame -----------------------------------------------------------
;;; Frame, font & appearance
;;; ----------------------------------------------------------------------
(use-package emacs
  :ensure nil
  :init
  ;; Start maximized rather than at some arbitrary default size.
  (add-to-list 'initial-frame-alist '(fullscreen . maximized))

  ;; No window-manager decorations (title bar, borders...).  Commented out
  ;; because it's situational -- flip on if you want a borderless frame.
  ;; (add-to-list 'default-frame-alist '(undecorated . t))

  :config
  ;; --- Font -----------------------------------------------------------
  (setq rc/font-name "SauceCodePro Nerd Font")
  (setq rc/font-size "17")
  (setq rc/font (concat rc/font-name "-" rc/font-size))
  (set-face-attribute 'default nil :font rc/font)
  (add-to-list 'default-frame-alist `(font . ,rc/font))

  ;; --- Chrome: turn off UI elements we don't use -----------------------
  (menu-bar-mode 1)                    ; actually useful, keep it
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (blink-cursor-mode -1)

  ;; --- Mouse wheel ------------------------------------------------------
  (mouse-wheel-mode 1)

  ;; --- Transparency -----------------------------------------------------
  ;; 100 == fully opaque for both the active and inactive frame.  Lower
  ;; either number for a see-through effect.
  (set-frame-parameter (selected-frame) 'alpha-background 100)
  (add-to-list 'default-frame-alist '(alpha 100 100))

  :bind
  ;; Prevent trackpad pinch-zoom and Ctrl+scroll from silently changing
  ;; the frame's font size while you're just trying to scroll.
  (("<pinch>" . ignore)
   ("<C-wheel-up>" . ignore)
   ("<C-wheel-down>" . ignore)))


;;; sec:window -----------------------------------------------------------
;;; Window settings
;;; ----------------------------------------------------------------------
(use-package emacs
  :ensure nil
  :bind (
         ;; Delete other windows in the current column
         ;; source: saw this in a video by Prot:
         ;;         https://www.youtube.com/watch?v=1-UIzYPn38s
         ("C-x !" . delete-other-windows-vertically))

  :config


  (defun rc/select-window (window &rest _)
    "Select WINDOW for display-buffer-alist"
    (select-window window))

  ;; Automatically select the window
  ;; TODO: move to a separate section
  (setq display-buffer-alist
        '(;; Jump to the window containing the results of `occur'
          ((or . ((derived-mode . occur-mode)))
           (display-buffer-reuse-mode-window display-buffer-at-bottom)
           (body-function . rc/select-window)
           (dedicated . t)
           (preserve-size . (t . t)))

          ;; Don't show modeline for the ancillary "*Completions*" buffer
          ("\\*Completions\\*"
           (display-buffer-reuse-mode-window display-buffer-at-bottom)
           (window-parameters . ((mode-line-format . none))))

          ;; Open Info to the right
          ((or (major-mode . Info-mode)
               (major-mode . help-mode))
           (display-buffer-reuse-window
            display-buffer-in-side-window)
           (reusable-frames . visible)
           (side . right)
           (window-width . 0.33))

          )))


;;; sec:themes -----------------------------------------------------------
;;; Color themes
;;; ----------------------------------------------------------------------

  ;;
  ;; WHAT: two Modus-themes-family theme collections by Protesilaos
  ;;       Stavrou: `standard-themes' (a more traditional light/dark look)
  ;;       and `ef-themes' (a large, vividly colored family of themes).
  ;; WHY:  both are kept installed/configured so you can freely switch
  ;;       between either family; only one theme is actually *loaded* below.
  ;; HOW:  each family is told to "take over" `modus-themes-mode' so that
  ;;       Modus-theme-aware packages keep working no matter which family is
  ;;       active.  `ef-fig' is the theme actually loaded at startup; the
  ;;       commented lines show other ways to pick a theme (including
  ;;       Modus' own "load a random theme" commands).

  ;; (use-package standard-themes
  ;;   :init
  ;;   (standard-themes-take-over-modus-themes-mode 1)
  ;;   :config
  ;;   (setq modus-themes-mixed-fonts t)
  ;;   (setq modus-themes-italic-constructs t)
  ;;   ;; (modus-themes-load-theme 'standard-dark)
  ;;   )

  ;; (use-package ef-themes
  ;;   :init
  ;;   (ef-themes-take-over-modus-themes-mode 1)
  ;;   :config
  ;;   (setq modus-themes-mixed-fonts t)
  ;;   (setq modus-themes-italic-constructs t)
  ;;   ;; Other options: `ef-themes-load-random', `ef-themes-load-random-dark',
  ;;   ;; `ef-themes-load-random-light'.
  ;;   ;; (load-theme 'ef-fig t)
  ;;   )

  (use-package naysayer-theme
    :config
    (load-theme 'naysayer t)
    ;; (custom-set-faces
    ;; '(mode-line-inactive ((t (:background "#264349" :foreground "#d1b897" :box nil)))))
    )

;; Other themes that have lived in this config at various points, kept
;; here for quick reference/switching:
;; (load-theme 'leuven-dark t)
;; (load-theme 'modus-vivendi t)
;; (load-theme 'solarized-dark t)
;; (load-theme 'zenburn t)


;;; sec:linenum -----------------------------------------------------------
;;; Line numbers & mode line
;;; ----------------------------------------------------------------------
(use-package emacs
  :ensure nil
  :hook
  ;; Relative line numbers only where they're actually useful: source
  ;; code buffers (handy for `d2j', `y3k'-style relative motions).
  (prog-mode . display-line-numbers-mode)
  :config
  (setq display-line-numbers-type 'relative)
  ;; Show the column number next to the line number in the mode line.
  (column-number-mode 1))


;;; sec:customfile -----------------------------------------------------------
;;; `custom.el' handling
;;; ----------------------------------------------------------------------
;;
;; WHAT: point Emacs' "Customize" UI at its own file instead of dumping
;;       auto-generated `custom-set-variables' blocks into this file.
;; WHY:  keeps hand-written config and machine-generated config cleanly
;;       separated.
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)


;;; sec:editing -----------------------------------------------------------
;;; Selection behavior & custom editing commands
;;; ----------------------------------------------------------------------
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
  ;; Typing while a region is selected replaces the region (standard,
  ;; "modern editor" behavior) instead of inserting before/after it.
  (transient-mark-mode 1)
  (delete-selection-mode 1)

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

;; `ffap' ("find file at point"): opens the file/URL under the cursor
;; instead of having to select and copy it yourself.
(use-package ffap
  :ensure nil
  :config
  (ffap-bindings)
  :bind
  ("M-s M-f" . find-file-at-point))

;; `move-text': moves a line under the point, or all lines in the region, up and
;; down.
(use-package move-text
  :ensure t
  :bind
  ("M-n" . move-text-down)
  ("M-p" . move-text-up))


;;; sec:pairs -----------------------------------------------------------
;;; Parens, electric pairs & whitespace
;;; ----------------------------------------------------------------------

;; `paren': highlights the matching parenthesis for the one under/near
;; point, so you can see at a glance which pair you're inside of.
(use-package paren
  :ensure nil
  :hook (prog-mode . show-paren-local-mode)
  :config
  (setq show-paren-style 'parenthesis)
  (setq show-paren-when-point-in-periphery nil)
  (setq show-paren-when-point-inside-paren nil)
  (setq show-paren-context-when-offscreen 'overlay)) ; Emacs 29+

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


;;; sec:modeline -----------------------------------------------------------
;;; Hide Unwanted Minor Modes
;;; ----------------------------------------------------------------------

;; only for emacs 31
;; source: https://emacsredux.com/blog/2025/12/24/hide-minor-modes-in-the-modeline-in-emacs-31/
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


;;; sec:spelling -----------------------------------------------------------
;;; Spell checking & input methods
;;; ----------------------------------------------------------------------
;; See: https://200ok.ch/posts/2020-08-22_setting_up_spell_checking_with_multiple_dictionaries.html

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

;; `jinx': a fast, modern, multi-language spell checker built on
;; `libenchant' (Debian/Ubuntu package: `libenchant-2-dev').  Checks
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
  (setq jinx-languages "en_US en_GB fr fa de"
        jinx-camel-modes '(prog-mode)
        jinx-delay 0.1)

  ;; Don't check comments/strings in programming modes -- too noisy.
  (setq jinx-exclude-faces
        '((prog-mode font-lock-comment-face font-lock-string-face))))

;; Input method toggle (for typing accented/French characters, etc.)
;; `toggle-input-method' remembers the last method used, or falls back to
;; `default-input-method' below.
(use-package emacs
  :ensure nil
  :demand t
  :bind
  ("<f2>" . toggle-input-method)
  :config
  (setq default-input-method "french-postfix"))


;;; sec:textmode -----------------------------------------------------------
;;; Plain text mode
;;; ----------------------------------------------------------------------
;; Config courtesy of Protesilaos Stavrou.
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


;;; sec:files -----------------------------------------------------------
;;; File, buffer & directory management
;;; ----------------------------------------------------------------------

;; `recentf': tracks recently opened files so you can jump back to them
;; without hunting through directories.
(use-package recentf
  :ensure nil
  :preface
  (defun rc/ido-recentf-open ()
    "Use `ido-completing-read' to open a recently visited file.\n
     https://www.masteringemacs.org/article/find-files-faster-recent-files-package"
    (interactive)
    (if (find-file (ido-completing-read "Find recent file: " recentf-list))
        (message "Opening file...")
      (message "Aborting")))

  :hook (after-init . recentf-mode)
  :bind ("C-x C-r" . recentf-open)
  :config
  ;; Remote file will be kept without testing if they still exists
  ;; Source - https://stackoverflow.com/a/2069425
  (setq recentf-keep '(file-remote-p file-readable-p))

  (setopt recentf-save-file (locate-user-emacs-file "recentf"))
  (setopt recentf-max-saved-items 300)
  (setopt recentf-max-menu-items 15)
  (setopt recentf-auto-cleanup (if (daemonp) 300 'never))
  (setopt recentf-exclude (list "^/\\(?:ssh\\|su\\|sudo\\)?:"
                                (locate-user-emacs-file "elpa")
                                (expand-file-name "~/quicklisp/dists"))))

;; `saveplace': reopening a file drops you back at the last place you were
;; editing, instead of at the top.
(use-package saveplace
  :demand t
  :ensure nil
  :hook (after-init . save-place-mode)
  :config
  (setopt save-place-limit 600)
  (setopt save-place-file (locate-user-emacs-file "places"))
  (save-place-mode 1))

;; NOTE: history persistence (minibuffer history, kill-ring, etc.) is
;; handled by `psession' further down instead of the built-in `savehist',
;; which caused "wrong-type-argument" errors in this setup.  A couple of
;; earlier attempts at `savehist' configuration are kept below purely for
;; reference:
;; (use-package savehist
;;   :config
;;   (setq savehist-additional-variables '(search-ring regexp-search-ring))
;;   (setq history-length 300
;;         savehist-autosave-interval nil
;;         history-delete-duplicates t
;;         savehist-save-minibuffer-history t)
;;   (savehist-mode 1))
;; (use-package savehist
;;   :init
;;   (savehist-mode 1)
;;   :custom
;;   (history-length 1000)
;;   (savehist-autosave-interval 300)
;;   (savehist-additional-variables '(kill-ring search-ring regexp-search-ring)))

;; `files': tame the various auto-generated files Emacs likes to scatter
;; around a project (lockfiles, backups, autosaves).
(use-package files
  :ensure nil
  :config
  ;; Lockfiles (`.#foo.txt') can confuse tools like `npm start' into
  ;; thinking a file is being edited by someone else.
  (setq create-lockfiles nil)
  (setq auto-save-default nil)
  (setq auto-save-list-file-prefix nil)
  (setq make-backup-files nil))

;; `autorevert': keep buffers in sync with what's actually on disk, e.g.
;; after a `git checkout' or an external editor's changes.
(use-package autorevert
  :ensure nil
  :config
  (setq auto-revert-interval 2)
  (setq auto-revert-check-vc-info t)
  (setq global-auto-revert-non-file-buffers t)
  (setq auto-revert-verbose nil)
  (global-auto-revert-mode +1))

;; `dired': the built-in directory browser/file manager.
(use-package dired
  :ensure nil
  :defer t
  :config
  (setq dired-listing-switches
        "-aGFhlv --group-directories-first --time-style=long-iso")
  ;; When two dired windows are open, default copy/rename targets to the
  ;; other window rather than always the current directory.
  (setq dired-dwim-target t)
  ;; Avoid piling up dired buffers -- opening a new directory replaces
  ;; the old one instead of stacking.
  (setq dired-kill-when-opening-new-dired-buffer t))


;;; sec:vc -----------------------------------------------------------
;;; Version control & project management
;;; ----------------------------------------------------------------------

;; `magit': the definitive text-based Git porcelain for Emacs.
(use-package magit
  :bind ("C-x g" . magit-status))

;; `project': Emacs' built-in project-awareness library, used here mostly
;; to recognize project roots that aren't plain Git repos.
(use-package project
  :ensure nil
  :config
  (setq project-vc-extra-root-markers '(".project" ".bare"))
  (setopt project-switch-commands #'project-dired))

;; `editorconfig': respects any `.editorconfig' file in a project so
;; indentation/line-ending style stays consistent across editors and
;; contributors.
(use-package editorconfig
  :ensure nil
  :config
  (editorconfig-mode 1))

;; `ediff': side-by-side diff/merge tool.
(use-package ediff
  :defer t
  :ensure nil
  :custom
  ;; Plain, single-frame side-by-side layout instead of a separate
  ;; control frame -- much friendlier in tiling WMs and terminals.
  (ediff-split-window-function 'split-window-horizontally)
  (ediff-window-setup-function 'ediff-setup-window-plain)
  (ediff-keep-variants nil)
  (ediff-make-buffers-readonly-at-startup nil)
  (ediff-merge-revisions-with-ancestor t)
  (ediff-show-clashes-only t))


;;; sec:undo -----------------------------------------------------------
;;; Undo history
;;; ----------------------------------------------------------------------

;; `undo-fu': a thin wrapper around Emacs' native undo system that adds a
;; conventional, linear undo/redo (as opposed to stock Emacs' "undoing an
;; undo is itself undoable" tree behavior).
(use-package undo-fu
  :bind (("C-/"  . undo-fu-only-undo)
         ("M-_"  . undo-fu-only-redo)))

;; `undo-fu-session': persists undo history to disk between Emacs
;; sessions, so `C-/' still works after restarting Emacs.
(use-package undo-fu-session
  :init
  (setq undo-fu-session-directory "~/.config/emacs/undo")
  (setq undo-fu-session-incompatible-files
        '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'" "/TODO.md\\'"))
  :config
  (undo-fu-session-global-mode))

;; `vundo': visualizes the undo history as a navigable tree -- handy when
;; `undo-fu''s linear model isn't enough and you need to see branches.
(use-package vundo
  :bind ("C-x C-u" . vundo))

;; Earlier this config used `undo-tree' instead of `undo-fu'/`vundo'.
;; Kept here in case you ever want to switch back:
;; (use-package undo-tree
;;   :config
;;   (global-undo-tree-mode 1)
;;   (setq undo-tree-auto-save-history t)
;;   (setq undo-tree-history-directory-alist '(("." . "~/.config/emacs/undo")))
;;   (make-directory (expand-file-name "~/.config/emacs/undo") t))

;; (non-essential) academic-phrases
;; (use-package academic-phrases)


;;; sec:prog -----------------------------------------------------------
;;; General programming settings
;;; ----------------------------------------------------------------------

(defun rc/prog-mode-compile-keys ()
  "Bind quick compile/recompile keys local to programming buffers."
  (local-set-key (kbd "C-c C-;") #'compile)
  (local-set-key (kbd "C-;") #'recompile))

;; Using a named function (instead of an anonymous lambda) as the hook
;; function means it can be introspected and removed with
;; `remove-hook' -- an anonymous lambda can't be un-hooked reliably.
(add-hook 'prog-mode-hook #'rc/prog-mode-compile-keys)

;; `hl-todo': highlights TODO/FIXME/etc. keywords (usually in comments) so
;; they actually stand out instead of blending into the rest of the text.
(use-package hl-todo
  :hook (prog-mode . hl-todo-mode))


;;; sec:cc -----------------------------------------------------------
;;; C / C++
;;; ----------------------------------------------------------------------
(use-package cc-mode
  :ensure nil
  :bind (:map c-mode-base-map
              ("C-c C-;" . compile)
              ("C-;"     . recompile))
  :config
  (c-set-offset 'innamespace '-)

  ;; Use `//' comments in C, matching C++ convention.
  (add-hook 'c-mode-hook
            (lambda ()
              (c-toggle-comment-style -1)))

  (add-hook 'c++-mode-hook
            (lambda ()
              (setq electric-indent-inhibit nil)))

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
(defun rc/visit-project-tags ()
  "Visit the TAGS file at the root of the current project, if any."
  (when-let* ((root (project-root (project-current))))
    (visit-tags-table (expand-file-name "TAGS" root))))

(use-package etags
  :ensure nil
  :hook ((c-mode-hook c-ts-mode-hook) . rc/visit-project-tags)
  :config
  (setq tags-revert-without-query 1)
  (etags-regen-mode 1))                 ; or maybe (use-package etags-regen)


;;; sec:org -----------------------------------------------------------
;;; Org mode and friends
;;; ----------------------------------------------------------------------

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
  (setq org-agenda-files (list org-directory))

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
  (setq org-hide-emphasis-markers t) ; hide the /.../ and *...* markers
  (font-lock-add-keywords
   'org-mode
   '(("^ *\\([-]\\) "
      (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; An earlier, more elaborate attempt at per-level heading fonts/colors
  ;; lived here.  Kept for reference if you want to revisit it:
  ;; (let* ((variable-tuple
  ;;         (cond ((x-list-fonts "Helvetica") '(:font "Helvetica"))
  ;;               ((x-list-fonts "Times") '(:font "Times"))
  ;;               ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
  ;;               ((x-list-fonts "Verdana") '(:font "Verdana"))
  ;;               ((x-family-fonts "Sans Serif") '(:family "Sans Serif"))
  ;;               (nil (warn "Cannot find a Sans Serif Font."))))
  ;;        (headline `(:inherit default :weight bold)))
  ;;   (custom-theme-set-faces
  ;;    'user
  ;;    `(org-level-8 ((t (,@headline ,@variable-tuple))))
  ;;    `(org-level-7 ((t (,@headline ,@variable-tuple))))
  ;;    `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.1))))
  ;;    `(org-document-title ((t (,@headline ,@variable-tuple :height 1.15 :underline nil))))))
  ;; (custom-theme-set-faces
  ;;  'user
  ;;  '(variable-pitch ((t (:family "Times" :height 200 :weight thin))))
  ;;  '(fixed-pitch ((t (:family "Courier" :height 200)))))
  ;; (add-hook 'org-mode-hook 'variable-pitch-mode)
  ;; (add-hook 'org-mode-hook 'fixed-pitch-mode)
  ;; (add-hook 'org-mode-hook 'visual-line-mode)

  ;;; --- Workflow states ----------------------------------------------------
  (setq org-todo-keywords
        '((sequence
           "TODO(t)" "LATER(l@/!)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELLED(c@/!)")))

  ;;; --- Capture --------------------------------------------------------
  (setq org-capture-use-agenda-date t)

  (setq org-capture-templates
        `(("t" "Inbox/Incoming Items"
           entry (file ,(concat org-directory "/inbox.org"))
           "* TODO [#B] %? %^g\n"
           :empty-lines 0)

          ("t" "Scheduled Items"
           entry (file ,(concat org-directory "/calendar.org"))
           "* TODO [#B] %? %^g\n"
           :empty-lines 0)

          ("j" "Journal Entry"
           entry (file+datetree ,(concat org-directory "/journal.org"))
           "* %?"
           :empty-lines 1)

          ("m" "Meeting"
           entry (file+datetree ,(concat org-directory "/meetings.org"))
           "* %? :meeting:%^g \n** Attendees\n - \n** Notes\n** Action Items\n*** TODO [#A] "
           :tree-type week
           :clock-in t
           :clock-resume t
           :empty-lines 0)

          ("n" "Note"
           entry (file+headline ,(concat org-directory "/notes.org") "Random Notes")
           "** %?"
           :empty-lines 0)))

  (setq org-tag-alist
        '(;; Places
          (:startgroup . nil)
          ("@home" . ?h)
          ("@work" . ?w)
          (:endgroup . nil)

          ;; Activities
          (:startgroup . nil)
          ("@code" . ?p)
          ("@email" . ?e)
          ("@calls" . ?a)
          ("@chore" . ?c)
          ("@errands" . ?r)
          ("@study" . ?s)
          ("@read" . ?R)
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
        org-confirm-babel-evaluate t))

;; Automatically stamp TODO entries with a CREATED property when they're
;; captured, so you can always tell how old a task is.
(defun rc/org-insert-created-if-todo ()
  "Insert a CREATED property on the just-captured entry, if it's a TODO."
  (when (org-entry-get nil "TODO")
    (org-expiry-insert-created)))

(add-hook 'org-capture-before-finalize-hook #'rc/org-insert-created-if-todo)

;; `org-roam': a Zettelkasten-style note-linking layer on top of Org.
(use-package org-roam
  :custom
  (org-roam-directory (file-truename "~/Documents/roam/"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today)
         ("C-c n t" . org-roam-dailies-goto-today))
  :config
  ;; A more informative completion candidate: title plus its tags.
  (setq org-roam-node-display-template
        (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; Needed if you also use `org-roam-protocol' (opening notes via an
  ;; `org-protocol://' URL from outside Emacs).
  (require 'org-roam-protocol))

;; `org-bullets': replaces the plain `*' heading stars with nicer Unicode
;; bullet glyphs.
(use-package org-bullets
  :hook (org-mode . org-bullets-mode))


;;; sec:markdown -----------------------------------------------------------
;;; Markdown
;;; ----------------------------------------------------------------------
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
    (add-to-list 'markdown-code-lang-modes '("math" . latex-mode))))

;; `edit-indirect': lets you edit a fenced code block (or any region) in
;; its own buffer, running the appropriate major mode -- used by
;; `markdown-mode' for editing code blocks with full language support.
(use-package edit-indirect
  :commands edit-indirect)


;;; sec:latex -----------------------------------------------------------
;;; LaTeX (AUCTeX, CDLaTeX, RefTeX)
;;; ----------------------------------------------------------------------

;; `AUCTeX': the comprehensive LaTeX authoring package (this block is
;; named `latex' because that's the feature AUCTeX provides, but the
;; installable package is `auctex' -- hence the explicit `:ensure auctex'
;; override below).
(use-package latex
  :ensure auctex
  :hook (LaTeX-mode . preview-larger-previews)
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

  (defun preview-larger-previews ()
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

  ;; TeX-fold: fold long LaTeX macros/environments down to a readable
  ;; summary.  `C-c C-o C-b'/`b' folds the buffer, `C-o' toggles at point.
  (add-hook 'TeX-mode-hook
            (lambda ()
              (TeX-fold-mode 1)
              (TeX-fold-buffer)))
  (setq TeX-fold-auto-reveal t)

  (setq-default TeX-PDF-mode t)
  (setq-default TeX-master nil)

  ;;; --- Bibliography -------------------------------------------------------
  (setq bibtex-dialect 'biblatex)
  (setq LaTeX-biblatex-use-Biber t)
  (setq-local TeX-command-BibTeX "Biber")

  ;;; --- Build & view ---------------------------------------------------
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

;; `yasnippet': template/snippet expansion, used heavily by the CDLaTeX
;; integration below (and generally useful on its own).
(use-package yasnippet
  :config
  (yas-global-mode -1)
  (setq yas-triggers-in-field t) ; allow expanding a snippet inside another
  (setq yas-snippet-dirs '("~/.config/emacs/snippets/"))

  (defun rc/yas-try-expanding-auto-snippets ()
    (when yas-minor-mode
      (let ((yas-buffer-local-condition ''(require-snippet-condition . auto)))
        (yas-expand))))
  (add-hook 'post-command-hook #'rc/yas-try-expanding-auto-snippets))

;; `cdlatex': fast entry of LaTeX math environments/symbols (e.g. typing
;; `sr' + Tab expands to a square-root template with point placed inside
;; it).  Originally this lived in two separate, duplicate `use-package
;; cdlatex' blocks (a genuine bad practice -- reopening the same
;; `use-package' form for one package spreads its configuration across
;; the file and makes load order harder to reason about); it's merged
;; into a single block here.
(use-package cdlatex
  :hook ((LaTeX-mode  . turn-on-cdlatex)
         ;; `cdlatex-tab-hook' runs extra functions whenever `cdlatex-tab'
         ;; is invoked -- used here to also try YaSnippet expansion.
         (cdlatex-tab . yas-expand)
         (cdlatex-tab . rc/cdlatex-in-yas-field))
  :bind (:map cdlatex-mode-map
              ("<tab>" . cdlatex-tab))
  :config
  ;; `cdlatex-tab-hook' is defined (via `defvar') inside the `cdlatex'
  ;; package itself, not in this file.  We need Emacs to treat it as a
  ;; dynamically-scoped ("special") variable below -- both because we
  ;; deliberately `let'-bind it to `nil' as a recursion guard, and
  ;; because `add-hook' adds to its *dynamic* value.  Under this file's
  ;; `lexical-binding: t', a plain `(let (cdlatex-tab-hook ...) ...)'
  ;; would otherwise silently become a lexical (i.e. purely local, with
  ;; no effect on the real hook) binding instead of a dynamic one,
  ;; breaking the recursion guard.  This no-value `defvar' is the
  ;; standard idiom for declaring "this symbol is special" without
  ;; clobbering the real default value that `cdlatex' itself sets.
  (defvar cdlatex-tab-hook)

  ;; --- Make CDLaTeX's Tab key play nicely with an active YaSnippet field ---
  (defun rc/cdlatex-in-yas-field ()
    "Let `cdlatex-tab' work correctly inside an active YaSnippet field."
    (when-let* ((_ (overlayp yas--active-field-overlay))
                (end (overlay-end yas--active-field-overlay)))
      (if (>= (point) end)
          ;; At the end of the field: try to move to the next Yas field,
          ;; unless CDLaTeX has something meaningful to expand right here.
          (let ((s (thing-at-point 'sexp)))
            (unless (and s (assoc (substring-no-properties s)
                                   cdlatex-command-alist-comb))
              (yas-next-field-or-maybe-expand)
              t))
        ;; Otherwise, expand normally and jump to the right spot inside
        ;; the field.
        (let (cdlatex-tab-hook minp)
          (setq minp
                (min (save-excursion (cdlatex-tab) (point))
                     (overlay-end yas--active-field-overlay)))
          (goto-char minp)
          t))))

  (defun rc/yas-next-field-or-cdlatex ()
    "Jump to the next YaSnippet field, deferring to CDLaTeX's Tab when active."
    (interactive)
    (if (or (bound-and-true-p cdlatex-mode)
            (bound-and-true-p org-cdlatex-mode))
        (cdlatex-tab)
      (yas-next-field-or-maybe-expand)))

  ;; Rebind Tab inside an active Yas field to the function above, once
  ;; `yasnippet' is loaded.  (This replaces the earlier config's pattern
  ;; of re-opening `(use-package yasnippet ...)' a second time just to
  ;; add these two keybindings.)
  (with-eval-after-load 'yasnippet
    (define-key yas-keymap (kbd "<tab>") #'rc/yas-next-field-or-cdlatex)
    (define-key yas-keymap (kbd "TAB") #'rc/yas-next-field-or-cdlatex)))

;; Org-table + CDLaTeX integration ("lazytab"): lets you write a table
;; using CDLaTeX's fast Tab-driven matrix/table templates while inside an
;; Org buffer, then convert it to real LaTeX with `C-c C-c'.
(use-package org-table
  :ensure nil                          ; part of `org', not separately
                                        ; installable
  :after cdlatex
  :bind (:map orgtbl-mode-map
              ("<tab>" . lazytab-org-table-next-field-maybe)
              ("TAB"   . lazytab-org-table-next-field-maybe))
  :init
  (add-hook 'cdlatex-tab-hook 'lazytab-cdlatex-or-orgtbl-next-field 90)

  ;; Extra CDLaTeX templates for common matrix/table environments.
  (add-to-list 'cdlatex-command-alist
               '("smat" "Insert smallmatrix env"
                 "\\left( \\begin{smallmatrix} ? \\end{smallmatrix} \\right)"
                 lazytab-position-cursor-and-edit
                 nil nil t))
  (add-to-list 'cdlatex-command-alist
               '("bmat" "Insert bmatrix env"
                 "\\begin{bmatrix} ? \\end{bmatrix}"
                 lazytab-position-cursor-and-edit
                 nil nil t))
  (add-to-list 'cdlatex-command-alist
               '("pmat" "Insert pmatrix env"
                 "\\begin{pmatrix} ? \\end{pmatrix}"
                 lazytab-position-cursor-and-edit
                 nil nil t))
  (add-to-list 'cdlatex-command-alist
               '("tbl" "Insert table"
                 "\\begin{table}\n\\centering ? \\caption{}\n\\end{table}\n"
                 lazytab-position-cursor-and-edit
                 nil t nil))
  :config
  (defun lazytab-position-cursor-and-edit ()
    (cdlatex-position-cursor)
    (lazytab-orgtbl-edit))

  (defun lazytab-orgtbl-edit ()
    (advice-add 'orgtbl-ctrl-c-ctrl-c :after #'lazytab-orgtbl-replace)
    (orgtbl-mode 1)
    (open-line 1)
    (insert "\n|"))

  (defun lazytab-orgtbl-replace (_)
    (interactive "P")
    (unless (org-at-table-p) (user-error "Not at a table"))
    (let* ((table (org-table-to-lisp))
           params
           (replacement-table
            (if (texmathp)
                (lazytab-orgtbl-to-amsmath table params)
              (orgtbl-to-latex table params))))
      (kill-region (org-table-begin) (org-table-end))
      (open-line 1)
      (push-mark)
      (insert replacement-table)
      (align-regexp (region-beginning) (region-end) "\\([:space:]*\\)& ")
      (orgtbl-mode -1)
      (advice-remove 'orgtbl-ctrl-c-ctrl-c #'lazytab-orgtbl-replace)))

  (defun lazytab-orgtbl-to-amsmath (table params)
    (orgtbl-to-generic
     table
     (org-combine-plists
      '(:splice t
        :lstart ""
        :lend " \\\\"
        :sep " & "
        :hline nil
        :llend "")
      params)))

  (defun lazytab-cdlatex-or-orgtbl-next-field ()
    (when (and (bound-and-true-p orgtbl-mode)
               (org-table-p)
               (looking-at "[[:space:]]*\\(?:|\\|$\\)")
               (let ((s (thing-at-point 'sexp)))
                 (not (and s (assoc s cdlatex-command-alist-comb)))))
      (call-interactively #'org-table-next-field)
      t))

  (defun lazytab-org-table-next-field-maybe ()
    (interactive)
    (if (bound-and-true-p cdlatex-mode)
        (cdlatex-tab)
      (org-table-next-field))))

;; `reftex': cross-reference/citation management for LaTeX (and Org, via
;; `turn-on-reftex').
(use-package reftex
  :ensure nil
  :hook ((LaTeX-mode      . turn-on-reftex)
         (reftex-toc-mode . reftex-toc-rescan))
  :config
  (setq reftex-plug-into-auctex t)
  (eval-after-load 'reftex-vars
    '(setq reftex-cite-format
           '((?\C-m . "\\cite[]{%l}")
             (?f    . "\\footcite[][]{%l}")
             (?t    . "\\textcite[]{%l}")
             (?p    . "\\parencite[]{%l}")
             (?o    . "\\citepr[]{%l}")
             (?n    . "\\nocite{%l}")))))


;;; sec:otherlangs -----------------------------------------------------------
;;; Misc languages
;;; ----------------------------------------------------------------------
(use-package gnuplot
  :mode (("\\.gp\\'"      . gnuplot-mode)
         ("\\.gnuplot\\'" . gnuplot-mode)
         ("\\.plt\\'"     . gnuplot-mode)
         ("\\.gpi\\'"     . gnuplot-mode)))

(use-package cmake-mode
  :mode (("\\.cmake\\'"         . cmake-mode)
         ("CMakeLists\\.txt\\'" . cmake-mode)))


;;; sec:selection -----------------------------------------------------------
;;; Region/selection helpers
;;; ----------------------------------------------------------------------

;; `expand-region': grows the selected region by increasingly larger
;; semantic units (word -> sexp -> statement -> ...) with each press.
(use-package expand-region
  :bind ("C-=" . er/expand-region))

;; `multiple-cursors': edit several matching pieces of text at once.
(use-package multiple-cursors
  :config
  (setq mc/always-run-for-all t)
  (setq mc/cmds-to-run-for-all t)
  :bind (("C->"         . mc/mark-next-like-this-symbol)
         ("C-<"         . mc/mark-previous-like-this-symbol)
         ("C-c C-<"     . mc/mark-all-like-this)
         ("C-S-c C-S-c" . mc/edit-lines)
         ("C-\""        . mc/skip-to-next-like-this)
         ("C-:"         . mc/skip-to-previous-like-this)))


;;; sec:visualfeedback -----------------------------------------------------------
;;; Visual feedback packages
;;; ----------------------------------------------------------------------

;; `visible-mark': puts a visible overlay on the mark, so you can see
;; where `C-SPC'/`C-x C-x' will jump back to.
(use-package visible-mark
  :config
  (setq visible-mark-max 1)
  (global-visible-mark-mode 1))

;; `beacon': briefly flashes the cursor line after a big jump (switching
;; windows/buffers, scrolling...) so your eye never loses point.
(use-package beacon
  :config
  (beacon-mode 1))


;;; sec:repeat -----------------------------------------------------------
;;; Repeat-mode
;;; ----------------------------------------------------------------------
;;
;; WHAT: after invoking a multi-key command once, lets you repeat it by
;;       pressing just its last key (or `C-z') again.
;; WHY:  saves re-typing the whole key sequence for things you do
;;       repeatedly in a row (e.g. `other-window').
(use-package repeat
  :ensure nil
  :hook (after-init . repeat-mode)
  :init
  (setq repeat-too-dangerous '(kills-this-buffer er/expand-region))
  :custom
  (repeat-exit-timeout 5))


;;; sec:lisp -------------------------------------------------------------
;;; Lisp-related Stuff
;;; ----------------------------------------------------------------------

(use-package paredit
  :ensure t
  ;; :hook ((emacs-lisp-mode . paredit-mode))
  :bind (
         ("M-<right>" . paredit-forward-slurp-sexp)
         ("M-<left>" . paredit-forward-slurp-sexp)))

;;; sec:search -----------------------------------------------------------
;;; Search Customization
;;; ----------------------------------------------------------------------
;; `isearch' builtin emacs search.
;; references - '("https://blog.chmouel.com/posts/emacs-isearch/")
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
        ("C-f" . rc/project-search-from-isearch))

  :config
  ;; use selection to search
  (defadvice isearch-mode (around isearch-mode-default-string (forward &optional regexp op-fun recursive-edit word-p) activate)
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


;;; sec:session ----------------------------------------------------------
;;; Session/history persistence
;;; ----------------------------------------------------------------------
;;
;; `psession': persists minibuffer history, kill-ring, registers, etc.
;; across Emacs restarts.  Used instead of the built-in `savehist' (see
;; the note in the "Files" section above for why).
(use-package psession
  :init
  (setq pssesion-object-to-save-alist
        '((minibuffer-history        . "minibuffer-history.el")
          (shell-command-history     . "shell-command-history.el")
          ;; (ido-buffer-history        . "ido-buffer-history.el")
          (ido-file-history          . "ido-file-history.el")
          (project--dir-history      . "project--dir-history.el")
          (extended-command-history  . "extended-command-history.el")
          (regexp-search-ring        . "regexp-search-ring.el")
          (kill-ring                 . "kill-ring.el")
          (register-alist            . "register-alist.el")))
  :config
  (psession-savehist-mode 1)
  (psession-autosave-mode 1)
  (psession-mode 1)
  ;; These hooks caused issues in this setup (see original notes) -- keep
  ;; them removed explicitly rather than just never adding them, so it's
  ;; clear this was a deliberate choice if `psession' changes its
  ;; defaults in a future version.
  (dolist (fn '(psession--dump-some-buffers-to-list
                psession--restore-some-buffers
                psession-save-last-winconf
                psession-restore-last-winconf))
    (remove-hook 'kill-emacs-hook fn)
    (remove-hook 'emacs-startup-hook fn)))


;;; sec:nav --------------------------------------------------------------
;;; Code navigation
;;; ----------------------------------------------------------------------
;;
;; `ido': interactively-do, a fast fuzzy-matching completion UI for
;; finding files/switching buffers.
(use-package ido
  :defer t
  :demand nil
  :ensure nil
  ;; :bind (("C-x C-f" . ido-find-file))
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


;;; sec:minibuffer -----------------------------------------------------------
;;; Minibuffer keybindings
;;; ----------------------------------------------------------------------
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
  (setq completions-format 'horizontal)

  ;; Put an upper limit to the Completions window, so that it does not
  ;; disorient me.
  (setq completions-max-height 12)

  ;; Rely on previous inputs to surface candidates towards the top of
  ;; the list (enable the built-in `savehist-mode' to persist
  ;; history).
  (setq completions-sort 'historical)

  ;; Show the Completions buffer if I hit TAB but there is no unique match yet.
  (setq completion-auto-help t)

  ;; Never switch to the Completions buffer when I type TAB, because I
  ;; want to select candidates while the minibuffer is still in focus,
  ;; per `minibuffer-visible-completions'.  This has the advantage of
  ;; auto-updating the completions as I type.
  (setq completion-auto-select nil
        minibuffer-visible-completions nil)

  ;; Those two are also relevant for the `completion-category-overrides', which I
  ;; cover elsewhere in this article.
  (setq completion-eager-display nil)
  (setq completion-eager-update nil))


;;; sec:whichkey ---------------------------------------------------------
;;; Which-Key Mode
;;; ----------------------------------------------------------------------
;;
;; Shows a list of all the key you can press next.
(use-package which-key
  :ensure nil
  :config
  (which-key-mode 1))


;;; sec:music --------------------------------------------------------------
;;; Music related stuff in Emacs
;;; ----------------------------------------------------------------------
;; `mpc' a set of commands and key bindings to control mpd through mpc
(use-package emacs
  :ensure nil
  :preface

  (defconst rc/music-directory
    (expand-file-name "~/Music/m")
    "Root directory of the music collection.")

  (defun rc/music--leaf-directories (root)
    "Return leaf directories below ROOT."
    (let (result)
      (dolist (dir (directory-files-recursively root "[^.]" t))
        (when (and (file-directory-p dir)
                   (not
                    (seq-some
                     #'file-directory-p
                     (directory-files dir t nil t))))
          (push dir result)))
      result))

  (defun rc/music--albums ()
    "Return album directories under the music directories."
    (let (albums)
      (dolist (root '("m" "slsk"))
        (let ((root-dir (expand-file-name root rc/music-directory)))
          (when (file-directory-p root-dir)
            (setq albums
                  (nconc albums
                         (rc/music--leaf-directories root-dir))))))
      (sort albums #'string-lessp)))

  (defun rc/music--state ()
    "Return the current MPD playback state."
    (string-trim
     (shell-command-to-string "mpc status %state%")))

  (defun rc/music--song ()
    "Return the current MPD song as TITLE - ARTIST."
    (string-trim
     (shell-command-to-string
      "mpc -f '%title% - %artist%' current")))

  (defun rc/music--state-label (state)
    "Return a display label for MPD STATE."
    (pcase state
      ("playing" "Play")
      ("paused"  "Pause")
      ("stopped" "Stop")
      (_         "Unknown")))

  (defun rc/music--report-current ()
    "Report MPD playback state and current song."
    (let ((state (rc/music--state))
          (song (rc/music--song)))
      (message "%s: %s"
               (rc/music--state-label state)
               song)))

  (defun rc/music-play-album ()
    "Select an album and play it."
    (interactive)
    (let* ((albums (rc/music--albums))
           (display-albums
            (mapcar (lambda (dir)
                      (file-relative-name dir rc/music-directory))
                    albums))
           (completion-styles '(flex basic))
           (selected
            (completing-read
             "Album: "
             display-albums
             nil
             t)))
      (when selected
        (call-process "mpc" nil nil nil "clear")
        (call-process "mpc" nil nil nil "add" selected)
        (call-process "mpc" nil nil nil "play")
        (rc/music--report-current))))

  (defun rc/music-toggle-play-pause ()
    "Toggle MPD playback and report the current song."
    (interactive)
    (call-process "mpc" nil nil nil "toggle")
    (rc/music--report-current))

  (defun rc/music-play-next ()
    "Play the next song and report its name."
    (interactive)
    (call-process "mpc" nil nil nil "next")
    (rc/music--report-current))

  (defun rc/music-play-previous ()
    "Play the previous song and report its name."
    (interactive)
    (call-process "mpc" nil nil nil "prev")
    (rc/music--report-current))

  :config
  (global-set-key (kbd "C-c m a") #'rc/music-play-album)
  (global-set-key (kbd "C-c m p") #'rc/music-toggle-play-pause)
  (global-set-key (kbd "C-c m f") #'rc/music-play-next)
  (global-set-key (kbd "C-c m b") #'rc/music-play-previous))


;;; sec:unix -------------------------------------------------------------
;;; Configurations related to Unix OSes
;;; ----------------------------------------------------------------------
;; `proced' is a command to view all processes in Emacs.
(use-package proced
  :ensure nil
  :init
  (setq-default proced-format 'verbose)
  (setq proced-auto-update-flag t
        proced-auto-update-interval 3
        proced-enable-color-flag t))


;;; sec:internet ---------------------------------------------------------
;;; Browsing internet and interaction between Emacs and the default browser
;;; ----------------------------------------------------------------------
;; `atomic-chrome' allows editing text areas in browsers with the help of
;; GhostText extension (or AtomicChrome extension)
(use-package atomic-chrome
  ;; commented if as otherwise it would not work with emacs client.
  ;; :if window-system
  :ensure t
  :demand t

  :custom
  (atomic-chrome-extension-type-list '(ghost-text))
  (atomic-chrome-default-major-mode 'markdown-mode)
  (atomic-chrome-server-ghost-text-port 4001)
  (atomic-chrome-buffer-open-style 'frame)
  (atomic-chrome-buffer-frame-width 100)
  (atomic-chrome-buffer-frame-height 30)

  :config
  (atomic-chrome-start-server)

  (when (fboundp 'gfm-mode)
    (setq atomic-chrome-url-major-mode-alist
          '(("overleaf\\.com"    . latex-mode)
            ("mail\\.google\\.com" . text-mode)
            ("github\\.com"      . gfm-mode)
            ("gitlab\\.com"      . gfm-mode)))))


;; `webjump' start searching right from Emacs and land on your desired website.
(use-package webjump
  :ensure nil
  :bind ("C-c /" . webjump)
  :init (setq webjump-sites
              '(;; Emacs
                ("Emacs Home Page" .
                 "www.gnu.org/software/emacs/emacs.html")
                ("Xah Emacs Site" . "ergoemacs.org/index.html")
                ("(or emacs irrelevant)" . "oremacs.com")
                ("Mastering Emacs" .
                 "https://www.masteringemacs.org/")

                ;; Search engines.
                ("DuckDuckGo" .
                 [simple-query "duckduckgo.com"
                               "duckduckgo.com/?q=" ""])
                ("Google" .
                 [simple-query "www.google.com"
                               "www.google.com/search?q=" ""])

                ("YouTube" .
                 [simple-query "www.youtube.com"
                               "https://www.youtube.com/results?search_query=" ""])

                ("Wikipedia" .
                 [simple-query "wikipedia.org" "wikipedia.org/wiki/" ""]))))


;; `erc' IRC
(use-package erc
  :defer t
  :demand nil
  :ensure nil
  :commands erc
  :defines erc-interpret-mirc-color erc-autojoin-channels-alist
  :init (setq erc-interpret-mirc-color t
              erc-lurker-hide-list '("JOIN" "PART" "QUIT")
              erc-autojoin-channels-alist '(("freenode.net" "#emacs"))))


;; `elfeed': provide rss feed-reader capabilities to Emacs.
(use-package elfeed
  :hook (elfeed-search-mode . buffer-wrap-mode)
  :bind (("C-c e" . elfeed))
  :init
  (setq elfeed-db-directory (concat user-emacs-directory ".elfeed")

        ;; Use unique buffers for each elfeed article
        elfeed-show-entry-switch #'pop-to-buffer
        elfeed-show-unique-buffers t

        elfeed-show-entry-delete #'delete-window
        elfeed-feeds '(("https://abzrg.github.io/rss.xml" me)

                       ;; Emacs
                       ("https://planet.emacslife.com/atom.xml" planet emacslife)
                       ("http://www.masteringemacs.org/feed/" mastering)
                       ("https://oremacs.com/atom.xml" oremacs)
                       ("https://pinecast.com/feed/emacscast" emacscast)
                       ("https://emacstil.com/feed.xml" Emacs TIL)

                       ;; News
                       ("https://news.ycombinator.com/rss" hackernews news)
                       ("https://www.reddit.com/r/commandline/.rss?limit=100" reddit content)

                       ;; C/C++
                       ("https://nullprogram.com/feed/" c)
                       ("https://www.sandordargo.com/feed.xml" c++)

                       ;; Python
                       ("https://til.simonwillison.net/tils/feed.atom" python)

                       ;; Prot
                       ("https://protesilaos.com/codelog.xml" emacs linux)
                       ("https://protesilaos.com/interpretations.xml" art philosophy)

                       ;; CFD
                       ("https://old.reddit.com/r/CFD/.rss?limit=100" reddit cfd)

                       ;; Other
                       ("https://acoup.blog/feed/" blog)
                       ("https://lukesmith.xyz/index.xml" blog)

                       ("https://www.joshwcomeau.com/rss.xml" blog web)
                       ("https://safjan.com/feeds/all.rss.xml" blog)
                       ("https://research.swtch.com/feed.atom" blog )
                       ("https://flaviocopes.com/rss.xml" blog)
                       ("https://protesilaos.com/master.xml" blog emacs philosophy)
                       ("https://zarif98sjs.github.io/index.xml" blog)
                       ("https://endler.dev/rss.xml" blog)
                       ("https://codelearn.me/feed.xml" blog)
                       ("https://tony-zorman.com/atom.xml" blog)


                       ;; from nullprogram
                       ("https://blog.cryptographyengineering.com/feed/" blog)
                       ("https://astralcodexten.substack.com/feed/" blog philosophy)
                       ("https://betonit.substack.com/feed/" blog economics)
                       ("https://simblob.blogspot.com/feeds/posts/default" blog dev)
                       ("https://utcc.utoronto.ca/~cks/space/blog/?atom" blog dev)
                       ("https://lemire.me/blog/feed/" dev blog)
                       ("https://danluu.com/atom.xml" dev blog)
                       ("https://www.debian.org/security/dsa" debian list security important)
                       ("https://www.debian.org/News/news" debian list)
                       ("https://www.filfre.net/feed/" blog history essay)
                       ("https://danwang.co/feed/" blog philosophy)
                       ("https://eli.thegreenplace.net/feeds/all.atom.xml" blog dev)
                       ("https://floooh.github.io/feed.xml" blog dev)
                       ("https://peter0x44.github.io/index.xml" blog dev)
                       ("https://www.exocomics.com/feed" comic)
                       ("https://fabiensanglard.net/rss.xml" blog dev)
                       ("https://gcc.gnu.org/git/?p=gcc-wwwdocs.git;a=atom;f=htdocs/releases.html" dev release)
                       ("https://github.com/rmyorston/busybox-w32/releases.atom" release product)
                       ("https://backend.deviantart.com/rss.xml?q=by%3AGydw1n" image)
                       ("https://photo.nullprogram.com/feed/" photo myself)
                       ("https://loadingartist.com/feed/" comic)
                       ("https://marc-b-reynolds.github.io/feed.xml" dev blog math)
                       ("http://www.mazelog.com/rss" math puzzle)
                       ("https://sourceforge.net/projects/mingw-w64/rss?path=/mingw-w64/mingw-w64-release" dev release)
                       ("https://www.mrmoneymustache.com/feed/" blog philosophy)
                       ("https://nrk.neocities.org/rss.xml" blog dev)
                       ("https://nullprogram.com/feed/" blog dev myself)
                       ("https://blogs.msdn.microsoft.com/oldnewthing/feed" blog dev)
                       ("https://www.overcomingbias.com/feed" blog philosophy)
                       ("http://feeds.feedburner.com/PoorlyDrawnLines" comic)
                       ("https://maskray.me/blog/atom.xml" blog dev)
                       ("https://www.npr.org/rss/podcast.php?id=510289" podcast audio economics)
                       ("https://possiblywrong.wordpress.com/feed/" blog math puzzle)
                       ("http://feeds.wnyc.org/radiolab" audio)
                       ("https://www.smbc-comics.com/comic/rss" comic)
                       ("https://blog.plover.com/index.atom" blog dev)
                       ("https://xkcd.com/atom.xml" comic)
                       ("http://hnapp.com/rss?q=host:nullprogram.com" hackernews myself)
                       ("https://old.reddit.com/domain/nullprogram.com.rss" reddit myself)
                       ("https://old.reddit.com/r/C_Programming/.rss?limit=100" subreddit)

                       ("https://www.youtube.com/feeds/videos.xml?channel_id=andreas_fertig" youtube c++)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=TsodingDaily" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=iran_sport" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=JadiMirmirani" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=gitbutlerapp" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=yousuckatprogramming" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=anthonywritescode" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=Computerphile" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=numberphile" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=protesilaos" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=MollyRocket" youtube) ; Casey Muratori
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=fluidmechanics101" youtube cfd)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=TomScottGo" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=GregHurrell" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=CodeForYourself" youtube)

                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UULFHnyfMqiRRG1u-2MsSQLbXA" youtube) ; Veritasium
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=adric22" youtube) ; The 8-Bit Guy
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=craig1black" youtube)              ; Adrian's Digital Basement
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UCbtwi4wK1YXd9AyV_4UcE6g" youtube) ; Adrian's Digital Basement ][
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UCd8v3SbzGP9_wuSOr_xk_eA" youtube) ; Antique Furniture Restoration
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UCH_7doiCkWeq0v3ycWE5lDw" youtube) ; Any Austin
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UCbGGg1xyVana3IY4WInzgyg" youtube) ; Blow Fan
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=damo2986" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=destinws2" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=EEVblog" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=eevblog2" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=foodwishes" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UULFtWCNdtCS-SG2gKYaYhE7BA" youtube) ; Gaming Jay
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UULFN9UPjA8I-uwvAy0-N9maOA" youtube) ; The Generalist Papers
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UCuCkxoKLYO_EQ2GeFtbM_bw" youtube) ; Half as Interesting
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UCm9K6rby98W8JigLoZOh6FQ" youtube) ; LockPickingLawyer
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=jastownsendandson" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=MatthiasWandel" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UC3_AWXcf2K3l9ILVuQe-XwQ" youtube) ; Matthias random stuff
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=Nerdwriter1" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UCNyGbxoEo6CQvaRVEvItxkA" youtube) ; Pask Makes
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UULFF1fG3gT44nGTPU2sVLoFWg" youtube) ; Patrick (H) Willems
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=Pixelmusement" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=PlumpHelmetPunk" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=ProZD" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=XboxAhoy" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=RedLetterMedia" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=Cercopithecan" youtube) ; Sebastian Lague
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UC1_uAIS3r8Vu6JjXWvastJg" youtube) ; Mathologer
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=standupmaths" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UCg-_lYeV8hBnDSay7nmphUA" youtube) ; Tally Ho
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UCy0tKL1T7wFoYcxCe0xjN6Q" youtube) ; Technology Connections
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UClRwC5Vc8HrB6vGx6Ti-lhA" youtube) ; Technology Connextras
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UCqrrxZeeFSNCjGmD-33SKMw" youtube) ; u m a m i
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=handmadeheroarchive" youtube dev)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UCwRqWnW5ZkVaP_lZF7caZ-g" youtube) ; Retro Game Mechanics Explained
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=phreakindee" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UCCj_mkYyeGIb9MPSdb74ykA" youtube) ; GET OFF MY LAWN
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=szyzyg" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UCsXVk37bltHxD1rDPwtNM8Q" youtube) ; Kurzgesagt – In a Nutshell
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UCq8ZAAsI89IoJ-fn1gYpO3g" youtube) ; Kurzgesagt After Dark
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UULFtKUW8LJK2Ev8hUy9ZG_PPA" youtube) ; Welker Farms
                       )))

;; `elfeed-goodies' some aditional niceties to elfeed.
(use-package elfeed-goodies
  :after elfeed)


;; `vpn/unvpn' interactive commands to connect to / disconnect from proxies
;;
;; This sets `url-proxy-services' so that Emacs's own HTTP/HTTPS
;; requests go through the proxy, and also updates environment
;; variables for child processes.
(use-package emacs
  :ensure nil
  :preface
  (defun rc/vtor ()
    "Enable Tor HTTP(S) proxy."
    (interactive)
    (let ((proxy "127.0.0.1:9080"))  ; note: no "http://" prefix for url-proxy-services
      (setq url-proxy-services
            '(("no_proxy" . "^\\(localhost\\|127\\.0\\.0\\.1\\)")
              ("http"   . "127.0.0.1:9080")
              ("https"  . "127.0.0.1:9080")))
      (message "Set HTTP proxy to use Tor (via HTTP), on port 9080")))

  (defun rc/unvpn ()
    "Disable HTTP(S) proxy."
    (interactive)
    (setq url-proxy-services nil)
    (message "Disable HTTP(S) proxies.")))


;;; sec:prose ------------------------------------------------------------
;;; Tools for prose
;;; ----------------------------------------------------------------------
;; `olivetti'
;; focused prose writing
(use-package olivetti
  :hook ((text-mode . olivetti-mode))
  ;; :bind ("<f7>" . olivetti-mode)
  :init (setq olivetti-body-width nil))


;;; sec:view -------------------------------------------------------------
;;; View files in something similar to vim
;;; ----------------------------------------------------------------------
;;
(use-package view
  :ensure nil
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


;;; sec:server -------------------------------------------------------------
;;; Emacs Server
;;; ------------------------------------------------------------------------
;; Start emacs server if it's not already started or there is not a daemon
;; process.
(use-package server
  :ensure nil
  :config
  (unless (or (daemonp)
              (server-running-p))
    (message "Starting server")
    (server-start)))


;;; sec:path -------------------------------------------------------------
;;; Setting PATH
;;; ----------------------------------------------------------------------
;; when Emacs is launched from Finder or the Dock, it may not inherit the PATH
;; configured by system default shell.
(use-package emacs
  :ensure nil
  :if (memq system-type '(darwin)); gnu/linux))
  :init
  (dolist (dir '("/opt/homebrew/bin"
                 "/opt/homebrew/sbin"
                 "/opt/homebrew/opt/curl/bin"
                 "/opt/homebrew/opt/coreutils/libexec/gnubin"))
    (setenv "PATH"
            (concat dir path-separator (getenv "PATH")))
    (add-to-list 'exec-path dir)))


;; ;;; sec:profiling---------------------------------------------------------
;; ;;; Profiling Emacs
;; ;;; ----------------------------------------------------------------------
;; ;; `esup' - Emacs Start Up Profiler
;; (use-package esup
;;   :ensure t)


;;; -----------------------------------------------------------------------
;;; END OF CONFIG
;;; -----------------------------------------------------------------------


;; Lower the GC threshold back down now that startup is done, trading a
;; little bit of GC-pause frequency back for lower steady-state memory
;; use during normal editing (see the note at the top of this file).
(setq gc-cons-threshold (* 2 1000 1000)) ; 2MB during normal use

(provide 'init)
;;; init.el ends here

;;; naysayer-dark-theme.el --- The naysayer dark color theme  -*- lexical-binding: t; -*-

;; Based on a theme developed by Nick Aversano <nickav@users.noreply.github.com>
;; on GitHub (https://github.com/nickav/naysayer-theme.el)
;;
;; Filename: naysayer-dark-theme.el
;; Package-Requires: ((emacs "24"))
;; URL: https://github.com/nickav/naysayer-theme.el
;; License: GPL-3+
;;
;;; Commentary:
;;
;; Monochrome version of the Naysayer color theme.
;;
;; Originally a dark green-blue color scheme with tan colors,
;; inspired by Jonathan Blow's compiler livestreams.
;;
;; This version keeps Naysayer's restrained syntax highlighting
;; while replacing the green/sepia palette with grayscale colors.
;; Red and yellow are retained for errors and warnings.
;;
;;; Code:

(unless (>= emacs-major-version 24)
  (error "The naysayer dark theme requires Emacs 24 or later!"))

(deftheme naysayer-dark
  "The naysayer dark color theme.")

(let ((background          "#101010")
      (gutter-fg          "#505050")
      (mode-line-inactive "#202020")

      ;; Main text hierarchy
      (text               "#c8c8c8")
      (comments           "#666666")
      (punctuation        "#999999")
      (keywords           "#f0f0f0")
      (variables          "thistle3") ; c0c0c0
      (functions          "#ffffff")
      (methods            "#c0c0c0")
      (strings            "#b0b0b0")
      (constants          "#d0d0d0")
      (macros             "#999999")
      (numbers            "#d0d0d0")
      (builtin            "#d0d0d0")
      (white              "#ffffff")

      ;; UI
      (selection          "#404040")
      (highlight-line     "#181818")
      (line-fg            "#505050")

      ;; Diagnostics
      (error              "#ff5555")
      (warning            "#d7af5f")

      ;; Org
      (org-blocks         "grey10")
      (org-code           "grey60")

      ;; LaTeX
      (latex-bold         "gray70")
      (latex-italic       "gray70")
      (latex-math         "bisque4")
      (latex-script-char  "RosyBrown3")
      (latex-warning      "RosyBrown3")

      ;; Font-lock overrides
      (lock-comments      "grey50")
      (lock-constants     "light slate gray") ; azure3
      (lock-keywords      "LightBlue2")
      (lock-strings       "bisque3"))   ;bisque3

  (custom-theme-set-faces
   'naysayer-dark

   ;; Default
   ;; *****************************************************************************

   `(default
     ((t (:foreground ,text
           :background ,background
           :weight normal))))

   `(cursor
     ((t (:background ,white))))

   `(region
     ((t (:foreground unspecified
           :background ,selection))))

   `(highlight
     ((t (:foreground unspecified
           :background ,selection))))

   `(fringe
     ((t (:foreground ,white
           :background ,background))))


   ;; Font lock
   ;; *****************************************************************************

   `(font-lock-keyword-face
     ((t (:foreground ,lock-keywords))))

   `(font-lock-type-face
     ((t (:foreground ,punctuation))))

   `(font-lock-constant-face
     ((t (:foreground ,lock-constants))))

   `(font-lock-variable-name-face
     ((t (:foreground ,variables))))

   `(font-lock-builtin-face
     ((t (:foreground ,builtin))))

   `(font-lock-string-face
     ((t (:foreground ,lock-strings))))

   `(font-lock-comment-face
     ((t (:foreground ,lock-comments))))

   `(font-lock-comment-delimiter-face
     ((t (:foreground ,lock-comments))))

   `(font-lock-doc-face
     ((t (:foreground ,comments))))

   `(font-lock-function-name-face
     ((t (:foreground ,functions))))

   `(font-lock-doc-string-face
     ((t (:foreground ,strings))))

   `(font-lock-preprocessor-face
     ((t (:foreground ,macros))))

   `(font-lock-warning-face
     ((t (:foreground ,warning))))

   ;; Org
   ;; *****************************************************************************

   `(org-block
     ((t (:inherit fixed-pitch
                   :background ,org-blocks
                   :foreground ,org-code))))

   `(org-verbatim
     ((t (:inherit fixed-pitch
                   :foreground ,org-code))))

   ;; LaTeX
   ;; *****************************************************************************

   `(font-latex-bold-face
     ((t (:inherit bold
           :foreground ,latex-bold))))

   `(font-latex-italic-face
     ((t (:inherit italic
           :foreground ,latex-italic))))

   `(font-latex-math-face
     ((t (:foreground ,lock-strings))))

   `(font-latex-script-char-face
     ((t (:foreground ,latex-script-char))))

   `(font-latex-sectioning-5-face
     ((t (:inherit variable-pitch
           :foreground unspecified
           :weight bold))))

   `(font-latex-warning-face
     ((t (:inherit bold
           :foreground ,latex-warning))))


   ;; Whitespace
   ;; *****************************************************************************

   `(trailing-whitespace
     ((t (:foreground unspecified
           :background ,warning))))

   `(whitespace-trailing
     ((t (:foreground ,warning
           :background unspecified
           :inverse-video t))))


   ;; Line numbers
   ;; *****************************************************************************

   `(linum
     ((t (:foreground ,line-fg
           :background ,background))))

   `(linum-relative-current-face
     ((t (:foreground ,white
           :background ,background))))

   `(line-number
     ((t (:foreground ,line-fg
           :background ,background))))

   `(line-number-current-line
     ((t (:foreground ,white
           :background ,background))))


   ;; Compilation
   ;; *****************************************************************************

   `(compilation-info
     ((t (:foreground ,text
           :inherit unspecified))))

   `(compilation-warning
     ((t (:foreground ,warning
           :weight bold
           :inherit unspecified))))

   `(compilation-error
     ((t (:foreground ,error))))

   `(compilation-mode-line-fail
     ((t (:foreground ,error
           :weight bold
           :inherit unspecified))))

   `(compilation-mode-line-exit
     ((t (:foreground ,text
           :weight bold
           :inherit unspecified))))


   ;; hl-line-mode
   ;; *****************************************************************************

   `(hl-line
     ((t (:background ,highlight-line))))

   `(hl-line-face
     ((t (:background ,highlight-line))))


   ;; Rainbow delimiters
   ;; *****************************************************************************

   ;; Keep delimiters monochrome rather than introducing a rainbow.

   `(rainbow-delimiters-depth-1-face
     ((t (:foreground ,white))))

   `(rainbow-delimiters-depth-2-face
     ((t (:foreground ,text))))

   `(rainbow-delimiters-depth-3-face
     ((t (:foreground ,punctuation))))

   `(rainbow-delimiters-depth-4-face
     ((t (:foreground ,white))))

   `(rainbow-delimiters-depth-5-face
     ((t (:foreground ,text))))

   `(rainbow-delimiters-depth-6-face
     ((t (:foreground ,punctuation))))

   `(rainbow-delimiters-depth-7-face
     ((t (:foreground ,white))))

   `(rainbow-delimiters-depth-8-face
     ((t (:foreground ,text))))

   `(rainbow-delimiters-depth-9-face
     ((t (:foreground ,punctuation))))

   `(rainbow-delimiters-depth-10-face
     ((t (:foreground ,white))))

   `(rainbow-delimiters-depth-11-face
     ((t (:foreground ,text))))

   `(rainbow-delimiters-depth-12-face
     ((t (:foreground ,punctuation))))


   ;; which-func
   ;; *****************************************************************************

   `(which-func
     ((t (:inverse-video unspecified
           :underline unspecified
           :foreground ,background
           :weight bold
           :box nil))))


   ;; Mode line / Powerline
   ;; *****************************************************************************

   `(mode-line-buffer-id
     ((t (:foreground ,background
           :distant-foreground ,text
           :text ,text
           :weight bold))))

   `(mode-line
     ((t (:inverse-video unspecified
           :underline unspecified
           :foreground ,background
           :background ,text
           :box nil))))

   `(mode-line-inactive
     ((t (:inverse-video unspecified
           :underline unspecified
           :foreground ,text
           :background ,mode-line-inactive
           :box nil))))

   `(powerline-active1
     ((t (:foreground ,background
           :background ,text))))

   `(powerline-active2
     ((t (:foreground ,background
           :background ,text))))

   `(powerline-inactive1
     ((t (:foreground ,text
           :background ,background))))

   `(powerline-inactive2
     ((t (:foreground ,text
           :background ,background))))


   ;; Better compatibility with Doom modeline
   ;; *****************************************************************************

   `(error
     ((t (:foreground unspecified
           :weight normal))))

   `(doom-modeline-project-dir
     ((t (:foreground unspecified
           :weight bold))))


   ;; js2-mode
   ;; *****************************************************************************

   `(js2-function-call
     ((t (:inherit (font-lock-function-name-face)))))

   `(js2-function-param
     ((t (:foreground ,text))))

   `(js2-jsdoc-tag
     ((t (:foreground ,keywords))))

   `(js2-jsdoc-type
     ((t (:foreground ,constants))))

   `(js2-jsdoc-value
     ((t (:foreground ,text))))

   `(js2-object-property
     ((t (:foreground ,text))))

   `(js2-external-variable
     ((t (:foreground ,constants))))

   `(js2-error
     ((t (:foreground ,error))))

   `(js2-warning
     ((t (:foreground ,warning))))


   ;; Highlight numbers
   ;; *****************************************************************************

   `(highlight-numbers-number
     ((t (:foreground ,numbers))))


   ;; Tab bar
   ;; *****************************************************************************

   `(tab-bar
     ((t (:foreground ,text
           :background ,background))))

   `(tab-bar-tab
     ((t (:foreground ,background
           :background ,text))))

   `(tab-bar-tab-inactive
     ((t (:foreground ,text
           :background ,background))))
   )

  (custom-theme-set-variables
   'naysayer-dark
   '(linum-format " %5i ")))

;;;###autoload
(when (and (boundp 'custom-theme-load-path) load-file-name)
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory
                (file-name-directory load-file-name))))

(provide-theme 'naysayer-dark)

;;; naysayer-dark-theme.el ends here

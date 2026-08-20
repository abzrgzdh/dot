;;; rc-package.el -*- lexical-binding: t; -*-

;; Bootstrap `package.el` (Emacs' built-in package manager), add the MELPA
;; archive (the most complete community package repository), and make sure
;; `use-package` itself is available.
;;
;; Everything below this point is declared with `use-package`, so it has to
;; exist before we can use it.
;;
(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

;; `use-package' has beend shipped builtin since Emacs 29. Since we already
;; demand Emacs 31, We don't need to run the following code
;; (unless (package-installed-p 'use-package)
;;   (package-refresh-contents)
;;   (package-install 'use-package))

(require 'use-package)

;; `use-package-always-ensure` is set to `t` so that every `use-package` block
;; below automatically installs its package if it's missing -- we no longer have
;; to repeat `:ensure t` on every single third-party package.  Built-in packages
;; that ship with Emacs (e.g. `dired`, `org`, `paren`...) are NOT installable
;; via `package.el`, so those blocks explicitly opt out with `:ensure nil`.
(setq use-package-always-ensure t)

;; By default, we want `use-package' to only load packages when explicitly
;; called on. This makes it easier to lazy-load packages.  [1]
(setq use-package-always-defer t)

;; Some debugging toggles, used for diagnosing startup and startup speed.  [1]
(setq use-package-verbose nil
      use-package-compute-statistics t
      use-package-minimum-reported-time 0.001)

(provide 'rc-package)
;;; rc-package.el ends here.

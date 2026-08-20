;; rc-benchmark.el -*- lexical-binding: t; -*-

;; Benchmark package initialization
;; `benchmark-init'
(use-package benchmark-init
  :ensure t
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))

(provide 'rc-benchmark)
;;; rc-benchmark.el ends here.

;;; init.el --- minimal init file -*- lexical-binding: t; no-byte-compile: t -*-

;;; Commentary:

;; This is minimal init file of Emacs to test flycheck-smlsharp.

;;; Code:

(let ((default-directory  "~/.emacs.d/elpa"))
  (normal-top-level-add-to-load-path '("."))
  (normal-top-level-add-subdirs-to-load-path))
(require 'flycheck)
(global-flycheck-mode)

(let ((default-directory  "~/.emacs.d/el-get/sml-mode"))
  (normal-top-level-add-to-load-path '("."))
  (normal-top-level-add-subdirs-to-load-path))
(require 'sml-mode)

(normal-top-level-add-to-load-path '("."))
(normal-top-level-add-subdirs-to-load-path)
(require 'flycheck-smlsharp)

(provide 'init)
;;; init.el ends here

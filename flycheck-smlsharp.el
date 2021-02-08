;;; flycheck-smlsharp.el --- Flycheck: SML# support -*- lexical-binding: t; -*-

;; Copyright (C) 2017 SAITOU Keita <keita44.f4@gmail.com>

;; Author: SAITOU Keita <keita44.f4@gmail.com>
;; URL: https://github.com/yonta/flycheck-smlsharp
;; Keywords: convenience, tools, languages
;; Version: 0.7
;; Package-Requires: ((emacs "24.1") (flycheck "0.22") (sml-mode "0.4"))

;; This file is distributed under the terms of Apache License (version 2.0).
;; See also LICENSE file.

;;; Commentary:

;; This Flycheck extension provides SML# syntax checker which uses SML#
;; compiler.
;;
;; How to use, see README.md in GitHub repository.
;; https://github.com/yonta/flycheck-smlsharp

;;; Code:

(require 'flycheck)

(flycheck-define-checker smlsharp
  "A SML# syntax checker using SML# compiler in sml-mode.

You need SML# compiler >= \"v3.4.0\". This checker calls SML# compiler with
`-ftypecheck-only' option to check source code.

This checker recognizes the following format strings of compiler.

1. Error without positions or with minus positions. In SML# v3.4.0, it has
   minus positions, and SML# v3.5.0 or later does not have.
   For example, syntax error by not closed `let'.
    - `none:~1.~1-~1.~1 Error: syntax error found at EOF'
    - `(none)-(none) Error: syntax error found at EOF'
2. Error with positions. For example, most sytax and type error.
    - `file.sml:1.13-1.13 Error: syntax error: replacing  COLON with  EQ'
    - `file.sml:1.0-1.3 Error:
         (type inference 017) operator is not a function:
         'FB::{int, int8, int16, int64, ...}'
3. Warning. For example, redundant or nonexhaustive match.
    - `file.sml:2.8-2.23 Warning: match nonexhaustive
             A  => ...
    - `longlonglonglonglongfile.sml:2.8-2.23 Warning:
         match nonexhaustive
             A  => ...'
4. Bug with `Bug.Bug' exception. For example.
    - `uncaught exception: Bug.Bug: InferType: FIXME: user error: doubled tycon at src/compiler/compilePhases/typeinference/main/InferTypes2.sml:51.14'

Now, this checker only checks when the file is saved. That's because real-time
flycheck creates a copy of source code with another file name. It makes
difference name between sml file and smi, and makes checker complex.

About SML#, see URL 'http://www.pllab.riec.tohoku.ac.jp/smlsharp/'."
  :command ("smlsharp" "-ftypecheck-only" source-original)
  :error-patterns
  ;; Errors with minus positions in version <= v3.4.0.
  ;; For example,
  ;; "none:~1.~1-~1.~1 Error: syntax error found at EOF"
  ;;
  ;; In version >= v3.5.0.
  ;; For example,
  ;; "(none)-(none) Error: syntax error found at EOF".
  ((error line-start (or "none:~1.~1-~1.~1" "(none)-(none)") (+ blank)
          "Error:" (+ (or blank "\n"))  ; first line and indented lines
          (message
           (and (+ not-newline) "\n"
                (* line-start (+ blank) (+ not-newline) "\n"))))
   ;; Errors with file name and positions.
   ;; For example,
   ;; "file.sml:1.13-1.13 Error: syntax error: replacing  COLON with  EQ"
   ;; or
   ;; "file.sml:1.0-1.3 Error:
   ;;    (type inference 017) operator is not a function:
   ;;    'FB::{int, int8, int16, int64, ...}"
   ;;
   ;; In version = v3.7.0, there is character base positions.
   ;; For example,
   ;; "file.sml:1.13(13)-1.13(13) Error: ..."
   (error line-start (file-name) ":"
          line "." column (? "(" (+ digit) ")") "-"
          end-line "." end-column (? "(" (+ digit) ")") (+ blank)
          "Error:" (+ (or blank "\n"))  ; first line and indented lines
          (message
           (and (+ not-newline) "\n"
                (* line-start (+ blank) (+ not-newline) "\n"))))
   ;; Warnings with file name and positions.
   ;; For example,
   ;; "file.sml:2.8-2.23 Warning: match nonexhaustive
   ;;        A  => ..."
   ;; or
   ;; "longlonglonglonglongfile.sml:2.8-2.23 Warning:
   ;;    match nonexhaustive
   ;;        A  => ..."
   ;;
   ;; In v3.7.0, there is character base positions.
   ;; "file.sml:2.8(27)-2.23(42) Warning: ..."
   (warning line-start (file-name) ":"
            line "." column (? "(" (+ digit) ")") "-"
            end-line "." end-column (? "(" (+ digit) ")") (+ blank)
            "Warning:" (+ (or blank "\n"))  ; first line and indented lines
            (message
             (and (+ not-newline) "\n"
                  (* line-start (+ blank) (+ not-newline) "\n"))))
   ;; Bug, it does not contains new-line.
   ;; For example,
   ;; "uncaught exception: Bug.Bug: InferType: FIXME: user error: doubled tycon at src/compiler/compilePhases/typeinference/main/InferTypes2.sml:51.14"
   (error
    (message (and "uncaught exception: Bug.Bug:" (+ not-newline)))))
  :error-filter
  (lambda (errors)
    (flycheck-increment-error-columns             ; for 0-based columns
     (flycheck-fill-empty-line-numbers errors)))  ; for no positions
  :modes sml-mode
  :predicate flycheck-buffer-saved-p) ; for source-original to compile with .smi

(add-to-list 'flycheck-checkers 'smlsharp)

(provide 'flycheck-smlsharp)

;;; flycheck-smlsharp.el ends here

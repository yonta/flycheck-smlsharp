;;; flycheck-smlsharp.el --- Flycheck: SML# support -*- lexical-binding: t; -*-

;; Copyright (C) 2017 SAITOU Keita <keita44.f4@gmail.com>

;; Author: SAITOU Keita <keita44.f4@gmail.com>
;; URL: https://github.com/yonta/flycheck-smlsharp
;; Keywords: convenience, tools, languages
;; Version: 0.1
;; Package-Requires: ((emacs "24.1") (flycheck "0.22"))

;; This file is distributed under the terms of Apache License (version 2.0).
;; See also LICENSE file.

;;; Commentary:

;; This Flycheck extension provides SML# syntax checker which uses SML#
;; compiler.

;;; Code:

(require 'flycheck)

(flycheck-define-checker smlsharp
  "A SML# syntax checker using SML# compiler in sml-mode.

You need SML# compiler \"v3.4.0\". This checker calls SML# compiler with
`-ftypecheck-only` option to check source code.

This checker recognizes the following format strings of compiler.

1. Error without position. For example, syntax error by not closed `let`.
    - `none:~1.~1-~1.~1 Error: syntax error found at EOF`
2. Error with position. For example, most sytax and type error.
    - `myfile.sml:1.0-1.7 Error: syntax error: inserting COLON`
    - `myfile.sml:6.8-6.9 Error:
          (type inference 017) operator is not a function:
          'FC::{int, int8, int16, int64,...}`
3. Warning. For example, redundant or nonexhaustive match.
    - `myfile.sml:10.0-10.10 Warning: match nonexhaustive
             A  => ...`
    - `myfile.sml:10.0-10.10 Warning:
             match nonexhaustive
                 A  => ...`
    with long file name.

Now, this checker only checks when the file is saved. That's because real-time
flycheck creates a copy of source code with another file name. It makes
difference name between sml file and smi, and makes checker complex.

About SML#, see URL 'http://www.pllab.riec.tohoku.ac.jp/smlsharp/'."
  :command ("smlsharp" "-ftypecheck-only" source-original)
  :error-patterns
   ; EOL errors do not have error position,
   ; like, "none:~1.~1-~1.~1 Error: syntax error found at EOF"
  ((error line-start "none:~1.~1-~1.~1 Error:" (+ (in " \t\n"))
          (message
           (and (+ not-newline) "\n"
                (* line-start (+ blank) (+ not-newline) "\n"))))
   ; Other errors have error position,
   ;   like "file.sml:1.0-1.7 Error: syntax error: inserting COLON",
   ;   or like "file.sml:6.8-6.9 Error:
   ;              (type inference 017) operator is not a function:
   ;              'FC::{int, int8, int16, int64,...}"
   ;   with long file name.
   (error line-start (file-name) ":"
          line "." column "-" (+ digit) "." (+ digit) (+ blank)
          "Error:" (+ (in " \t\n"))
          (message
           (and (+ not-newline) "\n"
                (* line-start (+ blank) (+ not-newline) "\n"))))
   ; like "file.sml:10.0-10.10 Warning: match nonexhaustive
   ;             A  => ..."
   ; or like "file.sml:10.0-10.10 Warning:
   ;            match nonexhaustive
   ;                A  => ..."
   ; with long file name.
   (warning line-start (file-name) ":" line "." column "-"
            (+ digit) "." (+ digit) (+ blank)
            "Warning:" (+ (in " \t\n"))
            (message
             (and (+ not-newline) "\n"
                  (* line-start (+ blank) (+ not-newline) "\n")))))
  :error-filter
  (lambda (errors)
    (flycheck-increment-error-columns             ; for 0-based columns
     (flycheck-fill-empty-line-numbers errors)))  ; for "none:~1.~1"
  :modes sml-mode
  :predicate flycheck-buffer-saved-p) ; for source-original to compile with .smi

(add-to-list 'flycheck-checkers 'smlsharp)

(provide 'flycheck-smlsharp)

;;; flycheck-smlsharp.el ends here

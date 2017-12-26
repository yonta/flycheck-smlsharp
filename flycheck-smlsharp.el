;;; flycheck-smlsharp.el --- Flycheck: SML# support -*- lexical-binding: t; -*-

;; Copyright (C) 2017 SAITOU Keita <keita44.f4@gmail.com>

;; Author: SAITOU Keita <keita44.f4@gmail.com>
;; URL: https://github.com/yonta/flycheck-smlsharp
;; Keywords: convenience, tools, languages
;; Version: 0.1
;; Package-Requires: ((emacs "24.1") (flycheck "0.22"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This Flycheck extension provides SML# syntax checker which uses SML#
;; compiler.

;;; Code:
(flycheck-define-checker smlsharp
  "A SML# syntax checker using SML# compiler.

About SML#, see URL 'http://www.pllab.riec.tohoku.ac.jp/smlsharp/'."
  :command ("smlsharp" "-ftypecheck-only" source-original)
  :error-patterns
   ; EOL errors do not have error line,
   ; like, "none:~1.~1-~1.~1 Error: syntax error found at EOF"
  ((error line-start "none:~1.~1-~1.~1 Error:" (+ (in " \t\n"))
          (message
           (and (+ not-newline) "\n"
                (* line-start (+ blank) (+ not-newline) "\n"))))
   ; Other errors have error line,
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
                  (* line-start (+ blank) (+ not-newline) "\n"))))
   )
  :error-filter
  (lambda (errors)
    (flycheck-increment-error-columns             ; for 0-based columns
     (flycheck-fill-empty-line-numbers errors)))  ; for "none:~1.~1"
  :modes sml-mode
  :predicate flycheck-buffer-saved-p  ; for source-original to compile with .smi
)

(add-to-list 'flycheck-checkers 'smlsharp)

(provide 'flycheck-smlsharp)

;;; flycheck-smlsharp.el ends here

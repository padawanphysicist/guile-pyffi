;;; (tests test-python-vm) --- Test basic interaction with Python VM.

;; Copyright (C) 2024 Victor Santos <victor_santos@fisica.ufc.br>
;;
;; This file is part of guile-pyffi.
;;
;; guile-pyffi is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3 of the License, or
;; (at your option) any later version.
;;
;; guile-pyffi is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with guile-pyffi. If not, see https://www.gnu.org/licenses/.

;;; Commentary:

;; Unit tests pyffi init

;;; Code:

(define-module (tests test-python-vm)
  #:use-module (pyffi)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-69)
  #:use-module (srfi srfi-64)
  #:use-module (tests runner))

(test-runner-factory pyffi:test-runner)

(test-begin "python-vm")

(test-group "python-vm-info"
  (test-assert "Is Python VM NOT initialized?" (not ((@@ (pyffi init) python-initialized?))))
  (python-initialize)
  (test-assert "Is Python VM initialized?" ((@@ (pyffi init) python-initialized?)))
  (pyimport sys)
  (test-assert "Major version is either 3 or 2?" (member (vector-ref #.sys.version-info 0) '(3 2)))
  (test-assert "sys.version is a string?" (string? #.sys.version))
  (format #t "Python version: ~a\n" #.sys.version)
  (python-finalize))

(test-end "python-vm")

;;; (tests test-python-vm) ends here

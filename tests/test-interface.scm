;;; (tests test-interface) --- Test (pyffi interface).

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

;; Unit tests for (pyffi interface) module

;;; Code:

(define-module (tests test-pyffi)
  #:use-module (pyffi)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-69)
  #:use-module (srfi srfi-64)
  #:use-module (tests runner))

(test-runner-factory pyffi:test-runner)

(define (test-alist-eq name alist1 alist2)
  (let ((sort-alist (lambda (v) (sort v (lambda (x y) (string<? (car x) (car y)))))))
    (test-equal name (sort-alist alist1) (sort-alist alist2))))

(test-begin "pyffi-interface")

(test-group "test-interface"
  (test-assert "Is libpython*.so loaded?" ((@ (system foreign-library) foreign-library?)
                (@@ (pyffi interface) libpython)))
  (test-assert "Can we call libpython*.so functions?" (procedure? (@ (pyffi interface) pyproc))))

(test-end "pyffi-interface")

;;; (tests test-interface) ends here

;;; (tests test-type-conversion) --- Test type conversion.

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

;;; Code:

(define-module (tests test-type-conversion)
  #:use-module (pyffi)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-69)
  #:use-module (srfi srfi-64)
  #:use-module (tests runner))

(test-runner-factory pyffi:test-runner)

(define (test-alist-eq name alist1 alist2)
  (let ((sort-alist (lambda (v) (sort v (lambda (x y) (string<? (car x) (car y)))))))
    (test-equal name (sort-alist alist1) (sort-alist alist2))))

(test-begin "type-conversion")

(test-group "python->scheme type conversion"
 (python-initialize)
 (test-eqv "Python integer converts to scheme?" 12345 (python-eval "12345"))
 ;; Pick a number that has an exact binary floating point representation.
 (test-eqv "Python float converts to scheme?" 0.25 (python-eval "0.25"))
 (test-eqv "Python inf converts to scheme?" +inf.0 (python-eval "float('inf')"))
 (test-eqv "Python -inf converts to scheme?" -inf.0 (python-eval "float('-inf')"))
 (test-assert "Python nan converts to scheme?" (nan? (python-eval "float('nan')")))
 (test-assert "Python string converts to scheme?" (string= "hello world" (python-eval "'hello ' + 'world'")))
 (test-eqv "Python complex converts to scheme?" 1.0+2.0i (python-eval "complex(1.0, 2.0)"))
 (test-equal "Python tuple converts to scheme vector?" #(10 20 30) (python-eval "(10, 20, 30)"))
 (test-equal "Python list converts to scheme?" '(10 20 30) (python-eval "[10, 20, 30]")) 
 (test-alist-eq "Python dict converts to scheme alist?" '(("a" . 1) ("b" . 2) ("c" . 3)) (hash-table->alist (python-eval "{'a': 1, 'b': 2, 'c': 3}")))
 (python-finalize))

(test-group "scheme->python type conversion"
  (python-initialize)
  (define (repr-compare rep x)
    (string= rep ((@@ (pyffi pyobject) python-pyrepr) (scm->python x))))
 (test-assert "scheme integer converted to python" (repr-compare "12345" 12345))
 ;; Pick a number that has an exact binary floating point representation.
 (test-assert "Scheme float converts to python" (repr-compare "0.25" 0.25))
 (test-assert "Scheme inf converts to python" (repr-compare "inf" +inf.0))
 (test-assert "Scheme inf converts to python" (repr-compare "-inf" -inf.0))
 (test-assert "Scheme nan converts to python" (repr-compare "nan" +nan.0))
 (test-assert "Scheme string converts to python" (repr-compare "'hello'" "hello"))
 (test-assert "Scheme complex converts to python" (repr-compare "(2+4j)" 2.0+4.0i))
 (test-assert "Scheme vector converts to python tuple" (repr-compare "(10, 20, 30)" #(10 20 30)))
 (test-assert "Scheme list converts to python" (repr-compare "[10, 20, 30]" '(10 20 30)))
 (test-alist-eq "Scheme alist converts to python dict" '(("a" . 1) ("b" . 2) ("c" . 3)) (hash-table->alist (python->scm (scm->python (alist->hash-table '(("a" . 1) ("b" . 2) ("c" . 3)))))))
 (python-finalize))

(test-end "type-conversion")

;;; (tests test-type-conversion) ends here

(define-module (pyffi)
  #:export (py-initialize py-initialized? *py-main-module* *py-main-module-dict*))

(define *py-main-module* (make-parameter #f))
(define *py-main-module-dict* (make-parameter #f))

;; Load shared object and register its functions within guile
(load-extension "libpyffi" "init_python")

(define (py-initialized?)
  (if (= 0 (Py_IsInitialized))
    #f
    #t))

(define (py-initialize)
  (if (py-initialized?)
    (display "Python interpreter already initialized!\n")
    (begin
      (Py_Initialize)
      (*py-main-module* (PyImport_AddModule "__main__"))
      (*py-main-module-dict* (PyModule_GetDict (*py-main-module*)))
      (Py_INCREF (*py-main-module-dict*))
      (display "Python interpreter initialized.\n"))))

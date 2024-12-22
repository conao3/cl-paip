(defsystem #:paip
  :class :package-inferred-system
  :version "0.1.0"
  :build-operation program-op
  :entry-point "paip:main"
  :depends-on (#:paip/src/paip)
  :in-order-to ((test-op (test-op #:paip/test))))

(defsystem #:paip/test
  :depends-on (#:fiveam #:paip/test/paip)
  :perform (test-op (o c)
             (symbol-call :fiveam :run! :paip)))

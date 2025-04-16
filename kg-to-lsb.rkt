#lang racket

(require web-server/servlet
         web-server/servlet-env)

(define kg->lbs-rate 2.2)

(define (start request)
  (define bindings (request-bindings request))
  (define number-pair (assoc 'kg bindings))

  (define result
    (cond
      [(not number-pair) "Please enter weight in kilograms"]
      [else
       (define str (cdr number-pair))
       (define maybe-number (string->number str))
       (if maybe-number
           (format "~a kg = ~a lbs"
                   maybe-number
                   (real->decimal-string (* maybe-number kg->lbs-rate) 2))
           "Invalid weight")]))

  (response/xexpr
   `(html
     (body
      (h2 "Kilograms → Pounds Converter")
      (form ([action ""] [method "post"])
        (label "Weight in kg: ")
        (input ([type "text"] [name "kg"]))
        (button ([type "submit"]) "Convert"))
      (div ,result)))))

(serve/servlet start
               #:port 8000
               #:servlet-path "/")

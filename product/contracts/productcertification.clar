;; Define constants
(define-constant contract-owner tx-sender)
(define-constant err-not-authorized (err u100))
(define-constant err-invalid-certification (err u101))

;; Define data maps
(define-map certifications
  { certification-id: uint }
  {
    certifier: principal,
    timestamp: uint,
    result: (string-ascii 20),
    notes: (string-utf8 500)
  }
)

(define-map validations
  { certification-id: uint }
  {
    validator: principal,
    timestamp: uint,
    result: (string-ascii 20)
  }
)

;; Define public functions

;; Record a new certification
(define-public (record-certification (certification-id uint) (result (string-ascii 20)) (notes (string-utf8 500)))
  (let
    (
      (certification {
        certifier: tx-sender,
        timestamp: stacks-block-height,
        result: result,
        notes: notes
      })
    )
    (if (map-insert certifications { certification-id: certification-id } certification)
      (ok certification-id)
      err-invalid-certification
    )
  )
)

;; Validate a certification
(define-public (validate-certification (certification-id uint) (result (string-ascii 20)))
  (let
    (
      (validation {
        validator: tx-sender,
        timestamp: stacks-block-height,
        result: result
      })
    )
    (if (map-insert validations { certification-id: certification-id } validation)
      (ok certification-id)
      err-invalid-certification
    )
  )
)

;; Read-only functions

;; Get certification details
(define-read-only (get-certification (certification-id uint))
  (map-get? certifications { certification-id: certification-id })
)

;; Get validation details
(define-read-only (get-validation (certification-id uint))
  (map-get? validations { certification-id: certification-id })
)

;; Check if a certification exists
(define-read-only (certification-exists (certification-id uint))
  (is-some (map-get? certifications { certification-id: certification-id }))
)

;; Check if a validation exists
(define-read-only (validation-exists (certification-id uint))
  (is-some (map-get? validations { certification-id: certification-id }))
)
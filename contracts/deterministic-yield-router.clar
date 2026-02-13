;; =====================================================
;; DeterministicYieldRouter
;; Rule-based yield distribution controller
;; =====================================================

;; -----------------------------
;; Data Variables
;; -----------------------------

(define-data-var admin principal tx-sender)
(define-data-var initialized bool false)
(define-data-var total-weight uint u0)
(define-data-var route-count uint u0)

;; -----------------------------
;; Data Maps
;; -----------------------------

(define-map routes
  uint
  {
    recipient: principal,
    weight: uint
  })

;; -----------------------------
;; Errors
;; -----------------------------

(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-ALREADY-INITIALIZED u101)
(define-constant ERR-NOT-INITIALIZED u102)
(define-constant ERR-INVALID-WEIGHT u103)

;; -----------------------------
;; Helpers
;; -----------------------------

(define-read-only (is-admin)
  (is-eq tx-sender (var-get admin))
)

;; -----------------------------
;; Configuration Phase
;; -----------------------------

(define-public (add-route (recipient principal) (weight uint))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (asserts! (not (var-get initialized)) (err ERR-ALREADY-INITIALIZED))
    (asserts! (> weight u0) (err ERR-INVALID-WEIGHT))

    (let ((id (var-get route-count)))
      (map-set routes id {
        recipient: recipient,
        weight: weight
      })

      (var-set route-count (+ id u1))
      (var-set total-weight (+ (var-get total-weight) weight))
      (ok id)
    )
  )
)

(define-public (finalize-routes)
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (asserts! (> (var-get total-weight) u0) (err ERR-INVALID-WEIGHT))

    (var-set initialized true)
    (ok true)
  )
)

;; -----------------------------
;; Yield Distribution
;; -----------------------------

;; Public function to trigger distribution
(define-public (distribute-yield)
  (let 
    (
      ;; In Clarity, we must use a fixed list to iterate. 
      ;; This supports up to 10 routes. Increase the list if needed.
      (iter-list (list u0 u1 u2 u3 u4 u5 u6 u7 u8 u9))
      (balance (stx-get-balance (as-contract tx-sender)))
    )
    (asserts! (var-get initialized) (err ERR-NOT-INITIALIZED))
    (asserts! (> balance u0) (ok true)) ;; Nothing to distribute
    
    ;; Use fold to iterate over the route IDs
    (fold distribute-one iter-list u0)
    (ok true)
  )
)

;; Private helper to process each route
(define-private (distribute-one (i uint) (acc uint))
  (let (
    (route (map-get? routes i))
    (balance (stx-get-balance (as-contract tx-sender)))
    (total (var-get total-weight))
  )
    (match route r
      (let (
        ;; Calculation: (Balance * Route Weight) / Total Weight
        (share (/ (* balance (get weight r)) total))
      )
        (if (> share u0)
          (begin
            ;; Use as-contract to send STX from the contract's balance
            (let ((transfer-result (as-contract (stx-transfer? share tx-sender (get recipient r)))))
              (if (is-ok transfer-result)
                (+ acc u1) ;; Increment accumulator to satisfy fold
                acc ;; Return the accumulator unchanged if transfer fails
              )
            )
          )
          acc
        )
      )
      acc ;; If no route at this ID, just return accumulator
    )
  )
)
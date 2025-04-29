;; Title: CredentialChain.clar
;; Summary: A decentralized credentials verification and management system built on Stacks
;; Description: This smart contract enables educational institutions to issue, verify, and manage digital credentials
;; on the Bitcoin Layer 2 blockchain (Stacks). It features institution registration with staking requirements,
;; credential issuance and verification, endorsement mechanisms, delegate management, and secure credential transfer.

;; Constants

(define-constant contract-owner tx-sender)
(define-constant MINIMUM-STAKE u1000000)
(define-constant MAX-BATCH-SIZE u50)

;; Error codes
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-ALREADY-REGISTERED (err u101))
(define-constant ERR-INSUFFICIENT-STAKE (err u102))
(define-constant ERR-CREDENTIAL-NOT-FOUND (err u103))
(define-constant ERR-ALREADY-VERIFIED (err u104))
(define-constant ERR-INVALID-STATUS (err u105))
(define-constant ERR-EXPIRED (err u106))
(define-constant ERR-BATCH-FAILED (err u107))
(define-constant ERR-TRANSFER-FAILED (err u108))
(define-constant ERR-INVALID-BATCH-SIZE (err u109))
(define-constant ERR-INVALID-DELEGATION (err u110))
(define-constant ERR-ALREADY-ENDORSED (err u111))
(define-constant ERR-INVALID-EXPIRY (err u112))
(define-constant ERR-INVALID-INPUT (err u113))
(define-constant ERR-EMPTY-STRING (err u120))

;; Data Variables

(define-data-var transfer-counter uint u0)
(define-data-var total-institutions uint u0)
(define-data-var governance-token-address principal 'SP000000000000000000002Q6VF78)

;; Data Maps

;; Stores information about registered educational institutions
(define-map institutions 
    principal 
    {
        name: (string-ascii 64),
        stake-amount: uint,
        credentials-issued: uint,
        reputation-score: uint,
        active: bool,
        suspension-status: bool,
        registration-date: uint,
        last-update: uint
    }
)

;; Stores credential data issued to students
(define-map credentials
    {id: (string-ascii 64), student: principal}
    {
        institution: principal,
        degree: (string-ascii 64),
        year: uint,
        verified: bool,
        validation-level: uint,
        endorsements: uint,
        metadata-url: (string-ascii 256),
        expiry-date: uint,
        revoked: bool,
        category: (string-ascii 32),
        issue-date: uint,
        last-endorsed: uint
    }
)

;; Tracks endorsements from institutions to credentials
(define-map endorsements
    {credential-id: (string-ascii 64), endorser: principal}
    {
        timestamp: uint,
        weight: uint,
        comment: (string-ascii 256),
        endorser-type: (string-ascii 32)
    }
)

;; Manages delegation of authority within institutions
(define-map institution-delegates
    {institution: principal, delegate: principal}
    {
        active: bool,
        permissions: (list 10 (string-ascii 32)),
        added-at: uint,
        expiry: uint
    }
)

;; Tracks credential transfer requests between users
(define-map transfer-requests
    uint
    {
        credential-id: (string-ascii 64),
        old-owner: principal,
        new-owner: principal,
        status: (string-ascii 16),
        request-time: uint,
        expiry-time: uint,
        transfer-type: (string-ascii 32)
    }
)

;; Input Validation Functions

(define-private (validate-non-empty-string (input (string-ascii 64)))
    (> (len input) u0)
)

(define-private (validate-url (url (string-ascii 256)))
    ;; Basic URL validation - ensure it's not empty
    (> (len url) u0)
)

(define-private (validate-year (year uint))
    ;; Ensure year is within reasonable range
    (and
        (> year u1900)  
        (< year (+ u2100 u1))
    )
)

(define-private (validate-expiry (expiry uint))
    (> expiry stacks-block-height)
)

(define-private (validate-credential-id (credential-id (string-ascii 64)))
    ;; Ensure credential ID is not empty
    (> (len credential-id) u0)
)

(define-private (validate-permissions (permissions (list 10 (string-ascii 32))))
    ;; Ensure the permissions list is not empty
    (> (len permissions) u0)
)

(define-private (validate-endorsement-weight (weight uint))
    ;; Ensure weight is within acceptable range (1-100)
    (and
        (>= weight u1)
        (<= weight u100)
    )
)

(define-private (validate-principal (address principal))
    (not (is-eq address tx-sender))  ;; Can't delegate to yourself
)
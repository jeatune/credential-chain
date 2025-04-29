# CredentialChain.clar

## Overview

**CredentialChain** is a Clarity smart contract built for the [Stacks blockchain](https://www.stacks.co), designed to decentralize the issuance, verification, and management of academic credentials. By leveraging the security and finality of Bitcoin via Stacks, CredentialChain empowers institutions to issue tamper-proof digital certificates and allows students and third parties to verify credentials transparently.

---

## Features

- **Institution Registration & Staking:** Educational institutions must stake STX tokens to register and activate their issuing privileges.
- **Credential Issuance:** Institutions can issue individual or batched credentials with metadata and expiry.
- **Endorsements:** Enables institutions to endorse credentials with weight, timestamp, and commentary.
- **Delegation:** Institutions can assign delegate accounts with specific permissions and expiry periods.
- **Transfers:** Credentials can be securely transferred between users (e.g., between wallets or systems).
- **Validation Tools:** Read-only utilities to verify the authenticity and validity of credentials.
- **Security:** Enforced input validation, permission checks, and expiry validation.

---

## Smart Contract Details

### Constants

| Name                  | Value        | Description                          |
|-----------------------|--------------|--------------------------------------|
| `MINIMUM-STAKE`       | `u1000000`   | Required stake to register as an institution |
| `MAX-BATCH-SIZE`      | `u50`        | Maximum credentials allowed in a batch issue |
| `contract-owner`      | `tx-sender`  | Owner of the deployed contract        |

---

## Key Data Maps

### `institutions`
Tracks registered educational institutions.

- Fields: `name`, `stake-amount`, `credentials-issued`, `reputation-score`, `active`, `suspension-status`, `registration-date`, `last-update`

### `credentials`
Stores metadata about issued credentials.

- Fields: `institution`, `degree`, `year`, `verified`, `endorsements`, `metadata-url`, `expiry-date`, `revoked`, `category`, `issue-date`, `last-endorsed`

### `endorsements`
Logs institution endorsements of credentials.

- Fields: `timestamp`, `weight`, `comment`, `endorser-type`

### `institution-delegates`
Manages delegate permissions within institutions.

- Fields: `active`, `permissions`, `added-at`, `expiry`

### `transfer-requests`
Handles pending credential ownership transfers.

- Fields: `credential-id`, `old-owner`, `new-owner`, `status`, `request-time`, `expiry-time`, `transfer-type`

---

## Public Functions

### Institution Management

- `register-institution(name)`  
  Registers an institution with staking and metadata.

- `add-delegate(delegate-address, permissions, expiry)`  
  Adds a delegate with specified permissions and expiry.

### Credential Management

- `issue-credential(...)`  
  Issues a credential to a student.

- `batch-issue-credentials(...)`  
  Issues multiple credentials in a single transaction (max 50).

### Endorsements

- `endorse-credential-extended(...)`  
  Endorses a credential with weight, comment, and endorser-type.

### Transfers

- `request-credential-transfer(...)`  
  Initiates a transfer request for a credential to another user.

---

## Read-Only Functions

- `get-institution-info(institution)`  
- `get-credential-info(credential-id, student)`  
- `get-endorsement-info(credential-id, endorser)`  
- `get-delegate-info(institution, delegate)`  
- `is-credential-valid(credential-id, student)`  
- `get-validation-level(credential-id, student)`

---

## Validation and Security

The contract uses extensive validation to prevent invalid or malicious input:

- Non-empty strings for IDs, categories, comments.
- Valid ranges for years and weights.
- Stake enforcement for institution registration.
- Credential expiry checks.
- Role-based access via delegates and institution mapping.

---

## Deployment Considerations

- **Network:** Designed for the Stacks blockchain (Bitcoin Layer 2).
- **Governance Token (placeholder):** `governance-token-address` is predefined but not used in current logic.
- **Upgradability:** This contract is non-upgradable once deployed. Consider careful auditing before deployment.

---

## Future Extensions

- Credential revocation and dispute resolution mechanisms.
- On-chain reputation algorithms.
- Integration with Stacks NFTs or off-chain oracles for broader verification.

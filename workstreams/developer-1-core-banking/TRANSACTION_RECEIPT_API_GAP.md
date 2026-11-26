# Transaction Receipt Data and Export Notes — S-CB-023

## Implemented data source

The screen reads the existing authenticated `GET /transactions/{id}` response and, when available, `GET /accounts/me`. The receipt contains only the transaction's status, amount, fee, counterparty name/bank, narration, reference, date/type, and post-transaction balance plus the account name/number supplied by the account API. Missing fields are omitted; unknown values are not filled with Stitch examples.

The screen follows the Developer 1 receipt layout and component guidance. It creates a shareable PNG from the rendered receipt and generates a PDF locally from the same API data using Flutter's PDF/printing packages. PDF save/print is a device/browser print flow. No receipt API endpoint or server document is assumed.

## Deliberately omitted from the Stitch fixture

The sample recipient account, sender-bank/issuer name, payment rail label, fee amount, licensing/insurance statements and claim that the generated document is official proof are not supplied by the transaction/account contract. The customer is told that the receipt reflects transaction details and does not change transaction status. A pending, failed, or reversed transaction keeps its API status in the receipt.

## Backend inputs for a bank-issued receipt

If a bank-issued or independently verifiable receipt is required, define the issuer, server receipt reference/signature, recipient account masking policy, authoritative fee/rail labels, and server-generated document/download operation. The current local image/PDF is a customer-side rendering of the API transaction record, not a bank-signed proof artifact.

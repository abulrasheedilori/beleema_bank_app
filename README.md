# Beleema Bank App

Beleema Bank App is a modern mobile banking application focused on **security, reliability, and transaction correctness**. It is designed to handle real‑world fintech challenges such as unstable networks, sensitive user data, and transaction‑critical workflows, while still delivering a smooth user experience.

---

## Overview

Beleema Bank App enables users to securely:

* Authenticate and manage sessions
* Set and manage transaction PINs
* Perform transaction‑sensitive actions safely
* Receive clear feedback on success and failure states

The app is built with production‑grade patterns, emphasizing **robust error handling**, **clear state management**, and **defensive coding practices**.

---

## Tech Stack

* **Framework:** Flutter
* **Architecture:** Layered / Feature‑based architecture
* **State Management:** Riverpod
* **Networking:** Dio
* **Security:**
    * Secure PIN handling
    * Encrypted network communication (HTTPS / TLS)
* **Error Handling:** Centralized error mapping with user‑friendly messages

---

## Key Features

### Authentication

* Secure login flow
* Session‑aware routing (e.g., PIN‑set vs PIN‑not‑set flows)
* Network timeout and retry handling

### Transaction PIN Setup

* Dedicated transaction PIN setup screen and confirmation
* PIN validation and confirmation
* Graceful error feedback via snackbars/dedicated screen

### Network Resilience

* Request timeout handling
* Retry and exponential backoff support ()
* Clear UI feedback for network and server errors

### User Feedback

* Error snackbars/screen for failed actions
* Loading states for async operations
* Disabled actions during in‑flight requests

---

## Project Structure

```
lib/
├── core/
│ ├── network/ # Dio client & interceptors
│ ├── security/ # Secure storage utilities
│ ├── utils/ # Helpers (snackbars, formatters)
│ ├── widgets/ # Reusable UI components
│ ├── config/ # app configurations
│ ├── theme/ # multile theme impl
│ └── navigation/ # Reusable UI components
├── features/
│ ├── auth/
│ │ ├── data/
│ │ ├── domain/
│ │ └── presentation/
│ │
│ ├── transaction_pin/
│ │ ├── data/
│ │ ├── domain/
│ │ └── presentation/
│ │
│ └── dashboard/
│ ├── data/
│ ├── presentation/
│ └── widgets/
│ │
│ └── dashboard/
│ ├── data/
│ ├── presentation/
│ └── widgets/
│
└── main.dart
└── app.dart
```

This structure promotes:

* Feature isolation
* Easier testing
* Long‑term maintainability
---

##  Error Handling Philosophy

Errors are treated as **first‑class citizens**:

* API errors are mapped into domain‑specific failures
* UI displays actionable, human‑readable messages
* Unknown errors are safely caught and logged

This ensures users are never left confused during critical flows.

---

##  Navigation Logic

Navigation decisions are state‑driven:

* Users without a transaction PIN are routed to PIN setup
* Authenticated users resume from their last valid state
* Invalid sessions trigger safe logout flows

---

## 📦 Setup & Installation

1. Clone the repository

   ```bash
   git clone <repository-url>
   ```

2. Install dependencies

   ```bash
   flutter pub get
   ```

3. Run the app

   ```bash
   flutter run
   ```

---

## Design Principles

* **Correctness over convenience**
* **Fail loudly, recover gracefully**
* **Security is non‑negotiable**
* **User trust comes first**

---

##  Status

The app is under active development and continuously evolving to support more advanced banking features.

---

##  Author

Built and maintained by a mobile engineer passionate about **fintech reliability**, **secure systems**, and **production‑ready mobile applications**.

---

##  License

This project is proprietary and intended for internal or private use unless stated otherwise.


## LIMITATION

Implementation is limited to the provided endpoints provided and the requirements.

## Security Enhancement
![pin_security_enhancement.png](assets/pin_security_enhancement.png)

## Mobile Screenshot

![splash_screen.png](assets/splash_screen.png)

![invalid_token.png](assets/invalid_token.png)

![login_screen.png](assets/login_screen.png)

![login_valid_screen.png](assets/login_valid_screen.png)

![empty_set_txn_screen.png](assets/empty_set_txn_screen.png)

![dedicated_secured_pin_pad.png](assets/dedicated_secured_pin_pad.png)

![unmatched_pin_screen.png](assets/unmatched_pin_screen.png)

![empty_confirm_pin_screen.png](assets/empty_confirm_pin_screen.png)

![pin_security_enhancement.png](assets/pin_security_enhancement.png)

![dashboard_screen.png](assets/dashboard_screen.png)

![transfer_screen.png](assets/transfer_screen.png)

![failure_status_transfer.png](assets/failure_status_transfer.png)

![transfer_confirmation_screen.png](assets/transfer_confirmation_screen.png)

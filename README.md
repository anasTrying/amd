
# Wadhah (وضّح) — AI Banking Assistant

Wadhah is a generative AI assistant embedded directly inside the banking app. It improves the customer experience by providing instant, personalized support around the clock — turning confusing bank statements into clear, human answers.

## About

Wadhah relies on the customer's real account data to explain transactions and financial services in simple language. It interprets unfamiliar merchant names, clarifies why an amount was deducted, identifies recurring subscriptions, and explains fees and banking products.

It also links each transaction to the customer's history and categorizes merchants, helping users understand their spending and feel confident about it quickly. Beyond explanations, Wadhah lets customers take direct action — such as raising a dispute or canceling a subscription — which reduces pressure on call centers and raises customer satisfaction and trust in banking services.

## Key Features

- **Transaction clarification** — every transaction has a "وضح" (Clarify) button that opens a chat explaining the charge in plain language.
- **Merchant name interpretation** — decodes cryptic statement descriptors (e.g. `APPLE COM BILL`, `THAMAR AL-TANMIYA TRADING CO`) into the real merchant, location, and payment channel.
- **Subscription detection** — identifies recurring charges and renewal patterns.
- **Fee & product explanations** — answers questions about bank fees, cards, and products.
- **In-chat actions** — raise a dispute, escalate to customer care, view the merchant on a map, or cancel a subscription without leaving the conversation.
- **Context-aware answers** — responses are grounded in the customer's actual transaction history.

## App Screens

1. **Home Dashboard (الرئيسية)** — greeting header, loyalty points, current balance card, quick actions (bill payments, quick transfers, mobile top-up, traffic fines), promo banners, and the latest transactions.
2. **Transaction History (سجل العمليات)** — full list of operations, each with a Wadhah entry point.
3. **Wadhah Chat (وضّح - مساعدك البنكي)** — the assistant conversation with contextual action buttons per scenario.

## Tech Stack

| Layer | Technology |
|---|---|
| iOS UI | **SwiftUI** (iOS 17+, RTL-first Arabic interface) |
| Shared business logic | **Kotlin Multiplatform (KMP)** — transaction models, merchant enrichment, and assistant orchestration shared across platforms |
| Design | Custom dark navy theme with orange accent (`WadhahTheme`) |

SwiftUI drives the native iOS experience, while Kotlin Multiplatform hosts the platform-independent core (data models, business rules, and API layer), enabling a future Android client to reuse the same logic.

## Project Structure

```
WadhahApp/
├── WadhahApp.swift            # App entry point & navigation routes
├── Theme.swift                # Colors, corner radius, shared styling
├── Models.swift               # Transaction, ChatScenario, dummy data
├── Components.swift           # TransactionRow, WadhahPill, WadhahTabBar
├── HomeView.swift             # Screen 1: Home dashboard
├── TransactionHistoryView.swift # Screen 2: Transaction history
├── WadhahChatView.swift       # Screens 3 & 4: Wadhah chat scenarios
└── Assets.xcassets            # banklogo, Wad, car & airalo banners
```

## Getting Started

1. Clone the repository.
2. Open `WadhahApp.xcodeproj` in Xcode 16 or later.
3. Select an iOS 17+ simulator (e.g. iPhone 17 Pro) and run.

> The current build is a visual prototype: chat scenarios are scripted and data is provided by `DummyData`. The KMP shared module will replace the dummy layer with live services.

## Roadmap

- Wire the chat to a live generative AI backend through the KMP shared module.
- Android client reusing the shared Kotlin Multiplatform core.
- Real dispute and subscription-cancellation flows.
- Merchant location map integration.

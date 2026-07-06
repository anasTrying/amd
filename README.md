
# Wadhah (وضّح) — AI Banking Assistant · Flutter

Wadhah is a generative AI assistant embedded directly inside the banking app. It improves the customer experience by providing instant, personalized support around the clock — turning confusing bank statements into clear, human answers.

> **Branch note:** this `flutter-wadhah` branch is the complete Flutter port of the app.
> The original native implementation (SwiftUI + Kotlin Multiplatform) lives on `main`.

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
3. **Wadhah Chat (وضّح - مساعدك البنكي)** — the assistant conversation with contextual action buttons per scenario, presentable as a pushed screen or a bottom sheet.

## Tech Stack

| Layer | Technology |
|---|---|
| Cross-platform UI | **Flutter** (Dart 3, Material 3, RTL-first Arabic interface) |
| State | Plain Dart — `BankStore` + `WadhahChatEngine` (`ChangeNotifier`), zero external packages |
| Design | Alinma palette (`AlinmaColors`): dark navy `#0B1F32` with orange accent `#E65C00` |

## Getting Started

```
flutter create . --project-name wadhah_app --org com.wadhah   # once: generates android/, ios/, …
flutter pub get
flutter run
```

`flutter create .` only adds the missing platform scaffolding — it does not touch
the existing `lib/`, `assets/`, or `pubspec.yaml`. Run the widget tests with
`flutter test`.

## Project Structure

```
lib/
├── main.dart                  # App entry, dark theme, forced RTL
├── theme/alinma_colors.dart   # Alinma brand palette
├── models/models.dart         # Transaction, ChatScenario, dummy data
├── state/bank_store.dart      # BankStore + WadhahChatEngine (assistant)
├── widgets/components.dart    # TransactionRow, WadhahPill, WadhahTabBar
└── screens/
    ├── dashboard_view.dart    # Screen 1: Home dashboard
    ├── history_view.dart      # Screen 2: Transaction history
    └── chat_view.dart         # Screens 3 & 4: Wadhah chat (push or sheet)

assets/images/                 # banklogo, wad, car & airalo banners
test/widget_test.dart          # Dashboard + navigation smoke tests
```

## Roadmap

- Wire the chat to a live generative AI backend behind `WadhahChatEngine`.
- Real dispute and subscription-cancellation flows.
- Merchant location map integration.
- Android/iOS release builds from this single codebase.

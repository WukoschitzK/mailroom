# Mailroom Tracker

A Flutter + Serverpod application for digitizing mailroom logistics. Supports AI-powered package scanning (OCR), real-time WebSocket updates, full-text search, email notifications, and signature-based handover — across mobile and desktop.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter (iOS, Android, macOS, Web) |
| Backend | Serverpod 2.7.0 (Dart) |
| Database | PostgreSQL 16.3 |
| Cache | Redis 6.2.6 |
| State | `signals_flutter` + `ValueNotifier` |
| UI Kit | `shadcn_ui` |
| Search | Meilisearch |
| AI/OCR | Ollama (llama3.2-vision / qwen3-vl) |
| Email | SMTP (Mailtrap for dev) |
| Testing | `flutter_test` + `spot` |

## Project Structure

```
mailroom_tracker/
├── mailroom_tracker_server/        # Serverpod backend
│   ├── bin/main.dart               # Entry point
│   ├── lib/src/
│   │   ├── endpoints/              # API endpoints (auth, shipment)
│   │   ├── services/               # Ollama, Meilisearch, Email
│   │   └── models/                 # .spy.yaml model definitions
│   ├── config/                     # development/staging/production configs
│   ├── migrations/                 # Database migrations
│   ├── deploy/                     # AWS & GCP Terraform + scripts
│   ├── docker-compose.yaml         # PostgreSQL + Redis (dev & test)
│   └── Dockerfile                  # Production container
│
├── mailroom_tracker_client/        # Generated Serverpod client package
│   └── lib/src/protocol/           # Type-safe client classes
│
└── mailroom_tracker_flutter/       # Flutter app
    ├── lib/
    │   ├── main.dart               # App entry, ShadApp wrapper
    │   ├── globals.dart            # Signals, WebSocket, helpers
    │   ├── screens/
    │   │   ├── dashboard_screen.dart    # SPA shell + shipment list
    │   │   ├── shipment_detail_view.dart # Detail/edit view
    │   │   ├── new_shipment_view.dart    # AI scanner + manual entry
    │   │   ├── handover_screens.dart     # Signature capture
    │   │   └── login_screen.dart         # PIN-based login
    │   └── widgets/
    │       ├── navigation.dart          # Sidebar (desktop) / BottomNav (mobile)
    │       ├── spotlight_search.dart     # Cmd+K full-text search
    │       └── ui_components.dart        # Shared card/timeline widgets
    └── test/
        ├── helpers_test.dart            # Unit tests for global helpers
        ├── ui_components_test.dart      # Widget tests for shared components
        ├── navigation_test.dart         # Widget tests for sidebar/bottom nav
        └── login_screen_test.dart       # Widget tests for login screen
```

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) >= 3.19.0
- [Dart SDK](https://dart.dev/get-dart) >= 3.3.0
- [Docker](https://docs.docker.com/get-docker/) (for PostgreSQL + Redis)
- [Serverpod CLI](https://docs.serverpod.dev/get-started): `dart pub global activate serverpod_cli`
- [Meilisearch](https://www.meilisearch.com/docs/learn/getting_started/installation) (port 7700)
- [Ollama](https://ollama.com/) with a vision model (optional, for AI scanning)

## Setup

### 1. Start Database & Redis

```bash
cd mailroom_tracker_server
docker compose up -d
```

This starts PostgreSQL (port 8090) and Redis (port 8091) for development.

### 2. Run Database Migrations

```bash
cd mailroom_tracker_server
dart run bin/main.dart --apply-migrations
```

### 3. Configure Environment

Create or update `mailroom_tracker_server/.env`:

```env
OLLAMA_BASE_URL="http://localhost:11434"
OLLAMA_MODEL="llama3.2-vision:11b"
SMTP_HOST="sandbox.smtp.mailtrap.io"
SMTP_PORT="2525"
SMTP_USER=""
SMTP_PASS=""
```

### 4. Start Meilisearch

```bash
meilisearch --master-key="your-key"
```

### 5. Start the Server

```bash
cd mailroom_tracker_server
dart run bin/main.dart
```

The server runs on `http://localhost:8080`.

### 6. Start the Flutter App

```bash
cd mailroom_tracker_flutter
flutter pub get
flutter run
```

## Commands

### Flutter App

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run on a specific device
flutter run -d chrome
flutter run -d macos
flutter run -d ios

# Static analysis
flutter analyze

# Run all tests
flutter test

# Run a specific test file
flutter test test/helpers_test.dart

# Run tests with verbose output
flutter test --reporter expanded
```

### Serverpod

```bash
# Generate protocol classes (run from project root)
serverpod generate

# Apply database migrations
dart run bin/main.dart --apply-migrations

# Create a new migration after model changes
serverpod create-migration

# Start the server
dart run bin/main.dart
```

### Docker

```bash
# Start dev services (PostgreSQL + Redis)
docker compose up -d

# Stop dev services
docker compose down

# Reset database (removes all data)
docker compose down -v && docker compose up -d
```

## Architecture

### SPA Routing (No Navigator.push)

The app uses a single-page architecture. The `ManagementDashboardScreen` acts as a shell with persistent navigation (sidebar on desktop, bottom nav on mobile). Content switching is handled by signals:

- `selectedShipmentIdSignal` — shows `ShipmentDetailView`
- `isCreatingNewSignal` — shows `NewShipmentView`
- `handoverShipmentSignal` — shows `SignatureCaptureScreen`
- All `null`/`false` — shows the shipment list

### Responsive Layout

`LayoutBuilder` with a 900px breakpoint switches between:
- **Desktop (> 900px):** Sidebar + 5:3 grid layout
- **Mobile (<= 900px):** Bottom nav + vertical stack

### Real-Time Updates

WebSocket streaming via Serverpod pushes `ShipmentUpdateEvent` messages to all connected clients when shipments are created or updated.

### AI Package Scanning

1. User picks an image from gallery
2. `mobile_scanner` detects barcodes offline
3. Image uploaded to server storage
4. Ollama Vision model extracts recipient info (OCR)
5. Server matches against employee database
6. Results auto-fill the form

## Testing

The project uses `flutter_test` with the [`spot`](https://pub.dev/packages/spot) package for widget testing. Spot provides chainable selectors and actions:

```dart
// Find and assert
spotText('Mailroom').existsOnce();
spot<TextField>().existsOnce();

// Interact
await act.tap(spotText('Neue Sendung'));
await act.enterText(spot<TextField>(), '1234');
```

Run all 33 tests:

```bash
cd mailroom_tracker_flutter
flutter test
```

## Default Test Users

The server seeds two users on first login attempt:

| Name | PIN | Role |
|------|-----|------|
| Max Mustermann | 1234 | Leitung |
| Laura Schmidt | 5678 | Zusteller |

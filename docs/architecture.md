# Code Architecture

## Tech Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| Frontend | Flutter (Mobile & Desktop) | SDK >= 3.19.0 |
| UI Components | shadcn_ui | 0.46.3 |
| State Management | signals_flutter | 6.3.0 |
| Backend | Serverpod | 2.7.0 |
| Database | PostgreSQL | via Serverpod |
| Search | Meilisearch | 0.18.0 (client) |
| Vision AI | Ollama (llama3.2-vision) | Local instance |
| Email | SMTP (Mailtrap sandbox) | via mailer package |

## Project Structure

```
mailroom_tracker/
├── mailroom_tracker_flutter/          # Flutter client app
│   └── lib/
│       ├── main.dart                  # App entry, ShadApp, Cmd+K listener
│       ├── globals.dart               # Shared state signals, WebSocket, helpers
│       ├── screens/
│       │   ├── dashboard_screen.dart  # SPA shell, list/table views, tab filtering
│       │   ├── shipment_detail_view.dart  # Detail/edit view, audit trail, actions
│       │   ├── new_shipment_view.dart # AI scan, form, save new shipment
│       │   ├── handover_screens.dart  # Signature capture for delivery
│       │   └── login_screen.dart      # PIN-based authentication
│       └── widgets/
│           ├── ui_components.dart     # Shared buildCard, buildTimelineItem
│           ├── navigation.dart        # Sidebar (desktop) + BottomNav (mobile)
│           └── spotlight_search.dart  # Cmd+K search dialog (Meilisearch)
│
├── mailroom_tracker_server/           # Serverpod backend
│   └── lib/src/
│       ├── server.dart                # Serverpod init, web routes, future calls
│       ├── endpoints/
│       │   ├── shipment_endpoint.dart # CRUD, AI analysis, delivery, WebSocket
│       │   └── auth_endpoint.dart     # PIN login, user seeding
│       ├── services/
│       │   ├── ollama_service.dart    # Vision AI integration
│       │   ├── meili_service.dart     # Search indexing
│       │   └── email_service.dart     # Delivery notifications
│       └── models/                    # Serverpod protocol definitions
│           ├── shipment.spy.yaml
│           ├── shipment_update_event.spy.yaml
│           ├── employee.spy.yaml
│           ├── mailroom_user.spy.yaml
│           └── dispatch_list.spy.yaml
│
└── mailroom_tracker_client/           # Generated Serverpod client (auto-generated)
```

## Data Models

### Shipment
| Field | Type | Description |
|-------|------|-------------|
| identifier | String | Display name (e.g., "Paket") |
| direction | String | `incoming` (outgoing not yet implemented) |
| type | String | `package` (other types not yet implemented) |
| status | String | `scanned` or `delivered` |
| trackingNumber | String? | Barcode/tracking ID |
| recipientText | String? | Formatted multi-line: name, department, location, email |
| recipientId | int? | FK to Employee table |
| isDamaged | bool | Damage flag (UI not yet implemented) |
| imageUrl | String | Uploaded label photo URL |
| signatureImageUrl | String? | Delivery signature PNG URL |
| scannedAt | DateTime | Creation timestamp |
| deliveredAt | DateTime? | Delivery timestamp |
| createdBy | String? | Staff name who scanned |
| deliveredBy | String? | Staff name who handed over |
| storageLocation | String? | Physical storage location |
| auditLog | String? | Formatted change history |
| note | String? | Internal notes |

### Employee
| Field | Type | Description |
|-------|------|-------------|
| name | String | Full name |
| department | String | Department (IT, HR, Marketing, etc.) |
| isAbsent | bool | Absence flag |
| substituteId | int? | FK to substitute Employee |
| email | String? | Email for notifications |
| officeNumber | String? | Office/room number |

### MailroomUser
| Field | Type | Description |
|-------|------|-------------|
| name | String | Display name |
| pin | String | 4-digit login PIN |
| role | String | `Leitung` or `Zusteller` (not enforced in UI) |
| location | String | Assigned location |

## State Management

All global state lives in `globals.dart` as top-level signals:

```dart
// ValueNotifier-based (for AnimatedBuilder/ValueListenableBuilder)
final currentUserSignal = ValueNotifier<MailroomUser?>(null);
final selectedShipmentIdSignal = ValueNotifier<int?>(null);
final isCreatingNewSignal = ValueNotifier<bool>(false);

// signals_flutter-based (for Watch widget)
final shipmentsSignal = listSignal<Shipment>([]);
final isScanningSignal = signal<bool>(false);
```

The SPA routing is driven by `selectedShipmentIdSignal` and `isCreatingNewSignal`. The dashboard shell uses `AnimatedBuilder` with `Listenable.merge` to react to both:

```
isCreatingNewSignal == true  -->  NewShipmentView
selectedShipmentIdSignal != null  -->  ShipmentDetailView
otherwise  -->  Dashboard list
```

## API Endpoints

### AuthEndpoint
| Method | Returns | Description |
|--------|---------|-------------|
| `login(pin)` | `MailroomUser?` | Authenticate by PIN |
| `seedUsers()` | `void` | Create test accounts if DB empty |

### ShipmentEndpoint
| Method | Returns | Description |
|--------|---------|-------------|
| `streamOpened()` | `void` | WebSocket bridge, listens to `mailroom` channel |
| `getAllShipments()` | `List<Shipment>` | Fetch all shipments |
| `analyzePackage(imageUrl, createdBy, barcode, location)` | `Shipment` | AI analysis only, returns unsaved Shipment |
| `saveAnalyzedShipment(shipment)` | `Shipment` | Persist to DB, sync Meilisearch, send email, broadcast |
| `updateShipmentDetails(shipment)` | `Shipment` | Update fields, sync Meilisearch, broadcast |
| `deliverPackage(id, signatureUrl, deliveredBy)` | `Shipment` | Mark delivered, attach signature, broadcast |
| `uploadImage(byteData, fileName)` | `String?` | Upload to Serverpod storage, return public URL |
| `resolveEmployeeDetails(name)` | `String?` | Employee lookup with absence/substitute resolution |
| `seedDatabase()` | `void` | Create 50 test employees |

## Backend Services

### OllamaService
- Downloads image from URL, encodes as Base64
- Posts to Ollama `/api/generate` with vision model and German-language prompt
- Extracts recipient name from postal label
- Falls back to `"Unbekannt"` if Ollama is unavailable
- Configured via env vars: `OLLAMA_BASE_URL`, `OLLAMA_MODEL`

### MeiliService
- Syncs shipments to Meilisearch index `shipments` on create/update
- Searchable attributes: `identifier`, `recipientText`, `trackingNumber`, `note`
- Hardcoded credentials: `http://localhost:7700` with key `meilisearch_geheim_123`

### EmailService
- Sends SMTP notification when a shipment is created for a known employee
- Mock mode when `SMTP_USER`/`SMTP_PASS` env vars are missing (logs to terminal)
- Configured via env vars: `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS`

## Responsive Layout

The app uses `LayoutBuilder` with a 900px breakpoint:

**Desktop (> 900px):**
- Left sidebar (`MailroomSidebar`, 240px fixed) + content area
- Detail/New views use a 5:3 flex ratio (content : sidebar)
- Recipient and Tracking cards shown side-by-side in a Row

**Mobile (<= 900px):**
- Bottom navigation bar (`MailroomBottomNav`)
- Single-column stacked layout
- Yellow accent AppBar

## External Dependencies

| Package | Purpose |
|---------|---------|
| serverpod_flutter | Server communication, WebSocket, file upload |
| shadcn_ui | UI component library (buttons, inputs, toasts) |
| signals_flutter | Reactive state management (Watch, signal, listSignal) |
| image_picker | Photo selection from gallery |
| mobile_scanner | Offline barcode/QR detection from image |
| signature | Canvas-based signature capture |
| meilisearch | Full-text search client |

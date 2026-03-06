# Technical Feature Breakdown

## 1. Real-Time Synchronization (WebSockets)
* **Mechanism:** Serverpod's `StreamingSession` is utilized to broadcast messages across clients.
* **Backend:** Whenever a `Shipment` is created or updated, the endpoint posts a `ShipmentUpdateEvent` to the internal `mailroom` channel, which is bridged to the WebSocket via `streamOpened`.
* **Frontend:** The `initializeWebSocket()` function listens to the stream and selectively updates the `shipmentsSignal`. Using `signals_flutter`, this immediately triggers UI redraws without requiring pull-to-refresh.
* **Guard:** A `_isWebSocketListening` flag prevents duplicate stream subscriptions. On stream close (`onDone`), the flag resets to allow reconnection.

## 2. Vision AI & Smart Routing
* **Image Capture:** `image_picker` opens the device's photo gallery for the user to select a high-res photo of the shipping label (`ImageSource.gallery`).
* **Barcode Detection:** `mobile_scanner`'s `analyzeImage()` extracts barcodes/QR codes from the selected image offline (no live camera preview).
* **Upload & Processing:** The image is uploaded via Serverpod's `byteData` storage. The backend forwards the image URL to a local Ollama Vision AI (`llama3.2-vision`).
* **Smart Parsing:** The AI extracts the recipient's name. The backend queries the `Employee` database. If the user is flagged as `isAbsent`, the backend automatically resolves the `substituteId` and constructs a dynamic routing text detailing the substitute's department and office.

## 3. Employee Lookup (Magic Wand)
* **Trigger:** In the `ShipmentDetailView` edit mode, clicking the magic wand icon next to the recipient name field invokes `resolveEmployeeDetails()`.
* **Backend:** Queries the `Employee` database by name, resolves absence/substitute chains, and returns structured details (department, office, email).
* **Use Case:** Allows manual correction of AI-detected names or looking up employees that the AI could not identify.

## 4. Spotlight Search (Cmd+K)
* **Trigger:** A global `Focus` node wraps the entire `ShadApp`, listening for the `LogicalKeyboardKey.keyK` + Meta/Control modifier.
* **UI:** Renders a transparent, floating `Dialog` overlay anchored to the top center with a slide+fade transition.
* **Engine:** Directly queries a local Meilisearch instance (index: `shipments`). Searchable fields: `identifier`, `recipientText`, `trackingNumber`, `note`. Results are displayed as a list, and tapping a result updates the `selectedShipmentIdSignal` to navigate the SPA to the specific item.

## 5. Email Notifications
* **Trigger:** When `saveAnalyzedShipment()` persists a new shipment and the recipient is matched to an `Employee` with an email address.
* **Content:** Sends a notification email with subject "Neue Sendung fur Sie eingetroffen!" containing the tracking number and pickup details.
* **Fallback:** If SMTP credentials are not configured (env vars `SMTP_USER`/`SMTP_PASS`), the service logs a mock email to the terminal instead of sending.

## 6. Audit Trail Engine
* **Data Structure:** The `auditLog` is stored as a formatted String in PostgreSQL (e.g., `[Date] by User \n- Changes`).
* **Change Detection:** The frontend compares old and new field values (identifier, recipientText, trackingNumber, storageLocation, note) and generates a list of change descriptions that is prepended to the audit log.
* **UI Parsing:** The frontend dynamically splits this string and constructs a visual timeline widget (`buildTimelineItem`). It automatically determines the latest node (marked with a green checkmark) and historical nodes (yellow/grey). Pending items (e.g., in `NewShipmentView`) render with a grey circle.

## 7. Digital Signature Capture
* **Package:** Uses the `signature` package to render a canvas.
* **Flow:** The user signs -> exported as PNG bytes -> uploaded via Serverpod Storage -> `signatureImageUrl` is attached to the Shipment entity -> status changes to `delivered` -> `deliveredAt` timestamp is set -> WebSocket broadcasts the update.
* **Display:** The signature image is permanently rendered in the Detail View alongside the delivery timestamp and the name of the staff member who processed the handover.

## 8. SPA Routing (Signal-Based)
* **Mechanism:** Instead of Flutter's Navigator, the app uses `ValueNotifier` signals (`selectedShipmentIdSignal`, `isCreatingNewSignal`) to control which view is rendered inside the main `ManagementDashboardScreen` shell.
* **Views:** Dashboard List (default) -> `ShipmentDetailView` (when `selectedShipmentIdSignal` is set) -> `NewShipmentView` (when `isCreatingNewSignal` is true).
* **Animation:** Uses `AnimatedBuilder` with `Listenable.merge` to react to both signals in a single listener.

## 9. Database Seeding (Development)
* **Users:** `seedUsers()` creates 2 test accounts (Max Empfang/PIN 1234, Laura Post/PIN 0000) if the user table is empty.
* **Employees:** `seedDatabase()` creates 50 test employees across departments (IT, HR, Marketing, Finance, Legal, Logistik) with random absence flags and substitute assignments.

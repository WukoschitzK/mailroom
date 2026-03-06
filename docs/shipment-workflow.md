# The Shipment Lifecycle Workflow

This document outlines the technical flow of a package from arrival at the loading dock to final handover.

### Phase 1: Inbound (Creation)
1.  **Trigger:** User clicks "+ Neu" / "+ Neu Erfassen". The SPA router sets `isCreatingNewSignal.value = true`, which swaps the view to `NewShipmentView`.
2.  **Capture:** User clicks "Sendung scannen". The device's photo gallery opens via `image_picker` (`ImageSource.gallery`). After selection, `mobile_scanner`'s `analyzeImage()` attempts offline barcode detection on the photo.
3.  **Upload & AI Analysis:**
    * Image is uploaded to Serverpod public storage via `uploadImage()`.
    * Backend invokes `analyzePackage()`.
    * Ollama Vision AI (`llama3.2-vision`) reads the label and extracts the recipient name.
    * Backend matches the name against the `Employee` DB. If the employee `isAbsent`, the substitute chain is resolved via `substituteId`.
    * Backend returns an *unsaved* `Shipment` object populated with structured data (Name, Department, Location, Email).
4.  **Review & Save:** The UI populates the form fields. The user manually verifies the data, can edit any field, and optionally adds internal notes. Upon clicking Save, `saveAnalyzedShipment()` inserts the row into DB, pushes to Meilisearch, sends an email notification to the recipient (if email is available), and triggers a WebSocket broadcast.
5.  **State Update:** The SPA sets `isCreatingNewSignal.value = false` and `selectedShipmentIdSignal.value = savedShipment.id`, dynamically switching to `ShipmentDetailView` displaying the newly created entity. Status is `Processing`.

### Phase 2: Processing & Storage
1.  **Action:** The mailroom staff stores the physical package.
2.  **Update:** Staff clicks "Hinterlegen" (Store).
3.  **UI Reaction:** The `_actionStorePackage()` method calls `_startEditing()` to populate all controllers, sets `_isEditing = true`, and after a short delay programmatically requests focus on the `Storage Location` text input via `_locationFocusNode`.
4.  **Save:** Staff types the storage location (e.g., "Regal A, Fach 3") and clicks the checkmark.
5.  **Audit Generation:** The frontend compares the old Shipment object fields with the new controller values, detects changes (e.g., `storageLocation`), and generates a timestamped, user-attributed change list that is prepended to the `auditLog` string. Saved via `updateShipmentDetails()`, which also broadcasts the update via WebSocket and syncs to Meilisearch.
6.  **Magic Wand (Optional):** If the recipient name needs correction, staff can click the magic wand icon to invoke `resolveEmployeeDetails()`, which queries the Employee DB and auto-fills the recipient fields.

### Phase 3: Handover (Delivery)
1.  **Trigger:** The recipient arrives to pick up the package. Mailroom staff clicks "Übernehmen" (Handover).
2.  **Signature Overlay:** The `SignatureCaptureScreen` opens as a new route (pushed via Navigator).
3.  **Authentication:** The recipient signs on the tablet using the `signature` package canvas.
4.  **Finalization:**
    * Signature is exported as PNG bytes and uploaded via Serverpod Storage.
    * `deliverPackage()` endpoint is called with the shipment ID, signature URL, and staff name.
    * Shipment `status` is set to `delivered`.
    * `deliveredAt` timestamp and `deliveredBy` name are recorded.
    * `signatureImageUrl` is attached to the Shipment.
    * WebSocket broadcasts the update to all connected clients.
5.  **UI Resolution:** The package now appears with a green "Delivered" badge in the list. The Detail View shows the signature image, delivery timestamp, and the name of the staff member who processed the handover. The "Hinterlegen" and "Übernehmen" action buttons are hidden.

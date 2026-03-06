# Smart Mailroom Tracker - Architecture Overview

## Introduction
The Smart Mailroom Tracker is a modern, enterprise-grade Single Page Application (SPA) built to digitalize and automate mailroom logistics. It replaces manual package logging with an AI-driven, real-time synchronized workflow across mobile (scanners) and desktop (management dashboard) clients.

## Core Architecture
The application follows a strict Client-Server model with real-time capabilities:

* **Frontend Framework:** Flutter (Dart) targeting iOS, Android, macOS, and Web.
* **Backend Framework:** Serverpod (Dart backend) ensuring type safety between server and client via generated protocol classes.
* **State Management:** `signals_flutter` (Reactive primitives: `Signal`, `listSignal`, and native `ValueNotifier`).
* **Database & Search:** PostgreSQL (via Serverpod ORM) and Meilisearch (for typo-tolerant, ultra-fast full-text search).
* **AI Integration:** Local Ollama instance (LLaMA 3.2 Vision) for GDPR-compliant Optical Character Recognition (OCR) and Natural Language Processing (NLP).

## SPA Layout Paradigm (Frontend)
The UI strictly avoids standard `Navigator.push` stacking for the main layout to maintain the SPA feel.
* **Wrapper Shell:** The app is enclosed in a master `Scaffold` containing a persistent `MailroomSidebar` (Desktop) or `MailroomBottomNav` (Mobile).
* **Dynamic Content Area:** The main body uses a `ValueListenableBuilder` listening to routing signals (`selectedShipmentIdSignal`, `isCreatingNewSignal`) to dynamically swap out the central content area (List, Detail View, or Creation View) without rebuilding the navigation shell.
* **Responsive Grid:** Utilizing `LayoutBuilder`, the UI seamlessly transitions from a vertical stack (mobile < 900px) to a 5:3 proportional split-grid layout (desktop > 900px).



# Technology Stack & Dependencies

## Frontend (Flutter)
* **UI Component Library:** `shadcn_ui` (Clean, enterprise aesthetics).
* **State Management:** `signals_flutter` (High-performance reactivity).
* **Routing:** Custom SPA Wrapper via `ValueListenableBuilder`.
* **Hardware:** `mobile_scanner` (Barcode/QR), `image_picker` (Camera).
* **Utilities:** `signature` (Canvas drawing for handover).

## Backend (Serverpod)
* **Core:** Serverpod framework running on Dart.
* **Database:** PostgreSQL (Automated schema generation).
* **Storage:** Serverpod native database-backed file storage (for images and signatures).
* **Real-time:** Native WebSocket streaming (`session.messages.postMessage`).

## External Services
* **Search:** Meilisearch (Running locally/Docker on port `7700`).
* **AI:** Ollama running `llama3.2-vision:11b` model locally for data-privacy compliance.
# Waitaminute Digital - Editorial Publishing Platform & App

A unified, high-performance Dart-first platform powering the editorial dispatches, interactive portfolio case studies, and client discovery intake pipeline for [Waitaminute Digital](https://waitaminutedigital.com).

Built entirely in Dart across both backend and client, replacing legacy monoliths with a modern, type-safe, and reactive architecture.

---

## Tech Stack

| Layer | Technologies |
|---|---|
| **Backend Framework** | [Serverpod 2](https://serverpod.dev) (Dart 3 backend, RPC & ORM) |
| **Database & Cache** | PostgreSQL 16, Redis |
| **Frontend Client** | [Flutter 3](https://flutter.dev) (Dart 3, Multi-Platform: Web & Mobile) |
| **Styling & Design** | Cyber-editorial tokens, Google Fonts (`Space Grotesk`, `Space Mono`, `Inter`), responsive layout |
| **Deployment & Containers** | Docker, Docker Compose, Azure Container Apps / Web Apps |

---

## Architecture Overview

```
waitaminutedigital_podblog/
├── waitaminute_serverpod/            # Serverpod 2 Backend Service
│   ├── waitaminute_serverpod_server/ # Core server endpoints, ORM models & migrations
│   │   ├── lib/src/endpoints/        # RPC Endpoints (Article, ProjectHighlight, Lead)
│   │   ├── lib/src/models/           # YAML-defined data models & generated entities
│   │   ├── config/                   # Environment configs (development, staging, production)
│   │   └── docker-compose.yaml       # Local PostgreSQL + Redis infrastructure
│   ├── waitaminute_serverpod_client/ # Auto-generated typed client SDK
│   └── waitaminute_serverpod_flutter/# Helper bindings for Flutter integration
│
└── waitaminute_flutter/              # Flutter 3 Client (Web & Mobile)
    ├── lib/
    │   ├── models/                   # Domain models & fallback data
    │   ├── services/                 # Serverpod client & connectivity
    │   ├── theme/                    # Cyber-editorial design tokens
    │   ├── widgets/                  # UI components (Peeking carousel, article cards)
    │   └── main.dart                 # Application entrypoint & navigation
    └── assets/img/                   # Robot mascot branding & media assets
```

### 1. All-in-One Container Backend (`waitaminute_serverpod`)
- **Serverpod Endpoints**:
  - `ArticleEndpoint`: Public article retrieval with category filtering, reading time estimation, and markdown rendering.
  - `ProjectHighlightEndpoint`: Featured case studies and portfolio project delivery.
  - `LeadEndpoint`: Public consultation intake form submission with honeypot spam protection and validation.
- **Single-Command Docker Orchestration**: Local development provisions containerized PostgreSQL and Redis automatically.
- **Type Safety**: Database tables, serialized JSON, and Flutter client bindings are compiled directly from declarative YAML models via `serverpod generate`.

### 2. Modern Editorial Client (`waitaminute_flutter`)
- **Responsive Cyber-Editorial UI**: Dark aesthetic engineered with `#0A0A0C` background, `#16161E` elevated surfaces, neon violet/cyan gradients, and typography powered by Google Fonts.
- **IGN-Style Peeking Carousel**: Desktop-constrained 4:5 portrait media cards (~300px x 400px), floating directional arrows (`<` and `>`), smooth scrolling, and touch/mouse dragging support.
- **Interactive Dispatches**: Dynamic category filtering (`ARCHITECTURE`, `POST-MORTEM`, `SHIPPED`, `DEVLOG`), article cards with reading duration badges, and full responsive grid scaling.
- **Discovery Consultation Intake**: Integrated modal form for client project inquiries with instant validation.
- **Resilient Offline Fallback**: Client gracefully operates against local memory caches if the backend container is offline.

---

## Getting Started

### Prerequisites
- [Dart SDK](https://dart.dev/get-dart) (>= 3.0.0)
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (>= 3.20.0)
- [Docker & Docker Compose](https://www.docker.com/)
- [Serverpod CLI](https://docs.serverpod.dev/get-started):
  ```bash
  dart pub global activate serverpod_cli
  ```

### 1. Start the Backend Infrastructure
```bash
cd waitaminute_serverpod/waitaminute_serverpod_server
docker compose up --build -d
dart bin/main.dart
```
The Serverpod backend will launch on `http://localhost:8080` (API) and `http://localhost:8082` (Web server / Insights).

### 2. Run the Flutter Client
In a separate terminal:
```bash
cd waitaminute_flutter
flutter pub get
flutter run -d chrome
```
Open your browser at the assigned localhost port (e.g. `http://localhost:60428`).

---

## License & Attribution
© 2026 Waitaminute Digital. All rights reserved.
Built and maintained by Cornelius Toole.

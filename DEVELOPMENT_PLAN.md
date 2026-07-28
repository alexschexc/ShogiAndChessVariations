# Development Plan

Goal: A desktop application supporting Shogi, Chess, and several common variants, with engine analysis and an LLM-backed chat interface.

## Phase 1: Foundations
- Define project structure under `src/main/kotlin/`
  - `core/` — game-agnostic types (Position, Move, Piece, Player)
  - `games/chess/`, `games/shogi/` — per-family rule logic
  - `ui/` — Compose Desktop widgets
  - `engine/` — UCI/USI adapter layer
  - `chat/` — LLM client (later)
- Add a minimal empty-window Compose entry point (already in place)
- Verify `nix-shell --run './gradlew run'` launches an empty window

## Phase 2: Board UI and Interaction
- Generic `BoardView` composable parameterized by board dimensions, perspective, and piece rendering
- Square selection and highlight states (selected, legal destinations, last move)
- Drag-and-drop or click-to-select interaction model
- Side panel for captured pieces, move history, and game metadata
- Persist board state via a `GameState` observable model

## Phase 3: Game Rules
- Chess
  - Standard rules, castling, en passant, promotion
  - FEN/PGN parsing and serialization
- Shogi
  - Standard rules, drop, promotion, nifu/uchifuzume detection
  - SFEN parsing and serialization
- Variants (driven by rules data, not code duplication)
  - Chess960, Three-Check, Atomic, Crazyhouse
  - Mini-Shogi, Yari-Shogi, Hasami-Shogi (judge scope before implementing)
- Shared rule-engine interfaces so UI and engines do not depend on concrete variants

## Phase 4: Engine Integration
- UCI client (Stockfish, Fairy-Stockfish)
- USI client (YaneuraOu)
- Engine process management via coroutines
- Analysis mode (eval, best line, principal variation)
- Move negotiation (human vs engine, engine vs engine)

## Phase 5: LLM Chat Interface (later)
- MiniMax API client using Ktor + kotlinx.serialization
- Streaming responses via Flow
- Chat panel with context-aware prompts (current position, last move, optional PGN/SFen)
- Local config for API key, base URL, model selection

## Phase 6: Polish
- Save/load games per variant
- Settings UI for engines, API keys, board themes
- Packaging via `createDistributable` for Linux, Windows, macOS
- Optional CI matrix to build distributables per OS

## Engineering Practices
- Keep `shell.nix` exhaustive for all runtime dependencies (JDK, Gradle, Kotlin, OpenGL/X11, engines)
- Run `./gradlew check` before commits
- Verify startup after any build or dependency change:
  ```
  nix-shell --run './gradlew clean build'
  nix-shell --run './gradlew run'
  ```
- Avoid coupling UI to a specific game; route everything through `GameState`
- Prefer data-driven variant definitions over parallel class hierarchies
---
name: writing-readme-files
description: Use when creating or revising a README, or when asked to document a project's front page. Guards against AI-slop READMEs — prompt rehashing, progress logs, and empty jargon — and shapes a README that convinces a new reader the project is worth using and shows them how to use it.
---

# Writing README Files

## Overview

A README is the face of the project. Its whole job is to move a reader from "no idea what this does" to (1) convinced the project is worth their time and (2) equipped to set it up and use it. It is not a changelog, not a design doc, and not a transcript of the decisions that built the code.

**Core principle:** write for a new human reader who has zero prior context. Every sentence either convinces them the project is useful or helps them use it. If it does neither, cut it.

AI-generated READMEs fail in predictable ways because the model reaches for conversation history and technical density instead of clarity. This skill names those failure modes and gives the structure that avoids them.

## When to Use

- Writing a new README from scratch
- Revising or "cleaning up" an existing README
- Reviewing a README someone (or an agent) generated
- Any time the request is "document this project" at the top level

**When NOT to use:** deep API docs, CLI references, contributing guides, or design-principle documents. Those are separate files the README *links to* (see Signpost below).

## The Three Pitfalls to Avoid

### Pitfall 1 — Prompt rehashing

Symptoms: unusual detail for a README; variable names, file paths, and internal nomenclature bleeding in; a paragraph that reads like a summary of everything discussed while building the feature.

A new reader does not want the full history of technical decisions. Density is not clarity. Jargon like "slug-scoped" or "identity on the wire" hides ideas instead of explaining them.

Fix: describe the *value* and the *design motivation*, not the wire format. Same length is fine — spend it on "what problem this solves" and "so what," not on internals.

Bad:
```
Vision Agent — Ingestion and CV, sole owner of the raw frame: no other process
ever sees the U16 data. ... its only outputs are a slug-scoped event socket
(length-prefixed protobuf VisionEvents) and the latest display image under
<runtime_dir>/<slug>/. Identity on the wire is the camera config slug.
```

Better:
```
Vision Agent — Because the app follows a strong separation of concerns, all
vision and camera tasks live in this one agent: camera connection, ingesting IR
data, and image processing (blob analysis, temperature extraction, and ML object
detection with our finetuned models). Results are published over the agent's
socket for the Core Agent to consume. This connect → ingest → publish design
means the Vision Agent runs standalone and depends on no other service.
```

### Pitfall 2 — Using the README to track progress

Symptoms: space spent on what one coding pass accomplished; placeholders, open TODOs, and checklists that get added but never updated.

The problem is structural: **the coding agent rarely revisits the README after later tasks, so a progress snapshot is stale by design.** A "first working slice is live, X is still a stub" blurb is wrong within a few prompts.

Fix: high-level *state* is fine and encouraged — **planning**, **in development**, **maintenance only**. Point-in-time progress is not. If "which services exist" matters, put it in a durable Services section (see Signpost), not a progress note. Track live TODOs in a dedicated document, never the README.

### Pitfall 3 — Empty jargon

Symptoms: phrases that sound impressive but clarify nothing; name-dropping vocab for its own sake.

Clarity sometimes costs a few extra words. Pay it.

| Avoid | Prefer |
|---|---|
| "Known prototype edges..." | "Known limitations in this prototype..." |
| "The first working slice is live..." | "You can run a live demo locally..." |
| "Identity on the wire is the camera config slug" | "Every socket message carries a slug unique to that camera" |
| "A local integrator and outward-facing process" | "Handles database integration and exposes a REST API for outside services" |
| "Caveats worth front loading" | "Considerations" / "Caveats to keep in mind" |

## The Structure That Convinces

Follow this shape. It is a style guide, not a rigid template — adapt sections to the project, but keep the convince-then-equip flow.

```
# About  (aka Motivation)
Convince the reader the project is necessary. A sentence or two on how it came
about is enough: a problem solved, a new experience, an idea tested. The reader
should think "this looks cool" or "glad someone built this." Images/charts are
welcome if they make the point.

# Quickstart
Convince the reader they can actually use it. Keep it focused and skimmable.
NOT the place for motivations, full service docs, or a file-by-file dump.

## Setup
### Prerequisites
### Building
### Start Commands

## Usage
Show a few real examples. Readers judge whether to install based on these, so
make them clean and show the project off a little.
```

Example of a strong About + Quickstart:
```
# About

The current ecosystem supports many image-processing tasks, but they are spread
across services built for different vendors — so you can't run them all in one
place. visq consolidates every image-processing tool into one SDK, and ships a
universal image driver so you can connect a camera and start processing in
minutes.

# Quickstart

visq is a single static binary with no runtime dependencies.

## Usage

Connect to a new camera
  visq vision-service ./config.yaml --name new-vision-service

Stream realtime detections
  visq tap --service new-detector --format json
```

## Define Conventions

A good README's contents are *foundational* — they stay fixed as the code grows. That is exactly why a small conventions section belongs here (or a pointer to a design-principles doc). Capture only decisions that stay true next month, each as one rule plus one line of reasoning.

```
## Patterns and Conventions
Full rationale in design-principles.md.

- One central database owner, sockets for everything else. state-server is the
  only writer to Postgres; everything else requests changes over WebSocket.
- The server is authoritative. Clients hold an optimistic copy; the server wins.
- Test-driven for core logic. UI and tooling are exempt.
- Feature-first structure. Grouped by domain (editing/, presence/), not by type.
```

## Make a Signpost

The README is not the whole documentation. Direct readers to where everything lives, and stop there.

```
## Services
- Vision Agent — ./internal/agents/vision/
- Core Agent — ./internal/agents/core/
- Database — ./internal/persistence/

## Documentation
- API Reference — ./docs/api.md
- CLI Reference — ./docs/query-syntax.md
- Contributing — ./CONTRIBUTING.md

External:
- simdjson — https://github.com/simdjson/simdjson
- CLI11 — https://github.com/CLIUtils/CLI11
```

Link major services/subprojects (each with its own README), existing docs for API/CLI, and external libraries (citation + easier debugging).

## Red Flags — stop and rewrite

- You copied internal names, file paths, or protocol details a new reader can't use
- A paragraph summarizes what was built recently rather than what the project *is*
- You wrote a TODO, checklist, or "current state: X is a stub" line
- A sentence sounds impressive but you can't say plainly what it means
- The About section explains architecture before it explains why anyone should care
- The README tries to document everything instead of linking out

## The Two Extremes Both Fail

- **Too sparse:** a few lines that reveal nothing about what the project does.
- **Too sprawling:** a long AI-generated wall no one will read (signalling no one wrote it, either).

Aim for the middle: short, to-the-point, and enough to get a reader started. Readers use these at-a-glance signals to judge quality — a clean README is the difference between a project that looks exciting and one that looks abandoned.

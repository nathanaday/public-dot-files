---
name: writing-documentation-prose
description: Use when writing or revising any prose documentation — docs pages, architecture and design notes, module or API overviews, doc comments, PR and commit descriptions, handoff notes — or when reviewing docs that read as vague, padded, or impressive-sounding without being clear.
---

# Writing Documentation Prose

## Overview

AI-generated documentation has a recurring failure: it takes longer to say less. It becomes punchy and salesman-like, optimized for headlines that look fine at a glance but carry no substance underneath.

**Core principle:** documentation transfers facts. It does not persuade, and it does not perform. State the fact plainly, then stop.

The output you want reads like a competent engineer explaining the system to a new hire in a hurry — not like a launch announcement.

## When to Use

- Writing or revising any documentation page, design note, or architecture doc
- Writing a module, service, or API overview
- Writing doc comments, PR bodies, commit messages, handoff notes
- Reviewing docs (yours or an agent's) that sound impressive but leave you unsure what the system does

**Related:** for README structure specifically — what sections a front page needs and in what order — use `writing-readme-files`. This skill governs the sentences; that one governs the shape of a README.

**When NOT to use:** reference tables, generated API specs, and CLI flag lists. Those are lookups, not prose.

## The Recipe

Apply to every sentence, in order:

1. **Name the actual thing doing the actual action.** Concrete subject (a function, a service, a message, the reader), concrete verb. If the subject is an abstraction — "identity," "the role," "the surface," "the slice" — replace it with the thing itself.
2. **Make it actionable by a stranger.** A new engineer reads the sentence and can act on it without a follow-up question. If they can't, the sentence is decoration — cut it.
3. **State it once, then stop.** No build-up to a point, no reframing a fact as an insight, no closing quip.
4. **Only claim what you were told.** If the brief didn't give you the reason, don't supply one.
5. **Spend words only on content.** Length must buy the reader a constraint, a number, a failure mode, or an example. If the fact fits in half the words, use half the words.

**Test:** a paragraph that follows the recipe can be read aloud to a tired colleague at 5pm without either of you wincing.

## Rewrites

Each pair says the same thing. The second one says it.

| Instead of | Write |
|---|---|
| "Identity on the wire is the camera config slug." | "Every socket message includes a slug that uniquely identifies the camera." |
| "This is a local integrator and outward-facing process." | "This service writes to the database and exposes a REST API to other services." |
| "It is returned, not thrown, and that is a design decision rather than a style preference. On the edge a dropped frame is not exceptional — it is Tuesday." | "`fetch()` returns an error value instead of throwing. Dropped frames are common and callers are expected to handle them." |
| "The role moved wholesale into the Core Agent, which adds JWT auth, multi-agent detection, and slug-scoped sockets." | "The Core Agent now handles authentication, agent detection, and socket identification." |
| "Caveats worth front loading" | "Considerations" / "Things to keep in mind" |
| "Known prototype edges" | "Known limitations in this prototype" |
| "The first working slice is live" | "You can run a demo locally" |
| "It receives only verified local artifacts to apply" | "It only accepts verified requests from internal services" |
| "It's not just X — it's Y" | (state what it is) |
| "Under the hood" / "At a high level" / "It's worth noting that" / "The key insight here is" | (delete, then describe the thing) |
| "Robust, seamless, powerful, elegant" | (delete, or give the measurement that justifies it) |
| "This is by design" / "This is deliberate" | (delete, unless the reader would otherwise file a bug) |

**Vocabulary:** _edge_, _wire_, _artifact_, _surface_, _primitive_, _slice_ mean something specific in some projects and nothing in others. If the project defines the word, use it. Otherwise say what you mean.

**Stacked names:** list components only when the reader needs each one. Three proper nouns in a clause usually means the sentence is marketing, not explaining.

## Worked Example

Same facts, written both ways.

Bad — metaphor, invented rationale, a punchline, and a fact reframed as an insight:

```
`thumbnailer` inverts the usual upload flow: rather than blocking the caller,
work is handed to the queue and the request returns immediately. Jobs that fail
are retried three times. This is deliberate — transient storage errors are the
common case, and failing a user's upload over a blip nobody caused would be the
wrong tradeoff. After the third attempt the job moves to the dead-letter queue,
where it waits for a human. The worker does not delete it. It forgets nothing.
```

Good — every sentence is a fact the reader can act on:

```
`thumbnailer` reads jobs from the `uploads` queue and writes a 256px JPEG to
S3 under the original's key plus `-thumb`. The API enqueues the job and returns
before the thumbnail exists, so callers must handle a missing thumbnail. A
failed job is retried three times, then moved to the `uploads-dlq` queue, which
is drained manually.
```

The second version is shorter and says more. The first spent its length on "inverts the usual upload flow," a tradeoff nobody stated, and a closing quip — none of which was a fact about `thumbnailer`. It also never says where the thumbnail lands or what callers must do about it.

## Common Mistakes

- **Supplying a "why" you don't have.** You were told the constraint, not the reason for it. Writing a plausible reason invents documentation. Ask, or state the constraint alone.
- **Treating the word budget as a target.** "4-6 paragraphs" is a ceiling, not a quota. Four tight paragraphs beat six padded ones.
- **Explaining the design's virtue instead of the design.** "This split keeps the hot path cheap" is a compliment. "The broker parses only JSON messages" is the fact under it.
- **Metaphors as topic sentences.** "The broker inverts the problem," "the session record is the broker's whole model of the world." Say the mechanism instead.

## Check Before Shipping

- Could I delete this sentence and lose nothing? Delete it.
- Does every noun refer to something the reader can point at in the codebase?
- Did I explain a fact, or perform an observation about a fact?
- Is every claim traceable to something I was told or read — no invented rationale?
- Would this sentence survive being read aloud to a tired colleague at 5pm?

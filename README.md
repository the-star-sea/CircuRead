# CircuRead: A Distributed Academic Idea Review System

CircuRead extends Git + GitHub into a **signed, multi‑tier review network** for academic idea notes.  
Every researcher keeps a private repository; reviews flow *upstream* to mentors via automatically‑generated “exchange” repositories and feedback flows *downstream* to students.  
All commits are GPG‑signed, fully traceable, and always visible to the original author.

[**English**](README.md) | [**中文**](README_CN.md)

## Table of Contents

* [Features](#features)
* [How It Works](#how-it-works)
* [Why CircuRead?](#why-circuread)
* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
  * [Setup](#setup)
  * [Workflow](#workflow)
* [Signature Verification](#signature-verification)
* [Contributing](#contributing)
* [License](#license)

---

## Features

* **Decentralised Repositories** – every participant owns a private repo; no single point of failure.  
* **Exchange Repos** – when two nodes first interact, CircuRead auto‑creates a lightweight edge repo (`alice__to__bob`) under a shared organisation; only the two collaborators can see it.
* **Graph‑Based Review** – each note can be routed to *multiple* upstream reviewers and exposed to selected downstream readers.
* **Per‑File Access Lists** – a sidecar YAML (`note.meta.yml`) names its `writer`, `noters`, `readers`, and `push_to` reviewers; privileges are granted/revoked automatically.
* **Immutable Signatures** – every approval is a GPG‑signed commit appended to the note.
* **LaTeX‑First** – notes are typically `.tex`, but any plaintext is fine.
* **One‑Line CLI** – `circuread deliver`, `circuread review`, `circuread fetch` wrap all Git + GitHub steps.
* **GitHub Actions Optional** – automate periodic permission cleanup or notify reviewers on delivery.

---

## How It Works

1. **Private Note Repo** – each researcher keeps a private repo (e.g. `alice/ideas`).2. **Note + Meta** – every idea lives in a directory:   ```
   qubits/
       note.tex
       note.meta.yml
   ```
   The meta file declares routing and ACLs.
3. **Delivery Upstream** – `circuread deliver qubits/note.tex` reads its `push_to` list, ensures an exchange repo for every `(me → reviewer)` pair, grants access, and pushes a signed commit containing only that note.
4. **Review & Signature** – reviewers run `circuread review`, append `\signature{…}` inside the LaTeX, commit with `-S`, and push back.
5. **Fetch & Merge** – the writer runs `circuread fetch <uuid>` to pull signed commits from each edge repo back into their private history; downstream readers get read‑only access automatically.
6. **Multiple Upstreams** – a note may fan‑out to many reviewers; each edge repo stores only its own history, avoiding merge chaos.
7. **Automatic Cleanup** – once the writer has fetched, a GitHub Action can revoke edge‑repo access to freeze the record.

---

## Why CircuRead?

* **Radical Transparency** – every signature is cryptographically verifiable; the originator sees the entire path of their idea.  
* **Early Discovery of Impactful Work** – multi‑tier routing lets strong ideas rise quickly through endorsement.  
* **Focused Resources (集中力量办大事)** – by bubbling up well‑signed proposals, departments can channel funding and attention to projects with proven merit.

---

## Getting Started

### Prerequisites

* GitHub account + Git CLI
* GitHub CLI (`gh`) for API calls
* GPG key for signed commits  
  * [Generate a key](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key)

### Setup

1. **Create your private repo** (e.g. `my-ideas`).  
2. **Add a node config** `.circuread.yml`:
   ```yaml
   me: alice_smith
   upstreams: [bob_johnson, clara_kim]
   downstreams: [charlie_lee, dana_chen]
   exchange_org: circuread-xrepos
   default_visibility: private
   ```
3. **Create a note template**:
   ```bash
   mkdir qubits
   touch qubits/note.tex qubits/note.meta.yml
   ```
   Example `note.meta.yml`:
   ```yaml
   title: Topological Qubits
   writer: alice_smith
   noters: []
   readers: [charlie_lee, dana_chen]
   push_to: [bob_johnson, clara_kim]
   ```
4. **Set Git to sign**:
   ```bash
   git config --global user.signingkey YOUR_GPG_ID
   git config --global commit.gpgsign true
   ```

### Workflow

#### 1 · Originator

```bash
vim qubits/note.tex            # write the idea
git add qubits/*
git commit -S -m "Draft: topological qubits"
circuread deliver qubits/note.tex   # pushes to each upstream
```

#### 2 · Reviewer

```bash
circuread review ~/gh/circuread-xrepos/alice__to__bob/qubits/note-uuid
```

The CLI opens the LaTeX, appends `\signature{Dr. Bob Johnson}{\today}{GPG}` and pushes.

#### 3 · Originator fetches

```bash
circuread fetch qubits/note-uuid
```

Signed commits merge into the private repo; edge‑repo access is optionally revoked.

---

## Signature Verification

* **GitHub UI** – look for the green **Verified** badge.  
* **Command line** –
  ```bash
  git log --show-signature --decorate --oneline
  ```

---

## Contributing

Ideas for a richer ACL schema, CLI extensions, or GitHub Action recipes are welcome. Open an issue or pull request.

---

## License

MIT © 2025 CircuRead Contributors

# CircuRead: A Distributed Academic Idea-Review System

CircuRead transforms Git and GitHub into a **distributed, digitally-signed, multi-tier peer-review system**, designed to facilitate the secure, efficient, and transparent exchange of academic ideas, enabling rapid identification and promotion of high-quality research concepts.

[**English**](README.md) | [**中文**](README_CN.md)

---

## Vision

CircuRead aims to establish a decentralized and transparent academic review mechanism that accelerates the discovery and elevation of high-quality academic ideas, fostering an open, trusted academic environment, and channeling research resources towards the most impactful and promising projects.

---

## Key Features

* **Decentralized Storage**: Every researcher maintains their own GitHub repository for storing idea notes, ensuring data resilience and eliminating single points of failure.
* **Robust Version Control**: Leveraging Git’s comprehensive version tracking to record every edit, addition, and signature, providing complete and traceable historical records.
* **Immutable Signatures**: Utilizes GPG-signed Git commits to verify the authenticity of reviews and maintain the integrity of idea content.
* **LaTeX Integration**: Supports professional-quality and consistently formatted idea notes written in LaTeX.
* **Automated Review Workflow**: GitHub Actions automates review request checks and notifications, minimizing manual overhead.
* **Flexible Multi-Tier Review Hierarchy**: Researchers can review ideas from their downstream colleagues while their own ideas are reviewed upstream, enabling dynamic collaboration.

---

## How It Works

1. **Individual Repositories**: Each researcher maintains a private repository, e.g., `alice/ideas`.

2. **Idea Notes & Metadata**: Ideas are stored in directories with associated metadata:

   ```
   qubits/
     ├── note.tex
     └── note.meta.yml
   ```

   The metadata file defines routing and access control.

3. **Upstream Submission**: Using `circuread deliver qubits/note.tex`, the system automatically reads the `push_to` list, sets up exchange repositories for each `(originator → reviewer)` pair, grants access, and pushes signed commits.

4. **Review & Signature**: Reviewers run `circuread review`, append a `\signature{…}` in LaTeX, commit with GPG signature, and push back.

5. **Fetch & Merge**: Authors execute `circuread fetch <uuid>` to integrate reviews; downstream readers automatically receive read-only updates.

6. **Parallel Multi-Upstream**: Ideas can simultaneously reach multiple reviewers without merge conflicts, as each reviewer maintains their separate history.

7. **Dynamic Permissions Management**: Access permissions are automatically synchronized whenever the configuration is updated, ensuring current and effective collaboration relationships.

---

## Getting Started

### Prerequisites

* GitHub account and Git CLI
* GitHub CLI (`gh`)
* GPG key for signed commits ([Guide](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key))

### Repository Setup

```yaml
# .circuread.yml
me: alice_smith
upstreams: [bob_johnson, clara_kim]
downstreams: [charlie_lee, dana_chen]
exchange_org: circuread-xrepos
default_visibility: private
```

Creating the first note:

```bash
mkdir -p qubits
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

Enable commit signing:

```bash
git config --global user.signingkey YOUR_GPG_ID
git config --global commit.gpgsign true
```

### Daily Workflow

```bash
# Originator writes note
vim qubits/note.tex
git add qubits/*
git commit -S -m "Draft: topological qubits"
circuread deliver qubits/note.tex

# Reviewer evaluates note
circuread review ~/gh/circuread-xrepos/alice__to__bob/qubits/<uuid>

# Originator fetches reviews
circuread fetch <uuid>
```

---

## Signature Verification

```bash
git log --show-signature --decorate --oneline
```

---

## Contributing

Bug reports, feature requests, or workflow enhancements are welcome via Issues or Pull Requests.

---

## File Structure

```text
startup/
├── bootstrap.sh
├── circuread
├── fetch_edges.sh
├── manage_edges.sh
└── .github/
    └── workflows/
        ├── auto_fetch.yml
        └── sync_edges.yml

my-ideas/                       # Example private repository
├── .circuread.yml
└── qubits/
    ├── note.tex
    └── note.meta.yml
```

---

## License

MIT © 2025 CircuRead Contributors

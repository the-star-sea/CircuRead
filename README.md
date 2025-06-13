# CircuRead: A Distributed Academic Idea Review System

CircuRead leverages GitHub and GitHub Actions to create a secure, transparent, and traceable distributed review process for academic idea notes. It ensures ideas are collaboratively reviewed, signatures are immutable, and version history is fully maintained.

[**English**](README.md) | [**中文**](README_CN.md)

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

* **Decentralized Storage:** Each participant maintains their own GitHub repository for idea notes, ensuring data resilience and eliminating single points of failure.
* **Version Control:** Leverages Git's powerful version control to track every change, addition, and signature, providing a complete historical record.
* **Immutable Signatures:** Utilizes Git's commit signing (GPG) to ensure the authenticity of each signature and the integrity of the idea note content.
* **LaTeX Integration:** Supports idea notes written in LaTeX, allowing for professional and consistent formatting.
* **Automated Review Workflow:** GitHub Actions can automate checks and notifications for review requests.
* **Fluid Review Hierarchy:** Supports a flexible review structure where individuals can review "downstream" ideas and have their own ideas reviewed "upstream," fostering dynamic collaboration.
* **Submitter Transparency:** Guarantees that the originator of an idea note always has visibility into its review progress and all subsequent signatures.

---

## How It Works

At its core, CircuRead treats each idea note and its review process as a series of Git commits in a distributed repository, promoting a flexible "up" and "down" review dynamic.

1.  **Individual's Repository:** Every participant (whether student, researcher, or professor) creates and maintains their own private GitHub repository for their idea notes.
2.  **Idea Note Creation:** Individuals write their idea notes in LaTeX, committing them to their own repository.
3.  **Initiating a Review (Upstream):** When an individual (the "Originator") wants an idea reviewed by a more senior colleague (their "Reviewer"), they:
    * Push their changes to their repository.
    * **Grant read access to their Reviewer** on their repository.
    * Notify their Reviewer about the new idea note requiring attention.
4.  **Reviewer's Action & Signature:**
    * The Reviewer clones the Originator's repository.
    * They review the idea note. If approved, they **add their name and a GPG-signed commit** to the LaTeX file (e.g., in a dedicated signature section).
    * This signed commit acts as their immutable approval.
    * They then push this signed commit back to the Originator's repository.
5.  **Hierarchical Advancement:** Good ideas can be "promoted" further up the chain:
    * If the Reviewer believes the idea merits review by an even more senior colleague (their "Upstream Reviewer"), they can:
        * Share the Originator's repository (or a specific commit/branch from it) with the Upstream Reviewer.
        * The Upstream Reviewer repeats the review and signing process directly within the **Originator's repository**.
    * Each level of review adds a new, cryptographically verifiable signature to the idea note's history, always within the original idea's repository.
6.  **Transparent Feedback Loop:** Since all reviews and signatures happen directly within the Originator's repository, the **Originator automatically sees every step of the review process**, including all added names and signed commits, as soon as they are pushed. This ensures full transparency for the person who initially submitted the idea.
7.  **Immutable Record:** Git's cryptographic hashing ensures that any attempt to tamper with past commits or signatures will invalidate the subsequent history, making tampering easily detectable.

---

## Why CircuRead?

CircuRead is designed with several key objectives in mind:

* **Academic Transparency:** By maintaining a complete, verifiable history of idea development and review, we foster an environment of open scrutiny and accountability. Every contribution and every signature is permanently recorded, enhancing trust and clarity in the academic process. The originator always has full visibility into the review chain.
* **Better Discovery of Good Ideas:** The structured, hierarchical review process allows promising ideas to naturally surface and gain visibility. As ideas are reviewed and endorsed by progressively senior academics, truly impactful concepts can be identified earlier and brought to the attention of the wider academic community.
* **Concentrate Resources on Major Undertakings (集中力量办大事):** This system helps us efficiently channel attention and resources towards the most impactful and validated research ideas. By systematically elevating strong proposals, we ensure that valuable time, funding, and intellectual effort are focused on initiatives that have the greatest potential for significant academic contribution. This strategic allocation helps us achieve breakthrough results more effectively.

---

## Getting Started

### Prerequisites

* A GitHub account.
* Basic understanding of Git commands.
* A GPG key for signing commits (recommended for all reviewers).
    * [Generating a new GPG key](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key)
    * [Telling Git about your signing key](https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key)

### Setup

1.  **Create Your Repository:**
    * Every participant: Create a **private** GitHub repository for your idea notes (e.g., `my-research-ideas`).
2.  **LaTeX Template (Optional but Recommended):**
    * Consider creating a standard LaTeX template for idea notes that includes a dedicated section for signatures (e.g., using `\signature{Name}{Date}{GPG_Fingerprint}`).
3.  **Configure Git for Signing:**
    * Ensure Git is configured to sign your commits using your GPG key.
        ```bash
        git config --global user.signingkey YOUR_GPG_KEY_ID
        git config --global commit.gpgsign true # Automatically sign all commits
        ```

### Workflow

1.  **Originator's Initial Submission:**
    * Write your idea note in LaTeX (e.g., `idea-note-quantum-computing.tex`).
    * Add and commit your file:
        ```bash
        git add idea-note-quantum-computing.tex
        git commit -S -m "Initial idea note: Towards Quantum Error Correction with Topological Qubits" # -S signs the commit
        git push origin main
        ```
    * **Grant read access** to your intended Reviewer on your GitHub repository.
    * Notify your Reviewer about the new idea note.
2.  **Reviewer's Action & Signature (First Level):**
    * The Reviewer clones the Originator's repository:
        ```bash
        git clone [https://github.com/originator-username/my-research-ideas.git](https://github.com/originator-username/my-research-ideas.git)
        cd my-research-ideas
        ```
    * Review `idea-note-quantum-computing.tex`.
    * If approved, edit `idea-note-quantum-computing.tex` to add your signature (e.g., `\signature{Dr. Alice Smith}{\today}{ABC123DEF456}` inside the document).
    * Commit the change with your GPG signature:
        ```bash
        git add idea-note-quantum-computing.tex
        git commit -S -m "Approved and signed by Dr. Alice Smith for Quantum Error Correction idea"
        git push origin main
        ```
    * **Transparency for Originator:** The Originator will see this new commit and signature in their own repository.
3.  **Upstream Reviewer's Action & Signature (Second Level, etc.):**
    * If Dr. Alice Smith decides this idea needs review by Professor Bob Johnson:
        * Dr. Smith would inform Prof. Johnson about the idea in `originator-username/my-research-ideas`.
        * Prof. Johnson would need to have (or be granted) read access to `originator-username/my-research-ideas`.
        * Prof. Johnson clones/pulls the latest changes from `originator-username/my-research-ideas`.
        * Reviews the idea note, adds their signature to `idea-note-quantum-computing.tex` (e.g., `\signature{Prof. Bob Johnson}{\today}{GHI789JKL012}`), and commits with their GPG signature:
            ```bash
            git add idea-note-quantum-computing.tex
            git commit -S -m "Endorsed and signed by Prof. Bob Johnson for Quantum Error Correction idea"
            git push origin main
            ```
    * The Originator continues to have full visibility into all new signatures and commits in their repository.

---

## Signature Verification

The integrity of this system relies on Git's commit signing. You can verify the authenticity of any commit (and thus, the signature) in a GitHub repository:

* **On GitHub:** Look for the "Verified" badge next to commit messages. Clicking it will show details about the GPG signature.
* **Locally using Git:**
    ```bash
    git log --show-signature
    ```
    This will display the GPG signature for each commit, indicating whether it's valid.

---

## Contributing

This is a conceptual framework. If you have ideas for improving the workflow, automation with GitHub Actions, or better LaTeX integration, feel free to open issues or pull requests.

---

## License

This project is open-sourced under the [MIT License](LICENSE).

---


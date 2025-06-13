# CircuRead：一个分布式学术思想圈阅体系

CircuRead 利用 GitHub 和 GitHub Actions 搭建了一个安全、透明、可追溯的学术思想笔记圈阅流程。它确保了思想的协作评审、签名的不可篡改性以及完整的版本历史记录。

[**English**](README.md) | [**中文**](README_CN.md)

## 目录

* [功能特性](#features)
* [工作原理](#how-it-works)
* [为何选择 CircuRead？](#why-circuread)
* [快速开始](#getting-started)
    * [前置条件](#prerequisites)
    * [设置](#setup)
    * [工作流程](#workflow)
* [签名验证](#signature-verification)
* [贡献](#contributing)
* [许可证](#license)

---

## 功能特性

* **去中心化存储**：每个参与者维护自己的 GitHub 仓库用于存放思想笔记，确保数据韧性，避免单点故障。
* **版本控制**：利用 Git 强大的版本控制功能，追踪每次修改、添加和签名，提供完整的历史记录。
* **不可篡改签名**：使用 Git 的提交签名（GPG），确保每个签名的真实性和思想笔记内容的完整性。
* **LaTeX 集成**：支持用 LaTeX 编写思想笔记，实现专业且一致的格式。
* **自动化圈阅流程**：GitHub Actions 可以自动化圈阅请求的检查和通知。
* **灵活的圈阅层级**：支持灵活的圈阅结构，个人可以评审“下游”的想法，自己的想法则由“上游”评审，促进动态协作。
* **提交者透明度**：确保思想笔记的原创者始终能够看到其评审进展和所有后续签名。

---

## 工作原理

CircuRead 的核心是将每个思想笔记及其圈阅过程视为分布式仓库中一系列 Git 提交，推动灵活的“向上”和“向下”评审动态。

1.  **个人仓库**：每位参与者（无论是学生、研究员还是教授）都创建并维护自己的私有 GitHub 仓库，用于存放他们的思想笔记。
2.  **思想笔记创建**：个人用 LaTeX 编写思想笔记，并提交到自己的仓库中。
3.  **发起圈阅（向上）**：当某位个人（“原创者”）希望更资深的同事（他们的“评审者”）评审一个想法时，他们会：
    * 将更改推送到自己的仓库。
    * **向其评审者授予对其仓库的读取权限**。
    * 通知评审者有新的思想笔记需要关注。
4.  **评审者的操作与签名**：
    * 评审者克隆原创者的仓库。
    * 他们评审思想笔记。如果批准，他们将在 LaTeX 文件中**添加自己的姓名和 GPG 签名的提交**（例如，在专门的签名区域）。
    * 这个签名的提交就代表了他们不可篡改的批准。
    * 然后他们将这个签名的提交推回到原创者的仓库。
5.  **层级推进**：好的想法可以进一步“上报”：
    * 如果评审者认为该想法值得更资深的同事（他们的“上游评审者”）评审，他们可以：
        * 与上游评审者分享原创者的仓库（或其中特定的提交/分支）。
        * 上游评审者直接在**原创者的仓库中**重复评审和签名过程。
    * 每次圈阅，都会在思想笔记的历史记录中添加一个新的、加密可验证的签名，始终保留在原始思想的仓库中。
6.  **透明反馈循环**：由于所有评审和签名都直接发生在原创者的仓库中，**原创者能够自动看到评审过程的每一步**，包括所有添加的姓名和签名提交，只要它们被推送。这确保了思想最初提交者的完全透明性。
7.  **不可篡改记录**：Git 的加密哈希确保任何试图篡改过去提交或签名的行为都会使后续历史失效，从而易于被发现。

---

## 为何选择 CircuRead？

构建此分布式学术思想圈阅体系，我们旨在实现以下关键目标：

* **学术透明**：通过维护思想发展和圈阅的完整、可验证历史，我们建立了一个开放审查和问责的环境。每一次贡献和每一个签名都被永久记录，增强了学术流程的信任度和清晰度。原创者始终能够完全了解评审链条。
* **更好发现好的想法**：结构化、层级化的圈阅流程使得有潜力的想法能够自然浮现并获得关注。随着想法逐步获得资深学者的评审和认可，真正有影响力的概念能够更早被识别，并被引荐给更广泛的学术群体。
* **集中力量办大事**：本体系有助于我们高效地将精力和资源集中于最有影响力和经过验证的研究思想。通过系统性地筛选出优秀的提案，我们确保宝贵的时间、资金和智力投入能够专注于最具重大学术贡献潜力的项目。这种战略性资源配置有助于我们更有效地取得突破性成果。

---

## 快速开始

### 前置条件

* 一个 GitHub 账户。
* 对 Git 命令有基本了解。
* 一个用于签名提交的 GPG 密钥（推荐所有评审者使用）。
    * [生成新的 GPG 密钥](https://docs.github.com/zh/authentication/managing-commit-signature-verification/generating-a-new-gpg-key)
    * [告诉 Git 你的签名密钥](https://docs.github.com/zh/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key)

### 设置

1.  **创建你的仓库**：
    * 每位参与者：为你的思想笔记创建一个**私有** GitHub 仓库（例如，`my-research-ideas`）。
2.  **LaTeX 模板（可选但推荐）**：
    * 考虑为思想笔记创建一个标准的 LaTeX 模板，其中包含专门用于签名的部分（例如，使用 `\signature{姓名}{日期}{GPG_指纹}`）。
3.  **配置 Git 进行签名**：
    * 确保 Git 配置为使用你的 GPG 密钥对提交进行签名。
        ```bash
        git config --global user.signingkey 你的_GPG_密钥_ID
        git config --global commit.gpgsign true # 自动签名所有提交
        ```

### 工作流程

1.  **原创者首次提交**：
    * 用 LaTeX 编写你的思想笔记（例如，`idea-note-quantum-computing.tex`）。
    * 添加并提交文件：
        ```bash
        git add idea-note-quantum-computing.tex
        git commit -S -m "Initial idea note: Towards Quantum Error Correction with Topological Qubits" # -S 签名提交
        git push origin main
        ```
    * **向你预期的评审者授予**你的 GitHub 仓库的读取权限。
    * 通知评审者有新的思想笔记。
2.  **评审者的操作与签名（第一级）**：
    * 评审者克隆原创者的仓库：
        ```bash
        git clone [https://github.com/originator-username/my-research-ideas.git](https://github.com/originator-username/my-research-ideas.git)
        cd my-research-ideas
        ```
    * 评审 `idea-note-quantum-computing.tex`。
    * 如果批准，编辑 `idea-note-quantum-computing.tex`，添加你的签名（例如，在文档内部添加 `\signature{Dr. Alice Smith}{\today}{ABC123DEF456}`）。
    * 使用你的 GPG 签名提交更改：
        ```bash
        git add idea-note-quantum-computing.tex
        git commit -S -m "Approved and signed by Dr. Alice Smith for Quantum Error Correction idea"
        git push origin main
        ```
    * **对原创者透明**：原创者将在自己的仓库中看到这个新的提交和签名。
3.  **上游评审者的操作与签名（第二级，以此类推）**：
    * 如果 Dr. Alice Smith 决定这个想法需要 Professor Bob Johnson 评审：
        * Dr. Smith 会将 `originator-username/my-research-ideas` 中的想法告知 Prof. Johnson。
        * Prof. Johnson 需要拥有（或被授予）`originator-username/my-research-ideas` 的读取权限。
        * Prof. Johnson 克隆/拉取 `originator-username/my-research-ideas` 的最新更改。
        * 评审思想笔记，将他们的签名添加到 `idea-note-quantum-computing.tex` 中（例如，`\signature{Prof. Bob Johnson}{\today}{GHI789JKL012}`），并用 GPG 签名提交：
            ```bash
            git add idea-note-quantum-computing.tex
            git commit -S -m "Endorsed and signed by Prof. Bob Johnson for Quantum Error Correction idea"
            git push origin main
            ```
    * 原创者将持续完全了解其仓库中所有新的签名和提交。

---

## 签名验证

本体系的完整性依赖于 Git 的提交签名。你可以在 GitHub 仓库中验证任何提交（以及签名）的真实性：

* **在 GitHub 上**：查看提交消息旁边的“已验证”徽章。点击它将显示 GPG 签名的详细信息。
* **在本地使用 Git**：
    ```bash
    git log --show-signature
    ```
    这将显示每个提交的 GPG 签名，并指示其是否有效。

---

## 贡献

这是一个概念框架。如果你对改进工作流程、GitHub Actions 自动化或更好的 LaTeX 集成有任何想法，请随时提出问题或提交拉取请求。

---

## 许可证

本项目采用 [MIT 许可证](LICENSE) 开源。

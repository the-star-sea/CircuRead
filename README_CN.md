# CircuRead：分布式学术圈阅与协作系统

CircuRead 是一个基于 Git 与 GitHub 的**分布式、数字签名的多层级同行评阅系统**，旨在实现学术想法的安全、高效与透明流转，推动思想火花快速浮现并获得认可。

[**English**](README.md) | [**中文**](README_CN.md)

---

## 愿景（Vision）

CircuRead 期望通过透明、高效的去中心化思想圈阅机制，帮助研究者更快地发现与提升高质量的学术思想，加速科研成果转化，推动科研资源集中于真正具有潜力的重大项目（集中力量办大事），营造一个可信、开放的学术环境。

---

## 核心特性

* **去中心化存储**：每个研究者拥有专属 GitHub 仓库，独立维护自己的思想笔记，确保数据韧性，避免单点故障。
* **强大版本控制**：利用 Git 完整记录每次修改、添加和签名，提供完整、可追溯的历史记录。
* **不可篡改签名**：采用 Git 提交的 GPG 数字签名，确保每条评阅记录的真实性及思想笔记的完整性。
* **LaTeX 原生支持**：支持 LaTeX 格式的思想笔记，确保学术文档格式专业统一。
* **自动化圈阅流程**：通过 GitHub Actions 自动完成圈阅请求的检查与通知，减少人工维护成本。
* **动态灵活的圈阅层级**：研究者既可以向“上游”导师提交笔记，也能审阅“下游”学生的笔记，实现圈阅结构的灵活与动态流动。

---

## 工作原理

1. **个人仓库**：每个研究者单独拥有一个私有仓库，例如 `alice/ideas`。

2. **笔记与元数据**：每个学术想法均存储在一个专属目录中：

   ```
   qubits/
     ├── note.tex
     └── note.meta.yml
   ```

   其中，元数据文件声明圈阅路径及权限。

3. **上游递交**：`circuread deliver qubits/note.tex` 自动解析 `push_to` 列表，创建并配置交换仓库，推送签名提交给指定的上游评阅人。

4. **评阅与签名**：评阅人运行 `circuread review`，在笔记中添加签名 `\signature{…}` 并通过 GPG 提交推回。

5. **拉取与合并**：作者运行 `circuread fetch <uuid>` 拉取所有评阅的签名反馈；下游的学生自动获得只读权限以追踪最新进展。

6. **多上游并行**：单个笔记可以并行发送至多个评阅人，每个评阅链独立存储，避免冲突。

7. **权限动态管理**：每次修改权限配置后，系统自动同步交换仓库权限，确保协作关系实时有效。

---

## 快速开始

### 前置条件

* GitHub 账号与 Git CLI
* GitHub CLI (`gh`) 工具
* GPG 签名密钥（[生成指南](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key)）

### 仓库配置

```yaml
# .circuread.yml
me: alice_smith
upstreams: [bob_johnson, clara_kim]
downstreams: [charlie_lee, dana_chen]
exchange_org: circuread-xrepos
default_visibility: private
```

创建首个笔记：

```bash
mkdir -p qubits
touch qubits/note.tex qubits/note.meta.yml
```

`note.meta.yml` 示例：

```yaml
title: Topological Qubits
writer: alice_smith
noters: []
readers: [charlie_lee, dana_chen]
push_to: [bob_johnson, clara_kim]
```

启用提交签名：

```bash
git config --global user.signingkey YOUR_GPG_ID
git config --global commit.gpgsign true
```

### 日常操作

```bash
# 作者提交笔记
vim qubits/note.tex
git add qubits/*
git commit -S -m "Draft: topological qubits"
circuread deliver qubits/note.tex

# 上游评阅笔记
circuread review ~/gh/circuread-xrepos/alice__to__bob/qubits/<uuid>

# 作者拉取评阅反馈
circuread fetch <uuid>
```

---

## 签名验证

```bash
git log --show-signature --decorate --oneline
```

---

## 贡献指南

欢迎提交 Bug 报告、功能请求以及新的自动化脚本，创建 Issue 或提交 Pull Request。

---

## 项目文件结构

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

my-ideas/                       # 个人私有仓库示例
├── .circuread.yml
└── qubits/
    ├── note.tex
    └── note.meta.yml
```

---

## 许可证

MIT © 2025 CircuRead Contributors
"""

with open('/mnt/data/README\_CN\_perfected.md', 'w', encoding='utf-8') as f:
f.write(readme\_cn\_perfected)

'/mnt/data/README\_CN\_perfected.md'

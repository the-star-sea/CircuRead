# CircuRead：分布式学术圈阅阅系统

CircuRead 将 Git + GitHub 拓展为一个**签名、多层级的评阅网络**。  
每位研究者保有私有仓库；创意沿自动生成的“交换仓库”向**上游**导师递交，评语沿**下游**返还学生。  
所有提交均 GPG 签名、可追溯，并始终对原作者可见。

[**English**](README.md) | [**中文**](README_CN.md)

## 目录

* [功能特色](#功能特色)
* [工作原理](#工作原理)
* [为什么选择 CircuRead](#为什么选择-circuread)
* [快速上手](#快速上手)
  * [前置条件](#前置条件)
  * [环境配置](#环境配置)
  * [典型流程](#典型流程)
* [签名校验](#签名校验)
* [贡献指南](#贡献指南)
* [许可证](#许可证)

---

## 功能特色

* **分布式存储** — 每人一个私有仓库，无单点故障。  
* **交换仓库** — 首次互动自动生成 `alice__to__bob` 轻量仓库，仅双方可见。  
* **图结构评阅** — 每篇笔记可并行发送至多个上游，并对选定下游开放阅读。  
* **文件级 ACL** — 伴随文件 `note.meta.yml` 指定 `writer / noters / readers / push_to`，权限自动授撤。  
* **不可篡改签名** — 每次批准都是 GPG 签名提交。  
* **LaTeX 优先** — 建议 `.tex`，亦兼容其它纯文本。  
* **一行式 CLI** — `circuread deliver / review / fetch` 包办所有 Git + API 操作。  
* **可选 GitHub Actions** — 定时清理权限、提醒评阅人。  

---

## 工作原理

1. **私有笔记仓库** — 如 `alice/ideas`。  
2. **笔记 + 元数据**：  
   ```
   qubits/
       note.tex
       note.meta.yml
   ```
3. **向上游投递** — `circuread deliver` 解析 `push_to`，为每个 `(我→评阅人)` 创建交换仓库并推送签名提交。  
4. **评阅与签名** — 评阅人运行 `circuread review`，在 LaTeX 中插入 `\signature{…}` 并签名提交。  
5. **拉取并合并** — 作者运行 `circuread fetch` 将签名历史合并回私仓，下游读者获得只读权限。  
6. **多上游并行** — 一个笔记可同时发送给多位评阅人，互不冲突。  
7. **自动收尾** — 合并后可由 Action 撤销交换仓库权限，固化记录。  

---

## 为什么选择 CircuRead

* **极致透明** — 原作者随时洞悉评阅路径，签名可加密验证。  
* **高效发现好点子** — 多层级背书让优秀创意更早脱颖而出。  
* **集中力量办大事** — 通过签名链遴选，高校/实验室可将资源聚焦于最具潜力的项目。  

---

## 快速上手

### 前置条件

* GitHub 账号 + Git CLI  
* GitHub CLI (`gh`)  
* GPG 密钥（用于签名）  

### 环境配置

1. **创建私有仓库**（如 `my-ideas`）  
2. **添加节点配置** `.circuread.yml`：  
   ```yaml
   me: alice_smith
   upstreams: [bob_johnson, clara_kim]
   downstreams: [charlie_lee, dana_chen]
   exchange_org: circuread-xrepos
   default_visibility: private
   ```
3. **建立笔记模版**：  
   ```bash
   mkdir qubits
   touch qubits/note.tex qubits/note.meta.yml
   ```
   示例 `note.meta.yml`：  
   ```yaml
   title: 拓扑量子比特
   writer: alice_smith
   noters: []
   readers: [charlie_lee, dana_chen]
   push_to: [bob_johnson, clara_kim]
   ```
4. **启用 Git 全局签名**：  
   ```bash
   git config --global user.signingkey YOUR_GPG_ID
   git config --global commit.gpgsign true
   ```

### 典型流程

#### 1 · 作者

```bash
vim qubits/note.tex
git add qubits/*
git commit -S -m "草稿：拓扑量子比特"
circuread deliver qubits/note.tex
```

#### 2 · 评阅人

```bash
circuread review ~/gh/circuread-xrepos/alice__to__bob/qubits/note-uuid
```

#### 3 · 作者拉取

```bash
circuread fetch qubits/note-uuid
```

---

## 签名校验

* **GitHub 页面** — 提交旁的绿色 **Verified**。  
* **命令行** —  
  ```bash
  git log --show-signature --oneline
  ```

---

## 贡献指南

欢迎 PR：改进 ACL 语法、CLI、或编写自动化脚本。

---

## 许可证

MIT © 2025 CircuRead 贡献者

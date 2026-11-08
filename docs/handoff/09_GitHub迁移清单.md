# GitHub 迁移清单（2026-11-08）

仓库：https://github.com/panchengdong88888/wjjm
默认分支：main
用途：本项目后续唯一主工作区。源码读取、分析、状态更新、交接均优先从本仓库进行。

## 已迁移并经 GitHub API 树清单确认
- 原始加密 Lua：`01_原始资料/MainLeftBottom(2).lua`（156,668 bytes）
- VM dump：`02_基础索引/MainLeftBottom_vm_dump.json`（623,674 bytes）
- 原型索引：`02_基础索引/02_原型总索引.json`（127,354 bytes）
- 函数状态 CSV：`02_基础索引/03_函数状态清单.csv`（21,958 bytes）
- 早期 opcode reference：`02_基础索引/MainLeftBottom_opcode_reference_早期版.txt`（90,976 bytes）
- corrected 物理 PC 反汇编：`03_静态反汇编/MainLeftBottom_vm_disassembly_corrected_phase3.txt`（773,749 bytes）
- 指令级去虚拟化清单：`03_静态反汇编/指令级去虚拟化清单_非作者源码.lua`（764,790 bytes）
- 阶段三控制流报告、内层解码报告、静态候选、28 个辅助函数候选、闭包捕获子集、辅助函数审计、MainLoop 捕获审计、第一/第二/第三遍历史草稿和接续文档均已迁移。
- 核心原始文件的 SHA256 与既有总账一致；VM dump、反汇编和指令级清单均已在 GitHub 侧检查末尾内容及对象大小。

## 仍留在 Library、尚未迁移的二进制归档
- `MainLeftBottom_stage3.bin`（71,216 bytes）
- `MainLeftBottom_V4_反虚拟化交接工程包.zip`
- `MainLeftBottom_decompile_package_v4_phase3.zip`

原因：当前 GitHub 连接接口可直接写 UTF-8 文本，并可创建 base64 blob，但没有直接从当前本地容器上传二进制文件的接口。不能假装这些二进制已经进入仓库。它们暂时保留在 Library 作为备份来源。

## 尚未单独进入仓库的阶段三完整资料
- `MainLeftBottom_opcode_reference_corrected_phase3.txt`（完整 413 项参考）
- `MainLeftBottom_closure_map_phase3.txt`（全量闭包映射）

仓库已有早期 opcode reference、OP_412 修正语义补充、主关键闭包映射 JSON 和完整 corrected 反汇编；但这不等于上述两个完整文本文件已迁移。它们仍包含在 V4 phase3 ZIP 内。

## 后续规则
1. 新增源码必须真实写入仓库，不只在聊天中展示。
2. 每批工作后同步更新函数状态 CSV、机器状态 JSON、接续说明。
3. 每次修改已有文件先 fetch 当前 blob SHA，再 update；同一路径不可并行写入。
4. 新恢复普通 Lua 必须标注静态候选/调用点核验/完整静态恢复/运行时验证，不虚报完成。
5. 用户验收完整明文后，再按用户要求清理临时工程文件。

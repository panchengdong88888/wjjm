# 检查点 #30：PlayerPos 与两个匿名转发闭包静态恢复

日期：2026-11-09

## 1. PlayerPos

- 原型：`root.children[57]` / legacy `root/58`
- 10 条物理指令，4 个常量，无子原型。
- 完整静态恢复：
  ```lua
  local function PlayerPos()
      local x = SL:GetMetaValue("X")
      local y = SL:GetMetaValue("Y")
      return x, y
  end
  ```
- PC1–4 通过 SL:GetMetaValue 读取 X；PC5–8 同样读取 Y；PC9–10 返回两个值。
- 接收者 SL 保留为冒号调用。
- 与此前已恢复的 GetPlayerPosition（root.children[18]，返回坐标表）不是同一函数；PlayerPos 返回两个独立值。

## 2. AnonymousHelper_32

- 原型：`root.children[32]` / legacy `root/33`
- 6 条物理指令，0 常量，无子原型，vararg flag=1。
- 创建点：root PC307。
- 两个捕获槽：
  - UP[0] <- root T[46]
  - UP[1] <- root T[42]
- PC1–3 将两个捕获值和第一个函数参数放入寄存器。
- PC4 执行并返回 `UP[0](UP[1], arg1)`。
- PC5 的 vararg return 位于无条件返回之后，不可达；不得把后续 vararg 原样转发当作有效语义。
- 由于父级 T[46]/T[42] 的原始业务标识未在此原型内证明，源码保留 upvalue0/upvalue1 语义占位名。

## 3. AnonymousHelper_33

- 原型：`root.children[33]` / legacy `root/34`
- 5 条物理指令，0 常量，无子原型，vararg flag=0。
- 创建点：root PC310。
- 两个捕获槽：
  - UP[0] <- root T[45]
  - UP[1] <- root T[43]
- PC1–3 执行并返回 `UP[0](UP[1])`。
- PC4 的空参数 vararg return 位于无条件返回之后，不可达；PC5 为尾部 return。
- 父级捕获变量的业务名称暂不臆造。

## 状态

本批三个原型均完成完整静态恢复，尚未进行目标环境运行时验证。
完整静态恢复总数：27 / 110（24.5%）。
运行时验证：0。
源码文件：`04_源码候选/PlayerPos与匿名转发闭包_第十一批.lua`

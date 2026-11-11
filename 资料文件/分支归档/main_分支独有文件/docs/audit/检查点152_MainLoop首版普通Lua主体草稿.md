# 检查点 #152（2026-11-09）：MainLoop 首版普通 Lua 主体草稿

## 对象与产出

- 原型：root.children[45]，旧一基标签 root/46。
- 指令：417 条物理记录，41 个常量，无子原型。
- 新增普通 Lua 候选：04_源码候选/root45_MainLoop.lua。
- 本批依据已有 corrected phase3 指令级清单、控制流报告、闭包捕获映射和已恢复辅助函数，先形成可读主体；不重做 VM dump、原型统计、底层反汇编或既有闭包映射。

## 已确认的捕获槽位

MainLoop 由 root PC 214 创建，捕获父 root 的 22 个 T 寄存器，按零基 upvalue 槽位顺序为：

T[18], T[14], T[13], T[4], T[23], T[35], T[26], T[34], T[15], T[32], T[17], T[16], T[19], T[20], T[22], T[36], T[21], T[31], T[30], T[33], T[24], T[8]。

结合既有审计和源码，以下身份可确认：
- UPVALUE_9：GetOwnerID。
- UPVALUE_17：GetOwnerIDText。
- UPVALUE_18：root.children[29] 的存活判断包装器；在此调用路径 truthy 表示 actor 存活。
- UPVALUE_19：GetOwnerDescription(actor, mainPlayerID)，返回 ownerID 和描述文本。
- UPVALUE_21：配置表，使用字段 ATTACK_WAIT_TIME。

其余 upvalue 保留槽位名或角色型占位；捕获寄存器已知不代表业务身份已知。

## 首版主体覆盖

草稿将已有高层控制流整理为四部分：

1. 运行标记与白名单地图门槛：运行标记关闭时返回；白名单地图中非 IDLE 状态会通知、切回 IDLE 并调用重置 helper。
2. IDLE：读取候选 actor 列表；列表为空时提示“视野内没有可攻击怪物”；通过 GetOwnerID 谓词过滤并建立目标 ID 列表；过滤结果为空时提示“没有可攻击的怪物”；初始化计数/索引，输出目标数并切换 GATHERING。
3. GATHERING：处理等待 owner 变更的状态；按目标 ID 查找 actor、检查视野和存活状态，读取名称及 ownerID/描述；分别处理其他玩家归属、自己归属和未归属分支；未归属时调用尚未识别身份的单参数 target-action helper，并根据返回值进入等待或失败路径。PC 313–343 的汇总比较按目前可见谓词写成保守占位，并明确标记待逐 PC 复核。
4. ATTACKING：从保存的目标 ID 列表中寻找仍存在且存活的 actor，记录攻击日志并调用同一个未命名 target-action helper；所有目标均死亡/离开后切回 IDLE 并重置。

## 未解决与限制

- UPVALUE_15 是 actor map/provider 一类 helper；调用点包括带参数和不带参数两种，真实业务身份及可选参数含义未证明。
- UPVALUE_20 是接收 targetID 的单参数 helper。虽然控制流位置类似目标锁定/攻击动作，仍不能认定它就是 SetTargetID、PickUpItems 或其他特定函数。
- PC 313–343 的循环终止、计数器与状态切换边界仍需独立逐 PC 数据流复核；草稿中的 UPVALUE_11 与目标数量比较只是当前可读轮廓，不能据此提升静态恢复等级。
- 其余捕获值真实名称、部分 owner 分支参数业务含义，以及融合载荷/跳转下的完整 CFG 语义尚未全部核清。
- 控制流报告记录该原型有 314 个入口可达节点、103 个静态不可达节点；这不等于 417 条记录全部完成作者级语义复原。
- 未做宿主运行时验证、Lua 解释器执行验证或游戏环境验证。

## 等级与统计

状态：首版普通 Lua 草稿（待静态复审 / 未运行时验证）。

- 普通 Lua 草稿：81 → 82。
- 完整静态恢复：76 / 110（不变）。
- 运行时验证：0（不变）。

下一步先独立复核 MainLoop 的 UPVALUE_15 / UPVALUE_20 捕获身份及 PC 313–343 计数器/循环边界，再逐块对照整函数 CFG 校正本草稿。
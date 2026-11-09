# 检查点159：MainLoop依赖的三个短helper独立静态复审

日期：2026-11-09（Asia/Singapore）

本批复审：
- `root.children[35]` / legacy root/36：SetTargetID，26条指令。
- `root.children[7]` / legacy root/8：GetOwnerIDText，31条指令。
- `root.children[38]` / legacy root/39：GetOwnerID，31条指令。

## 1. SetTargetID（PC1-PC26）

- PC1-PC4检查global.Facade；缺失时PC5-PC6返回false。
- Facade存在时，PC7-PC13取得retrieveProxy并调用；VM在PC8保存Facade接收者，PC13以Facade作为第一个实参调用retrieveProxy。
- 因此普通Lua必须写成`global.Facade:retrieveProxy(global.ProxyTable.PlayerInputProxy)`，不能使用点调用丢失self。本批已修正原草稿中的点调用。
- PC14-PC17检查PlayerInputProxy；缺失返回false。
- PC18-PC23取得proxy:SetTargetID方法，传入proxy接收者、targetID及`global.MMO.SELETE_TARGET_TYPE_FIND`。
- PC24-PC25返回true；PC26是函数尾部return。
- vararg标志存在，但可达主体只读取第一个显式参数targetID；未读取额外变参。
- 26条指令的活动路径、receiver、实参顺序和布尔返回契约闭合。

## 2. GetOwnerIDText（PC1-PC31）

- PC1-PC2调用第一个参数actor的GetOwnerID()。
- PC3-PC8分别处理nil、空字符串、-1；特殊值路径均返回false（PC9-PC10）。
- 其他值PC12-PC15调用type(ownerID)并区分string。
- string路径PC17-PC24比较`ownerID == tostring(ownerID)`，相等返回true，不等返回false。
- 非string路径PC26-PC30比较`ownerID == 第二显式参数`，相等返回true，不等返回false。
- PC11、PC25为跳转/死代码路径，不构成额外业务返回。
- MainLoop调用点PC124-PC129将truthy结果用于“归属已变更为自己”分支，与上述布尔契约相符。

## 3. GetOwnerID（PC1-PC31）

- PC1-PC2同样调用actor:GetOwnerID()。
- PC3-PC8分别处理nil、空字符串、-1；特殊值均返回false（PC9-PC10）。
- 其他值PC12-PC15调用type(ownerID)并区分string。
- string路径PC17-PC24比较`ownerID ~= tostring(ownerID)`，不等返回true，相等返回false。
- 非string路径PC26-PC30比较`ownerID ~= 第二显式参数`，不等返回true，相等返回false。
- PC11、PC25为跳转/死代码路径，不构成额外业务返回。
- MainLoop调用点PC49-PC54使用该结果控制候选目标插入；truthy路径跳过插入，false路径插入目标ID。

## 4. 结论与状态

三个helper的可达PC、条件极性、receiver/实参和返回契约已闭合：
- `root.children[35]` SetTargetID：完整静态恢复（未运行时验证）。
- `root.children[7]` GetOwnerIDText：完整静态恢复（未运行时验证）。
- `root.children[38]` GetOwnerID：完整静态恢复（未运行时验证）。

本批更新：
- `04_源码候选/短函数草稿_第十二批.lua`：将Facade.retrieveProxy点调用修正为冒号调用，保留Facade作为self。
- `04_源码候选/root7_GetOwnerIDText.lua`、`root38_GetOwnerID.lua`：状态标记升级。
- 更新函数状态CSV、机器状态JSON与checkpoint协议。

统计：普通Lua源码候选82；完整静态恢复由77增至80/110；运行时验证0。

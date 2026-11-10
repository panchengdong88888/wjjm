# 检查点245：root PC1-PC412全局导出与模块字段总账复核

日期：2026-11-10

## 跨区间复核

将检查点241的PC1-PC85账本、检查点242-243的寄存器/字段记录、检查点244的PC341-PC412最终记录，与root corrected phase3逐段交叉核对。

### 全局导出（21项，包含模块根表）

1. MainLeftBottom
2. log
3. GetMapId
4. GetMapName
5. PlayerPos
6. GetDroppedItems
7. MoveTo
8. DiuItems
9. GetAvailableStoragePage
10. GetStorageItemData
11. StorageItems
12. TakeItems
13. PickUpItems
14. IsInWhitelistMap
15. MainLoop
16. InitGatherMonsters
17. StopGatherMonsters
18. Builtsetting
19. MoveItemToQuickUse
20. BlacklistItems
21. ClearBlacklistItems

### MainLeftBottom根表字段

- a、b、z三个子表/状态表入口。
- hide=DestroyUI
- show=SetButtonVisibilityState
- destroy=ShowHideAllButtons
- main=AccountIDValidation
- blacklist=blacklistState
- onDamageMsg=onDamageMsg
- doInit=doInit_UI

其中a内部字段另行保留：version、screenW、screenH、Blocklist、SendHookList、RecvHookList、isHidden、hidebut、LuaSendMsg；z包含六个布尔状态字段。b在已审区间初始化为空表。

### 无新增导出的区间

PC86-PC211未发现新的全局导出或MainLeftBottom根表字段写入。该段创建的配置表、状态cell和局部闭包不应误计为导出。

### 统计

- 根模块全局导出：21项（含MainLeftBottom根表）。
- MainLeftBottom根表字段入口：10项（a/b/z及7个直接功能字段）。
- 父寄存器生命周期：57/57；OP_387捕获描述符135项。
- 完整静态函数109/110；普通Lua草稿72；运行时验证0。
- 根模块仍是唯一未完成的整体源码单元；本总账不是完整可执行恢复源码。

### 下一步

检查点246：以58个直接子原型为清单，核对每个已完成工厂函数的源码位置、捕获参数顺序和root实例化点；先把无捕获及捕获关系最简单的闭包接入根模块普通Lua候选，再逐步处理共享cell和嵌套闭包。

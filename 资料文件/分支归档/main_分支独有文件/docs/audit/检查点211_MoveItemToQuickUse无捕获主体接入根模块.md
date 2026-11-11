# 检查点211：MoveItemToQuickUse无捕获主体接入根模块

日期：2026-11-10  
原型：root.children[41] / legacy root/42  
函数：MoveItemToQuickUse  
规模：133条物理指令、26常量、0子原型、0项upvalue

## 本次实际修改

将 `04_源码候选/短函数草稿_第六十一批.lua` 中已恢复的 `local function MoveItemToQuickUse(itemIndex, targetPos)` 主体接入 `root_MainLeftBottom_Module.lua`，放在根模块装配接口之前，并在其后执行：

```lua
_G.MoveItemToQuickUse = MoveItemToQuickUse
```

依据根模块反汇编PC259-PC260，该闭包无捕获且导出为全局 `MoveItemToQuickUse`，因此可以直接内嵌，无需伪造父级upvalue或闭包工厂。

## 主体保留的控制流

- 获取QuickUseProxy与Bag代理；任一缺失返回固定失败结果。
- 校验目标快捷栏位置范围。
- 遍历快捷栏数据，按Index定位物品；已在目标位置则拒绝。
- 目标位置已有条目时执行原字节码顺序的交换写入；空位时执行移动写入。
- 快捷栏未找到时查询背包列表，并通过 `next` 检查非空。
- 目标位原有条目先回退背包，再使用返回列表第1项写入目标位。
- 成功/失败返回值及提示文本保持现有草稿内容。

## 未擅自解释的事项

- `SetQuickUsePosData` 的布尔参数语义未验证，保留原始true/false和调用顺序。
- `GetItemDataByItemIndex` 返回表第1项的业务身份未验证。
- 所有代理API均未在目标宿主运行时验证。

## 计数口径

这是已登记原型的根模块整合副本，不是新增恢复原型。普通Lua草稿数仍为72；完整静态恢复记录仍为103；运行时验证仍为0。不得把本次整合副本重复计入函数数量，也不得将其标记为运行时可用。

## 验证

更新后回读根模块，确认函数定义仅有一份、导出语句存在，且原装配接口仍保留。该验证仅为仓库文本一致性检查，不代表Lua解释器或游戏运行时测试。

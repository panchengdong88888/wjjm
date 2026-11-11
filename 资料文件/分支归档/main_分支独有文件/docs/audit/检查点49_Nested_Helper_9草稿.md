# 检查点 #49：Nested_Helper_9 普通 Lua 草稿

日期：2026-11-09

## 对象身份
- 规范路径：`root.children[42].children[15]`
- legacy：`root/43/16`
- 原型索引：77
- 物理指令：30
- 常量：10
- 子原型：0

## 父级闭包捕获
父级 `root/43` PC415 创建闭包，捕获数2；捕获描述紧随其后：
- child UP[0] <- parent UP[3]
- child UP[1] <- parent UP[0]

子函数访问证据：
- UP[0].isHidden
- UP[0].hidebut
- UP[0].hide()
- UP[0].show()
- UP[1] 分别接收“隐藏所有按钮”与“显示所有按钮”

因此 child UP[0] 可暂命名为 uiState，UP[1] 为 notify；父级 UP[3]/UP[0] 的更上层原始变量名不强行推断。

## 控制流恢复
- isHidden truthy：notify("隐藏所有按钮")；调用 uiState.hide()；调用 GUI.setOpacity(uiState.hidebut, 0)；结束函数。
- isHidden false/nil：notify("显示所有按钮")；调用 uiState.show()；调用 GUI.setOpacity(uiState.hidebut, 255)；正常结束。

## 源码
`04_源码候选/短函数草稿_第二十七批.lua`

## 未验证
- notify 回调的外部实现与显示方式未追溯。
- GUI.setOpacity 的实际运行时效果未测试。
- 未进行运行时验证；本函数仅计入普通 Lua 草稿。

## 统计
- 本批新增普通 Lua 草稿：1
- 普通 Lua 草稿累计：33
- 完整静态恢复：27/110（24.5%），不变
- 运行时验证：0
- 最新检查点：#49

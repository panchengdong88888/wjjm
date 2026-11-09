# 检查点 #71：Nested_Button_setTitleFontSize 首版普通 Lua 草稿

日期：2026-11-09

## 原型身份
- 原型索引：68
- 规范路径：`root.children[42].children[9]`
- legacy：`root/43/10`
- 50条物理指令、17个常量、1个子原型、`vararg_flag=3`。

## 创建点及捕获
doInit_UI（`root/43`）PC340创建本函数，捕获数5；PC341-PC345依次给出：
- 本函数UPVALUE_0 <- doInit_UI.R6
- 本函数UPVALUE_1 <- doInit_UI.R22
- 本函数UPVALUE_2 <- doInit_UI.R23
- 本函数UPVALUE_3 <- doInit_UI.UPVALUE_4
- 本函数UPVALUE_4 <- doInit_UI.R21

以上仅确认槽位来源。草稿中的positionXBase、positionYBase、positionOffset、buttonRegistry、buttonYBase是暂定可读名，仍需结合doInit_UI局部变量生命周期核对。

## 已恢复主流程
1. 取GUI.Button_Create。
2. x坐标由`85 * UPVALUE_1`计算；y坐标由`UPVALUE_0.key - (UPVALUE_2 + 2.5)`计算。
3. 使用固定图片`res/public/fuzhu_btn.png`创建按钮。
4. 创建结果为假时直接返回。
5. 将按钮写入`UPVALUE_3[button.key]`。
6. 依次调用GUI.Button_setTitleText(button, UPVALUE_0.name)、Button_setTitleFontSize(button,18)、Button_setTitleFontName(button,"res/public/kaiti2.ttf")、Button_setTitleColor(button,"#ffffff")。
7. 若button.toggle为真，将button.toggled写为false。
8. 创建唯一子原型`root/43/10/1`并注册到按钮的addOnClickEvent。

## 子原型边界
- 子原型名称：Nested_Button_setTitleText；48条物理指令、10个常量、无子原型。
- 父函数PC45创建该闭包，captures=3；PC46-PC48的来源分别为父函数R4、父函数T[0]、父函数T[3]。
- 子原型内部会读取/写入与key、toggle、toggled、name相关的状态，并调用GUI.Button_setTitleText与GUI.Button_setTitleColor。
- 目前未能可靠闭合子原型中融合载荷的寄存器/临时参数边界，故没有将其伪写成完整点击回调；父函数草稿保留了回调注册位置和捕获映射，子原型另行专项恢复。

## 未闭合事项
- 本函数`vararg_flag=3`的参数表语义待解释器参数初始化规则复核。
- 五个UPVALUE槽位的业务语义名称暂定，需追踪doInit_UI局部变量。
- 子原型主体尚未恢复成可靠普通Lua。
- 未运行时验证。本批仅计首版普通Lua草稿，不升级完整静态恢复。

## 文件
- 源码：`04_源码候选/短函数草稿_第四十七批.lua`
- 审计：`docs/audit/检查点71_Nested_Button_setTitleFontSize首版草稿.md`

# 检查点 #215：Builtsetting 55指令完整静态恢复

日期：2026-11-10
原型：`root.children[23]`（legacy `root/24`）
物理指令：55；常量：15；子原型：0；无显式参数；1项Upvalue捕获。

## 捕获关系

根模块 PC256 创建该闭包，PC257 捕获 root R5 为 UPVALUE[0]。该值的业务名称尚未确认，但其调用契约由子函数本体闭合：每组设置后以一条中文提示文本作为唯一显式参数调用该回调。因此使用中性名称 `onSettingMessage`，不猜测其原始局部变量名或具体宿主API身份。

## 恢复源码

```lua
local function make_Builtsetting(onSettingMessage)
    return function Builtsetting()
        CHANGE_SETTING(27, { 0 })
        onSettingMessage("关闭背景音乐")

        CHANGE_SETTING(52, { 0 })
        onSettingMessage("关闭游戏音乐")

        CHANGE_SETTING(1002, { 0 })
        onSettingMessage("关闭高帧率")

        CHANGE_SETTING(57, { 1 })
        onSettingMessage("开启人物简装")

        CHANGE_SETTING(58, { 1 })
        onSettingMessage("开启怪物简装")

        CHANGE_SETTING(2005, { 0 })
        onSettingMessage("关闭屏蔽怪物")
    end
end
```

## 指令映射

- PC1-PC9：`CHANGE_SETTING(27,{0}))，随后调用 UPVALUE[0] 并传入“关闭背景音乐”。
- PC10-PC18：`CHANGE_SETTING(52,{0}))，随后提示“关闭游戏音乐”。
- PC19-PC27：`CHANGE_SETTING(1002,{0}))，随后提示“关闭高帧率”。
- PC28-PC36：`CHANGE_SETTING(57,{1}))，随后提示“开启人物简装”。
- PC37-PC45：`CHANGE_SETTING(58,{1}))，随后提示“开启怪物简装”。
- PC46-PC54：`CHANGE_SETTING(2005,{0}))，随后提示“关闭屏蔽怪物”。
- PC55：无显式返回值的return。

六组设置编号、数组值、执行顺序和对应提示文本均与 corrected phase3 反汇编一致。函数不读取其他参数，也没有子闭包。

## 状态

55条指令的主体控制流、六组设置参数和唯一捕获回调的调用契约全部闭合。升级为**完整静态恢复（未运行时验证）**。回调原始业务名称及 CHANGE_SETTING 宿主实现不在本函数内展开；未做目标游戏运行时验证。

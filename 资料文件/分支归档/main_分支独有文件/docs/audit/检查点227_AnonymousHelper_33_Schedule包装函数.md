# 检查点 #227：AnonymousHelper_33 Schedule包装函数

日期：2026-11-10
原型：`root.children[34]`（legacy `root/35`）
物理指令：7；常量：2；捕获：0；子原型：0；参数：2。

## 恢复源码

```lua
local function AnonymousHelper_33_Schedule(callback, interval)
    return SL:Schedule(callback, interval)
end
```

## 指令映射

- PC1-PC2：读取全局SL及Schedule成员，保留SL作为方法self。
- PC3-PC4：将两个显式参数依序放入调用区。
- PC5：直接返回Schedule调用的全部返回值。
- PC6-PC7：处于PC5无条件return之后，不可达，不生成额外逻辑。

## API核对

新框架开发包`SL.md`明确给出`SL:Schedule(callback,time)`，与本原型的self+两个参数调用一致。

## 结论

此前prototype_index将此原型错误指向`PlayerPos与匿名转发闭包_第十一批.lua`；该文件中的同名helper实际对应另一原型。本批新增专用源码并修正索引和CSV。7条指令完整静态恢复，未运行时验证。

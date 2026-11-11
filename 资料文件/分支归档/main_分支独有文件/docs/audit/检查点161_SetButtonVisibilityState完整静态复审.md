# 检查点161：SetButtonVisibilityState 15条指令独立静态复审

日期：2026-11-09（Asia/Singapore）
对象：`root.children[10]`（legacy `root/11`），15条物理指令，5个常量，无子原型。

## 1. 捕获值与状态写入（PC1-PC2）

- PC1读取UPVALUE_0，随后PC2执行字段写入。
- 字段名为`isHidden`，写入值为true。
- 因此UPVALUE_0是共享UI/模块状态对象；该闭包将其`isHidden`标记为true。

## 2. 按钮映射迭代器（PC3-PC6、PC13-PC14）

- PC3取得全局pairs函数。
- PC4读取UPVALUE_1作为待遍历的按钮映射表。
- PC5调用pairs(buttonMap)，取得泛型for迭代器三元组。
- PC6为循环初始化/控制转移节点；初次迭代进入PC7，迭代推进由PC13完成，PC14回跳PC7。
- PC13执行迭代器调用并检查下一键；迭代结束后离开循环。
- PC6/PC13/PC14构成标准pairs泛型for循环骨架，没有其他集合遍历或过滤条件。

## 3. GUI可见性调用（PC7-PC12）

- PC7读取全局GUI对象。
- PC8取得GUI.setVisible方法，并保留GUI接收者。
- PC9读取UPVALUE_1[当前key]，PC10取得映射值。
- PC11加载true。
- PC12调用setVisible，实参为GUI接收者、映射值、true。
- 因此必须保留冒号调用：`GUI:setVisible(buttonMap[key], true)`；不能改成丢失self的点调用。

## 4. 返回路径（PC15）

PC15为函数return。没有其他业务分支；循环结束后自然返回。

## 5. 等价普通Lua与结论

```lua
local function make_SetButtonVisibilityState(moduleState, buttonMap)
    return function()
        moduleState.isHidden = true
        for key in pairs(buttonMap) do
            GUI:setVisible(buttonMap[key], true)
        end
    end
end
```

- 15条物理指令的活动路径、两个upvalue读取、isHidden字段写入、pairs循环和GUI:setVisible receiver/实参顺序均已闭合。
- 捕获值按创建点寄存器保留中性名称，不声称恢复了原作者局部变量名。
- 当前草稿函数体与字节码执行顺序一致。

结论：升级为**完整静态恢复（未运行时验证）**。未验证GUI运行时行为或真实界面效果。

## 6. 统计与下一步

- 普通Lua源码候选：82（不变）
- 完整静态恢复：82/110（由81增加1）
- 运行时验证：0（不变）

下一步：复审`root.children[26]` ResetGatherMonsterData（20条）。重点核实捕获表/数值/字符串槽位写入是否对应共享upvalue cell，而不是误写成工厂函数参数的局部重绑定；并追踪捕获的回调是否有可确定的业务身份。

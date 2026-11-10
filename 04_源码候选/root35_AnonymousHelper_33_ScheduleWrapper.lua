-- root.children[34] / legacy root/35 / AnonymousHelper_33
-- 7条物理指令；2个显式参数；无Upvalue捕获、无子原型。
-- PC1-PC2读取SL.Schedule并保留SL作为self；
-- PC3-PC4将两个实参放入调用区；PC5返回SL:Schedule的全部返回值。
-- SL:Schedule(callback,time)签名由新框架3_40_xx/SL.md确认。

local function AnonymousHelper_33_Schedule(callback, interval)
    return SL:Schedule(callback, interval)
end

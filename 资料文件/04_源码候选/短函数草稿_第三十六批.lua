-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第三十六批：Nested_str / Nested_match
-- 状态：Nested_str / Nested_match已于检查点112完成静态恢复（未运行时验证）；父包装函数Nested_Anonymous仍为草稿。
-- UPVALUE_n 为闭包槽位占位名，不代表作者原始变量名。

-- Nested_str / Nested_match的完整、嵌套闭包结构及参数语义以第七十七批源码为准。
-- 本文件保留早期候选记录；Nested_match中的result缺失应回退空串，不可提前返回。
-- Nested_Anonymous父包装函数仍为草稿，不能因其子回调完成而升级。

-- 本批不将父包装函数 Nested_Anonymous 计为已恢复，其调用参数/vararg
-- 消费关系仍需结合父级调用点复核。


-- 检查点112更正：result或result.editStr缺失时回退空串并继续校验；不得在not result时提前return。完整逐PC映射见第七十七批源码与检查点112审计。Nested_Anonymous仍未完成。

-- 检查点112：请以04_源码候选/短函数草稿_第七十七批.lua为当前权威实现；其修正了子闭包层级、捕获链、result缺失处理和tonumber失败分支。

# 检查点232：ReadNumericConfig首参数与vararg入口复核

日期：2026-11-10

## 原型信息

- 规范路径：root.children[9]
- legacy路径：root/10
- 45条物理指令、13常量、无子原型
- VM vararg标记：1（可变参数原型）
- 唯一捕获：UP[0] = root.children[2] GetWritablePath

## 入口参数复核

PC5读取UP[0] GetWritablePath；PC6将当前帧R[0]复制到R[3]；PC7调用GetWritablePath并把该首参数作为路径输入。其后PC8-PC10将结果交给FileUtils:isFileExist。

函数后续没有读取任何额外vararg。PC15-PC17调用getStringFromFile，PC18-PC20调用type，PC25-PC36执行string.gsub(content,"%s","")与string.match(normalized,"^%d+$")，PC41-PC43仅在匹配非空ASCII数字串时调用tonumber并返回结果。

VM dump提供vararg标记，但未提供可独立确认固定形参数量的字段。调用链确认AnonymousHelper_49只传入一个文件名。为避免将未证明的固定形参数量写死，本次将源码入口统一为：

```lua
return function(...)
    local fileName = ...
    -- 后续读取逻辑
end
```

这与原先`function(fileName,...)`在本函数实际读取行为上等价：均只使用第一个传入值，后续可变参数不读取；但新的写法不额外断言第一个参数在原型声明中属于固定参数还是vararg。

## 45条指令的活动逻辑

1. 取得cc.FileUtils实例。
2. 通过捕获的GetWritablePath(fileName)构造完整路径。
3. 文件不存在时返回nil。
4. 读取文件内容；结果不是string时返回nil。
5. 删除内容中的全部Lua空白字符。
6. 仅匹配非空ASCII十进制数字串`^%d+$`。
7. 匹配成功时返回tonumber(normalized)，失败时返回nil。
8. PC44-PC45是return之后的不可达尾部。

## 调用链

- root PC297创建GetWritablePath。
- root PC298创建ReadNumericConfig闭包，PC299捕获GetWritablePath为UP[0]。
- root PC295准备`blacklist_distance.txt`；root PC304创建AnonymousHelper_49，捕获ReadNumericConfig与该文件名。
- AnonymousHelper_49调用ReadNumericConfig(fileName)，并原样转发返回值。

## 状态

- ReadNumericConfig 45条物理指令的活动路径与返回分支均已闭合。
- 主源码和独立候选文件统一采用保守vararg入口。
- 状态升级为完整静态恢复（未运行时验证）。
- 本次不进行游戏宿主运行时验证；runtime_verified仍为false。
- 完整静态恢复总数仍为108/110，本批只是对已有恢复函数的参数入口校正与状态同步，不增加总数。

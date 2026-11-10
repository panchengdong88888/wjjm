# 检查点271：MainLoop共享cell版本与root22注册去重

日期：2026-11-10  
仓库：panchengdong88888/wjjm / main

## 一、本批发现

检查点270留下两组重复注册：
- `root45_MainLoop.lua`注册3次；
- `root22_GetMapData2DPtr.lua`注册2次。

这些不是可忽略的格式重复。MainLoop的三个版本对OP_387共享cell的处理不同，后注册版本会覆盖正确版本。

## 二、MainLoop三个版本核对

| 版本 | 状态说明 | UP[8]/UP[10]处理 | 结论 |
|---|---|---|---|
| 第1版（检查点250） | complete static reconstruction candidate; adds shared-cell factory adaptation | 对目标列表和游标通过`.value`读写 | 保留 |
| 第2版 | first-pass ordinary Lua draft; no complete CFG proof | 把UP[8]/UP[10]当普通table/number | 删除 |
| 第3版 | first-pass ordinary Lua draft; no complete CFG proof | 把UP[8]/UP[10]当普通table/number | 删除 |

根装配实际传入：
- UP[8] <- `rootCells[15]`
- UP[10] <- `rootCells[17]`

二者都是OP_387共享cell适配对象。第1版使用`UPVALUE_8.value`和`UPVALUE_10.value`；第2/3版直接对cell表做长度/数值运算，不能与根装配实参匹配。由于第2/3版在sources注册表中后写入，它们此前覆盖了第1版，存在真实装配错误风险。

本批删除第2/3版（分别约12,450和12,538字符），保留检查点250的共享cell工厂版本。清理后：
- root45来源注册1处；
- make_MainLoop工厂定义1处；
- `UPVALUE_10.value`读写仍在；
- 旧的`UPVALUE_10 = index + 1`操作计数为0。

## 三、GetMapData2DPtr重复注册核对

root22有两个等价工厂定义：
- 首个来源块在`来源文件：04_源码候选/root22_GetMapData2DPtr.lua`内，导出`make_GetMapData2DPtr`到sources表；
- 后续块再次定义相同工厂，并直接覆盖同一sources键。

两版函数主体执行同一可达路径：五个参数truthy检查、坐标相同返回0、maxDistance非正返回nil、Chebyshev距离计算、超范围返回nil。后续块没有增加语义，故删除后续重复注册块（约1,009字符），保留带PC范围说明的首个来源块。

清理后root22来源注册1处、make_GetMapData2DPtr工厂定义1处。

## 四、主恢复稿清理结果

主恢复稿现对上述两项来源各保留一个注册版本；与检查点270合计清理了被覆盖的旧源码块。主恢复稿的root assembly调用仍将rootCells[15]/[17]传给MainLoop，不改其参数顺序。

本批未改MainLoop业务逻辑，只选择与现有OP_387共享cell根装配匹配的检查点250版本。静态完成数不因去重增加。

## 五、验证边界

- 已静态核对来源注册键唯一性及MainLoop共享cell参数契约。
- 未执行Lua/luac；环境未发现lua、luac、luajit可执行文件。
- 未进行目标游戏运行时验证。
- 完整静态恢复109/110；普通Lua草稿72；根直接闭包58/58源码层绑定；运行时验证0。

## 六、下一批

检查点272：对主恢复稿所有`MainLeftBottomRecovered.sources`注册键做全量重复扫描，确认不存在后注册覆盖前注册的同名键；随后复核根装配区所有`sourceFunction`调用是否只依赖当前唯一来源块。最后继续根模块PC1-PC412连续可读源码组织，而非继续仅增加审计文件。

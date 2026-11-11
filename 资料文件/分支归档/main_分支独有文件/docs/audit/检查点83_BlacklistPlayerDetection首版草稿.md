# 检查点 #83：BlacklistPlayerDetection 首版普通 Lua 草稿

日期：2026-11-09  
源码：04_源码候选/短函数草稿_第五十九批.lua  
状态：首版普通Lua草稿；未运行时验证；不作为最终可执行实现。

## 原型身份
- 名称：BlacklistPlayerDetection；原型索引93。
- 规范路径 root.children[47]；legacy root/48。
- 216条物理指令、35常量、无子原型、vararg_flag=0。
- root PC367创建闭包，捕获13个父寄存器。现有闭包映射文件未包含root/48这组捕获描述，故使用UPVALUE_0..12，不臆造父级变量名。

## 可确认的功能片段
1. 写入捕获表字段 isBlacklisting=true，并调用另一个捕获函数。
2. 调用 SL.GetMetaValue("HP")，经tonumber转换；随后读取/维护捕获表中的lastHp与deathHandled字段。
3. 使用HP变化、零值/负值及deathHandled状态分支更新字段；部分路径会调用第三个捕获函数。
4. 调用 IsInWhitelistMap；白名单地图路径提前返回。
5. 调用 SL.GetMetaValue("FIND_IN_VIEW_PLAYER_LIST")，后续存在按索引遍历视野玩家列表的数值循环。
6. 循环内出现SL.GetMetaValue("ACTOR_NAME")、ACTOR_MAP_X、ACTOR_MAP_Y读取；存在distance字段读取、坐标/距离计算或查询分支。
7. 通过os.time与捕获状态alertAt比较，更新alertAt并构造“野外观测到黑名单玩家：%s（%d格）”提示。
8. 使用nextTryAt实施下一次尝试时间门控，并维护noStoneWarned字段。
9. 后段存在随机传送道具检测/选择、Use/消息提示相关的控制流；常量包括随机传送、道具不可用、无随机传送石等提示。
10. 函数无显式返回值。

## 关键未闭合点
- 本函数13个upvalue捕获槽位与父root寄存器的映射尚未落入现有闭包映射文档；UPVALUE_0..12的业务身份未确定。
- HP状态分支中PC23使用的常量在反汇编中显示为['unknown',2]，不得擅自解释成特定哨兵；草稿中的字符串unknown仅为可读占位。
- HP变化与deathHandled分支的比较方向、状态写回顺序需结合融合载荷/跳转目标进一步复核。
- FIND_IN_VIEW_PLAYER_LIST元素究竟是actorInfo、实体对象还是复合结构未确认；草稿中的双返回值是寄存器级暂定命名。
- 多次GetMetaValue调用的接收参数、ACTOR_NAME/坐标取值对象尚未完全闭合。
- distance字段的来源、坐标/距离函数、unknown比较含义未确认；草稿把寄存器组写成coordinateData仅为结构化占位。
- alertAt节流阈值、nextTryAt延迟值分别来自哪个upvalue尚未映射。
- 随机传送道具筛选/UseItemByIndex或其他使用函数、道具索引与LuaSendMsg相关调用参数未闭合；草稿中的UPVALUE_9..12调用只是占位骨架，不能当作确定API。
- “没有随机传送石”与“没有可用的随机传送道具”两类提示的触发关系、table.concat参数和路径读取仍待复核。

## 统计
- 本批新增普通Lua草稿：1个；累计73个。
- 完整静态恢复仍29/110（26.4%）。
- 运行时验证仍0。
- 本函数保持首版草稿状态，不升级完整静态恢复。

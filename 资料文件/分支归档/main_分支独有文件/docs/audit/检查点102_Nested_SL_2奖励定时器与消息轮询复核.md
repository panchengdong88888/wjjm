# 检查点 #102：Nested_SL_2奖励定时器与消息轮询复核

日期：2026-11-09  
范围：
- `Nested_SL_2`：`root.children[42].children[1]` / legacy `root/43/2`，33条指令、8常量、1个子原型。
- `Nested_LuaSendMsg`：`root.children[42].children[1].children[0]` / legacy `root/43/2/1`，22条指令、5常量、无子原型。

## 父级捕获来源
doInit_UI PC289创建Nested_SL_2，PC290-PC294依次捕获：
1. parent UP[2] -> child UP[0]：rewardTimer状态表。
2. parent UP[0] -> child UP[1]：单字符串功能提示回调。
3. parent UP[17] -> child UP[2]：消息轮询取模基数。
4. parent UP[18] -> child UP[3]：消息条目表。
5. parent UP[19] -> child UP[4]：传入SL.Schedule的附加上下文实参。

## Nested_SL_2控制流
- PC1-PC4读取并测试rewardTimer。
- 句柄存在：PC5-PC7通知“关闭奖励功能”；PC8-PC12调用SL:UnSchedule(timer)；PC13-PC14将rewardTimer置为nil；PC15-PC16返回true。
- 句柄不存在：PC17-PC19通知“开启奖励功能”；PC20准备0；PC21-PC23取得SL.Schedule。
- PC24创建Nested_LuaSendMsg，捕获父T[0]、UP[2]、UP[3]。
- PC20-PC29构造调用实参：延迟0、回调闭包、UP[4]附加上下文；调用SL:Schedule。
- PC30将返回句柄写入rewardTimer；PC31-PC32返回true。
- VM dump中的`["unknown",2]`是nil序列化占位，关闭路径恢复为`rewardTimer=nil`。

## Nested_LuaSendMsg控制流
捕获：
- UP[0]：父函数T[0]，创建前初始化为0的可写计数器。
- UP[1]：父函数UP[2]，用于取模。
- UP[2]：父函数UP[3]，消息条目表。

逐PC：
- PC1-PC3：counter加1并写回捕获槽。
- PC4-PC10：计算`(counter-1)%modulus+1`，读取messageEntries[index]。
- PC11-PC12：条目为false/nil时跳至尾部，不发送。
- PC13-PC21：条目truthy时调用LuaSendMsg，7个实参依次为：
  `9002, entry[1], 1.0, 2.0, 3.0, entry[2], entry[3]`。
- PC22：无显式返回。

## 静态恢复结论
两个函数的捕获来源、轮询计数器写回、取模索引、空条目跳过、消息参数顺序、奖励定时器开关、Schedule/UnSchedule调用、句柄存储和返回值均已闭合。升级完整静态恢复（未运行时验证）。

## 保留边界
- UP[2]/UP[3]/UP[4]的原作者局部名称未恢复；按用途命名。
- Schedule第三个参数保留为附加上下文，不推断具体宿主含义。
- 未进行游戏客户端运行时验证。

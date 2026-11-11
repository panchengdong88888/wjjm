# 检查点 #25：InitGatherMonsters 捕获来源复核

日期：2026-11-09  
原型：`root.children[19]` / legacy `root/20` / `InitGatherMonsters`  
闭包创建位置：父原型 root PC238

## 已确认的捕获映射

root PC238 创建 `root/20`，捕获数为 7。随后 PC239–245 的捕获描述按顺序为：

| 子闭包 upvalue | 父级来源 | 当前可确认内容 |
|---|---|---|
| UP[0] | root T[3] | 供子函数读取/写入 `gatherTimer` 字段的状态对象 |
| UP[1] | root T[18] | 子函数将其设置为 true |
| UP[2] | root T[23] | 被调用一次，参数为 UP[3].IDLE |
| UP[3] | root T[13] | 读取其 `IDLE` 字段 |
| UP[4] | root T[35] | 被零参数调用 |
| UP[5] | root T[8] | 读取 `CHECK_INTERVAL`、`GATHER_THRESHOLD` |
| UP[6] | root T[4] | 接收格式化后的启动提示文本 |

## 关键结论与边界

- UP[2]、UP[3]、UP[4] 的**行为角色**已由子函数自身指令确定：状态切换 callable、状态常量表、零参数 callable。
- 但 root T[23]、T[13]、T[35] 在根初始化过程中的原始语义身份尚未闭合。不能据此断言作者原始变量名，也不能把 `setGatherState/stateConstants/resetMovement` 当作原始名称。
- UP[0] 的 `gatherTimer` 字段、UP[1] 的 true 写入、UP[5] 配置字段、UP[6] 通知回调角色均由子函数直接读写/调用证实。
- 本检查点不将 InitGatherMonsters 从首版草稿升级为完整静态恢复；运行时验证仍为 0。

## 下一步

继续从 root 初始化函数中反向追踪 T[23]、T[13]、T[35] 的定义与赋值；并独立解析 `root.children[17].children[0]` PC9–13 的融合调用，避免把捕获函数调用误写成 FileUtils 方法参数。

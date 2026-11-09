# 检查点156：MainLoop GATHERING未归属目标锁定路径校正

日期：2026-11-09（Asia/Singapore）
对象：`root.children[45]`（legacy `root/46`），PC203-PC312。

## 核验依据

逐条对照 corrected phase3 MainLoop PC203-PC312、阶段三控制流报告中的条件跳转/跳转目标，以及检查点153已确认的UPVALUE_9/17/19/20身份。

## 1. 进入未归属分支

- PC203-PC211读取actor名称（缺失时回退“未知怪物”），调用UPVALUE_19(actor, mainPlayerID)取得ownerID与description。
- PC215-PC216调用UPVALUE_9(actor, mainPlayerID)。truthy表示归属其他玩家，走PC218-PC235日志并推进索引。
- 否则PC239-PC240调用UPVALUE_17(actor, mainPlayerID)。truthy表示归属自己，走PC242-PC262日志、UPVALUE_11递增及索引推进。
- 两个归属判断均不成立时，PC263将本轮R2标志清为false，进入未归属目标分支。

## 2. 锁定前状态与日志（PC263-PC276）

- PC264先将当前循环索引写入UPVALUE_10。该写入发生在调用SetTargetID之前，草稿此前遗漏；现已补回。
- PC265-PC276格式化并输出：
  `锁定怪物 %d: %s (ID: %s, 归属: %s)`
  参数依次对应当前索引、怪物名称、目标ID的tostring结果、UPVALUE_19返回的归属描述文本。
- 草稿此前错误地在此处输出“怪物 %s 归属未变更或已离开视野”；该文案实际属于PC141-PC147的等待结果检查分支，现已移除并替换为准确的“锁定怪物…”日志。

## 3. SetTargetID成功/失败分支（PC277-PC312）

- PC277-PC279调用UPVALUE_20(targetID)，PC280检查返回值truthiness。
- 成功路径PC282-PC302：设置UPVALUE_12=true；读取os.time并加UPVALUE_21.ATTACK_WAIT_TIME写入UPVALUE_13；写入UPVALUE_16目标ID与UPVALUE_14怪物名称；输出“开始等待 %s 归属变更 (等待 %d 秒)”；最后跳至PC312汇合。
- 失败路径PC303-PC311：输出“锁定怪物 %s 失败”，将当前索引加1写入UPVALUE_10。
- 成功/失败均在PC312汇合，之后由PC313数值循环继续；不在此处return。
- 成功路径也会在循环体稍后统一将UPVALUE_10推进到当前索引+1；PC264的提前写入必须保留，以匹配字节码的调用前状态。

## 4. 修改

修订`04_源码候选/root45_MainLoop.lua`：
- 在未归属目标分支调用SetTargetID前，先写`UPVALUE_10 = index`。
- 恢复PC265-PC276真实锁定日志及四个参数。
- 不再将等待结果分支的“归属未变更或已离开视野”文案错误用于锁定前日志。

## 5. 状态

本批仅校正既有普通Lua草稿，不新增草稿、不提升完整静态恢复、不增加运行时验证。
全工程统计保持：普通Lua草稿82；完整静态恢复76/110；运行时验证0。
下一步：把MainLoop PC1-PC417的入口可达/不可达节点、所有分支目标、状态写入、循环和return汇合做一次总账式独立复核；确认没有剩余草稿差异后再评估完整静态恢复。

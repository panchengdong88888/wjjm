# 检查点 #138：BlacklistPlayerDetection HP/deathHandled 状态机闭合

日期：2026-11-09
原型：root.children[47] / legacy root/48，216条物理指令。

## PC21-PC54确认的状态转移
1. previousHp == nil：写入 state.lastHp=hp，并设置 state.deathHandled=(hp<=0)。PC23 K[16]=['unknown',2] 是nil序列化哨兵。
2. previousHp 非 nil且 hp>0：写入 state.lastHp=hp，state.deathHandled=false。
3. hp<=0、previousHp>0且 deathHandled 为假：设置 deathHandled=true、lastHp=0，并调用UPVALUE_3()一次。
4. hp<=0但previousHp<=0，或deathHandled已为真：不重复触发死亡回调。

## 分支证据
- PC23 OP_271：与nil哨兵相等时跳过PC24的跳转，进入首次状态初始化路径。
- PC28 OP_216与PC29/30/31配合，将首次状态的deathHandled设为hp<=0。
- PC34 OP_352/PC35跳转区分当前HP是否大于0；正HP路径PC36/39更新lastHp并清除deathHandled。
- PC43 OP_364检查previousHp是否大于0；PC47 OP_342检查deathHandled；仅未处理路径执行PC50/52/54设置标志、lastHp=0并调用捕获回调。

## 修订与边界
已更新第五十九批草稿及函数状态CSV。HP/deathHandled分支现已静态闭合，但整个BlacklistPlayerDetection仍是首版普通Lua草稿，不能标记为完整静态恢复或运行时验证。后续还需复核PC74-PC216。

统计：普通Lua草稿78；完整静态恢复76/110；运行时验证0。

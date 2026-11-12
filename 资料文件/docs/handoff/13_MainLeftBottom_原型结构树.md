# MainLeftBottom(2).lua 原型结构树（仓库证据汇总）

生成日期：2026-11-10  
主仓库：`panchengdong88888/wjjm` / `main`

## 1. 数据来源与可信边界

本结构树由以下当前仓库文件机械汇总，不使用旧对话进度推测：

- `02_基础索引/02_原型总索引.json`（blob `86a173ddfe8097a9a8407d68c4d6ce57948c2c0e`）：110个原型、父路径、原型编号、固定参数数、指令数、常量数、子原型数、二进制偏移、子闭包创建PC。
- `docs/handoff/04_闭包捕获映射.json`（blob `ad4fa8b59cf9e99c2acc8da3c16acc08e55e43bd`）：root/45、root/46、root/46/0及根级58个直接闭包的捕获描述。
- `docs/handoff/12_根模块闭包装配表.json`（2026-11-10版本）：58个根级闭包创建点、135项OP_387捕获描述、57个不同父T寄存器的共享cell关系。
- `02_基础索引/03_函数状态清单.csv`（blob `0753a847844b365a397b43b60e37a45899ed4f4f`）：函数静态恢复状态。

规范路径统一采用 `root.children[n]` 的零基索引。旧报告中的 `root/n` 是一基标签，不能直接混用。

## 2. 总体统计

| 项目 | 当前仓库证据 |
|---|---:|
| 原型总数 | 110 |
| 物理指令总数 | 5580 |
| 根模块指令数 | 412 |
| 根模块常量数 | 109 |
| 根模块直接子原型 | 58 |
| 根级闭包创建点 | 58 |
| 根级OP_387捕获描述 | 135 |
| 根级不同父T寄存器数 | 57 |
| 根级直接闭包捕获描述全部为OP_387 | true |
| 完整静态恢复原型 | 109 / 110 |
| 普通Lua草稿函数 | 72 |
| 运行时验证通过 | 0 |

## 3. 根级闭包捕获的VM语义

OP_387不是捕获寄存器当前值的快照，而是捕获父T表中的寄存器cell。闭包读取/写入同一父寄存器时会观察到该cell的后续值变化。因此：

- 同一个父T寄存器被多个闭包捕获时，必须共享同一cell适配对象。
- 不同父T寄存器不能错误共用cell。
- 不能把捕获列表当作业务变量名列表；寄存器到业务语义的命名必须另有数据流证据。
- 本树对根级58个直接子原型列出确切父T寄存器；其他嵌套原型列出捕获数量和创建PC，除非专门闭包映射文件提供寄存器细节，否则不猜测寄存器编号。

## 4. 完整原型父子树

下列110个节点按真实parent_path递归排列。每个节点包含：可识别名称、规范路径、proto编号、固定参数数量、物理指令数量、子原型数量、常量数量、字节偏移、父级创建PC、捕获数量/可确认的父T寄存器、CSV状态。

- **MainLeftBottom_Module** — `root`; proto=0; params=0; instructions=412; children=58; constants=109; offset 0..71216; create-PC=root; UP=未记录; status=根模块部分普通Lua草稿（未完成；未运行时验证）
  - **FileExistCheck_pcall_wrapper** — `root.children[0]`; proto=1; params=1; instructions=32; children=1; constants=5; offset 5323..5760; create-PC=302; UP=1; parent T regs=[44]; status=完整静态恢复（未运行时验证）
    - **Nested_removeFile** — `root.children[0].children[0]`; proto=2; params=0; instructions=5; children=0; constants=1; offset 5686..5759; create-PC=16; UP=2; status=完整静态恢复（未运行时验证）
  - **GetStorageItemData** — `root.children[1]`; proto=3; params=0; instructions=77; children=0; constants=16; offset 5760..6712; create-PC=71; UP=1; parent T regs=[4]; status=完整静态恢复（未运行时验证）
  - **GetWritablePath** — `root.children[2]`; proto=4; params=1; instructions=10; children=0; constants=4; offset 6712..6872; create-PC=297; UP=0; parent T regs=[]; status=完整静态恢复（未运行时验证）
  - **MoveTo** — `root.children[3]`; proto=5; params=3; instructions=51; children=0; constants=20; offset 6872..7583; create-PC=62; UP=0; parent T regs=[]; status=完整静态恢复（未运行时验证）
  - **GetDroppedItems** — `root.children[4]`; proto=6; params=0; instructions=8; children=0; constants=3; offset 7583..7734; create-PC=60; UP=0; parent T regs=[]; status=完整静态恢复（未运行时验证）
  - **TakeItems** — `root.children[5]`; proto=7; params=0; instructions=99; children=0; constants=23; offset 7734..8941; create-PC=79; UP=2; parent T regs=[2, 5]; status=完整静态恢复（未运行时验证）
  - **InstallDamageHook** — `root.children[6]`; proto=8; params=0; instructions=40; children=1; constants=9; offset 8941..9715; create-PC=360; UP=2; parent T regs=[0, 4]; status=完整静态恢复（未运行时验证）
    - **Nested_onDamageMsg** — `root.children[6].children[0]`; proto=9; params=2; instructions=18; children=0; constants=4; offset 9491..9714; create-PC=29; UP=2; status=完整静态恢复（未运行时验证）
  - **GetOwnerIDText** — `root.children[7]`; proto=10; params=2; instructions=31; children=0; constants=7; offset 9715..10070; create-PC=191; UP=0; parent T regs=[]; status=完整静态恢复（未运行时验证）
  - **FormatStateChange** — `root.children[8]`; proto=11; params=1; instructions=10; children=0; constants=3; offset 10070..10222; create-PC=181; UP=2; parent T regs=[4, 14]; status=完整静态恢复（未运行时验证）
  - **ReadNumericConfig** — `root.children[9]`; proto=12; params=1; instructions=45; children=0; constants=13; offset 10222..10789; create-PC=298; UP=1; parent T regs=[44]; status=完整静态恢复（未运行时验证）
  - **SetButtonVisibilityState** — `root.children[10]`; proto=13; params=0; instructions=15; children=0; constants=5; offset 10789..10985; create-PC=266; UP=2; parent T regs=[0, 1]; status=完整静态恢复（未运行时验证）
  - **DistanceCalculation** — `root.children[11]`; proto=14; params=2; instructions=25; children=0; constants=6; offset 10985..11269; create-PC=189; UP=0; parent T regs=[]; status=完整静态恢复（未运行时验证）
  - **LuaSendMsg** — `root.children[12]`; proto=15; params=0; instructions=92; children=0; constants=34; offset 11269..12464; create-PC=48; UP=2; parent T regs=[0, 4]; status=完整静态恢复（未运行时验证）
  - **GetMapId** — `root.children[13]`; proto=16; params=0; instructions=9; children=0; constants=4; offset 12464..12602; create-PC=54; UP=0; parent T regs=[]; status=完整静态恢复（未运行时验证）
  - **FindMonsterInCurrViewField** — `root.children[14]`; proto=17; params=0; instructions=27; children=0; constants=4; offset 12602..12917; create-PC=210; UP=1; parent T regs=[30]; status=完整静态恢复（未运行时验证）
  - **ClearBlacklistItems** — `root.children[15]`; proto=18; params=0; instructions=63; children=1; constants=17; offset 12917..13975; create-PC=383; UP=4; parent T regs=[54, 4, 5, 41]; status=完整静态恢复（未运行时验证）
    - **Nested_SL** — `root.children[15].children[0]`; proto=19; params=0; instructions=13; children=0; constants=4; offset 13793..13974; create-PC=51; UP=2; status=完整静态恢复（未运行时验证）
  - **PrintLog** — `root.children[16]`; proto=20; params=1; instructions=38; children=0; constants=13; offset 13975..14463; create-PC=43; UP=0; parent T regs=[]; status=完整静态恢复（未运行时验证）
  - **PCallHelper** — `root.children[17]`; proto=21; params=2; instructions=14; children=1; constants=2; offset 14463..14825; create-PC=300; UP=1; parent T regs=[44]; status=完整静态恢复（未运行时验证）
    - **Nested_tostring** — `root.children[17].children[0]`; proto=22; params=0; instructions=14; children=0; constants=5; offset 14613..14824; create-PC=1; UP=3; status=完整静态恢复（未运行时验证）
  - **GetPlayerPosition** — `root.children[18]`; proto=23; params=0; instructions=19; children=0; constants=7; offset 14825..15066; create-PC=187; UP=0; parent T regs=[]; status=完整静态恢复（未运行时验证）
  - **InitGatherMonsters** — `root.children[19]`; proto=24; params=0; instructions=36; children=1; constants=11; offset 15066..15618; create-PC=238; UP=7; parent T regs=[3, 18, 23, 13, 35, 8, 4]; status=完整静态恢复（未运行时验证）
    - **Nested_MainLoop** — `root.children[19].children[0]`; proto=25; params=0; instructions=3; children=0; constants=1; offset 15564..15617; create-PC=22; UP=0; status=完整静态恢复（未运行时验证）
  - **ShowLocalNoticeByType** — `root.children[20]`; proto=26; params=1; instructions=15; children=0; constants=14; offset 15618..15907; create-PC=46; UP=1; parent T regs=[0]; status=完整静态恢复（未运行时验证）
  - **PickUpItems** — `root.children[21]`; proto=27; params=0; instructions=172; children=2; constants=34; offset 15907..18157; create-PC=83; UP=1; parent T regs=[5]; status=完整静态恢复（未运行时验证）
    - **Nested_dist** — `root.children[21].children[0]`; proto=28; params=2; instructions=19; children=0; constants=2; offset 17860..18062; create-PC=103; UP=0; status=完整静态恢复（未运行时验证）
    - **Nested_dist_2** — `root.children[21].children[1]`; proto=29; params=2; instructions=8; children=0; constants=1; offset 18062..18156; create-PC=112; UP=0; status=完整静态恢复（未运行时验证）
  - **GetMapData2DPtr** — `root.children[22]`; proto=30; params=5; instructions=144; children=0; constants=15; offset 18157..19639; create-PC=350; UP=1; parent T regs=[52]; status=完整静态恢复（未运行时验证）
  - **Builtsetting** — `root.children[23]`; proto=31; params=0; instructions=55; children=0; constants=15; offset 19639..20373; create-PC=256; UP=1; parent T regs=[5]; status=完整静态恢复（未运行时验证）
  - **UseItemByIndex** — `root.children[24]`; proto=32; params=0; instructions=33; children=0; constants=8; offset 20373..20797; create-PC=355; UP=1; parent T regs=[37]; status=完整静态恢复（未运行时验证）
  - **DeathAutoBlacklist** — `root.children[25]`; proto=33; params=0; instructions=47; children=1; constants=15; offset 20797..21597; create-PC=363; UP=4; parent T regs=[41, 4, 55, 5]; status=完整静态恢复（未运行时验证）
    - **Nested_RequestAddBlacklistByName** — `root.children[25].children[0]`; proto=34; params=0; instructions=6; children=0; constants=3; offset 21483..21596; create-PC=41; UP=1; status=完整静态恢复（未运行时验证）
  - **ResetGatherMonsterData** — `root.children[26]`; proto=35; params=0; instructions=20; children=0; constants=3; offset 21597..21824; create-PC=200; UP=9; parent T regs=[15, 16, 17, 25, 19, 20, 21, 22, 4]; status=完整静态恢复（未运行时验证）
  - **StopGatherMonsters** — `root.children[27]`; proto=36; params=0; instructions=25; children=0; constants=6; offset 21824..22136; create-PC=247; UP=7; parent T regs=[18, 3, 25, 23, 13, 35, 4]; status=完整静态恢复（未运行时验证）
  - **FindMonsterCandidates** — `root.children[28]`; proto=37; params=0; instructions=102; children=1; constants=19; offset 22136..23414; create-PC=194; UP=5; parent T regs=[27, 30, 28, 29, 8]; status=完整静态恢复（未运行时验证）
    - **Nested_distance** — `root.children[28].children[0]`; proto=38; params=2; instructions=8; children=0; constants=1; offset 23314..23413; create-PC=81; UP=0; status=完整静态恢复（未运行时验证）
  - **IsDie** — `root.children[29]`; proto=39; params=1; instructions=7; children=0; constants=1; offset 23414..23500; create-PC=190; UP=0; parent T regs=[]; status=完整静态恢复（未运行时验证）
  - **GetMapName** — `root.children[30]`; proto=40; params=0; instructions=9; children=0; constants=4; offset 23500..23636; create-PC=56; UP=0; parent T regs=[]; status=完整静态恢复（未运行时验证）
  - **IsInWhitelistMap** — `root.children[31]`; proto=41; params=0; instructions=28; children=0; constants=6; offset 23636..23977; create-PC=212; UP=0; parent T regs=[]; status=完整静态恢复（未运行时验证）
  - **AnonymousHelper_32** — `root.children[32]`; proto=42; params=1; instructions=6; children=0; constants=0; offset 23977..24044; create-PC=307; UP=2; parent T regs=[46, 42]; status=完整静态恢复（未运行时验证）
  - **AnonymousHelper_33** — `root.children[33]`; proto=43; params=0; instructions=5; children=0; constants=0; offset 24044..24102; create-PC=310; UP=2; parent T regs=[45, 43]; status=完整静态恢复（未运行时验证）
  - **Schedule** — `root.children[34]`; proto=44; params=2; instructions=7; children=0; constants=2; offset 24102..24198; create-PC=53; UP=0; parent T regs=[]; status=完整静态恢复（未运行时验证）
  - **SetTargetID** — `root.children[35]`; proto=45; params=1; instructions=26; children=0; constants=8; offset 24198..24573; create-PC=184; UP=0; parent T regs=[]; status=完整静态恢复（未运行时验证）
  - **GetAvailableStoragePage** — `root.children[36]`; proto=46; params=0; instructions=51; children=0; constants=12; offset 24573..25251; create-PC=68; UP=1; parent T regs=[4]; status=完整静态恢复（检查点190逐PC闭合；未运行时验证）
  - **DestroyUI** — `root.children[37]`; proto=47; params=0; instructions=31; children=0; constants=11; offset 25251..25655; create-PC=261; UP=3; parent T regs=[0, 3, 1]; status=完整静态恢复（未运行时验证）
  - **GetOwnerID** — `root.children[38]`; proto=48; params=2; instructions=31; children=0; constants=7; offset 25655..26010; create-PC=192; UP=0; parent T regs=[]; status=完整静态恢复（未运行时验证）
  - **GetMainPlayerID** — `root.children[39]`; proto=49; params=0; instructions=6; children=0; constants=3; offset 26010..26133; create-PC=186; UP=0; parent T regs=[]; status=完整静态恢复（未运行时验证）
  - **ShowHideAllButtons** — `root.children[40]`; proto=50; params=0; instructions=47; children=0; constants=9; offset 26133..26669; create-PC=270; UP=3; parent T regs=[3, 1, 0]; status=完整静态恢复（未运行时验证）
  - **MoveItemToQuickUse** — `root.children[41]`; proto=51; params=2; instructions=133; children=0; constants=26; offset 26669..28367; create-PC=259; UP=0; parent T regs=[]; status=完整静态恢复（未运行时验证）
  - **doInit_UI** — `root.children[42]`; proto=52; params=0; instructions=419; children=23; constants=105; offset 28367..52718; create-PC=390; UP=20; parent T regs=[4, 2, 3, 0, 1, 41, 48, 7, 8, 50, 49, 5, 44, 42, 51, 43, 47, 11, 12, 9]; status=完整静态恢复（父函数及23个子原型；未运行时验证）
    - **Nested_find** — `root.children[42].children[0]`; proto=53; params=1; instructions=46; children=0; constants=12; offset 33721..34285; create-PC=17; UP=0; status=完整静态恢复（未运行时验证）
    - **Nested_SL_2** — `root.children[42].children[1]`; proto=54; params=0; instructions=33; children=1; constants=8; offset 34285..34964; create-PC=288; UP=5; status=完整静态恢复（未运行时验证）
      - **Nested_LuaSendMsg** — `root.children[42].children[1].children[0]`; proto=55; params=0; instructions=22; children=0; constants=5; offset 34701..34963; create-PC=23; UP=3; status=完整静态恢复（未运行时验证）
    - **Nested_Helper** — `root.children[42].children[2]`; proto=56; params=0; instructions=21; children=0; constants=4; offset 34964..35292; create-PC=276; UP=4; status=完整静态恢复（未运行时验证）
    - **Nested_FFFF00** — `root.children[42].children[3]`; proto=57; params=0; instructions=320; children=5; constants=72; offset 35292..43248; create-PC=329; UP=4; status=完整静态恢复（未运行时验证）
      - **Nested_Helper_2** — `root.children[42].children[3].children[0]`; proto=58; params=1; instructions=35; children=0; constants=12; offset 39273..39720; create-PC=117; UP=0; status=完整静态恢复（未运行时验证）
      - **Nested_string** — `root.children[42].children[3].children[1]`; proto=59; params=1; instructions=46; children=0; constants=12; offset 39720..40284; create-PC=291; UP=0; status=完整静态恢复（未运行时验证）
      - **Nested_FFFFFF** — `root.children[42].children[3].children[2]`; proto=60; params=3; instructions=65; children=0; constants=17; offset 40284..41063; create-PC=264; UP=2; status=完整静态恢复（未运行时验证）
      - **Nested_Helper_3** — `root.children[42].children[3].children[3]`; proto=61; params=0; instructions=168; children=0; constants=31; offset 41063..42943; create-PC=299; UP=10; status=完整静态恢复（未运行时验证）
      - **Nested_UnSchedule** — `root.children[42].children[3].children[4]`; proto=62; params=0; instructions=20; children=0; constants=8; offset 42943..43247; create-PC=67; UP=3; status=完整静态恢复（未运行时验证；unknown哨兵宿主语义保留）
    - **Nested_OnGameLeaveWorld** — `root.children[42].children[4]`; proto=63; params=0; instructions=5; children=0; constants=3; offset 43248..43362; create-PC=335; UP=0; status=完整静态恢复（未运行时验证）
    - **Nested_ffffff** — `root.children[42].children[5]`; proto=64; params=2; instructions=41; children=0; constants=10; offset 43362..43876; create-PC=235; UP=2; status=完整静态恢复（未运行时验证）
    - **Nested_StopGatherMonsters** — `root.children[42].children[6]`; proto=65; params=0; instructions=31; children=0; constants=5; offset 43876..44309; create-PC=268; UP=6; status=完整静态恢复（未运行时验证）
    - **Nested_InitGatherMonsters** — `root.children[42].children[7]`; proto=66; params=1; instructions=17; children=0; constants=2; offset 44309..44519; create-PC=244; UP=2; status=完整静态恢复（未运行时验证）
    - **Nested_SL_3** — `root.children[42].children[8]`; proto=67; params=0; instructions=29; children=0; constants=10; offset 44519..44921; create-PC=306; UP=4; status=完整静态恢复（未运行时验证）
    - **Nested_Button_setTitleFontSize** — `root.children[42].children[9]`; proto=68; params=3; instructions=50; children=1; constants=17; offset 44921..46230; create-PC=339; UP=5; status=完整静态恢复（未运行时验证）
      - **Nested_Button_setTitleText** — `root.children[42].children[9].children[0]`; proto=69; params=0; instructions=48; children=0; constants=10; offset 45661..46229; create-PC=44; UP=3; status=完整静态恢复（未运行时验证）
    - **Nested_shiquTimer** — `root.children[42].children[10]`; proto=70; params=0; instructions=25; children=0; constants=8; offset 46230..46577; create-PC=318; UP=3; status=完整静态恢复（未运行时验证）
    - **Nested_Helper_4** — `root.children[42].children[11]`; proto=71; params=0; instructions=12; children=1; constants=1; offset 46577..47268; create-PC=249; UP=8; status=完整静态恢复（未运行时验证）
      - **Nested_Helper_5** — `root.children[42].children[11].children[0]`; proto=72; params=1; instructions=35; children=0; constants=6; offset 46765..47267; create-PC=2; UP=7; status=完整静态恢复（未运行时验证）
    - **Nested_04d_02d_02d** — `root.children[42].children[12]`; proto=73; params=0; instructions=43; children=0; constants=25; offset 47268..47939; create-PC=159; UP=3; status=完整静态恢复（未运行时验证）
    - **Nested_Helper_6** — `root.children[42].children[13]`; proto=74; params=0; instructions=6; children=0; constants=2; offset 47939..48050; create-PC=295; UP=1; status=完整静态恢复（未运行时验证）
    - **Nested_Helper_7** — `root.children[42].children[14]`; proto=75; params=0; instructions=12; children=1; constants=1; offset 48050..48690; create-PC=258; UP=8; status=完整静态恢复（未运行时验证）
      - **Nested_Helper_8** — `root.children[42].children[14].children[0]`; proto=76; params=1; instructions=34; children=0; constants=5; offset 48223..48689; create-PC=2; UP=7; status=完整静态恢复（未运行时验证）
    - **Nested_Helper_9** — `root.children[42].children[15]`; proto=77; params=0; instructions=30; children=0; constants=10; offset 48690..49103; create-PC=414; UP=2; status=完整静态恢复（未运行时验证）
    - **Nested_ITEM_INDEX_BY_NAME** — `root.children[42].children[16]`; proto=78; params=0; instructions=26; children=0; constants=7; offset 49103..49450; create-PC=136; UP=2; status=完整静态恢复（未运行时验证）
    - **Nested_blacklistTimer** — `root.children[42].children[17]`; proto=79; params=1; instructions=28; children=0; constants=5; offset 49450..49821; create-PC=238; UP=5; status=完整静态恢复（未运行时验证）
    - **Nested_Helper_10** — `root.children[42].children[18]`; proto=80; params=0; instructions=39; children=0; constants=9; offset 49821..50382; create-PC=298; UP=6; status=完整静态恢复（未运行时验证；六项捕获业务身份已闭合）
    - **Nested_TakeItems** — `root.children[42].children[19]`; proto=81; params=0; instructions=29; children=0; constants=10; offset 50382..50777; create-PC=312; UP=4; status=完整静态恢复（未运行时验证）
    - **Nested_s** — `root.children[42].children[20]`; proto=82; params=0; instructions=21; children=0; constants=4; offset 50777..51117; create-PC=282; UP=4; status=完整静态恢复（未运行时验证）
    - **Nested_dropTimer** — `root.children[42].children[21]`; proto=83; params=0; instructions=29; children=0; constants=10; offset 51117..51511; create-PC=323; UP=4; status=完整静态恢复（未运行时验证）
    - **Nested_Anonymous** — `root.children[42].children[22]`; proto=84; params=2; instructions=8; children=1; constants=0; offset 51511..52717; create-PC=247; UP=1; status=完整静态恢复（未运行时验证）
      - **Nested_str** — `root.children[42].children[22].children[0]`; proto=85; params=1; instructions=27; children=1; constants=13; offset 51595..52716; create-PC=0; UP=4; status=完整静态恢复（未运行时验证）
        - **Nested_match** — `root.children[42].children[22].children[0].children[0]`; proto=86; params=2; instructions=50; children=1; constants=14; offset 51994..52715; create-PC=16; UP=4; status=完整静态恢复（未运行时验证）
          - **Nested_Helper_11** — `root.children[42].children[22].children[0].children[0].children[0]`; proto=87; params=0; instructions=4; children=0; constants=1; offset 52624..52714; create-PC=41; UP=1; status=完整静态恢复（未运行时验证）
  - **GetOwnerDescription** — `root.children[43]`; proto=88; params=2; instructions=20; children=0; constants=7; offset 52718..52983; create-PC=193; UP=0; parent T regs=[]; status=完整静态恢复（未运行时验证）
  - **GetPlayerMapPosition** — `root.children[44]`; proto=89; params=1; instructions=17; children=0; constants=5; offset 52983..53198; create-PC=188; UP=0; parent T regs=[]; status=完整静态恢复（未运行时验证）
  - **MainLoop** — `root.children[45]`; proto=90; params=0; instructions=417; children=0; constants=41; offset 53198..58148; create-PC=214; UP=22; parent T regs=[18, 14, 13, 4, 23, 35, 26, 34, 15, 32, 17, 16, 19, 20, 22, 36, 21, 31, 30, 33, 24, 8]; status=完整静态恢复（未运行时验证）
  - **DiuItems** — `root.children[46]`; proto=91; params=0; instructions=169; children=1; constants=64; offset 58148..60736; create-PC=64; UP=2; parent T regs=[2, 5]; status=完整静态恢复（未运行时验证）
    - **Nested_string_2** — `root.children[46].children[0]`; proto=92; params=1; instructions=20; children=0; constants=4; offset 60502..60735; create-PC=66; UP=1; status=完整静态恢复（未运行时验证）
  - **BlacklistPlayerDetection** — `root.children[47]`; proto=93; params=0; instructions=216; children=0; constants=35; offset 60736..63329; create-PC=368; UP=13; parent T regs=[2, 57, 41, 58, 55, 53, 38, 4, 56, 39, 5, 40, 37]; status=完整静态恢复（未运行时验证）
  - **PCallHelper_2** — `root.children[48]`; proto=94; params=0; instructions=10; children=1; constants=1; offset 63329..63607; create-PC=352; UP=0; parent T regs=[]; status=完整静态恢复（未运行时验证）
    - **Nested_FriendProxy** — `root.children[48].children[0]`; proto=95; params=0; instructions=9; children=0; constants=5; offset 63441..63606; create-PC=1; UP=0; status=完整静态恢复（未运行时验证）
  - **AnonymousHelper_49** — `root.children[49]`; proto=96; params=0; instructions=5; children=0; constants=0; offset 63607..63665; create-PC=304; UP=2; parent T regs=[45, 42]; status=完整静态恢复（未运行时验证）
  - **StorageItems** — `root.children[50]`; proto=97; params=0; instructions=224; children=2; constants=57; offset 63665..67464; create-PC=74; UP=3; parent T regs=[2, 4, 5]; status=完整静态恢复（未运行时验证）
    - **Nested_isOutputted** — `root.children[50].children[0]`; proto=98; params=2; instructions=52; children=0; constants=15; offset 66540..67198; create-PC=101; UP=2; status=完整静态恢复（未运行时验证；上层捕获业务原名未知）
    - **Nested_Anonymous_2** — `root.children[50].children[1]`; proto=99; params=0; instructions=27; children=0; constants=1; offset 67198..67463; create-PC=53; UP=4; status=完整静态恢复（未运行时验证）
  - **FindBlacklistPlayer** — `root.children[51]`; proto=100; params=1; instructions=35; children=0; constants=5; offset 67464..67864; create-PC=353; UP=1; parent T regs=[54]; status=完整静态恢复（未运行时验证）
  - **onDamageMsg** — `root.children[52]`; proto=101; params=2; instructions=72; children=1; constants=19; offset 67864..68844; create-PC=357; UP=1; parent T regs=[41]; status=完整静态恢复（未运行时验证）
    - **Nested_JsonDecode** — `root.children[52].children[0]`; proto=102; params=0; instructions=6; children=0; constants=2; offset 68754..68843; create-PC=6; UP=1; status=完整静态恢复（未运行时验证）
  - **ScheduleOnce** — `root.children[53]`; proto=103; params=2; instructions=7; children=0; constants=2; offset 68844..68944; create-PC=52; UP=0; parent T regs=[]; status=完整静态恢复（未运行时验证）
  - **AnonymousHelper_54** — `root.children[54]`; proto=104; params=1; instructions=6; children=0; constants=0; offset 68944..69011; create-PC=313; UP=2; parent T regs=[46, 43]; status=完整静态恢复（未运行时验证）
  - **AccountIDValidation** — `root.children[55]`; proto=105; params=0; instructions=64; children=2; constants=21; offset 69011..70728; create-PC=276; UP=2; parent T regs=[4, 5]; status=完整静态恢复（未运行时验证）
    - **Nested_Panel_mini_chat** — `root.children[55].children[0]`; proto=106; params=0; instructions=24; children=0; constants=8; offset 69950..70337; create-PC=57; UP=2; status=完整静态恢复（未运行时验证）
    - **Nested_ID** — `root.children[55].children[1]`; proto=107; params=1; instructions=27; children=0; constants=4; offset 70337..70727; create-PC=37; UP=3; status=完整静态恢复（未运行时验证）
  - **ClearTargetID_2** — `root.children[56]`; proto=108; params=0; instructions=22; children=0; constants=9; offset 70728..71076; create-PC=185; UP=0; parent T regs=[]; status=完整静态恢复（未运行时验证）
  - **PlayerPos** — `root.children[57]`; proto=109; params=0; instructions=10; children=0; constants=4; offset 71076..71215; create-PC=58; UP=0; parent T regs=[]; status=完整静态恢复（未运行时验证）

## 5. 函数调用关系与闭包父子关系的区分

本文件中的缩进只表示VM原型的父子嵌套关系，不等同于普通函数调用图。父函数创建子闭包并不证明父函数在业务执行路径上调用了该子函数。

调用边只有在函数体反汇编、候选源码或独立调用点审计中明确出现时才应记录。当前可由机器状态确认的关键调用/捕获关系包括：

- `root.children[45]` MainLoop：22个upvalue按父root T寄存器序列 `[18,14,13,4,23,35,26,34,15,32,17,16,19,20,22,36,21,31,30,33,24,8]` 捕获。
- `root.children[46]` DiuItems：2个upvalue，分别捕获父root T[2]、T[5]；其子原型 `root.children[46].children[0]` 捕获DiuItems T[5]。
- `root.children[42]` doInit_UI：23个子原型；20项upvalue捕获及根PC390-PC412返回/挂接关系已在检查点268/269核对。
- `root.children[47]` BlacklistPlayerDetection：13项捕获及T[57] live cell关系已在检查点267核对。

## 6. 状态结论与下一步

- **原型结构父子树：** 110/110节点均可从原型总索引还原；根级58个闭包创建点均有对应结构记录。
- **参数数量、指令数、常量数、子原型数、偏移：** 直接来自原型索引。
- **根级父T寄存器捕获：** 58/58闭包创建点有捕获描述；总计135项。
- **嵌套闭包捕获寄存器：** 仅在已有专门映射的原型上列出；其余不从捕获数量推导寄存器编号。
- **调用图：** 尚未形成110个原型的完整逐边调用图；不能将父子嵌套树冒充调用图。
- **源码恢复：** 110/110原型均已在唯一交付文件中形成可读普通Lua功能等价源码：109个子原型主体已恢复，root模块PC1-PC412已整合为同一chunk中的初始化、闭包创建、字段挂接、ENV导出与最终return。14个嵌套原型以父函数内匿名/局部闭包实现；不要求其必须以原型标签作为Lua变量名。此状态代表完整静态恢复，不代表作者原始源码逐字恢复，也不代表运行时验证通过。
- **运行时：** 0个函数通过运行时验证；当前没有Lua/luac编译成功的证据。

下一步按检查点353进行唯一交付文件最终静态收尾：检查根模块函数引用/局部作用域、Lua 5.1兼容性、重复定义/导出和过期审计注释；不再把root模块描述为未完成分段适配稿。

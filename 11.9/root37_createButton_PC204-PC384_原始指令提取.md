# 11.9 新版 root/37（原型48 createButton）原始指令提取记录

日期：2026-11-17  
原始文件：`11.9/MainLeftBottom_11.9.lua`  
原始文件 Blob SHA：`e9d3afa16bbc0e306ce764ecb749954a304c4715`

## 解码与解析方法确认

- 从原始加载器 `S("...")` 提取载荷，Base36/LZW 解码后得到 79,573 字节。
- 按加载器读取器对每个字节 XOR `0x4A`，与结构文档记录长度一致。
- 直接按原始加载器的 `M()` 递归解析常量表、子原型、参数数和指令流；完整消费 79,573 字节，无剩余。
- 根原型：455条指令、54个直接子原型。
- `root.children[37]`：433条指令、26个子原型、111项常量；即原型48/createButton。
- 下列PC编号为1-based指令序号。指令数组按原始结构记为 `[opcode, A, B, C]`；常量操作数已替换为对应常量值。这里记录的是原始字段，不把尚未逐项映射的opcode语义伪装成Lua源码。

## PC204-PC250：三组按钮配置字段

第一组V12（6项）：

| PC | 表项寄存器 | key | name | toggle |
|---:|---:|---|---|---|
| 206-207 | R13 | moneybut | V10001 | — |
| 209-210 | R14 | settingbut | 内挂设置 | — |
| 212-214 | R15 | shiqubut | 开拾取 | 关拾取 |
| 216-218 | R16 | diuqibut | 开丢弃 | 关丢弃 |
| 220-221 | R17 | clearblacklistbut | 清黑名单 | — |
| 223-224 | R18 | stopallbut | 停止脚本 | — |

第二组V13（7项）：

| PC | 表项寄存器 | key | name | toggle |
|---:|---:|---|---|---|
| 228-229 | R14 | buygoldbut | 购买金条 | — |
| 231-232 | R15 | recyclebut | 回收装备 | — |
| 234-235 | R16 | newzone | 开新区 | — |
| 237-239 | R17 | rewardbut | 开奖励 | 关奖励 |
| 241-243 | R18 | yinguaibut | 开拉怪 | 关拉怪 |
| 245-247 | R19 | blacklistbut | 开黑名单 | 关黑名单 |
| 249-250 | R20 | xiaotuibut | 快速小退 | — |

第三组V14为空表。PC251-PC252完成分组表收尾。由此新版createButton的实际按钮配置为6/7/0共13项；与旧root/43的4/3/3十项分组不同。

## PC253-PC271：callbackMap及新区回调登记关键片段

原始指令字段：

```text
253 [177,15,9,4]
254 [57,0,12,0]
255 [57,0,13,0]
256 [57,0,14,0]
257 [374,0,4,0]
258 [177,16,6,5]
259 [374,0,5,0]
260 [374,0,3,0]
261 [374,0,6,0]
262 [374,0,7,0]
263 [374,0,0,0]
264 [177,17,25,1]
265 [374,0,8,0]
266 [47,18,0,15]
267 [177,19,12,0]
268 [240,18,"settingbut",19]
269 [177,19,2,1]
270 [374,0,9,0]
271 [156,18,"newzone",19]
```

可直接确认：
- PC269创建子原型2的单捕获包装闭包。
- PC270把createButton的UP[9]作为唯一捕获值传给该闭包。
- PC271以字符串key `newzone` 将该闭包写入callbackMap（目标表寄存器R18，闭包寄存器R19）。
- 因而新区处理器实例必须由createButton的第10个upvalue提供；不能用旧root/43 callbackMap代替。

## PC340-PC384：按钮工厂与三组遍历原始字段

PC340创建子原型17工厂闭包，捕获数5；PC341-PC345按序传入父函数寄存器R6、R19、R20、R4、R18。

PC346-PC384三组遍历原始指令（保留原始字段）：

```text
346 [127,22,"ipairs",null]
347 [23,23,12,0]
348 [87,22,23,24]
349 [38,0,356,null]
350 [313,27,21,0]
351 [23,28,26,0]
352 [74,29,12,0]
353 [321,29,29,25]
354 [222,29,29,1]
355 [399,30,40,null]
356 [91,27,30,0]
357 [411,22,2,0]
358 [51,0,349,null]
359 [50,22,"ipairs",null]
360 [95,23,13,0]
361 [118,22,23,24]
362 [85,0,369,null]
363 [313,27,21,0]
364 [95,28,26,0]
365 [159,29,13,0]
366 [321,29,29,25]
367 [341,29,29,1]
368 [263,30,0,null]
369 [91,27,30,0]
370 [411,22,2,0]
371 [38,0,362,null]
372 [50,22,"ipairs",null]
373 [23,23,14,0]
374 [39,22,23,24]
375 [38,0,382,null]
376 [313,27,21,0]
377 [23,28,26,0]
378 [74,29,14,0]
379 [321,29,29,25]
380 [222,29,29,1]
381 [399,30,80,null]
382 [91,27,30,0]
383 [411,22,2,0]
384 [125,0,375,null]
```

这三段循环分别读取V12、V13、V14（PC347、360、373）；循环中使用的偏移立即数分别为40、0、80（PC355、368、381）。具体opcode到Lua语句的完整语义映射仍需逐项对照加载器分派器，不能仅凭字段值写成未经验证的工厂源码。

## 根函数创建点与新区处理器闭包捕获

根函数相关原始指令：

```text
430 [177,54,38,5]
431 [57,0,4,0]
432 [57,0,2,0]
433 [57,0,3,0]
434 [57,0,7,0]
435 [57,0,53,0]
438 [177,57,37,15]
439 [57,0,4,0]
440 [57,0,2,0]
441 [57,0,0,0]
442 [57,0,3,0]
443 [57,0,1,0]
444 [57,0,44,0]
445 [57,0,7,0]
```

- 根PC430创建子原型38（新区处理器），捕获数5，捕获寄存器依次为R4、R2、R3、R7、R53，闭包结果写入R54。
- 根PC438创建子原型37（createButton），捕获数15；其捕获序列从PC439开始，后续继续按VM指令读取。
- createButton的第10个捕获值来自根寄存器R54，因此与PC430创建的新区处理器是同一闭包实例。
- 原型83/84/93的既有业务身份记录与上述原始闭包创建点相互吻合。

## 当前边界

- 已从当前原始11.9文件本身重新提取root/37的真实指令流，不再依赖旧phase3 root/43反汇编。
- 13项按钮配置及key/name/toggle字段已直接恢复；新区callbackMap登记点PC269-PC271已确认；ButtonFactory五个捕获源寄存器及三段遍历偏移已提取。
- 尚未将这些原始指令完整翻译为可执行Lua，也尚未把新版createButton接入唯一明文文件的正确初始化路径。
- 本记录不代表Lua编译、APK打包或游戏运行验证通过。


## 后续：PC253-PC271 opcode语义与两个关键子闭包

继续直接对照当前原始加载器 `I()` 的opcode分派器，确认本轮接线关键指令语义：

- opcode 177：从当前函数的子原型表取出指定子原型，按后续upvalue描述创建闭包，并写入目标寄存器。
- opcode 374：读取当前闭包upvalue到目标寄存器（`V[A] = upvalue[B]`）。
- opcode 57：寄存器间移动（`V[A] = V[B]`）。
- opcode 156：以常量字符串作为键、寄存器值作为值写入表（`V[A][constantKey] = V[B]`）。因此PC271可直接翻译为`callbackMap["newzone"] = newzoneWrapper`，不是普通寄存器键赋值。
- opcode 279：按指令参数数量调用目标寄存器中的函数。
- opcode 269：return。
- 上述语义来自当前11.9原始加载器分派器，不是旧版opcode表类推。

### child2：新区callbackMap包装闭包

`root.children[37].children[2]`：0参数、5条指令、无子原型、无常量；PC269创建时捕获数1，捕获对象为createButton UP[9]，即根PC430创建的新区处理器闭包。

原始指令：
```text
1 [17,0,0,0]
2 [279,0,0,0]
3 [412,0,1,0]
4 [30,0,0,0]
5 [269,0,0,0]
```

该闭包只捕获新区处理器一个对象，主体执行一次调用并返回；其用途是把新区处理器包装成按钮callbackMap所需的零参数点击回调。剩余opcode组合（17、412、30）的逐条表达式仍以加载器分派器为准，当前不臆造参数或返回值细节。

### child17：按钮创建工厂的toggle点击回调

`root.children[37].children[17]`：3参数、50条指令、1个子原型。常量表包含`Button_Create`、`GUI`、`addOnClickEvent`、`Button_setTitleText`、`Button_setTitleColor`、`toggle`、`toggled`、按钮名称和字体资源。

- PC1-PC12开始创建GUI按钮、读取配置key并设置初始标题/图标资源。
- PC15-PC37根据配置name、字体和颜色设置按钮属性。
- PC38-PC49检查配置是否有`toggle`字段；存在时创建子原型0作为点击处理器，并将其绑定到`addOnClickEvent`。
- PC45创建的子原型0有48条指令、0参数、3个捕获值。它的常量表包含`toggled`、`toggle`、`name`、`Button_setTitleText`、`Button_setTitleColor`、`#ff0000`、`#ffffff`。因此该闭包承担toggle按钮点击后的状态、标题和颜色切换；具体共享状态写入和UI调用次序仍以其48条指令为准。
- 本次只恢复到闭包职责和常量/捕获结构，没有把按钮工厂伪写成完整Lua。

## 接线结论更新

现在已经有足够的原始证据把PC269-PC271精确翻译为：创建单捕获零参数包装闭包（捕获新区处理器）并登记到`callbackMap["newzone"]`。尚需完整恢复PC253-PC268周边callbackMap其他回调构造，以及child17按钮工厂的全部50条指令，之后再写入唯一明文Lua并接入正确初始化路径。


## 后续：PC253-PC271 callbackMap 构造语义（2026-11-17继续）

本轮直接读取当前11.9原始加载器 I() 的实际opcode分派器，不使用旧版opcode表。对PC253-PC271得到以下进一步结论：

- PC253 [177,15,9,4]：创建 root.children[37].children[9] 闭包，捕获4项；其后的PC254-PC257是闭包捕获描述序列，不应误读成普通业务赋值。
  - 捕获顺序：父函数R12、R13、R14、当前createButton闭包UP[4]。
- PC258 [177,16,6,5]：创建child6闭包，捕获5项；PC259-PC263依次捕获当前闭包UP[5]、UP[3]、UP[6]、UP[7]、UP[0]。
- PC264 [177,17,25,1]：创建child25闭包，捕获1项；PC265捕获当前闭包UP[8]。
- PC266 [47,18,0,15]：opcode47在当前加载器分派器中明确执行 V[A] = {}，因此R18是新建的callbackMap空表。
- PC267 [177,19,12,0]：创建child12闭包，捕获0项。
- PC268 [240,18,settingbut,19]：opcode240在当前加载器分派器中明确执行 V[A][B] = V[C]（常量键写表），因此 callbackMap[settingbut] = child12闭包。
- PC269-PC271继续已确认的新区链：创建child2单捕获闭包，捕获UP[9]（根PC430创建的新区处理器实例），再写入 callbackMap[newzone]。

因此本轮把此前PC253-PC268其他callback构造尚未理解的范围缩小为：三只捕获闭包（child9/child6/child25）及一只零捕获闭包（child12）已确认创建方式与捕获源；callbackMap创建点及settingbut、新区两项登记方式已确认。其他闭包的具体按钮key/用途仍需依据child原型常量和调用点确认，不能仅按子原型编号猜名称。

本轮尚未修改唯一明文Lua；尚未把13项按钮配置、callbackMap全部回调和工厂遍历接入新版初始化入口。未编译、未打包、未运行游戏。

## 2026-11-17续：修正嵌套原型解析器并完整导出child17/child0指令

### 解析器边界错误已修正，完整性校验通过

本轮重新逐字对照原始加载器的读取函数与M()：
- K()读取4字节并按小端组合：d*16777216+c*65536+b*256+a。
- F()读取2字节并按大端组合：second*256+first。这与K()不同，是上轮解析器偏移错误的重要原因之一。
- I()读取两个K()字组成IEEE-754双精度数，先低32位、后高32位。
- M()字段顺序严格为：常量数量与常量值 → 子原型数量及递归子原型 → 参数数 → 指令数量及指令记录。指令头字节最低位为1时跳过该记录；否则按头字节中的模式位读取操作数，并按常量标志替换常量索引。

校验结果：Base36/LZW载荷解码79,573字节；XOR 0x4A后M()完整消费79,573字节、剩余0；根原型455指令/54子原型；root.children[37]为433指令/26子原型/111常量；其child17为3参数/50指令/1子原型；child17.child0为0参数/48指令/0子原型。全部关键结构约束一致。

### child17（按钮创建工厂）完整50条指令

以下格式为[opcode, A, B, C]，常量操作数已替换为实际常量值；PC为该子原型内1-based序号：

~~~text
1. [387, 3, "GUI", null]
2. [305, 3, 3, "Button_Create"]
3. [158, 5, 0, 0]
4. [73, 6, 0, "key"]
5. [17, 7, 1, 0]
6. [3, 8, 85, 1]
7. [202, 7, 7, 8]
8. [17, 8, 2, 0]
9. [400, 8, 8, 2]
10. [399, 9, "res/public/fuzhu_btn.png", null]
11. [70, 3, 9, 0]
12. [239, 3, 0, 1]
13. [100, 0, 14, null]
14. [152, 0, 0, 0]
15. [158, 4, 3, 0]
16. [73, 5, 0, "key"]
17. [84, 4, 5, 3]
18. [236, 4, "GUI", null]
19. [175, 4, 4, "Button_setTitleText"]
20. [95, 6, 3, 0]
21. [388, 7, 0, "name"]
22. [303, 4, 7, 0]
23. [193, 4, "GUI", null]
24. [175, 4, 4, "Button_setTitleFontSize"]
25. [169, 6, 3, 0]
26. [399, 7, 18, null]
27. [91, 4, 7, 0]
28. [330, 4, "GUI", null]
29. [305, 4, 4, "Button_setTitleFontName"]
30. [169, 6, 3, 0]
31. [399, 7, "res/public/kaiti2.ttf", null]
32. [303, 4, 7, 0]
33. [193, 4, "GUI", null]
34. [305, 4, 4, "Button_setTitleColor"]
35. [169, 6, 3, 0]
36. [399, 7, "#ffffff", null]
37. [303, 4, 7, 0]
38. [73, 4, 0, "toggle"]
39. [165, 4, 0, 0]
40. [100, 0, 41, null]
41. [132, 0, "toggled", false]
42. [330, 4, "GUI", null]
43. [175, 4, 4, "addOnClickEvent"]
44. [23, 6, 3, 0]
45. [177, 7, 0, 3]
46. [374, 0, 4, 0]
47. [57, 0, 0, 0]
48. [57, 0, 3, 0]
49. [279, 4, 7, 0]
50. [269, 0, 0, 0]
~~~

### child17.child0（toggle点击处理器）完整48条指令

~~~text
1. [262, 0, 0, 0]
2. [158, 1, 1, 0]
3. [388, 1, 1, "key"]
4. [379, 0, 0, 1]
5. [398, 1, 1, 0]
6. [165, 0, 0, 0]
7. [85, 0, 10, null]
8. [95, 2, 0, 0]
9. [64, 2, 2, 0]
10. [95, 1, 2, 0]
11. [158, 2, 1, 0]
12. [73, 2, 2, "toggle"]
13. [234, 2, 0, 0]
14. [51, 0, 47, null]
15. [265, 1, 1, false]
16. [51, 0, 47, null]
17. [46, 2, 1, 0]
18. [17, 3, 1, 0]
19. [388, 3, 3, "toggled"]
20. [334, 3, 3, 0]
21. [308, 2, "toggled", 3]
22. [387, 2, "GUI", null]
23. [305, 2, 2, "Button_setTitleText"]
24. [262, 4, 2, 0]
25. [158, 5, 1, 0]
26. [73, 5, 5, "toggled"]
27. [234, 5, 0, 0]
28. [51, 0, 32, null]
29. [158, 5, 1, 0]
30. [73, 5, 5, "toggle"]
31. [239, 5, 0, 1]
32. [125, 0, 34, null]
33. [158, 5, 1, 0]
34. [73, 5, 5, "name"]
35. [91, 2, 5, 0]
36. [387, 2, "GUI", null]
37. [305, 2, 2, "Button_setTitleColor"]
38. [262, 4, 2, 0]
39. [17, 5, 1, 0]
40. [388, 5, 5, "toggled"]
41. [234, 5, 0, 0]
42. [85, 0, 45, null]
43. [263, 5, "#ff0000", null]
44. [239, 5, 0, 1]
45. [38, 0, 46, null]
46. [399, 5, "#ffffff", null]
47. [303, 2, 5, 0]
48. [269, 0, 0, 0]
~~~

### 本轮确认与边界

- 现在已经有child17与child0的完整原始指令流，不再需要重新解码载荷或重新猜嵌套边界。
- child17常量表：["Button_setTitleFontName","Button_Create","res/public/fuzhu_btn.png","key","GUI",18,85,false,"toggle","Button_setTitleColor","toggled","res/public/kaiti2.ttf","addOnClickEvent","#ffffff","Button_setTitleFontSize","name","Button_setTitleText"]
- child0常量表：["toggled","Button_setTitleColor","Button_setTitleText","key","GUI","#ff0000","name","#ffffff",false,"toggle"]
- child17的PC38-PC49读取toggle配置并在存在时创建child0、绑定addOnClickEvent；child0的指令序列中包含toggled状态读写、toggle标题切换、name标题设置及红/白颜色切换相关调用。
- 本轮只完成了原始指令的完整导出和读取格式校验；尚未把48/50条指令逐条翻译为可执行Lua，也未将新版按钮工厂接入唯一明文文件。不得把指令导出记为按钮功能完成。
- 下一步直接基于这两份完整指令流逐条映射分派器语义，先恢复child0状态切换，再恢复child17按钮创建与事件绑定；随后处理PC253-PC268其他callbackMap闭包及root/37初始化调用点。
- 未编译、未打包APK、未运行游戏。
## 2026-11-17续：child0 toggle闭包首段opcode语义映射

本轮从当前11.9加载器I()的D分派树直接映射，不套用旧opcode表。确认以下语义：

- opcode 262：该分支是融合指令，会连续消费当前记录及后续两条记录。其分派器主体依次执行`V[E[2]]=A[E[3]]`、下一条`V[E[2]]=A[E[3]]`、再下一条`V[E[2]]=V[E[3]][E[4]]`。在child0中对应PC1-PC3：先读取upvalue[0]到R0，读取upvalue[1]到R1，再取`R1["key"]`写回R1。此处不是单条普通赋值，不能把PC2/PC3重复当作独立执行入口。
- opcode 379：`V[E[2]]=V[E[3]][V[E[4]]]`，即用寄存器键执行表索引。child0 PC4据此为`R0 = R0[R1]`，读取当前配置key对应的toggle状态。
- opcode 398：`V[E[2]]=E[3]~=0`，并在`E[4]~=0`时跳过下一条指令。child0 PC5的立即数为1且跳过标志为0，因此为`R1 = true`，不跳过下一条。
- opcode 263：`V[E[2]]=E[3]`，即把立即数写入目标寄存器（在child17/child0之外的相关路径也需按该分派器语义使用）。

### child0前5条的可确认表达式

~~~lua
R0 = upvalue[0]
R1 = upvalue[1]
R1 = R1["key"]
R0 = R0[R1]
R1 = true
~~~

说明：前3行由opcode262融合分支一次性执行，PC4/PC5分别对应后续记录。寄存器/Upvalue的零基索引按VM记录保留；转写为Lua时应映射到真实捕获变量名，不应直接将R0/R1作为最终业务变量名。

### 尚未确认

- child0 PC6之后的状态条件、跳转方向、共享状态写回及GUI调用还没有全部逐条映射；尤其不能只根据`toggled`/`toggle`常量推断开关方向。
- 本轮没有改唯一明文Lua；只完成分派器语义与child0首段表达式确认。
## 2026-11-17续：child0 PC6-PC18控制流与upvalue读取继续映射

本轮直接核对I()分派器对应D分支，新增确认：

- opcode 165：条件跳过下一条，条件为`(not not V[E[2]]) ~= (E[4] ~= 0)`时令指令游标前进一条。child0 PC6为`R0`真值判断，比较值为false。
- opcode 85：当D=85时走`D>84`分支，执行跳转`K=E[3]`（若目标寄存器索引大于0还会先处理开放upvalue）。child0 PC7的跳转目标操作数为10。
- opcode 95：`V[E[2]]=E[3]`。child0 PC8将立即数0写入R2。
- opcode 64：`V[E[2]]=V[E[2]](H(V,E[2]+1,E[3]))`，是以目标寄存器当前值作为函数调用目标的调用指令。child0 PC9的调用目标为R2。PC8/PC9组合出现了`R2=0`后调用R2的表面矛盾，当前不擅自改写或推断；需结合原始指令头模式字段/寄存器初始化与实际控制流再核实。
- opcode 158：分派器连续消费两条记录，先`V[E[2]]=A[E[3]]`，再`V[E[2]]=V[E[3]][E[4]]`。child0 PC11-PC12合并表达为：`R2=upvalue[1]`，随后`R2=R2["toggle"]`。
- opcode 234：条件跳过下一条，条件为`(not not V[E[2]]) ~= (E[4] ~= 0)`。child0 PC13对R2做真值条件跳过。
- opcode 51：跳转指令；执行`K=E[3]`，并在必要时关闭目标寄存器范围内的开放upvalue。child0 PC14、PC16均为跳转目标47。
- opcode 265：条件跳过下一条，条件为`(V[E[3]] == E[4]) ~= (E[2] ~= 0)`。child0 PC15比较R1与false。
- opcode 46：连续消费两条记录，分别执行`V[E[2]]=A[E[3]]`。child0 PC17-PC18分别将upvalue[1]读入R2和R3。

### 当前可直接还原的局部表达式（仍非完整业务函数）

~~~lua
-- PC11-PC12（融合指令）
local toggleConfig = upvalue1
local toggleText = toggleConfig["toggle"]

-- PC17-PC18（融合指令）
local configForTitle = upvalue1
local configForColor = upvalue1
~~~

### 必须保留的未决点

- PC6-PC10的跳转/调用组合目前出现`PC8写R2=0`后PC9又调用R2的表面矛盾。本轮只记录分派器真实语义，不把它翻译成看似合理的Lua；下一步要回查原始指令头字节的模式位、常量标志和指令记录边界，并检查child0捕获值初始化，确认这是否为操作数解码呈现问题或真实运行路径。
- PC19-PC48涉及toggled字段读写、按钮标题/颜色调用，尚未完成逐条映射。
- 唯一明文Lua未修改；本轮不计为toggle业务代码完成。
## 2026-11-17续：child0 PC19-PC30状态翻转与标题分支映射

本轮继续按当前11.9加载器I()分派器逐条确认，新增映射如下：

- PC19 `[388,3,3,"toggled"]`：opcode388在当前分派树对应`V[E[2]]=V[E[3]][E[4]]`，即`R3 = R3["toggled"]`。
- PC20 `[334,3,3,0]`：opcode334执行`V[E[2]]=not V[E[3]]`，即`R3 = not R3`。结合PC19，这一段明确读取并反转`toggled`布尔状态。
- PC21-PC22 `[308,2,"toggled",3]` + 后继记录：opcode308为融合操作，先执行`V[E[2]][E[3]]=V[E[4]]`，随后消费下一条记录执行`V[E[2]]=F[E[3]]`。因此先把反转后的R3写回配置表`R2["toggled"]`，再把环境全局`GUI`读入R2；PC22记录被融合消费，不可再独立执行。
- PC23 `[305,2,2,"Button_setTitleText"]`：opcode305按`local P=V[E[3]]; V[E[2]+1]=P; V[E[2]]=P[E[4]]`取出GUI的`Button_setTitleText`方法，并保留GUI接收者。
- PC24-PC26 `[262,4,2,0]` + 后两条：opcode262融合三条记录，读取`upvalue[2]`到R4、读取`upvalue[1]`到R5，再取`R5["toggled"]`写回R5。即取得按钮对象和配置当前`toggled`值，后续用于标题分支。
- PC27 `[234,5,0,0]`：按R5真值条件跳过下一条。
- PC28 `[51,0,32,null]`：跳转到PC32。
- PC29-PC30 `[158,5,1,0]` + 后继记录：opcode158融合两条记录，先从`upvalue[1]`取配置表，再按PC30给出的常量键`toggle`取字段。该读取用于另一标题分支。

### 当前可确认的局部业务逻辑（伪代码表达，不是完整闭包）

~~~lua
local config = upvalue1
local toggled = config["toggled"]
toggled = not toggled
config["toggled"] = toggled

-- 随后取GUI.Button_setTitleText方法；
-- 根据按钮配置的toggled状态选择后续标题文本。
~~~

### 边界

- PC21 opcode308会消费PC22记录；PC24 opcode262会消费PC25-PC26；PC29 opcode158会消费PC30。融合消费关系必须保留，不能重复执行被消费记录。
- PC31-PC48仍未全部映射，尤其按钮标题最终参数、`name`字段读取及红/白颜色分支尚待确认。
- 唯一明文Lua未修改，本轮仅增加指令语义映射。

## 2026-11-17续：child0 toggle闭包 PC31-PC48 分支与UI调用映射

本轮继续直接对照当前11.9原始文件内嵌加载器 `I()` 的分派树，不套用旧版opcode表；没有重新解码载荷。

### PC31-PC35：标题更新分支

- PC31 `[239,5,0,1]`：条件跳过，条件为 `(not not R5) ~= true`。此处R5是PC29-PC30从配置读取的 `config["toggle"]`。
- PC32 `[125,0,34]`：无条件跳转到PC34。
- PC33-PC34由opcode158融合消费：先 `R5 = upvalue[1]`，再 `R5 = R5["name"]`。
- PC35 `[91,2,5,0]`：调用R2，实参寄存器范围为R3..R5。PC23已取得 `GUI.Button_setTitleText` 并把GUI接收者保留在R3，PC24-PC26把按钮对象保留在R4，因此该调用可表达为 `GUI.Button_setTitleText(button, config.name)`。

控制流要按原始跳转保留：PC27先依据当前 `toggled` 状态决定是否跳过PC28；若执行PC28则跳到PC32；若进入PC29-PC31，则PC31在 `config.toggle` 为真值时执行PC32跳过name调用，在其为假值时跳过PC32并执行PC33-PC35。这里不把“toggle字段是字符串”当作所有运行时输入必然成立的前提。

### PC36-PC48：标题颜色调用

- PC36-PC37由opcode387融合：读取环境全局 `GUI` 到R2，并取出 `GUI.Button_setTitleColor`，同时把GUI接收者保留在R3。
- PC38-PC40由opcode262融合：R4读取upvalue[2]（按钮对象）；R5读取upvalue[1]并取 `["toggled"]`。
- PC41 `[234,5,0,0]`：按R5的布尔真值进行条件跳过。
- PC42 `[85,0,45]`：跳转PC45。
- PC43 `[263,5,"#ff0000",null]`：R5写入红色字符串。
- PC44 `[239,5,0,1]`：判断R5真值是否与true不同；红色字符串为真值，因此该条件不成立，不跳过PC45。
- PC45 `[38,0,46]`：跳转PC46。
- PC46 `[399,5,"#ffffff",null]`：R5写入白色字符串。
- PC47 `[303,2,5,0]`：调用R2，实参寄存器范围R3..R5，即调用 `GUI.Button_setTitleColor(button, "#ffffff")`。
- PC48 `[269,0,0,0]`：return。

### 必须保留的异常观察

按当前加载器分派器和已导出的原始字段逐条执行，PC43写入的红色值随后会被PC46白色值覆盖；两条控制路径最终都到达PC47，传入的颜色是 `#ffffff`。因此不能擅自把它“修正”为按toggled状态设置红/白，也不能只凭常量表声称红色分支最终生效。此处记录为**字节码控制流呈现的结果**，后续若有必要再核对指令头/运行时寄存器，但当前不改写原始逻辑。

### child0当前恢复边界

- 48条指令的主要状态翻转、标题方法获取、name分支、颜色方法获取及最终调用已映射。
- 已确认的局部行为：先把配置 `toggled` 取反并写回；之后按原始分支条件决定是否调用 `Button_setTitleText(button, config.name)`；最后按字节码实际控制流调用 `Button_setTitleColor(button, "#ffffff")`。
- PC6-PC10的 `R2=0` 后调用R2表面矛盾仍未解决，不能把整个闭包标为完全无歧义的可执行Lua。
- 本轮没有修改唯一明文Lua；child17按钮工厂50条指令仍待逐项映射；没有编译、打包APK或游戏实测。


## 2026-11-17续：child17按钮工厂 PC1-PC11 首段调用链精确映射

本轮从当前原始加载器 I() 的完整分派树定位到 opcode 387、158、17、3、202、400、399、70 的实际叶子分支，并按“融合指令会消费后续记录”的规则映射child17。不是把每条记录都当成独立指令执行。

### 已确认的指令组合

- PC1-PC2：opcode387融合消费PC2。先读取环境全局 GUI 到R3；再从R3取 Button_Create，并把原GUI对象保留在R4作为方法接收者。因此调用目标为 GUI.Button_Create，接收者R4。
- PC3-PC4：opcode158融合消费PC4。PC3先把createButton的upvalue[0]读入R5；PC4再执行 R6 = R0["key"]。这里R0是child17第一个参数（按钮配置）。
- PC5 opcode17：R7 = upvalue[1]。
- PC6 opcode3：R8 = 85 * R1。这是加载器分派器中的真实乘法表达式，不根据常量85猜它的业务含义。
- PC7 opcode202：R7 = R7 - R8。
- PC8 opcode17：R8 = upvalue[2]。
- PC9 opcode400：R8 = R8 + R2。
- PC10 opcode399：R9 = "res/public/fuzhu_btn.png"。
- PC11 opcode70：调用R3，参数范围为R4..R9；即以R4中的GUI接收者调用前面取得的 GUI.Button_Create，并传入R5、R6、R7、R8、R9，调用结果写回R3（按钮对象/后续寄存器用途仍按后续指令继续确认）。

### 当前首段可读结构（寄存器名暂保留）

```lua
local buttonCreate = GUI.Button_Create
local guiReceiver = GUI
local captured0 = upvalue0
local buttonKey = config.key
local coord1 = upvalue1 - 85 * arg2
local coord2 = upvalue2 + arg3
local button = buttonCreate(guiReceiver, captured0, buttonKey, coord1, coord2,
    "res/public/fuzhu_btn.png")
```

注意：上面只表达PC1-PC11的寄存器数据流。三个函数参数的业务名称、upvalue[0..2]的真实变量名，以及坐标参数的屏幕布局含义尚未全部闭合；不能把暂用的arg2/arg3直接定为最终源码变量名。

### 边界与下一步

- 本轮把按钮工厂最关键的 GUI.Button_Create 取得方式和调用参数寄存器顺序推进到可追踪状态。
- PC12-PC50尚未逐条映射；尤其PC12后的分支、按钮标题/字体/颜色setter、toggle闭包捕获值和addOnClickEvent绑定仍待恢复。
- 此次明确区分了“opcode分派树叶子语义”和“业务字段含义”，避免把寄存器数值解释成未经证实的UI坐标/控件参数。
- 唯一明文Lua未修改；未编译、未打包APK、未游戏实测。


## 2026-11-17续：child17 PC12-PC14出现提前返回控制流异常

本轮继续对照child17原始50条指令和当前加载器I()分派树，检查PC12-PC14：

- PC12 `[239,3,0,1]`：opcode239为条件跳过；条件为`(not not R3) ~= true`时跳过下一条。
- PC13 `[100,0,14,null]`：当前加载器对opcode100的分支执行跳转，目标为指令索引14（该指令的E[2]=0，不触发开放upvalue关闭分支）。
- PC14 `[152,0,0,0]`：当前加载器D=152叶子分支为直接return。

按当前1-based指令记录和加载器的K游标语义：若PC12条件成立，则跳过PC13并落到PC14；若条件不成立，则执行PC13跳到索引14，同样落到PC14。因此从PC1顺序执行时，PC14会无条件结束child17，PC15-PC50没有可见的入口路径。

这是与常量表及PC15-PC50所呈现的标题、字体、颜色和addOnClickEvent逻辑明显冲突的控制流异常。当前不能擅自把PC14改解释成普通赋值，也不能直接将PC15-PC50拼成必然执行的Lua。下一步需回查原始字节码指令头、PC编号与K索引的对应、opcode100/152的完整分派上下文，以及是否存在其他入口/跳转路径。此处是本轮新增的关键阻塞点。

### 本轮边界

- 本轮只定位并记录PC12-PC14的控制流矛盾；尚未完成PC15-PC50的可执行路径证明。
- 唯一明文Lua未修改；未编译、未打包APK、未游戏实测。


## 2026-11-17续：child17 PC12-PC14控制流按加载器分派树重新定案

本轮重新沿当前加载器 `I()` 的完整嵌套分派树追踪opcode 239、100、152，纠正此前对opcode100和152的错误解释：

- opcode239（PC12 `[239,3,0,1]`）执行条件跳过：`(not not V[E[2]]) ~= (E[4] ~= 0)` 时才令 `K=K+1`。此处E[2]=R3、E[4]=1；R3为真时不跳过PC13，R3为假时跳过PC13。
- opcode100（PC13 `[100,0,14,null]`）不是跳转指令。加载器对应分支仅在 `E[2]>0` 时关闭相应upvalue；此处E[2]=0，因此PC13不执行有效业务操作，也不会把K设为14。
- opcode152（PC14 `[152,0,0,0]`）在加载器分派树中明确对应直接 `return`。

因此无论R3真假：R3为假时PC12跳过PC13，直接到PC14；R3为真时执行PC13（因A=0无操作），随后到PC14。两条路径均在PC14直接返回，PC15-PC50在该原始指令流的正常入口下不可达。

**边界说明：** 这是按当前加载器I()与当前已解析的child17指令记录得到的静态控制流结论。它与PC15-PC50显然包含按钮标题、字体、颜色、toggle点击事件绑定的代码形成结构性矛盾；不能因此擅自删除PC15-PC50，也不能把这些代码当作可执行路径写入明文Lua。下一步应只针对child17的指令记录索引/序列化头字段和解释器取指索引，查明是否存在显示PC与VM执行PC不一致，或原始指令记录提取/字段解读错位。不要重做整个载荷解码或解析器审计。

本轮唯一明文Lua未修改；未编译、未打包APK、未运行游戏。


## 2026-11-17续：child17原始指令槽位/偏移核验，排除PC编号错位

本轮仅针对已解码载荷中的child17原始指令区做局部核验，不重做整份载荷解码。按加载器M()逐条读取指令头并保留原始槽位号、载荷偏移、头字节和操作数，得到：

- child17的指令数量字段为50；实际指令槽位1至50全部存在，没有任何因指令头最低位为1而跳过的空槽。
- 每条记录均为9字节（1字节头 + 4个2字节字段/操作数编码布局），槽位偏移连续递增9字节。
- PC12 opcode239位于解码/XOR后载荷偏移50458，头字节64。
- PC13 opcode100位于偏移50467，头字节130。
- PC14 opcode152位于偏移50476，头字节128，操作数为[152,0,0,0]。
- PC15紧接偏移50485；因此PC14之后不存在隐藏的指令槽位、未计入的头字节或压缩记录导致的PC编号偏移。

结合加载器解释器I()：PC12是条件跳过；PC13 opcode100在A=0时不做有效操作；PC14 opcode152命中D>151分支并直接return。解释器从K=1开始按Y[K]取指，故无论PC12条件分支如何，正常入口均会在PC14退出。PC15-PC50确实是载荷中存在的尾部指令，但不是当前入口可达的执行路径。

**结论与限制：** 已排除“显示PC与VM取指索引错位”和“头字节跳过槽位造成PC偏移”这两种解释。当前仍不能仅凭静态证据断言这些尾部指令的设计用途；可能是编译/混淆产物中的死代码、残留块，或存在尚未识别的原型/版本关联问题。下一步应沿createButton父函数PC340创建child17及后续调用点，确认实际被调用的原型是否就是root.children[37].children[17]，并核对是否存在其他入口直接从PC15开始执行（当前解释器没有函数入口参数支持任意PC）。

唯一明文Lua未修改；未编译、未打包APK、未游戏实测。


## 2026-11-17续：父函数实际调用child17，PC15-PC50仍不可达

本轮沿createButton父函数PC340-PC384继续核对，目标是确认PC340创建的工厂是否真的被调用，以及调用对象是否就是root.children[37].children[17]。

### 创建与捕获

- PC340 [177,21,17,5] 创建子原型17，写入父函数R21，捕获数5。
- PC341-PC345按序把父函数R6、R19、R20、R4、R18捕获到child17。
- 因此被父函数保存到R21的闭包实例，正是本次完整导出的child17，而非同编号之外的其他原型。

### 三组循环都实际调用同一个闭包

- 第一组循环：PC350的opcode313融合执行R27=R21并消费PC351写入R28=R26；PC352-PC355准备其余调用参数；PC356 [91,27,30,0] 调用R27，实参寄存器范围为R28-R30。
- 第二组循环：PC363的opcode313融合执行R27=R21并消费PC364；PC365-PC368准备调用参数；PC369 [91,27,30,0] 再次调用R27，实参范围仍为R28-R30。
- 第三组循环：PC376的opcode313融合执行R27=R21并消费PC377；PC378-PC381准备调用参数；PC382 [91,27,30,0] 第三次调用R27，实参范围为R28-R30。
- opcode91在当前加载器中的实际语义是V[A](H(V,A+1,B))；因此上述三处不是仅复制闭包或登记引用，而是确实执行闭包调用。
- 三组循环分别围绕父函数V12、V13、V14配置表展开，调用前准备的偏移立即数分别为40、0、80。这里只确认调用链和实参寄存器范围，不把尚未完全命名的坐标/索引寄存器强行翻译成业务变量。

### 与child17入口控制流合并后的结论

1. root.children[37].children[17]身份已确认：PC340创建的就是该原型，三组循环均将这个实例复制到R27并调用。
2. child17从PC1正常进入，PC12为条件跳过，PC13在A=0时不产生有效关闭upvalue操作，PC14 opcode152直接return。
3. 因而每次父函数调用child17，都会执行PC1-PC14并返回；PC15-PC50不会由这三处调用到达。
4. 这已经排除了“父函数实际调用了另一个原型”的解释，也排除了“child17只是创建未调用”的解释。PC15-PC50目前只能定性为载荷中存在、但经已确认正常入口不可达的尾部指令；其设计来源仍不做超出证据的断言。
5. 当前可确认的运行效果仅到GUI.Button_Create(...)调用及随后提前返回。标题、字体、颜色、toggle及addOnClickEvent绑定指令虽然位于尾部，但不能据此宣称它们实际生效。

### 本轮边界与下一步

- 本轮只完成父函数创建/调用链与child17入口控制流的闭合；没有修改唯一明文Lua。
- 下一步应检查root/37中创建的其他子闭包及按钮回调接线，尤其确认callbackMap["newzone"]包装闭包与三组按钮配置之间是否存在可达绑定路径；不要把child17的PC15-PC50直接拼进Lua。
- 未进行Lua编译、APK打包或游戏运行测试。


## 2026-11-17续：newzone回调映射已构建，但绑定指令位于不可达尾部

本轮结合已确认的PC253-PC271、PC340-PC384及child17 PC38-PC50，继续追踪callbackMap["newzone"]的完整数据流，并检查父函数PC385-PC433是否存在第二条事件绑定路径。

### callbackMap数据流

- PC266创建callbackMap空表；PC268登记settingbut回调。
- PC269创建child2零参数包装闭包，PC270捕获createButton的UP[9]（根PC430创建的新区处理器实例），PC271执行callbackMap["newzone"] = child2。
- PC340创建child17时，第5个捕获源为父函数R18；而R18正是PC266创建并在PC271写入newzone回调的callbackMap。因此child17的UP[4]就是这张callbackMap。
- child17 PC45创建child0点击闭包；PC46读取child17 UP[4]（callbackMap），PC47-PC48再捕获当前按钮配置和按钮对象。child0开头的指令随后按config.key读取callbackMap[key]。这确认PC45-PC49原本就是将对应业务回调绑定到按钮点击事件的路径。
- 但PC45-PC49位于child17 PC14直接return之后，正常调用无法执行；因此callbackMap["newzone"]虽已创建并登记，却没有经这条按钮工厂路径绑定到新区按钮。

### 父函数PC385-PC433排查

- PC385-PC433是独立的hidebut隐藏按钮创建/设置/事件绑定尾段：使用GUI.Button_Create创建hidebut，设置“隐 藏”标题、字号和字体，再创建并绑定隐藏按钮自己的child24处理闭包。
- 该段没有再次读取callbackMap，也没有引用newzone键或新区处理器；因此它不是新区按钮回调的备用绑定路径。

### 当前可下的结论

- 已确认的createButton父函数路径中：新区处理器实例已进入callbackMap["newzone"]；child17也确实被三组循环调用；但负责读取callbackMap并执行addOnClickEvent绑定的child17尾部路径不可达。
- 当前不能宣称新版开新区按钮的点击回调已经接通。可以确认的是父函数会调用GUI.Button_Create创建对应按钮对象；其后标题/字体/toggle/点击事件绑定代码因PC14 return而未执行。
- 这一结论只针对当前已解析的root/37函数路径；若要排除模块外部另有绑定，仍需检查root级调用入口及是否有其他原型直接操作该按钮对象。
- 唯一明文Lua未修改；未编译、未打包APK、未运行游戏。


## 2026-11-17续：根函数入口与新区处理器的外层闭包链

本轮继续检查原始根原型PC426-PC455，确认root/37的外层入口及新区处理器的来源：

- 根PC426 [177,53,44,3]创建root.children[44]，捕获源依次为根寄存器R52、R4、R3。该原型有76条指令，常量包含BAG_DATA、MSG_CS_USE_BAG_ITEM、newzoneTimer、Gbtc等，是新区背包物品处理回调。
- 根PC430 [177,54,38,5]创建root.children[38]，捕获源依次为R4、R2、R3、R7、R53；其中R53就是刚在PC426创建的root.children[44]闭包。因此root.children[38]是持有新区物品处理回调的启动处理器。
- 根PC438 [177,57,37,15]创建root.children[37]（createButton），15项捕获中的第10项来自R54，即PC430创建的root.children[38]启动处理器。
- 根PC437取得MainLeftBottom表，根PC454执行MainLeftBottom["doInit"] = createButton闭包。根函数本身没有在PC454后直接调用createButton，而是把它作为doInit入口暴露给外部初始化流程。

### 外层新区链与按钮绑定链合并

root.children[44]物品处理回调 → root.children[38]新区启动处理器 → createButton UP[9] → callbackMap["newzone"]包装闭包 → createButton本地callbackMap → child17 UP[4] → child17 PC45-PC49创建点击闭包并调用GUI.addOnClickEvent。

最后一段仍受child17 PC14直接return阻断。因此目前已确认新区业务处理器、包装闭包和callbackMap登记都存在；root/37通过MainLeftBottom.doInit作为外部入口创建按钮时，也会调用child17；但新区点击事件的已知绑定段不可达。父函数PC385-PC433只另行处理hidebut，不存在callbackMap备用绑定。

**当前结论边界：** 已闭合当前文件中从根原型新区处理器创建到createButton、callbackMap登记、child17调用及点击事件绑定尝试的静态链路。仍不能排除外部宿主或其他独立原型在模块外另行操作按钮，但当前root/37内部没有第二条已证实的newzone绑定路径。唯一明文Lua未修改；未编译、未打包、未游戏实测。


## 2026-11-17续：doInit_UI确实调用MainLeftBottom.doInit

本轮按整体框架索引定位到UI初始化原型：原型ID42是根直接子原型，其子原型ID44为doInit_UI。注意这里的原型ID与root.children数组下标不同：实际路径为root.children[34].children[1]，不是root.children[44]。

### doInit_UI调用点

root.children[34].children[1]：0参数、24条指令，常量包含MainLeftBottom、doInit、SL、UnSchedule、Panel_mini_chat、MainProperty。

- PC1-PC12：检查MainProperty、MainProperty._ui及Panel_mini_chat等UI对象是否就绪；未满足条件时跳到函数尾部。
- PC13-PC16：取得SL.UnSchedule并执行对应清理调用。
- PC17 [402,0,"MainLeftBottom"]取得MainLeftBottom对象；PC18 [73,0,0,"doInit"]读取其doInit字段；PC19 [279,0,0,0]以零参数调用该函数。
- 根PC454此前已明确执行MainLeftBottom["doInit"] = root.children[37]创建的createButton闭包。

因此实际初始化链已经确认：doInit_UI → MainLeftBottom.doInit() → root.children[37] createButton → 三组循环调用child17。

### 路径索引防混淆

- root.children[37]：433条指令的createButton父函数（原型ID48）。
- root.children[38]：37条指令的新区启动处理器（原型ID83）。
- root.children[44]：76条指令的新区背包物品处理回调（原型ID93）。
- root.children[34].children[1]：24条指令的doInit_UI（原型ID44）。

特别注意：表格里的“原型ID44”不是数组路径root.children[44]。后者是原型ID93的新区物品处理回调。今后记录路径时必须同时保留数组路径和原型ID，不能只写“原型44”。

### 当前链路结论更新

- 已确认doInit_UI会实际调用MainLeftBottom.doInit；该属性由根PC454赋值为createButton闭包。
- 因而root/37并非未使用的函数，child17也会在正常UI初始化时被调用。
- child17 PC14提前return仍然阻断其PC15-PC50的标题/字体/颜色/toggle和addOnClickEvent逻辑；目前在该UI初始化链中没有发现其他newzone按钮事件绑定点。
- 唯一明文Lua未修改；未编译、未打包APK、未游戏实测。


## 2026-11-17续：全原型检索未发现第二条newzone事件绑定路径

本轮对完整79,573字节载荷重新按已确认解析格式读取全部原型树（105个原型；载荷完整消费，无剩余），只做目标字符串/调用点定向检索，没有重做业务反编译。

### 关键字符串分布

- `newzone`（不含定时器名称）只出现在root.children[37]的按钮配置/回调映射逻辑中。
- `newzoneTimer`出现在根子原型1、root.children[37]、root.children[38]、root.children[44]，均属于定时器/物品处理业务。
- `addOnClickEvent`常量只出现在root.children[37]父函数、root.children[37].children[15]、root.children[37].children[17]。
- `Button_Create`只出现在root.children[37]父函数和child17。
- 没有任何原型常量包含`callbackMap`字样；callbackMap是运行时表变量，不是常量命名。

### 唯一额外addOnClickEvent调用者的用途

root.children[37].children[15]（原型ID65，320条指令）确实包含一处独立`GUI.addOnClickEvent`调用：PC65-PC69绑定的是资源信息窗口`resWin`的关闭布局/控件事件，回调由本原型自己的child2闭包提供。它不读取`newzone`键，不接收createButton按钮对象，也不读取新区callbackMap，因此不是新区按钮的补充接线。

另一处`addOnClickEvent`位于child17 PC45-PC49，仍在PC14直接return之后不可达。父函数本身虽然含`addOnClickEvent`字符串常量，但未形成第三处独立调用路径。

### 本轮结论

在当前11.9模块完整原型树中，未发现除child17尾部之外的第二条新区按钮点击事件绑定路径。结合doInit_UI → MainLeftBottom.doInit → createButton的已确认入口，当前模块内可见路径为：按钮对象可创建，但新区点击回调没有被绑定。外部宿主/其他模块仍不在该文件的静态证据范围内，不能对模块外行为作绝对断言。

唯一明文Lua未修改；未编译、未打包APK、未进行游戏实测。


## 2026-11-17续：opcode152返回作用域与全原型使用分布已核实

本轮直接重新读取main分支当前加载器，并对当前加密载荷执行一次定向解析统计（不是重做业务反编译）：

### 1. opcode152的return作用域

- 加载器结构为外层local function I(E,A,F)返回一个内层function(...)；opcode分派循环while true位于这个内层函数中。
- opcode152分支位于该内层执行函数的分派树中：if D<=152 then if D>151 then return ...。
- 因此opcode152的return会结束当前正在执行的VM闭包调用，不是退出外层加载器I，也不是退出某个仅负责分派的局部辅助函数。先前“return作用域可能看错”的疑点已排除。

### 2. 完整105原型中的使用统计

- 当前载荷解码为79,573字节，原型解析完整消费79,573字节；根455条指令、54个直接子原型，递归共105个原型。
- 在全部105个原型指令流中，opcode152共出现28次；其中22次位于该原型最后一条指令，另有6次后面仍存在指令记录。
- 6处非末尾出现位置：root.children[4] PC9、root.children[26] PC5与PC19、root.children[37].children[17] PC14、root.children[45] PC42、root.children[49] PC10。
- 这说明“return后仍有指令记录”并非child17独有；VM载荷中确实存在非末尾return模式。仅凭return后仍有字节码，不能直接判定解析器错位或载荷损坏。其他函数中return后的代码是否由前置分支跳转到达，需要逐函数看控制流，不能一概称为死代码。

### 3. child17自身的局部控制流结论

- child17 PC1-PC11是按钮创建及参数准备，没有跳转指令；PC12 opcode239只按R3真值条件跳过紧随其后的PC13，不会跳到PC15或更后位置。
- PC13 opcode100的A操作数为0，按加载器分支不会执行有效upvalue关闭操作，也不会修改取指位置。
- PC14 opcode152直接return。PC14前没有可把控制流送到PC15-PC50的跳转边；PC12的条件只决定是否执行PC13。
- 因此，当前VM正常入口下，child17的PC15-PC50仍不可达。它们不是被误识别为另一段函数的指令，也不能擅自拼入唯一明文Lua。

### 4. 本轮结论与后续边界

- 已排除opcode152 return作用域误判；已确认它在全原型中既有末尾用法，也有非末尾用法。
- child17的特殊点不是“return后还有指令”本身，而是它的PC1-PC14之间没有任何跳转能进入PC15-PC50，且PC14无条件返回。
- 目前最稳妥的分类是：PC15-PC50为当前正常入口不可达的尾部字节码块；其来源可能涉及编译/混淆生成的残留块或其他构建异常，尚无证据确定具体成因。不要改写VM语义、跳过return或猜测入口偏移。
- 唯一明文Lua未修改；未编译、未打包APK、未运行游戏。


## 2026-11-17更正：child17 PC13 opcode100会设置取指位置

对加载器D<=102的分派分支重新按完整表达式核对后，发现此前把opcode100描述成“仅关闭upvalue、不会改变K”不完整，现更正：

- opcode100对应分支为：若E[2]>0则执行upvalue关闭逻辑；随后无条件执行K=E[3]。
- child17 PC13为[100,0,14,null]，A=0，因此不会执行upvalue关闭逻辑，但仍会执行K=14，即下一轮取指转到指令槽位14（PC14）。
- PC12 opcode239在R3为假时跳过PC13，随后自然到PC14；R3为真时执行PC13，PC13又把K设为14，仍到PC14。
- 所以两条路径都在PC14 opcode152 return。PC13并非单纯空操作，而是一个跳转到紧接着的PC14的指令；该更正不改变PC15-PC50在正常入口下不可达的结论。
- 此前文档中“PC13不修改取指位置/不会把K设为14”的说法作废，以本更正为准。

补充版本隔离：仓库中的11.9/MainLeftBottom.lua文件头标注root模块412条物理指令、109常量、58个直接子原型，属于另一份旧恢复源码；其中createButton的早退与事件绑定实现可作行为参考，但不能代替当前MainLeftBottom_11.9.lua的455条根指令/54个直接子原型VM证据，也不能据此覆盖当前PC12-PC14控制流。

本轮仍未修改唯一明文目标11.9/MainLeftBottom_11.9_明文.lua；未编译、未打包、未游戏实测。


## 2026-11-17续：对照其余非末尾return原型，确认跳转到return块的模式

本轮对完整105原型中的其他非末尾opcode152位置做了局部指令流对照，并重新核实加载器opcode51/100分支：

### 1. opcode51与opcode100均可改变取指位置

- opcode51分支在加载器中的效果：先按A操作数条件关闭upvalue（A>0时），随后无条件执行K=E[3]。
- opcode100分支效果相同：A>0时关闭upvalue，随后无条件执行K=E[3]。
- 因此这两种指令都属于“跳转到指定指令槽位”，不能把它们当作普通赋值或空操作。

### 2. 其他非末尾return样本

- `root.children[26]` PC4 opcode51跳到PC5，PC5为return；PC15 opcode51跳到PC18，PC18 opcode100再跳到PC19，PC19为return。
- `root.children[45]` PC38 opcode51跳到PC42，PC42为return。
- `root.children[49]` PC9 opcode51跳到PC10，PC10为return；PC19 opcode100跳到PC20，PC20也是return。
- `root.children[4]` PC5 opcode100跳到PC9，PC9为return。
- 这些样本表明：opcode152位于函数指令流中间、后面仍有物理指令，并不自动表示异常；字节码中确实存在“跳转到return出口块，return之后仍排列其他代码块”的布局。

### 3. child17与上述样本的相同点和不同点

相同点：
- child17 PC13 opcode100的目标K=14，PC14为opcode152 return。它和其他样本一样，是明确跳转到return出口块。
- 所以child17的PC12-PC14并不是解码错位；这三条指令的控制流语义彼此吻合。

不同点：
- child17 PC1-PC11没有控制转移指令；PC12 opcode239只可能跳过紧邻的PC13，不会把取指位置送到PC15及以后；PC13无条件把K设为14；PC14无条件return。
- 因此从函数正常入口PC1出发，当前可证明没有路径进入PC15-PC50。其他样本的return后代码是否可达，需要结合它们各自的条件分支/跳转边分析，不能把其他样本一概当作child17的同构案例。
- 现阶段可确认“return出口块中间布局”是VM常见结构；但child17尾部PC15-PC50仍是当前入口下无入边的代码段。它可能是编译器遗留块、构建期残留或有未识别的外部入口机制，尚不能确定具体来源。

### 4. 恢复边界

- 不改写opcode152语义，不跳过PC14，不将PC15-PC50直接写入唯一明文Lua。
- 后续若继续查，应优先验证child17是否存在本原型之外的执行入口/continuation机制，或在同一项目其他版本中寻找对应按钮工厂的已知结构；不再重复完整载荷解码和字符串扫描。
- 唯一明文目标未修改；未编译、未打包APK、未运行游戏。


## 2026-11-17续：VM闭包入口与旧版按钮工厂对照

### 1. VM执行闭包不存在已知的外部PC入口

- 当前加载器的原型执行器结构为 `local function I(proto, upvalues, env) ... return function(...)`。
- 返回的内层执行闭包每次被调用时，均在调用体内初始化 `local K=1`，并重新建立本次调用的参数/寄存器/upvalue访问状态；取指循环从 `E=Y[K]` 开始。
- 加载器末尾以 `return I(M(),{},X())()` 启动根原型；子原型由父VM创建为闭包后，普通调用仍进入该内层函数的常规调用入口。
- 已检查的执行器接口没有暴露初始PC参数；也未发现保存PC/寄存器帧并恢复执行的continuation或重入恢复入口。普通调用会从PC1重新开始，不能据此解释child17 PC15-PC50。
- 这项结论限定于当前加载器可见的VM接口；不能据此排除模块外宿主直接操作GUI对象或其他未包含在该文件中的行为，但目前没有此类证据。

### 2. 旧版按钮工厂对照

- 只读参考文件 `11.9/MainLeftBottom.lua` 中，createButton明确按顺序执行：
  1. `GUI:Button_Create(uiParent, config.key, x, y, texture)`；
  2. 按钮非nil检查；
  3. 写入buttonMap；
  4. 设置标题、字号、字体、颜色；
  5. 按需初始化toggle；
  6. `GUI:addOnClickEvent(button, function() ... end)`。
- 旧版还把 `newzone = MakeNewZoneButtonHandler()` 登记到buttonHandlers，并在按钮点击闭包中按config.key调用对应处理器。
- 这证明旧版按钮工厂的完整UI初始化/事件绑定设计意图与新版child17 PC15-PC50的指令内容高度一致；但旧版是不同版本源码，只能作为行为参照，不能覆盖新版PC12-PC14的实际控制流。

### 3. 当前判断

- “VM闭包通过普通调用从PC15启动”以及“VM保存现场后从PC15恢复”两种解释，目前均没有加载器实现依据。
- 新版child17正常调用从PC1开始，并在PC14 opcode152返回；PC15-PC50仍归类为当前正常入口不可达的尾部指令块。
- 旧版结构支持“尾部UI指令原本意图完成按钮标题和事件绑定”的判断，但尚不能证明这些指令在当前新版中实际执行。
- 唯一明文目标 `11.9/MainLeftBottom_11.9_明文.lua` 未修改；本轮只更新分析记录。未编译、未打包APK、未运行游戏。

### 4. 下一步

优先检查新版父VM的闭包创建/调用分派是否存在除普通调用外的特殊调用形式，并定点检查其他版本是否有与当前新版同源的child17/按钮工厂原型；不重复解码、不重审已闭合的callbackMap和doInit_UI链。


## 2026-11-17续：找到旧VM结构树中的同构按钮工厂（强对照证据）

### 1. 新发现的旧版静态恢复材料

本轮从仓库完整文件树中找到并读取：
- `资料文件/04_源码候选/MainLeftBottom_完整结构树.lua`
- `资料文件/04_源码候选/MainLeftBottom_恢复源码.lua`
- `资料文件/04_源码候选/短函数草稿_第七十一批.lua`

旧VM结构树中明确记录：
- `root.children[42].children[9]`，原型ID68，50条指令、17项常量、1个子原型、5项upvalue；父级创建点为root/42 PC339。
- 其子原型 `root.children[42].children[9].children[0]`，原型ID69，48条指令、10项常量、0个子原型、3项upvalue；父级创建点为旧按钮工厂PC44。
- 这组规模和父子结构与新版child17（50条指令、1个子原型）及child0（48条指令）高度吻合，属于非常强的同构按钮工厂对照，但仍是不同版本/不同原型编号，不能把旧版PC编号当成新版PC编号。

### 2. 旧版50指令按钮工厂的已恢复行为

第七十一批草稿给出的旧版工厂顺序为：
1. 取GUI和5项捕获值；
2. 调用 `GUI:Button_Create(buttonParent, config.key, baseX-85*offsetX, baseY+offsetY, texture)`；
3. 创建失败立即return；
4. 成功后写入 `buttonByKey[config.key]`；
5. 设置标题、字号18、字体 `kaiti2.ttf`、白色；
6. 按旧版配置条件初始化 `config.toggled`；
7. 创建child0点击闭包并调用 `GUI:addOnClickEvent`。

旧版child0按key查找stateGateMap，默认allowed=true；存在gate才调用；非toggle退出；只有allowed严格等于false才退出；之后切换toggled并更新标题/颜色。

### 3. 对新版child17问题的意义

- 新版child17 PC1-PC11同样完成GUI.Button_Create调用；PC12-PC14却无论Button_Create返回真值或假值，最终都进入PC14 opcode152 return。
- 旧版同构工厂明确在“创建失败”时return，而创建成功时继续执行登记、标题/字体/颜色设置、toggle初始化和事件注册。
- 新版PC15-PC50的指令内容与这套成功后流程高度吻合；因此现在可以高置信地将PC15-PC50识别为“按钮创建成功后的初始化与事件绑定代码块”。
- 但这只能确认其业务身份/设计意图，不能改变新版VM的可达性事实：在当前新版PC12-PC14控制流下，PC15-PC50仍不可达。不得直接把旧版函数体复制进新版明文，也不得把新版PC14 return改成条件return。
- 目前最值得继续追查的是：新版这处PC12-PC14是否是原始字节码真实存在的控制流异常/补丁，或指令解码时对PC12-PC14某条指令的操作数/融合边界仍有局部解释错误。由于opcode239、opcode100、opcode152的分派语义已核对，下一步应以原始VM dump/纠正反汇编记录逐字节复核child17这三条指令的编码字段和线性融合边界，而不是继续搜索外部PC入口。

### 4. 版本与文件边界

- 旧版材料路径为 `资料文件/04_源码候选/...`，旧结构路径为 `root.children[42].children[9]`；新版仍为 `11.9/MainLeftBottom_11.9.lua` 中的 `root.children[37].children[17]`。
- 旧版恢复源码仅作同构结构和业务行为对照，不能替代新版原始字节码证据。
- 唯一明文目标 `11.9/MainLeftBottom_11.9_明文.lua` 本轮未修改；本轮仅更新原始指令记录、进度账本和接续入口。未编译、未打包APK、未运行游戏。


## 2026-11-17续：child8与child25原始指令已从新版载荷直接导出

本轮重新按当前加载器源码逐字节实现LZW解码及M()递归解析。关键修正是严格复现LZW的A()：先读取一个base36长度字符，再读取该长度的base36码值；按字典0..255初始化，逐码扩展字典。随后按K()/A()/F()/I()/S()/M()原始读取顺序解析，不再使用上一版有偏差的独立解析器。

完整性校验：编码串87572字符；解码后79573字节；解析游标恰好消费79573字节。根原型147常量、54直接子原型、455指令；root/37为111常量、26子原型、433指令，与已确认结构完全吻合。

### child8（root/37/8，yinguaibut）
- 4项常量：`StopGatherMonsters`、`关闭引怪功能`、`gatherTimer`、`开启引怪功能，阈值：11`。
- 0显式参数、0子原型、19条物理指令。
- 捕获仍按父级PC286-PC290记录：UP[0]=createButton的UP[3]，UP[1]=createButton的UP[10]，UP[2]=父R17（child25闭包）。

| PC | opcode | mode | flags | 解码操作数（R寄存器/常量索引按原始字段） |
|---:|---:|---:|---:|---|
| 1 | 17 | 0 | 0 | 0,0,0,0 |
| 2 | 388 | 0 | 4 | 0,0,0,`gatherTimer` |
| 3 | 234 | 0 | 0 | 0,0,0,0 |
| 4 | 38 | 1 | 0 | 0,0,11,null |
| 5 | 17 | 0 | 0 | 0,0,1,0 |
| 6 | 399 | 1 | 2 | 0,1,`关闭引怪功能`,null |
| 7 | 279 | 0 | 0 | 0,1,0,0 |
| 8 | 127 | 1 | 2 | 0,0,`StopGatherMonsters`,null |
| 9 | 91 | 0 | 0 | 0,0,0,0 |
| 10 | 398 | 0 | 0 | 0,1,0,0 |
| 11 | 223 | 0 | 0 | 0,0,0,0 |
| 12 | 29 | 0 | 0 | 0,0,1,0 |
| 13 | 263 | 1 | 2 | 0,1,`开启引怪功能，阈值：11`,null |
| 14 | 91 | 0 | 0 | 0,0,1,0 |
| 15 | 17 | 0 | 0 | 0,0,2,0 |
| 16 | 331 | 0 | 0 | 0,0,0,0 |
| 17 | 412 | 0 | 0 | 0,0,1,0 |
| 18 | 30 | 0 | 0 | 0,0,0,0 |
| 19 | 152 | 0 | 0 | 0,0,0,0 |

### child25（root/37/25，阈值初始化闭包）
- 3项常量：`GATHER_THRESHOLD`、数值`11`、`InitGatherMonsters`。
- 0显式参数、0子原型、7条物理指令；父级PC264创建时捕获UP[8]。

| PC | opcode | mode | flags | 解码操作数 |
|---:|---:|---:|---:|---|
| 1 | 17 | 0 | 0 | 0,0,0,0 |
| 2 | 132 | 0 | 6 | 0,0,`GATHER_THRESHOLD`,11 |
| 3 | 127 | 1 | 2 | 0,0,`InitGatherMonsters`,null |
| 4 | 331 | 0 | 0 | 0,0,0,0 |
| 5 | 412 | 0 | 0 | 0,0,1,0 |
| 6 | 223 | 0 | 0 | 0,0,0,0 |
| 7 | 396 | 0 | 0 | 0,0,0,0 |

### 已确认的指令执行细节
- opcode17执行`V[E[2]]=A[E[3]]`，因此child8 PC1/5/15分别读取捕获UP[0]/UP[1]/UP[2]；child25 PC1读取其唯一捕获UP[0]。
- opcode388在该指令位置执行表字段读取，child8 PC2将捕获对象的`gatherTimer`字段读入R0。
- opcode234按R0真值决定是否跳过紧邻PC4；opcode38把取指位置设为操作数11，叠加分派循环尾部公共递增后从PC12继续。
- opcode132在child25 PC2先执行`V[0]["GATHER_THRESHOLD"]=11`，并在同一分派分支内额外消费下一条指令PC3，将`InitGatherMonsters`常量载入R0。故PC3是opcode132的融合消费项，不能再当作独立执行指令。
- opcode91是无返回值调用；opcode331也是普通无返回值调用；opcode412是带两个显式参数并接收一个返回值的调用形态；opcode223/30为寄存器区间返回；opcode152为直接return。
- 目前child8在“已有gatherTimer”分支的关闭通知、StopGatherMonsters调用和true返回链已能解释；无timer分支后半段存在连续调用及返回值传递，尚未完全闭合。child25 PC4-PC7同样有连续调用/返回路径，不能仅凭函数名将其简化成一次InitGatherMonsters调用。
- 因此本轮只保存原始指令和已证明的融合/调用事实，暂不改写MakeGatherButtonHandler或唯一明文源码；禁止将旧root/43六参数装配移植到新版。

### 下一步
对照VM调用指令的寄存器生命周期，继续闭合child8 PC12-PC19及child25 PC4-PC7的调用帧；确认UP[0]/UP[1]/UP[2]真实语义后，写入新版引怪handler装配，再回到新版root/37真实doInit入口和newzone接线。未编译、未打包、未运行游戏。


## 2026-11-17指令融合边界更正：child8/child25的331为四记录融合指令

本轮重新逐层追踪原始解释器`I()`中的分派树，纠正上一节对opcode412/331的单条语义判断。关键证据：解释器对`D=331`走入`if D<=388 -> D<=375 -> D<=368 -> D<=365 -> D<=363`分支；该分支不是单条操作，而是连续读取当前及后续三条记录：

1. `V[E[2]]=F[E[3]]`
2. `K=K+1; E=Y[K]; V[E[2]]=V[E[3]][E[4]]`
3. 再消费一条记录执行同样的表索引赋值
4. 再消费一条记录执行同样的表索引赋值

所以opcode331在这里一次性消费4条物理记录，后3条只提供操作数，不会再独立分派。按child8和child25的原始记录：

| 原型 | 融合起点 | 被融合消费记录 | 被消费记录中的opcode字段（不独立执行） |
|---|---:|---|---|
| child8 | PC16 opcode331 | PC17、PC18、PC19 | 412、30、152 |
| child25 | PC4 opcode331 | PC5、PC6、PC7 | 412、223、396 |

对两段都能确定的寄存器级形式是：先将`F[0]`写入目标寄存器R0，再按随后三条记录的操作数连续进行三次`V[dst]=V[src][key]`表索引赋值。child8/child25对应的三个索引操作数分别来自各自PC17-PC19/PC5-PC7记录。

**重要更正：**此前将child8 PC17 opcode412解释为“单独的两参数调用并接收返回值”，以及将child25 PC5-PC7分别当作独立调用/返回操作，均不成立；这些记录都被前一条opcode331融合分支消费。child25 PC2的opcode132也确实融合消费PC3，但那是另一种两记录融合分支（先写`GATHER_THRESHOLD=11`，再执行`V[E[2]]=F[E[3]]`，其中PC3的常量键为`InitGatherMonsters`）。

当前能确定的是融合边界与寄存器操作形式；`F[0]`及连续索引链最终解析到的运行时对象/函数身份，仍需结合该闭包捕获环境和父级createButton作用域继续追踪。暂不把它命名为`InitGatherMonsters()`或其他业务调用，避免凭常量名猜测。

### 下一步
回到root/37父函数PC253-PC271，精确追踪child25创建时捕获的UP[8]运行时来源及其环境表结构；据此解释`F[0]`和三次索引链的最终目标。完成后再解释child8相同融合链，最后恢复新版引怪handler。未修改唯一明文Lua；未编译、未打包APK、未运行游戏。


## 2026-11-17续：child25的UP[8]来源已追到根函数R8

本轮按当前main分支原始加密文件重新执行已验证的LZW/XOR/M()解析器，定点导出根函数PC430-PC455及root/37 PC253-PC271；完整性校验仍为编码串87572字符、解码79573字节、根455指令/54子原型、root/37为433指令/26子原型，解析游标消费全部载荷。

### 1. 更正createButton捕获编号与新区处理器编号

root PC438创建root/37（createButton），捕获数15。PC439-PC453捕获序列完整如下，编号按VM upvalue的0-based索引：

| createButton upvalue | 根函数来源寄存器 | 说明 |
|---:|---:|---|
| UP[0] | R4 | |
| UP[1] | R2 | |
| UP[2] | R0 | |
| UP[3] | R3 | |
| UP[4] | R1 | |
| UP[5] | R44 | |
| UP[6] | R7 | |
| UP[7] | R39 | |
| UP[8] | R8 | child25实际捕获来源 |
| UP[9] | R54 | 根PC430创建的新区处理器 |
| UP[10] | R5 | |
| UP[11] | R55 | |
| UP[12] | R11 | |
| UP[13] | R12 | |
| UP[14] | R9 | |

因此，root/37 PC265的[374,0,8,0]读取的是createButton UP[8]，也就是根函数R8；root/37 PC270的[374,0,9,0]才读取根函数R54（新区处理器）。此前只确认UP[9]是新区处理器，本轮将UP[8]/UP[9]相邻槽位严格区分，避免错接。

### 2. 根函数R8的真实对象身份

根函数PC86为[47,8,0,3]，当前加载器opcode47语义为创建空表，因此R8从此处成为一张新表。随后：
- PC87：[344,8,"GATHER_THRESHOLD",11]
- PC88：[344,8,"CHECK_INTERVAL",0.5]
- PC89：[107,8,"ATTACK_WAIT_TIME",1]

这三条指令把引怪配置字段写入R8。结合root/37 PC265与child25 PC1，child25唯一捕获UP[0]就是这张共享引怪配置表。child25 PC2设置R8.GATHER_THRESHOLD=11，因此阈值写入目标已闭合；这不是新区处理器，也不是环境表。

### 3. child25后半段仍不能冒进命名

child25 PC2 opcode132先设置捕获配置表的GATHER_THRESHOLD=11，并融合消费PC3，将环境表字段F["InitGatherMonsters"]载入R0。随后PC4 opcode331融合消费PC5-PC7，执行：
- R0 = F[0]
- R0 = R0[1]
- R0 = R0[0]
- R0 = R0[0]

所以PC3载入的InitGatherMonsters值会被PC4覆盖；当前可证明的是最终环境表索引链F[0][1][0][0]，不能把它写成InitGatherMonsters()。加载器创建VM闭包时传入的F是getfenv()返回的环境表；但该环境表的数值键0及后续嵌套对象身份，尚未从仓库静态资料中确认。

同理，child8 PC15虽把捕获的child25闭包读入R0，但PC16 opcode331随即以F[0]覆盖R0并完成三次索引；在当前已确认的VM语义下，不能宣称child8实际调用了child25。其开启分支的环境索引链目标仍待运行环境/宿主结构证据确认。

### 4. 当前结论

- child25捕获来源已确认：createButton UP[8] → 根R8 → 共享引怪配置表。
- child25阈值写入已确认：GATHER_THRESHOLD=11。
- createButton UP[9]才是新区处理器R54；新区callbackMap包装链PC269-PC271仍保持此前结论。
- F[0][1][0][0]的最终运行时对象/元方法副作用未确认；不补写推测性调用，不改写唯一明文Lua。
- 本轮未修改唯一明文源码；未编译、未打包APK、未运行游戏。

### 下一步
先在仓库已有的宿主环境/API资料中定点查找环境表数值键0及F[0][1][0][0]的对象定义/注入方式；若静态资料没有证据，则将其保留为明确待确认点，不伪造调用。随后继续恢复child9、child6与child12的真实业务职责及新版callbackMap装配。


## 2026-11-18：新版child9 toggle状态同步闭包恢复

重新定点解析root/37 PC253-PC257与child9完整51条指令。root/37 PC253创建child9（2个显式参数），后续四项捕获依次为：
- UP[0] ← root/37局部R12：第一组按钮配置数组
- UP[1] ← root/37局部R13：第二组按钮配置数组
- UP[2] ← root/37局部R14：第三组按钮配置数组
- UP[3] ← createButton的UP[4] ← 根函数R1：MainLeftBottom模块表

child9两个显式参数为buttonKey和toggled。其51条指令实现双层ipairs遍历三组配置，按config.key匹配buttonKey，写入config.toggled=toggled；然后从MainLeftBottom.b[buttonKey]取控件。控件存在时调用GUI.Button_setTitleText与GUI.Button_setTitleColor：开启状态标题使用config.toggle、颜色#ff0000；关闭状态标题使用config.name、颜色#ffffff。命中后立即返回；未命中则遍历下一项/下一组。

已在唯一明文Lua新增MakeMainLeftBottomToggleStateSync_11_9(firstGroup, secondGroup, thirdGroup, mainLeftBottom)，保留旧root/43的MakeMainLeftBottomToggleStateSync不动。新函数捕获对象按新版证据明确区分：MainLeftBottom是模块表，按钮映射为MainLeftBottom.b，不能误用MainLeftBottom.a。

该辅助函数的明文主体已写入；完整新版doInit实例化及调用点接线仍待完成。未编译、未打包APK、未游戏实测。

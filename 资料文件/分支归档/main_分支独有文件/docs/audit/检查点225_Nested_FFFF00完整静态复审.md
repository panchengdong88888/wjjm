# 检查点 #225：Nested_FFFF00 320指令完整静态复审

日期：2026-11-10
原型：`root.children[42].children[3]`（legacy `root/43/4`）
物理指令：320；常量：72；子原型：5；捕获：4。

## 捕获

- UPVALUE[0]：moduleState（窗口与屏幕状态表）。
- UPVALUE[1]：printLog。
- UPVALUE[2]：timerState。
- UPVALUE[3]：initState。
以上均为按行为角色命名。

## 控制流

1. PC1-PC27：判断资源窗口是否存在；存在时提示关闭，若resTimer存在则SL:UnSchedule并将resTimer置nil，随后关闭窗口并返回。
2. PC28-PC46：创建资源窗口。实参为`"resWin",0,0,screenW,screenH,false,true,true,true,true,nil,999`。
3. PC47-PC72：创建根Layout、开启触摸并绑定关闭回调。
4. PC73-PC117：创建ListView，设置锚点、背景类型1、背景色`#CEB5F7`及透明度255。
5. PC118-PC264：依次创建title/initTime/currentTime/duration/note五组Layout与Text。每次Text_Create后先检查返回值truthy，再设置锚点。
6. PC265-PC267：创建Nested_FFFFFF资源行刷新闭包。
7. PC268-PC291：建立moneyNames四项和resourceNames六项，分别以`(names,2,"money")`及`(names,2,"item")`调用资源行构造闭包。
8. PC292-PC299：获取Nested_string及MoneyProxy。
9. PC300-PC310：创建10项捕获的刷新闭包。
10. PC311-PC319：立即刷新一次，再以1.0秒周期Schedule并保存resTimer。
11. PC320：无显式返回。

## GUI开发文档核对

已从`新框架(3_40_xx).zip`核对：
- Win_Create(ID,x,y,width,height,hideMain,hideLast,needVoice,escClose,isRevmsg,npcID,param)
- Layout_Create(parent,ID,x,y,width,height,isClip)
- ListView_Create(parent,ID,x,y,width,height,direction)，direction=1垂直
- Text_Create(parent,ID,x,y,fontSize,fontColor,str)
- ListView背景颜色类型/颜色/透明度、setAnchorPoint、setTouchEnabled、addOnClickEvent、Win_IsNotNull、Win_Close等。

候选源码调用参数数量和顺序与文档签名一致。GUI控件创建返回值门控按字节码保留。

## nil序列化占位修正

本原型常量K[28]=`["unknown",2]`与检查点102中Nested_SL_2关闭rewardTimer时的同型dump标记一致。检查点102已证明该标记是dump序列化nil的占位，因此resTimer清理应为`nil`，不是运行时哨兵。同步将doInit_UI的cruiseTimer清理也改为nil。

## 外部API边界

MoneyProxy的GetMoneyIdByName/GetMoneyCountById未在43份开发文档中找到精确条目，保留字节码观察到的代理方法调用，不分析内部实现。其返回值按名称写入初始快照，不将moneyId误当作快照键。

## 结论

320条父指令与5个子原型完整静态恢复。无Lua解释器或游戏客户端运行时验证。

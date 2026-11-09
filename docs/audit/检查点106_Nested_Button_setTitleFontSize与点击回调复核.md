# 检查点 #106：Nested_Button_setTitleFontSize / Nested_Button_setTitleText复核

日期：2026-11-09

## 原型信息
| 函数 | 规范路径 | legacy | 指令 | 常量 | 子原型 | vararg |
|---|---|---|---:|---:|---:|---:|
| Nested_Button_setTitleFontSize | root.children[42].children[9] | root/43/10 | 50 | 17 | 1 | 3 |
| Nested_Button_setTitleText | root.children[42].children[9].children[0] | root/43/10/1 | 48 | 10 | 0 | 0 |

## 父函数捕获
doInit_UI PC340创建Nested_Button_setTitleFontSize，PC341-PC345捕获：
- UP[0] <- root T[6]
- UP[1] <- root T[22]
- UP[2] <- root T[23]
- UP[3] <- root UP[4]
- UP[4] <- root T[21]

仅凭寄存器捕获不臆测全部业务名。本函数实际使用：
- UP[0]作为GUI.Button_Create的首个非self参数。
- UP[1]作为横向基准值。
- UP[2]作为纵向基准值。
- UP[3]作为按钮对象注册表，按config.key写入。
- UP[4]作为点击子闭包的状态门控表，按config.key读取。

## Nested_Button_setTitleFontSize逐PC
- PC1-PC2：取得GUI.Button_Create方法，同时保留GUI作为self。
- PC3-PC4：读取UP[0]与首个参数config.key。
- PC5-PC7：计算x坐标`UP[1] - 85 * arg1`。
- PC8-PC9：计算y坐标`UP[2] + arg2`。
- PC10-PC11：调用GUI:Button_Create(parent,key,x,y,"res/public/fuzhu_btn.png")。
- PC12-PC14：返回值false/nil时直接返回。
- PC15-PC17：写入UP[3][config.key]=button。
- PC18-PC22：GUI:Button_setTitleText(button,button.name)。
- PC23-PC27：GUI:Button_setTitleFontSize(button,18)。
- PC28-PC32：GUI:Button_setTitleFontName(button,"res/public/kaiti2.ttf")。
- PC33-PC37：GUI:Button_setTitleColor(button,"#ffffff")。
- PC38-PC41：config.toggle false/nil时设置config.toggled=false；truthy时保留原值。
- PC42-PC45：取得GUI.addOnClickEvent，创建点击子闭包。
- PC46-PC48：子闭包依次捕获本函数UP[4]、本函数R0(config)、本函数R3(button)。
- PC49：GUI:addOnClickEvent(button, callback)。
- PC50：返回。

## Nested_Button_setTitleText逐PC
子闭包捕获：
- UP[0]：父函数UP[4]，即按按钮key索引的状态门控表。
- UP[1]：父函数R0，即config对象。
- UP[2]：父函数R3，即Button_Create返回的button对象。

控制流：
- PC1-PC4：读取`gate=UP[0][config.key]`。
- PC5-PC10：allowed默认true；gate truthy时调用gate()并用其返回值覆盖allowed。
- PC11-PC14：config.toggle false/nil时跳至尾部返回。
- PC15-PC16：严格比较allowed==false；仅等于false时跳至尾部。nil不会触发该退出分支。
- PC17-PC21：config.toggled取反并写回config.toggled。
- PC22-PC35：调用GUI.Button_setTitleText，实参为更新后的toggled值、button对象、config.name。
- PC36-PC37：取得GUI.Button_setTitleColor。
- PC38-PC42：读取config.toggled，真值时进入红色分支，否则跳过红色赋值。
- PC43-PC45：若config.toggled truthy，且config.toggle truthy，颜色设为#ff0000；否则保留/装载#ffffff。
- PC46-PC48：调用GUI.Button_setTitleColor，实参为更新后的toggled值、button对象、颜色。

## 重要语义
1. 父函数PC6-PC9坐标公式按寄存器算术顺序确认为`baseX-85*offsetX`与`baseY+offsetY`。CSV早期备注中的旧坐标表达式不再作为依据。
2. 点击子闭包门控退出比较是`allowed == false`，不是`not allowed`；nil与false行为不同。
3. 子回调Button_setTitleText/Button_setTitleColor的首个显式参数是更新后的toggled值；GUI self由方法调用寄存器布局隐式传入。
4. 父函数创建阶段的GUI初始化方法使用GUI self、button和对应属性值，不能与子回调实参布局混淆。

## 结论
两个原型的创建/失败返回、寄存器坐标运算、注册表写入、GUI初始化调用、闭包捕获、门控严格false判断、toggled反转、文本和颜色更新均已闭合。

状态：完整静态恢复（未运行时验证）。未在游戏客户端运行。

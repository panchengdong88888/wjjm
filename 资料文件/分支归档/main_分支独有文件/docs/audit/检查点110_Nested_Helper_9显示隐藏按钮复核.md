# 检查点 #110：Nested_Helper_9显示/隐藏按钮复核

日期：2026-11-09  
规范路径：`root.children[42].children[15]`  
legacy：`root/43/16`  
物理指令：30；常量：10；子原型：0；无显式参数。

## 捕获来源
doInit_UI PC415创建：
- UP[0] <- 父UP[3]：UI状态对象。
- UP[1] <- 父UP[0]：单字符串提示回调。

## 分支
- PC1-PC3读取UP[0].isHidden。
- PC3的条件跳转为truthy进入隐藏分支，false/nil跳至PC18显示分支。

### 隐藏分支（PC5-PC17）
1. 通知回调("隐藏所有按钮")。
2. 调用uiState.hide()，无显式参数。
3. 读取GUI.setOpacity。
4. 读取uiState.hidebut。
5. 调用GUI:setOpacity(uiState.hidebut,0)。
6. 跳至函数尾部返回。

### 显示分支（PC18-PC30）
1. 通知回调("显示所有按钮")。
2. 调用uiState.show()，无显式参数。
3. 读取GUI.setOpacity。
4. 读取uiState.hidebut。
5. 调用GUI:setOpacity(uiState.hidebut,255)。
6. 函数尾部返回。

## 结论
- 两条分支的通知文本、回调对象、透明度值、GUI self与显式实参均已闭合。
- isHidden为truthy时执行隐藏；false/nil时执行显示。
- 函数没有显式返回值。
- UI状态对象的原作者局部名称未知，按字段行为命名。

状态：完整静态恢复（未运行时验证）。未进行宿主运行时验证。

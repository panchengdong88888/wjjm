# 检查点 #94：Nested_FFFF00 布局参数与锚点校正

日期：2026-11-09  
函数：Nested_FFFF00  
规范路径：`root.children[42].children[3]`  
legacy：`root/43/4`

## 修正内容

### 五个Layout_Create调用补齐尾随参数
父函数PC120-PC128、PC148-PC156、PC182-PC190、PC210-PC218、PC238-PC246均可见：
- 父节点resList
- 名称titleCell/initTimeCell/curTimeCell/durTimeCell/noteCell
- x/y为0/0
- 宽度为1
- 高度为30
- 末尾实参为1

此前草稿的五个调用均漏掉最后一个1，现已补齐。该实参的宿主GUI含义尚未确认。

### 五个Text节点锚点补齐
PC139-PC146：titleText调用setAnchorPoint(0.5,0.5)。  
PC173-PC180：initTimeText调用setAnchorPoint(0.5,0.5)。  
PC201-PC208：curTimeText调用setAnchorPoint(0.5,0.5)。  
PC229-PC236：durTimeText调用setAnchorPoint(0.5,0.5)。  
PC257-PC264：noteText调用setAnchorPoint(0.5,0.5)。

此前父函数草稿创建这些Text节点后漏写锚点设置，现已补齐。各条件跳转在这些片段中不会阻断锚点调用。

## 当前状态
本次只修正可由物理PC与寄存器实参直接确认的参数和调用，不推断末尾数值1的宿主端语义。Nested_FFFF00仍为普通Lua草稿，其他捕获/GUI参数与Schedule返回契约继续待核；无运行时验证。

[TOC]
# 创建输入框
## TextInput_Create(parent, ID, x, y, width, height, fontSize)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|width      |是|int|宽度|
|height     |是|int|高度|
|fontSize   |是|int|字体大小|
- 示例代码
```
local TextField_input = GUI:TextInput_Create(parent, "TextField_input", 0, 0, 30, 33, 16)
```

# 设置输入框字体颜色
## TextInput_setFontColor(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|输入框对象|
|value      |是|string|色值("#000000")|

# 设置输入框字体 [仅支持移动端设置]
## TextInput_setFont(widget, value, value2)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|输入框对象|
|value      |是|string|字体路径|
|value2     |是|int|字号|

# 设置输入框字体大小
## TextInput_setFontSize(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|输入框对象|
|value      |是|int|字号|

# 设置输入框占位文本字体
## TextInput_setPlaceholderFont(widget, value, value2)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|输入框对象|
|value      |是|string|字体路径|
|value2     |是|string|字体("font.ttf")|

# 设置输入框占位文本字体颜色
## TextInput_setPlaceholderFontColor(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|输入框对象|
|value      |是|string|色值("#000000")|

# 设置输入框占位文本字体大小
## TextInput_setPlaceholderFontSize(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|输入框对象|
|value      |是|int|字号|

# 设置输入框占位文本
## TextInput_setPlaceHolder(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|输入框对象|
|value      |是|string|输入内容|

# 设置输入框文本
## TextInput_setString(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|输入框对象|
|value      |是|string|输入内容|

# 获取输入框文本
## TextInput_getString(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|输入框对象|

# 设置输入框行宽
## TextInput_setMaxLength(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|输入框对象|
|value      |是|int|输入框控件宽度|

# 设置输入框水平对齐
## TextInput_setTextHorizontalAlignment(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|输入框对象|
|value      |是|int|对齐方式：<br>0 左对齐<br> 1 水平居中<br>2 右居中|

# 设置输入框文本类型
## TextInput_setInputFlag(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|输入框对象|
|value      |是|int|类型|
-  类型如下
```
0   -- 密码形式
1   -- 敏感数据输入
2   -- 每个单词首字符大写，并有提示
3   -- 第一句首字符大写，并有提示
4   -- 自动大写
```

# 设置输入框键盘编辑类型
## TextInput_setInputMode(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|输入框对象|
|value      |是|int|类型|
-  类型如下
```
0   -- 开启任何文本的输入键盘(含换行)
1   -- 开启邮箱地址输入类型键盘
2   -- 开启数字符号输入类型键盘
3   -- 开启电话号码输入类型键盘
4   -- 开启URL输入类型键盘
5   -- 开启数字输入类型键盘(含小数点)
6   -- 开启任何文本的输入键盘(不含换行)
```

# 设置输入框弹出式键盘返回类型
## TextInput_setReturnType(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|输入框对象|
|value      |是|int|类型|


# 设置输入框监听事件
## TextInput_addOnEvent(widget, eventCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|输入框对象|
|eventCB    |是|function|事件处理函数|

# 关闭输入框输入 [3.40.5版本]
## TextInput_closeInput(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|输入框对象|
























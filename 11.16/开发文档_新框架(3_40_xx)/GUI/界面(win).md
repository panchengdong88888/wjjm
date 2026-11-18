[TOC]
#打开界面
## Win_Open(filename)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|filename   |是|string|界面文件名, 目录默认GUILayout下|


#创建界面
## Win_Create(ID, x, y, width, height, hideMain, hideLast, needVoice, escClose, isRevmsg, npcID, param)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|width      |是|int|宽度|
|height     |是|int|高度|
|hideMain   |否|bool|是否隐藏主界面|
|hideLast   |否|bool|是否隐藏上一个界面|
|needVoice  |否|bool|是否有音效|
|escClose   |否|bool|是否按键盘ESC关闭界面|
|isRevmsg   |否|bool|是否pc鼠标经过吞噬/触摸吞噬，默认true|
|npcID      |否|int|绑定的NPCID|
|param      |否|int|窗口创建层 0主界面层 1普通面板层 2通知层 默认1<br>[仅普通面板时 hideMain、hideLast、escClose参数生效]|
- 注意此方法创建界面只做父节点


#关闭界面
## Win_Close(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|界面对象|


## Win_CloseByID(ID)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|ID         |是|string|界面ID|
- 通过界面ID关闭界面


## Win_CloseByNPCID(NPCID)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|NPCID      |是|int|NPCID|
- 通过NPCID关闭界面


## Win_SetESCClose(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|界面对象|
|value      |是|bool|是否关闭|
- 通过键盘的Esc键关闭界面


## Win_CloseAll()
- 关闭所有界面


#获取界面控件
## GetWindow(parent, ID)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|控件ID|
- 示例代码


```lua
    local _parent = GUI:Win_Create("QSQ_challengeboss", 0, 0, 0, 0, false, false, true, false)
    local LV_type = GUI:ListView_Create(_parent, "LV_type", 905, 65, 40, 450, 1)
    if LV_type then
            local template = GUI:Layout_Create(LV_type, "template", 0, 0, 40, 100)
            if template then
                GUI:Button_Create(template, "btn_switch", 0,0, "res/01/010022.png")
            end
        end
    end
    方法:一 根据父窗口对象与下级子控件ID获取对象
    local LV_type = GUI:GetWindow(_parent,"LV_type")


    方法:二 根据父窗口对象与多层子控件ID获取对象
    local btn_switch = GUI:GetWindow(_parent,"LV_type/template/btn_switch")


    方法:三 根据当前“桌面”打开的窗口控件ID获取对象
    local _parent = GUI:GetWindow(nil,"QSQ_challengeboss")
    local LV_type = GUI:GetWindow(nil,"QSQ_challengeboss/LV_type")
```


#设置控件自定义参数
## Win_SetParam(widget, param)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|界面对象|
|param      |是|int/string/bool|参数内容|


## Win_GetParam(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|界面对象|
- 获取控件自定义参数


#设置界面拖拽
`第一个参数 widget  必须是 GUI:Win_Create 创建的  第二个拖拽参数可以使用普通控件`
## Win_SetDrag(widget, dragLayer)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|界面对象|
|dragLayer  |是|obj|拖拽区域控件|


#设置主界面隐藏
## Win_SetMainHide(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|界面对象|
|value      |是|bool|是否隐藏, 普通面板生效|


#设置是否按ESC键关闭窗口
## Win_SetESCClose(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|界面对象|
|value      |是|bool|能否关闭, 普通面板生效|


#设置界面绑定NPC
## Win_BindNPC(widget, npcID)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|界面对象|
|npcID      |是|int|NPCID|


#设置界面浮起
## Win_SetZPanel(widget, zPanel)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|界面对象|
|zPanel     |是|obj|控件对象|


#设置界面内鼠标右键吞噬
## Win_SetSwallowRightMouseTouch(widget, state)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|界面对象|
|state      |是|bool|是否吞噬|


#判断对象是否为空
## Win_IsNull(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|对象|


#判断对象是否不为空
## Win_IsNotNull(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|对象|



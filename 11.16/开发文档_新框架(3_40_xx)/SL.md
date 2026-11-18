[TOC]
#打印函数
#### 日志打印
- `SL:release_print(...)`

#### DEBUG下日志打印
- `SL:Print(...)`
- `SL:PrintEx(...)`
- `SL:PrintTraceback()`
- `SL:dump(data, desciption, nesting)`

|字段|类型|注释|
|:---- |:------- |:---|
|data |table |需要打印的表|
|desciption |string|打印表描述|
|nesting |int|需要打印的深度|

**------------**
#JSON

<font color="#ff00ff" style="font-family: Fixedsys;font-size: 15px;">特殊：json过程中已下违禁词不可用</font>
<font color="#ff00ff" style="font-family: Fixedsys;font-size: 15px;">违禁词：`lib` `function` `then` `end` `_G` `return` `index` `set` `%(` `%)` `_`</font>

#### json字符串解密
- `SL:JsonDecode(jsonStr, isfilter)`

|字段|类型|注释|
|:---- |:--- |:--- |
|jsonStr |string |json字符串 |
|isfilter |boolean|是否过滤违禁词 默认为true|

- 返回值： json table
- 代码示例

```
	-- [[{"index":1, "value":2}]] --> {index = 1, value = 2}

	local jsonStr = [[{"index":1, "value":2}]]
	local jsonData = SL:JsonDecode(jsonStr)
```

------------
#### json字符串加密
- `SL:JsonEncode(jsonData, isfilter)`

|字段|类型|注释|
|:---- |:------|:--- |
|jsonData |table |json表 |
|isfilter |boolean|是否过滤违禁词 默认为true|

- 返回值： json string
- 代码示例

```
	-- {index = 1, value = 2} --> [[{"index":1, "value":2}]

	local tab = {"1","2"}
	local jsonStr = SL:JsonEncode(tab)
	SL:Print(jsonStr)
```

**------------**
#常用函数
#### 颜色转换函数
- `SL:ConvertColorFromHexString(hexStr)`

- 从16进制字符转为{r, g, b}
- 返回值： table

*示例*
```
	local color = SL:ConvertColorFromHexString("#FFFFFF")
	SL:dump(color)
```

------------
#### 文件路径是否存在
- `SL:IsFileExist(path)`

- path ：文件路径
- 返回值 ：true / false


*示例*
```
	if SL:IsFileExist("E:/1.png") then
		SL:Print("文件存在")
	else
		SL:Print("文件不存在")
	end
```

------------
#### 深拷贝
- `SL:CopyData(data)`

------------
#### 字符串分割
- `SL:Split(str, delimiter)`

- 按分隔符去拆分一串字符
- 返回值 ： table

*示例*
```
	local spt = SL:Split("11#22#33", "|")
	SL:dump(spt)
```

------------
#### 文本提示
- `SL:ShowSystemTips(str)`

- str : string 提示文本

------------
#### 哈希表转成按数组
- `SL:HashToSortArray(hashTab, sortFunc)`

- 将hashTab转换成有序table，并可以按sortFunc排序，sortFunc可选参数

*示例*
```lua
	local cfg = {["测试表1"] = {"表1", 1},["测试表2"] = {"表2", 2},["测试表3"] = {"表3", 3},["测试表4"] = {"表4", 4},["测试表5"] = {"表5", 5}}
	local function sort_cfg(a, b)
		return a[1] < b[1]
	end
	local new_cfg = SL:HashToSortArray(cfg, sort_cfg)
	SL:dump(new_cfg, "new_cfg")
```
------------
#### 显示提示文本框
- `SL:SHOW_DESCTIP(str, width, pos, anchorPoint)`

|字段 |必选|类型|注释|
|:---- |:-|:--|:---|
|str |是|string|显示文本|
|width |否|int|显示宽度, 默认: 1136|
|pos |否|table|坐标, 默认: {x = 0, y = 0}|
|anchorPoint|否|table|锚点, 默认: {x = 0, y = 1}|

------------
#### 加载文件
- `SL:Require(file, reload)`

|字段 |必选|类型|注释|
|:---- |:-|:--|:---|
|file |是|string|文件名|
|reload |否|boolean|是否重新加载文件，填true时，会先释放文件再加载|

- `SL:RequireFile(file)`

- DEBUG下默认重新加载文件

|字段 |必选|类型|注释|
|:---- |:-|:--|:---|
|file |是|string|文件名|

#### 拆解文件 [3.40.4版本]
- `SL:LoadTxtFile(path, delimiter, callBack)`

- 以指定分隔符拆解一个文件

|字段 |必选|类型|注释|
|:---- |:-|:--|:---|
|path |是|string|文件路径|
|delimiter |否|string|指定分隔符|
|callback |是|function|拆解回调方法 传入拆分后table参数|

*示例 *
```
	local function callback(data)
        SL:PrintTable(data, "LINE======")
    end
    SL:LoadTxtFile("data_config/msg_decoder_config.txt", "#", callback)
```


------------
#### 数字转换成万、亿单位
- `SL:GetSimpleNumber(num, places)`

|字段 |必选|类型|注释|
|:---- |:-|:--|:---|
|num |是|int|数值|
|places |否|int|显示小数点后几位数 [3.40.3版本]|

- 将数字 num 转换成 xx万、xx亿

------------
#### 血量单位显示 
- ` SL:HPUnit(hp, pointBit)`

- 将血量数值转换有单位显示 过十亿(单位：E)   10w-99999w(单位：W）

|字段 |必选|类型|注释|
|:---- |:-|:--|:---|
|hp |是|int|血量数值|
|pointBit |否|int|显示小数点后几位, 默认保留后两位|

-----------
#### 中文转换成竖着显示
- `SL:ChineseToVertical(str)`

------------
#### 阿拉伯数字转中文大写
- `SL:NumberToChinese(num)`

------------
#### 获取字符串的byte长度
- `SL:GetUTF8ByteLen(str)`

------------
#### 时间格式化成字符串显示
- `SL:TimeFormatToStr(time)`

- 将时间 time 大于 1 天时转换成 xx天xx时xx分， 否则 xx:xx:xx

- `SL:SecondToHMS(sec, isToStr, isSimple)` [3.40.2版本]

- 秒转时分秒

|字段 |必选|类型|注释|
|:---- |:-|:--|:---|
|sec |是|int|秒数|
|isToStr |否|boolean|是否转成字符串输出, 空或false则返回table <br>{d = 天数, h = 小时, m = 分钟, s = 秒}|
|isSimple |否|boolean|是否简化字符串[基于isToStr 为 true]|

* 返回字符串格式 : xx天xx时xx分xx秒

------------
#### 阿拉伯数字转中文大写
- `SL:NumberToChinese(num)`

------------
#### 数字转化为千分位字符串
- `SL:GetThousandSepString(num)`

* 返回字符串格式 : 例: 10,000,000

------------
#### lua table转成config配置表
- `SL:SaveTableToConfig(tab, name, destPath, sortFunc)`

|字段 |必选|类型|注释|
|:---- |:-|:--|:---|
|tab |是|table|需要转换的table|
|name |是|string|转出文件名|
|destPath |否|string|文件保存的路径, 默认目录：dev/scripts/game_config/|
|sortFunc |否|function|外层排序函数|

------------
#### 十六进制转十进制
- `SL:HexToInt(hexStr)`

------------
#### MD5加密
- `SL:GetStrMD5(str)`

------------
#### UTF8转GBK编码[3.40.8版本]
- `SL:UTF8ToGBK(str)`

------------
#### GBK转UTF8编码 [3.40.8版本]
- `SL:GBKToUTF8(str)`


------------
#### 计算两坐标间的平方距离 [3.40.3版本]
- `SL:GetPointDistanceSQ(pt1, pt2)`

|字段 |必选|类型|注释|
|:---- |:-|:--|:---|
|pt1 		 |是|table|起始坐标 GUI:p(x, y) 或 <br>{x = x, y = y}|
|pt2 		 |是|table|结束坐标 GUI:p(x, y) 或 <br>{x = x, y = y}|


------------
#### 计算两坐标间的距离 [3.40.3版本]
- `SL:GetPointDistance(pt1, pt2)`

|字段 |必选|类型|注释|
|:---- |:-|:--|:---|
|pt1 		 |是|table|起始坐标 GUI:p(x, y) 或 <br>{x = x, y = y}|
|pt2 		 |是|table|结束坐标 GUI:p(x, y) 或 <br>{x = x, y = y}|

------------
#### 计算向量长度 [3.40.3版本]
- `SL:GetPointLength(pt)`

|字段 |必选|类型|注释|
|:---- |:-|:--|:---|
|pt 		 |是|table|GUI:p(x, y) 或 <br>{x = x, y = y}|

------------
#### 计算向量长度平方 [3.40.3版本]
- `SL:GetPointLengthSQ(pt)`

|字段 |必选|类型|注释|
|:---- |:-|:--|:---|
|pt 		 |是|table|GUI:p(x, y) 或 <br>{x = x, y = y}|

------------
#### 计算两点中心点坐标 [3.40.3版本]
- `SL:GetMidPoint(pt1, pt2)`

|字段 |必选|类型|注释|
|:---- |:-|:--|:---|
|pt1 		 |是|table|坐标 GUI:p(x, y) 或 <br>{x = x, y = y}|
|pt2 		 |是|table|坐标 GUI:p(x, y) 或 <br>{x = x, y = y}|

------------
#### 计算两点相加坐标 [3.40.3版本]
- `SL:GetAddPoint(pt1, pt2)`

|字段 |必选|类型|注释|
|:---- |:-|:--|:---|
|pt1 		 |是|table|坐标 GUI:p(x, y) 或 <br>{x = x, y = y}|
|pt2 		 |是|table|坐标 GUI:p(x, y) 或 <br>{x = x, y = y}|

------------
#### 计算两点相减坐标 [3.40.3版本]
- `SL:GetSubPoint(pt1, pt2)`
- pt1坐标 减 pt2坐标

|字段 |必选|类型|注释|
|:---- |:-|:--|:---|
|pt1 		 |是|table|坐标 GUI:p(x, y) 或 <br>{x = x, y = y}|
|pt2 		 |是|table|坐标 GUI:p(x, y) 或 <br>{x = x, y = y}|

------------
#### 标准向量化坐标 [3.40.3版本]
- `SL:GetNormalizePoint(pt)`

|字段 |必选|类型|注释|
|:---- |:-|:--|:---|
|pt 		 |是|table|坐标 GUI:p(x, y) 或 <br>{x = x, y = y}|

------------
#### 计算两向量夹角弧度值 [3.40.3版本]
- `SL:GetPointAngle(pt1, pt2)`

|字段 |必选|类型|注释|
|:---- |:-|:--|:---|
|pt1 		 |是|table|坐标 GUI:p(x, y) 或 <br>{x = x, y = y}|
|pt2 		 |是|table|坐标 GUI:p(x, y) 或 <br>{x = x, y = y}|

------------
#### 计算两向量夹角角度值 [3.40.3版本]
- `SL:GetPointRotate(pt1, pt2)`

|字段 |必选|类型|注释|
|:---- |:-|:--|:---|
|pt1 		 |是|table|坐标 GUI:p(x, y) 或 <br>{x = x, y = y}|
|pt2 		 |是|table|坐标 GUI:p(x, y) 或 <br>{x = x, y = y}|

------------
#### 计算自身弧度值 [3.40.3版本]
- `SL:GetPointAngleSelf(pt)`

|字段 |必选|类型|注释|
|:---- |:-|:--|:---|
|pt 		 |是|table|坐标 GUI:p(x, y) 或 <br>{x = x, y = y}|

------------
#### 计算自身角度值 [3.40.3版本]
- `SL:GetPointRotateSelf(pt)`

|字段 |必选|类型|注释|
|:---- |:-|:--|:---|
|pt 		 |是|table|坐标 GUI:p(x, y) 或 <br>{x = x, y = y}|

```
	-- 获取坐标 pt1 到 pt2 的角度值
	local pt1 = GUI:p(100, 100)
	local pt2 = GUI:p(100, 200)
	local p = SL:GetSubPoint(pt2, pt1)
	local rotate = SL:GetPointRotateSelf(p)
	SL:Print(rotate)
	
	-- 两向量夹角 角度值
	local tRotate = SL:GetPointRotate(pt1, pt2)
	SL:Print(tRotate)
```
------------
#### 获取高16位值 [3.40.4版本]
- `SL:GetH16Bit(value)`

#### 获取低16位值 [3.40.4版本]
- `SL:GetL16Bit(value)`

------------
#### 跳转到某个超链
- `SL:JumpTo(id)`

- id : 对应界面的跳转id
*跳转id参考如下: *
```
		Equip               = 1,            -- 角色-装备
		State               = 2,            -- 角色-状态
		Attri               = 3,            -- 角色-属性
		Skill               = 4,            -- 角色-技能
		Title               = 5,            -- 角色-装备
		BestRing            = 6,            -- 角色-首饰盒
		Bag                 = 7,            -- 背包
		Stall               = 8,            -- 摆摊
		StoreHot            = 9,            -- 商城-热销
		StoreBeauty         = 10,           -- 商城-装饰
		StoreEngine         = 11,           -- 商城-功能
		StoreFestival       = 12,           -- 商城-节日
		GuildMain           = 13,           -- 行会-主界面
		GuildMember         = 14,           -- 行会成员列表
		GuildList           = 15,           -- 行会列表
		Mail                = 16,           -- 邮件
		Team                = 17,           -- 组队
		NearPlayer          = 18,           -- 附近玩家

		Setting             = 23,           -- 设置
		MiniMap             = 24,           -- 小地图
		SkillSetting        = 25,           -- 技能设置
		StoreRecharge       = 26,           -- 充值
		Auction             = 27,           -- 拍卖行
		Friend              = 28,           -- 好友
		ExitToRole          = 29,           -- 小退
		GuildCreate         = 30,           -- 行会创建
		Guild               = 31,           -- 智能行会界面
		Rank                = 32,           -- 排行榜
		Trade               = 33,           -- 面对面交易 请求
		ForceExitToRole     = 34,           -- 强制小退
		TradingBank         = 35,           -- 交易行
		GuideEnter          = 36,           -- 引导进入
		SuperEquip          = 37,           -- 角色-神装
		HeroEquip           = 41,           -- 英雄-装备
		HeroState           = 42,           -- 英雄-状态
		HeroAttri           = 43,           -- 英雄-属性
		HeroSkill           = 44,           -- 英雄-技能
		HeroTitle           = 45,           -- 英雄-称号
		HeroBestRing        = 46,           -- 英雄-首饰盒
		HeroBag             = 47,           -- 英雄-背包
		HeroSuperEquip      = 48,           -- 英雄-神装
		ReinAttrPoint       = 51,           -- 转生属性点
		Chat                = 52,           -- 聊天
		PCPrivate           = 53,           -- PC 私聊记录页

		MagicJointAttack    = 99,           -- 释放合击

		AssistChange        = 110,          -- 主界面-任务栏
		Box996              = 111,          -- 盒子称号
		MainMiniMapChange   = 112,          -- 小地图伸缩
		PCResolution        = 113,          -- PC 分辨率设置
		ChatExtendEmoj      = 114,          -- 角色-表情
		ChatExtendBag       = 115,          -- 聊天小框-背包
		MainNear            = 116,          -- 主界面-附近列表
		CallPay             = 117,          -- 调用-支付

		SettingBasic        = 300,          -- 基础设置
		SettingWindowRange  = 301,          -- 视距
		SettingFight        = 302,          -- 战斗
		SettingProtect      = 303,          -- 保护
		SettingAuto         = 304,          -- 挂机
		SettingHelp         = 305,          -- 帮助

		KeFu                = 310,          -- 调用客服界面
		Compound            = 2201,         -- 合成
		
		PlayerInternalState     = 401,      -- 人物内功状态
		PlayerInternalSkill     = 402,      -- 人物内功技能
		PlayerInternalMeridian  = 403,      -- 人物内功经络
		PlayerInternalCombo     = 404,      -- 人物内功连击

		HeroInternalState       = 501,      -- 英雄内功状态
		HeroInternalSkill       = 502,      -- 英雄内功技能
		HeroInternalMeridian    = 503,      -- 英雄内功经络
		HeroInternalCombo       = 504,      -- 英雄内功连击
		
		ReviewGift = 311, -- 好评有礼
		Community = 320, -- 社区帖子
```
------------
#### 退出到选角界面
- `SL:ExitToRoleUI()`

- 小退时, 有弹窗提示

- `SL:ForceExitToRoleUI()`

- 强制小退, 无弹窗提示

------------
#### 退出到登录界面
- `SL:ExitToLoginUI()`

#### 退出游戏 [3.40.8版本]
- `SL:ExitGame()`
------------
#### 发送GM命令到聊天
- `SL:SendGMMsgToChat(msg)`

- msg : 字符串

------------
#### 创建一个红点到节点
- `SL:CreateRedPoint(targetNode, offset)`

- 返回红点 widget

|字段 |必选|类型|注释|
|:---- |:-|:--|:---|
|targetNode |是|widget|目标控件|
|offset |否|table|偏移位置 例: {x = 5, y = 5}|

------------
#### 设置文本样式(按钮、文本)
- `SL:SetColorStyle(widget, colorID)`

- widget ：按钮或者文本对象

- colorID ：0 - 255 色值ID 

------------
#### 获取对应色值ID的配置
- `SL:GetColorCfg(colorID)`

------------
#### 检查是否满足条件
- `SL:CheckCondition(conditionStr)`
- 返回值 : true / false

------------
#### 显示气泡提醒
- `SL:AddBubbleTips(id, path, callback)`

- id ：气泡ID

- path：气泡图片资源路径

- callback：气泡点击回调

```lua
 SL:AddBubbleTips(996, "private/main/bubble_tips/1900012605_1.png", function ()
 SL:DelBubbleTips(996)
 end)
```
------------
#### 删除气泡提醒
- `SL:DelBubbleTips(ID)`

- id ：气泡ID

------------
#### 重新加载地图
- `SL:ReloadMap()`

------------
#### 请求HTTP Get方式
- `SL:HTTPRequestGet(url, httpsCB)`

|参数名|必选|类型|说明|
|:---- |:---|:----- |----- |
|url |是 |string | 链接地址|
|httpsCB|是 |function | 回调函数 |

*示例*
```
	local function httpsCB(success, response)
		-- success: boolean 请求是否成功
		-- response: string 请求返回数据
	end
	SL:HTTPRequestGet("https://www.baidu.com/", httpsCB)
```

------------
#### 请求HTTP Post方式
- `SL:HTTPRequestPost(url, httpsCB, suffix, head, notForce)`

|参数名|必选|类型|说明|
|:---- |:---|:----- |----- |
|url |是 |string | 链接地址|
|httpsCB |是 |function | 回调函数|
|suffix |是 |string | 请求信息|
|head |否 |table | 请求头|
|notForce |否 |boolean | 不强行设置header "Content-type"为"application/x-www-form-urlencoded" [3.40.7版本新增]|

*示例*
```
	local function httpsCB(success, response)
		-- success: boolean 请求是否成功
		-- response: string 请求返回数据
	end
	local suffix = "appid=1&device_id=PCDV-6ct5fzZ&game_id=1&platform=0&type=1&username=wuuhui&sign=30a51e6"
	SL:HTTPRequestPost("https://www.baidu.com/", httpsCB, suffix)
```

-----------
#### 本地公告展示 [3.40.3版本]
- `SL:ShowLocalNoticeByType(data)`

|参数名|必选|类型|说明|
|:---- |:---|:----- |----- |
|data |是 |table | 具体参数配置|

参数说明： 
```
	Type 	-- 公告类型
	【
 4: 顶部跑马灯公告 (Msg、 FColor、 BColor) 5: 屏幕跑马灯公告 可控制Y轴坐标 (Msg、 FColor、 BColor、 Y、 Count)
 6: 聊天上方公告 (Msg、 FColor、 BColor、 Time、 Label) 9: 普通通用提示 (Msg) 
 10: 可控制X轴Y轴公告 (Msg、 FColor、 BColor、 X、 Y) 11: 屏幕跑马灯公告 (系统公告) (Type、 Msg、 FColor、 BColor) 
 12: 系统频道公告 (Msg、 FColor、 BColor) 13: 带缩放效果的公告 可设置Y轴 (Msg、 FColor、 BColor、Y)
	】
	Msg 	-- 提示内容
	FColor 	-- 文字色值ID
	BColor 	-- 背景色值ID
	X 	-- 坐标X
	Y 	-- 坐标Y
	Time 	-- 倒计时
	Count 	-- 播放次数
	Label 	-- 响应Link

```

#### 震屏 [3.40.3版本]
- `SL:ShakeScene(time, distance)`

|参数名|必选|类型|说明|
|:---- |:---|:----- |----- |
|time |否 |int | 震动时间 (毫秒)|
|distance |否 |int | 震动距离|

例 :
```
	-- 无参默认 time为700 、distance为10 
	SL:ShakeScene()
```


**------------**
#游戏事件函数
#### 注册控件事件
- `SL:RegisterWndEvent(widget, desc, msgtype, callback)`

|参数名|必选|类型|说明|
|:---- |:---|:----- |----- |
|widget |是 |object |控件对象|
|msg |是 |string | 描述|
|msgtype|是 |int | 窗体事件id|
|callback|是 |function | 回调函数|
* **！同一控件注册不同事件需统一描述**

```
	窗口事件 msgtype
	WND_EVENT_MOUSE_LB_DOWN             = 1                                         -- 鼠标左键按下事件
	WND_EVENT_MOUSE_LB_UP               = 2                                         -- 鼠标左键弹起事件
	WND_EVENT_MOUSE_LB_CLICK            = 3                                         -- 鼠标左键点击事件
	WND_EVENT_MOUSE_LB_DBCLICK          = 4                                         -- 鼠标左键双击事件
	WND_EVENT_MOUSE_RB_DOWN             = 5                                         -- 鼠标右键按下事件
	WND_EVENT_MOUSE_RB_UP               = 6                                         -- 鼠标右键弹起事件         
	WND_EVENT_MOUSE_RB_CLICK            = 7                                         -- 鼠标右键点击事件
	WND_EVENT_MOUSE_RB_DBCLICK          = 8                                         -- 鼠标右键双击事件
	WND_EVENT_MOUSE_MOVE                = 9                                         -- 鼠标移动事件
	WND_EVENT_MOUSE_WHEEL               = 10                                        -- 鼠标滚轮滚动事件
	WND_EVENT_MOUSE_IN                  = 11                                        -- 鼠标进入控件事件
	WND_EVENT_MOUSE_OUT                 = 12                                        -- 鼠标离开控件事件
	
	WND_EVENT_WND_VISIBLE               = 21                                        -- 可见状态发生变化事件
	WND_EVENT_WND_POS_CHANGE            = 22                                        -- 控件位置发生变化事件
	WND_EVENT_WND_SIZECHANGE            = 23                                        -- 窗口大小发生变化事件
	WND_EVENT_WND_DESTROY               = 24                                        -- 窗体被销毁事件

```
*示例*
```
 SL:RegisterWndEvent(btn, "npc", WND_EVENT_MOUSE_LB_UP, function()
		SL:Print("2")
	end)
```

------------
#### 注销控件事件
- `SL:UnRegisterWndEvent(widget, desc, msgtype)`

|参数名|必选|类型|说明|
|:---- |:---|:----- |----- |
|widget |是 |object |控件对象|
|msg |是 |string | 描述|
|msgtype|是 |int | 窗体事件id|

*示例*
```
 SL:UnRegisterWndEvent(btn, "npc", WND_EVENT_MOUSE_LB_UP)
```

------------
#### 窗体控件自定义属性

* 添加窗体控件自定义属性 *
- `SL:AddWndProperty(widget, desc, key, value)`

* 删除窗体控件自定义属性*
- `SL:DelWndProperty(widget, desc, key)`

* 获取窗体控件自定义属性*
- `SL:GetWndProperty(widget, desc, key)`

|参数名|必选|类型|说明|
|:---- |:---|:----- |----- |
|widget |是 |object |控件对象 |
|desc |是 |string |描述 |
|key |是 |string |属性名称|
|value |是 |any |属性值 |

*示例*

```
	SL:AddWndProperty(btn, "test", "key", 1)
	local a = SL:GetWndProperty(btn, "test", "key")
	SL:Print(a, type(a))
	SL:DelWndProperty(btn, "test", "key")
```

**------------**
#定时器
#### 开启一个定时器
- `SL:Schedule(callback, time)`

------------
#### 停止一个定时器
- `SL:UnSchedule(scheduleID)`

------------
#### 开启一个单次定时器
- `SL:ScheduleOnce(callback, time)`

------------
#### 开启一个定时器, 绑定node节点
- `SL:schedule(node, callback, time)`

------------
#### 开启一个单次定时器, 绑定node节点
- `SL:scheduleOnce(node, callback, time)`

------------

*示例*

```
	local time = 0.5
	local function callback()
		SL:Print("callback...")
	end

	-- 每隔0.5s执行一次 callback
	local sch1 = SL:Schedule(callback, time)

	-- 停止上面的定时器 sch1
	SL:UnSchedule(sch1)

	-- 0.5s后执行一次 callback
	SL:ScheduleOnce(callback, time)

	-- 创建一个Node节点
	local node = GUI:Node_create(parent, "Node", 0 , 0)
	-- node 节点每隔0.5s执行一次 callback
	SL:schedule(node, callback, time)

	-- node 节点0.5s后执行一次 callback
	SL:scheduleOnce(node, callback, time)

	-- node 节点取消定时器操作
	GUI:stopAllActions(node)
```

**------------**
#引导相关
#### 打开引导
- `SL:StartGuide(data)`

- 返回值 : 引导对象

|参数名|必选|类型|说明|
|:-- |:---|:--- |----- |
|data |是 |table| 数据结构如下, 参考示例|

*table特殊参数*
 **mainIdx** — int 如若指引界面加在主界面节点 需要配置对应标识 :
`1 --左上 2 --中上 3 --右上 4 --左下 5 --中下 6 --右下`

*示例 1 ：*
```
	local function callback()
		SL:Print("callback".....)
	end
	local data = {}
	data.dir = 8 -- 方向（1~8）从左按瞬时针
	data.guideWidget = btn_close -- 当前节点
	data.guideParent = _parent -- 父窗口
	data.guideDesc = "测试" -- 文本描述
	data.clickCB = callback -- 回调
	data.autoExcute = 3 -- 自动执行秒数
	data.isForce = true -- 强制引导
	data.hideMask = true -- 隐藏蒙版 [仅不强制引导时有效]

	SL:StartGuide(data)
```

* **针对引导一些引擎原生界面 必需参数 :**

	id — int 提供的原生界面指引ID
	param — int 指引参数 提供的一些原生界面对应位置指引所需参数 比如任务ID
	
*示例 2 ：*
```
	SL:StartGuide({
		id = 1,				-- 背包引导窗口ID
		param = 2682001,		-- 背包物品唯一ID
		guideDesc = "测试引导"
    })
```

#### 关闭引导
- `SL:CloseGuide(guide)`

- 参数 : 传入开始引导返回的 引导对象


**------------**
#本地存储

#### 存储字符到本地
- `SL:SetLocalString(key, data)`

* 存储数据到本地，存储的文件名为："GUIStorage" + 角色ID

|参数名|必选|类型|说明|
|:---- |:--- |:--- |----- |
|key |是 |任意类型 |字段名 |
|data |是 |table、int、string| 数据|

*示例*
```
	-- 把数据 t 存储到本地配置的 key 字段里
	local t = {
		val1 = "111", val2 = "222"
	}
 local jsonStr = SL:JsonEncode(t)
 SL:SetLocalString("key", jsonStr)
```

------------
#### 从本地读取字符
- `SL:GetLocalString(key)`

* 读取存储到本地的key数据

* 返回值 : string

|参数名|必选|类型|说明|
|:----|:---|:--- |----- |
|key |是 |任意类型 |字段名 |

*示例*
```
	-- 把数据从本地存储配置中取出来
	local data = {}
 local jsonStr = SL:GetLocalString("key")
 if jsonStr and string.len(jsonStr) > 0 then
 local jsonData = SL:JsonDecode(jsonStr)
 if jsonData then
 data = jsonData
 end
 end
	SL:dump( data )
```

**------------**
# 背包常用函数 [3.40.2版本]
#### 背包刷新
- `SL:RefreshBagPos()`

#### 使用物品 
- `SL:UseItemByIndex(Index)`

|参数名|必选|类型|说明|
|:----|:---|:--- |----- |
|Index|是 |int |物品Index |

#### 批量勾选背包物品 [3.40.3版本]
- `SL:SetBagItemChoose(data)`

|参数名|必选|类型|说明|
|:----|:---|:--- |----- |
|data|是 |table |物品唯一ID 数组 |

#### 丢弃物品 [3.40.3版本]
- `SL:IntoDropBagItem(itemData)`

|参数名|必选|类型|说明|
|:----|:---|:--- |----- |
|itemData|是 |table |装备数据 |

**------------**
# 装备常用函数
#### 检测人物是否可穿戴
- `SL:CheckItemUseNeed(itemData)`

*参数： itemData 装备数据*

------------
#### 检测英雄是否可穿戴
- `SL:CheckItemUseNeed_Hero(itemData)`

*参数： itemData 装备数据*

------------
#### 获得需要比较的装备
- `SL:GetDiffEquip(itemData, isHero)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|itemData |是 |table |装备数据|
|isHero |否 |boolean |是否对比英雄|

*返回值： table, 具体用法参考官方 GUILayout/ItemTips.lua *

------------
#### 对比传入装备和自身穿戴的装备
- `SL:CheckEquipPowerThanSelf(itemData, from)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|itemData |是 |table |装备数据|
|from |否 |int |物品来自(界面位置), 可参照元变量"ITEMFROMUI_ENUM"|

*返回值： table

------------
#### 人物装备穿戴 [3.40.2版本]
- `SL:TakeOnPlayerEquip(itemData, pos, isFromHero)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|itemData |是 |table |装备数据|
|pos |是 |int |装备位置|
|isFromHero|否 |boolean |是否来自英雄背包|

------------
#### 人物装备脱下 [3.40.2版本]
- `SL:TakeOffPlayerEquip(itemData, isToHero)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|itemData |是 |table |装备数据|
|isToHero |否 |boolean |是否脱到英雄背包|

------------
#### 英雄装备穿戴 [3.40.2版本]
- `SL:TakeOnHeroEquip(itemData, pos, isFromPlayer)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|itemData |是 |table |装备数据|
|pos |是 |int |装备位置|
|isFromPlayer|否 |boolean |是否来自人物背包|

------------
#### 英雄装备脱下 [3.40.2版本]
- `SL:TakeOffHeroEquip(itemData, isToPlayer)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|itemData |是 |table |装备数据|
|isToPlayer|否 |boolean |是否脱到人物背包|



**------------**
# 界面相关 Menulayer
- `SL:CheckMenuLayerConditionByID(layerID)`

*通过 cfg_menulayer 表中的界面ID检测该界面的条件配置，是否满足显示*

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|layerID |是 |int |cfg_menulayer 表中的界面ID|

*返回值： boolean*

------------
- `SL:OpenMenuLayerByID(layerID，parent， extent)`

*通过 cfg_menulayer 表中的界面ID打开该界面*

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|layerID |是 |int |cfg_menulayer 表中的界面ID|
|parent |是 |object |挂接点 |
|extent |否 |int |可选参数 |

------------
- `SL:CloseMenuLayerByID(layerID)`

*通过 cfg_menulayer 表中的界面ID关闭该界面*

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|layerID |是 |int |cfg_menulayer 表中的界面ID|

*返回值： boolean*

------------
### 打开、关闭相关功能界面
####设置界面
- `SL:OpenSettingUI(pageID)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|pageID |否 |int |页签ID 不填默认基础设置<br>1 : 基础设置<br>2 : 视距<br>3 : 战斗<br>4 : 保护<br>5 : 挂机<br>6 : 帮助|

- `SL:CloseSettingUI()`

####行会界面
- `SL:OpenGuildMainUI(pageID)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|pageID |否 |int |页签ID 不填默认行会主页<br>1 : 主页<br>2 : 成员<br>3 : 列表|

- `SL:CloseGuildMainUI()`
####行会申请界面
- `SL:OpenGuildApplyListUI()`

- `SL:CloseGuildApplyListUI()`

####行会创建界面
- `SL:OpenGuildCreateUI()`

- `SL:CloseGuildCreateUI()`

####行会结盟申请界面
- `SL:OpenGuildAllyApplyUI()`

- `SL:CloseGuildAllyApplyUI()`

####行会宣战/结盟界面 [关闭]
- `SL:CloseGuildWarSponsorUI()`

####人物背包
- `SL:OpenBagUI(data)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|data |否 |table |pos : 背包打开位置 <br>bag_page : 背包打开页签ID|
例:
```
	local data = {pos = {x = 200, y = 0}, bag_page = 2}
 SL:OpenBagUI(data) 
```

- `SL:CloseBagUI()`

####英雄背包
- `SL:OpenHeroBagUI()`

- `SL:CloseHeroBagUI()`

####拍卖行
- `SL:OpenAuctionUI()`

- `SL:CloseAuctionUI()`

####摆摊界面
- `SL:OpenStallLayerUI()`

- `SL:CloseStallLayerUI()`

####玩家交易界面
- `SL:OpenTradeUI()`

- `SL:CloseTradeUI()`

####排行榜
- `SL:OpenRankUI(type)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|type |否 |int |打开 指定页签ID|

- `SL:CloseRankUI()`

####聊天界面(手机端)
- `SL:OpenChatUI()`

- `SL:CloseChatUI()`

####聊天扩展框
- `SL:OpenChatExtendUI(index)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|index |否 |int |打开 指定分组 <br> 1 : 快捷命令<br>2 : 表情<br> 3 : 背包|

- `SL:CloseChatExtendUI()`

####社区帖子 [3.40.3版本]
* 需要后台配置社区地址
- `SL:OpenCommunityUI()`

- `SL:CloseCommunityUI()`

####交易行
- `SL:OpenTradingBankUI()`

- `SL:CloseTradingBankUI()`

####商城
- `SL:OpenStoreUI(page)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|page |否 |int |打开 商城对应分页|

- `SL:CloseStoreUI()`

####商城商品购买框
- `SL:OpenStoreDetailUI(storeIndex, limitStr)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|storeIndex |是 |int |商品index cfg_store商城表配置的id|
|limitStr|否|string|超出限制购买的提示|

- `SL:CloseStoreDetailUI()`

####技能配置界面
- `SL:OpenSkillSettingUI(data)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|data |！PC端必填 |table |对应技能数据 打开技能快捷键配置页|

- `SL:CloseSkillSettingUI()`

####社交
- `SL:OpenSocialUI(page)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|page |否 |int |页签ID ( 不填默认1附近 )<br> 1附近玩家、2组队、3好友、4邮件|

- `SL:CloseSocialUI()`

####分辨率修改界面(PC端)
- `SL:OpenResolutionSetUI()`

- `SL:CloseResolutionSetUI()`

####玩家角色界面
- `SL:OpenMyPlayerUI(data)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|data |否 |table |extent: 子页id<br> 1装备、2状态、3属性、4技能、6称号、11时装<br>isFast: boolen 是否快捷键打开|
*例 :*
```
	SL:OpenMyPlayerHeroUI({extent = 1})
```

- `SL:CloseMyPlayerUI()`

- `SL:CloseMyPlayerPageUI(data)` 

 *移除对应子页id内容*

####查看他人角色界面
- `SL:OpenOtherPlayerUI(data)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|data |否 |table |extent: 子页id<br> 1装备、2状态、3属性、4技能、6称号、11时装|

- `SL:CloseOtherPlayerUI()`

- `SL:CloseOtherPlayerPageUI(data)` 

 *移除对应子页id内容*

####英雄角色界面
- `SL:OpenMyPlayerHeroUI(data)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|data |否 |table |extent: 子页id<br> 1装备、2状态、3属性、4技能、6称号、11时装|

- `SL:CloseMyPlayerHeroUI()`

- `SL:CloseMyPlayerHeroPageUI(data)` 

 *移除对应子页id内容*

####查看他人英雄界面
- `SL:OpenOtherPlayerHeroUI(data)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|data |否 |table |extent: 子页id<br> 1装备、2状态、3属性、4技能、6称号、11时装|

- `SL:CloseOtherPlayerHeroUI()`

- `SL:CloseOtherPlayerHeroPageUI(data)` 

 *移除对应子页id内容*

####交易行查看他人界面
- `SL:CloseTradingBankPlayerPageUI(data)`

 *移除他人角色对应子页id内容*

- `SL:CloseTradingBankHeroPageUI(data)`

 *移除他人英雄对应子页id内容*

####首饰盒界面
- `SL:OpenBestRingBoxUI(param)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|param |是 |int |param: <br>1: 自己人物<br>2：自己英雄<br>11：其他玩家人物<br>12：其他玩家英雄<br>21：交易行人物<br>22：交易行英雄|

- `SL:CloseBestRingBoxUI(param)`

 *param参数同上*

####打开装备面板
- `SL:OpenPlayerEquipUI(param)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|param |是 |int |param: <br>1: 自己人物<br>2：自己英雄<br>11：其他玩家人物<br>12：其他玩家英雄<br>21：交易行人物<br>22：交易行英雄|

####打开状态面板
- `SL:OpenPlayerBaseAttrUI(param)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|param |是 |int |param: <br>1: 自己人物<br>2：自己英雄<br>11：其他玩家人物<br>12：其他玩家英雄<br>21：交易行人物<br>22：交易行英雄|

####打开属性面板
- `SL:OpenPlayerExtraAttrUI(param)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|param |是 |int |param: <br>1: 自己人物<br>2：自己英雄<br>11：其他玩家人物<br>12：其他玩家英雄<br>21：交易行人物<br>22：交易行英雄|

####打开技能面板
- `SL:OpenPlayerSkillUI(param)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|param |是 |int |param: <br>1: 自己人物<br>2：自己英雄<br>11：其他玩家人物<br>12：其他玩家英雄<br>21：交易行人物<br>22：交易行英雄|

####打开称号面板
- `SL:OpenPlayerTitleUI(param)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|param |是 |int |param: <br>1: 自己人物<br>2：自己英雄<br>11：其他玩家人物<br>12：其他玩家英雄<br>21：交易行人物<br>22：交易行英雄|

####打开时装面板
- `SL:OpenPlayerSuperEquipUI(param)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|param |是 |int |param: <br>1: 自己人物<br>2：自己英雄<br>11：其他玩家人物<br>12：其他玩家英雄<br>21：交易行人物<br>22：交易行英雄|

####打开人物BUFF面板 [3.40.6版本]
- `SL:OpenPlayerBuffUI(param)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|param |是 |int |param: <br>1: 自己人物<br>2：自己英雄<br>11：其他玩家人物<br>12：其他玩家英雄 [英雄BUFF页3.40.8版本新增]|

####称号提示界面
- `SL:OpenTitleTipsUI(data)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|data |是 |table |id: 称号id <br> pos: Tips放置位置<br>type: 1未激活 2已激活<br>time: 时间|

- `SL:CloseTitleTipsUI()`

####他人称号提示界面
- `SL:OpenOtherTitleTipsUI(data)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|data |是 |table |id: 称号id <br> pos: Tips放置位置<br>type: 1未激活 2已激活<br>time: 时间|

- `SL:CloseOtherTitleTipsUI()`

####关闭交易行查看他人容器
- `SL:CloseTradingBankLookPanelUI()`

####关闭交易行查看他人界面
- `SL:CloseTradingBankLookInfoUI()`

####邀请组队界面
- `SL:OpenTeamInvite()`

- `SL:CloseTeamInvite()`

####入队申请列表页
- `SL:OpenTeamApply()`

- `SL:CloseTeamApply()`

####小地图界面
- `SL:OpenMiniMap()`

- `SL:CloseMiniMap()`

####主界面技能按钮区域切换显示
- `SL:OpenGuideEnter(param)`

- `SL:CloseGuideEnter()`

####转生点分配界面
- `SL:OpenReinAttrUI()`

- `SL:CloseReinAttrUI()`

####导航栏栏收缩切换
- `SL:OpenAssistUI()`

- `SL:CloseAssistUI()`

- `SL:SwitchToMainMission()` [3.40.9版本]
* 导航栏切换到任务面板

####主界面小地图收缩切换[手机端]
- ` SL:OpenMiniMapChangeUI()`

- `SL:CloseMiniMapChangeUI()`

####附近展示页
- `SL:OpenMainNearUI()`

- `SL:CloseMainNearUI()`

####直接调用支付
- `SL:OpenCallPayUI()`

####打开客服UI
- `SL:OpenKefuUI()`

####PC端私聊界面
- `SL:OpenPCPrivateUI()`

- `SL:ClosePCPrivateUI()`

####PC端小地图变换
- `SL:OpenPCMiniMapUI()`

####添加好友界面
- `SL:OpenAddFriendUI()`

- `SL:CloseAddFriendUI()`

####添加黑名单界面
- `SL:OpenAddBlackListUI()`

- `SL:CloseAddBlackListUI()`

####好友添加申请页
- `SL:OpenFriendApplyUI()`

- `SL:CloseFriendApplyUI()`

####拍卖行-世界拍卖/行会拍卖
- `SL:OpenAuctionWorldUI(parent, source)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|parent |是 |widget |挂接父节点|
|source|是|int|类别 <br>0: 世界拍卖 <br>1: 行会拍卖|

- `SL:CloseAuctionWorldUI()`

####拍卖行-我的竞拍
- `SL:OpenAuctionBiddingUI(parent)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|parent |是 |widget |挂接父节点|

- `SL:CloseAuctionBiddingUI()`

####拍卖行-我的上架
- `SL:OpenAuctionPutListUI(parent)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|parent |是 |widget |挂接父节点|

- `SL:CloseAuctionPutListUI()`

####拍卖行上架界面
- `SL:OpenAuctionPutinUI(itemData)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|itemData |是 |table |背包物品数据|

- `SL:CloseAuctionPutinUI()`

####拍卖行下架界面
- `SL:OpenAuctionPutoutUI(item)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|item |是 |table |拍卖行上架的物品数据|

- `SL:CloseAuctionPutoutUI()`

####拍卖行竞拍界面
- `SL:OpenAuctionBidUI(item)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|item |是 |table |拍卖行上架的物品数据|

- `SL:CloseAuctionBidUI()`

####拍卖行一口价界面
- `SL:OpenAuctionBuyUI(item)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|item |是 |table |拍卖行上架的物品数据|

- `SL:CloseAuctionBuyUI()`

####拍卖行超时界面
- `SL:OpenAuctionTimeoutUI(item)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|item |是 |table |拍卖行上架的物品数据|

- `SL:CloseAuctionTimeoutUI()`

####合成界面
- `SL:OpenCompoundItemsUI()`

- `SL:CloseCompoundItemsUI()`

####怪物提示列表-设置界面
- `SL:OpenBossTipsUI()`

- `SL:CloseBossTipsUI()`

####拾取列表-设置界面
- `SL:OpenPickSettingUI()`

- `SL:ClosePickSettingUI()`

####保护配置-设置界面
- `SL:OpenProtectSettingUI(data)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|data |是 |table |cfg_setup对应保护配置|

- `SL:CloseProtectSettingUI()`

####增加怪物名字-设置界面
- `SL:OpenAddNameUI(data)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|data |否 |table |ignoreName: boolean 是否是挂机忽略名字|

- `SL:CloseAddNameUI()`

####增加BOSS类型-设置界面
- `SL:OpenAddBossTypeUI()`

- `SL:CloseAddBossTypeUI()`

####技能排行-设置界面
- `SL:OpenSkillRankPanelUI(data)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|data |是 |table |cfg_setup对应保护配置|

- `SL:CloseSkillRankPanelUI(data)`

####新增技能-设置界面
- `SL:OpenSkillPanelUI()`

- `SL:CloseSkillPanelUI()`

####选择下拉框
- `SL:OpenSelectListUI(list, position, cellwidth, cellheight, func)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|list |是 |table |下拉要显示的内容|
|position|是 |table |初始位置 |
|cellwidth|否 |int |单条cell的宽|
|cellheight|否 |int |单条cell的高|
|func |否 |function |回调 选中的编号1~n 0是关闭|

- `SL:CloseSelectListUI()`

####996盒子界面
- `SL:OpenBox996UI(index)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|index|否 [ 3.40.4版本新增参数 ] |int |盒子打开默认分页id<br>1: 特权称号 2: 每日礼包 3: 超级礼包 4: 会员礼包 5: SVIP|

- `SL:CloseBox996UI()`

####英雄状态选择界面
- `SL:OpenHeroStateSelectUI(data)`

- `SL:CloseHeroStateSelectUI(data)`

####打开快捷使用框
- `SL:OpenAutoUseTip(itemData, equipPos, isBook, isHero)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|itemData |是 |table |真实物品数据|
|equipPos |否 |int |物品为装备时装戴的装备位置|
|isBook |否 |boolean|是否是技能书|
|isHero |否 |boolean|是否为英雄|

####关闭快捷使用框
- ` SL:CloseAutoUseTip(makeIndex, isHero)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|makeIndex|是 |int |物品唯一ID|
|isHero |否 |boolean|是否为英雄|

####开宝箱动画页 [3.40.3版本]
- `SL:OpenTreasureBoxShow(itemData)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|itemData |是 |table |宝箱物品数据|

- `SL:CloseTreasureBoxShow()`

####宝箱奖励界面 [3.40.3版本]
- `SL:OpenGoldBoxUI(itemData)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|itemData |是 |table |宝箱物品数据|

- `SL:CloseGoldBoxUI()`

####摇骰子界面 [3.40.4版本]
- `SL:OpenPlayDice(data)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|data |是 |table |字段说明如下|
```
	{
        arr = table 投掷值 {xx, xx}
        count = 数量
        callback = @xxx 脚本触发
    }
```

- `SL:ClosePlayDice()`

#### 求购界面 [3.40.5版本]
- `SL:OpenPurchaseUI()`

- `SL:ClosePurchaseUI()`

#### 求购 - 世界求购 [3.40.5版本]
- `SL:OpenPurchaseWorldUI(parent)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|parent |是 |widget |挂接父节点|

- `SL:ClosePurchaseWorldUI()`


#### 求购 - 我的求购 [3.40.5版本]
- `SL:OpenPurchaseMyUI(parent)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|parent |是 |widget |挂接父节点|

- `SL:ClosePurchaseMyUI()`

#### 求购出售页 [3.40.5版本]
- `SL:OpenPurchaseSellUI(data)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|data |是 |table |单条世界求购数据|

- `SL:ClosePurchaseSellUI()`

#### 求购上架页 [3.40.5版本]
- `SL:OpenPurchasePutInUI()`

- `SL:ClosePurchasePutInUI()`

#### 仓库 - 关闭
- `SL:CloseStorageUI()`

####通用描述Tips
- `SL:OpenCommonDescTipsPop(data)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|data |是 |table |str: 描述内容 <br> worldPos: 提示位置<br> width: 描述内容宽度<br> anchorPoint: 锚点<br>formatWay: 设置为1 解析富文本格式: `<font></font>`[！否则默认解析老脚本富文本`<RText/FCOLOR=254>`] |

```lua
    local data = {width = 1136, str = "测试文本", worldPos = {x = 568, y = 320}, anchorPoint = {x = 0, y = 1}}
    SL:OpenCommonDescTipsPop(data)
```

- `SL:CloseCommonDescTipsPop()`

####通用弹窗
- `SL:OpenCommonTipsPop(data)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|data |是 |table |str: 文本<br>btnType: 按钮类型 int 1:"确定" 2:{"确定","取消"} <br> btnDesc: 按钮描述 table<br> showEdit: 是否显示输入框<br>editParams: 输入框参数table <br>```{ inputMode: 键盘编辑类型, maxLength: 可输入最大长度, str: 默认文本内容}```<br> callback: 按钮回调 [参数1: 点击的按钮id 参数2: 额外参数 table: {editStr=输入框字符串}]|

*例 :*
```
	local data = {}
	data.str = "请输入邀请玩家的名字"
	data.btnType = 2
	data.showEdit = true
	data.callback = function(atype, param)
		if atype == 1 then
			if param and param.editStr and string.len(param.editStr) > 0 then
				SL:RequestInviteJoinTeam(nil, param.editStr)
			end
		end
	end
	SL:OpenCommonTipsPop(data)
```

- `SL:CloseCommonTipsPop()`

####道具装备Tips
- `SL:OpenItemTips(data)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|data |是 |table |itemData: 物品数据 <br> pos: 提示位置<br> from:非必要 物品来自(界面位置), 可参照元变量ITEMFROMUI_ENUM|

- `SL:CloseItemTips()`

####道具拆分弹窗
- `SL:OpenItemSplitPop(itemData)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|itemData |是 |table |物品数据|

- `SL:CloseItemSplitPop()`

####通用功能选择提示
- `SL:OpenFuncDockTips(data)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|data |是 |table |参数说明: <br> type : 类型 可参照元变量DOCKTYPE_NENUM<br> targetId : 选中目标id<br> targetName :目标名称 <br> pos : 展示位置|

示例可参照 MainTarget文件内 点击查看菜单功能。
- `SL:CloseFuncDockTips()`

####NPC进度条提示 [3.40.3版本]
- `SL:OpenProgressBarUI(data)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|data |是 |table |参数说明: <br> time : 时间 <br> msg : 显示内容|

- `SL:CloseProgressBarUI()`

####多条选项弹窗提示 [3.40.3版本]
- `SL:OpenCommonBubbleInfo(data)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|data |是 |table |参数说明: <br> pos : 坐标 <br> list : 多条选项列表<br>[单条数据参考: <br>{str = 文本, agreeCall = 同意按钮回调(function), disAgreeCall = 拒绝回调(function)}<br>]|

- `SL:CloseCommonBubbleInfo()`

*例 :*
```
	local tt = {
		[1] = "11111",
		[2] = "22222",
		[3] = "33333",
	}

	local data = {}
	data.pos = {x = 200, y = 400}
	data.list = {}
	for _, v in pairs(tt) do
		local info = {}
		info.str = v
		info.agreeCall = function()
			SL:Print("AgreeCall____" .. v)
		end
		info.disAgreeCall = function()
			SL:Print("disAgreeCall___" .. v)
		end
		table.insert(data.list, info)
	end
	SL:OpenCommonBubbleInfo(data)
```

#### 打开好评有礼 [3.40.3版本]
- `SL:ReviewGift()`

------------
### 打开网址/链接 [3.40.3版本]
- `SL:OpenURL(url)`

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|url |是 |string |网址/链接|

*示例*
```
	SL:OpenURL("https://www.baidu.com/")
```


**------------**
#颜色
- `SL:GetColorByStyleId(id)`

*把 cfg_colour_style 表中的对应 id 的颜色转换成 RGB 格式*

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|id |是 |int |cfg_colour_style 表中的对应 id|

*返回值类型： table {r = 255, g = 255, b = 255} *

------------
- `SL:GetHexColorByStyleId(id)`

*把 cfg_colour_style 表中的对应 id 的颜色转换成 16进制 格式 *

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|id |是 |int |cfg_colour_style 表中的对应 id|

* 返回值类型： string "#FFFFFF"

------------
- `SL:GetSizeByStyleId(id)`

*把 cfg_colour_style 表中的对应 id 的颜色大小 *

* 返回值类型： int size

------------
- `SL:GetColorHexFromRGB(color3B)`

* Color3B颜色转化为hex 16进制

|参数名|必选|类型|说明|
|:---- |:---|:--- |----- |
|color3B |是 |table |例: {r = 255, g = 255, b = 255}|

* 返回值类型： string "#FFFFFF"

##颜色Id(0-255) 对应 16进制Hex(#000000-#ffffff)
```
 Id：(0) Hex：(#000000)
 Id：(1) Hex：(#800000)
 Id：(2) Hex：(#008000)
 Id：(3) Hex：(#808000)
 Id：(4) Hex：(#000080)
 Id：(5) Hex：(#800080)
 Id：(6) Hex：(#008080)
 Id：(7) Hex：(#c0c0c0)
 Id：(8) Hex：(#558097)
 Id：(9) Hex：(#9db9c8)
 Id：(10) Hex：(#7b7373)
 Id：(11) Hex：(#2d2929)
 Id：(12) Hex：(#5a5252)
 Id：(13) Hex：(#635a5a)
 Id：(14) Hex：(#423939)
 Id：(15) Hex：(#1d1818)
 Id：(16) Hex：(#181010)
 Id：(17) Hex：(#291818)
 Id：(18) Hex：(#100808)
 Id：(19) Hex：(#f27971)
 Id：(20) Hex：(#e1675f)
 Id：(21) Hex：(#ff5a5a)
 Id：(22) Hex：(#ff3131)
 Id：(23) Hex：(#d65a52)
 Id：(24) Hex：(#941000)
 Id：(25) Hex：(#942918)
 Id：(26) Hex：(#390800)
 Id：(27) Hex：(#731000)
 Id：(28) Hex：(#b51800)
 Id：(29) Hex：(#bd6352)
 Id：(30) Hex：(#421810)
 Id：(31) Hex：(#ffaa99)
 Id：(32) Hex：(#5a1000)
 Id：(33) Hex：(#733929)
 Id：(34) Hex：(#a54a31)
 Id：(35) Hex：(#947b73)
 Id：(36) Hex：(#bd5231)
 Id：(37) Hex：(#522110)
 Id：(38) Hex：(#7b3118)
 Id：(39) Hex：(#2d1810)
 Id：(40) Hex：(#8c4a31)
 Id：(41) Hex：(#942900)
 Id：(42) Hex：(#bd3100)
 Id：(43) Hex：(#c67352)
 Id：(44) Hex：(#6b3118)
 Id：(45) Hex：(#c66b42)
 Id：(46) Hex：(#ce4a00)
 Id：(47) Hex：(#a56339)
 Id：(48) Hex：(#5a3118)
 Id：(49) Hex：(#2a1000)
 Id：(50) Hex：(#150800)
 Id：(51) Hex：(#3a1800)
 Id：(52) Hex：(#080000)
 Id：(53) Hex：(#290000)
 Id：(54) Hex：(#4a0000)
 Id：(55) Hex：(#9d0000)
 Id：(56) Hex：(#dc0000)
 Id：(57) Hex：(#de0000)
 Id：(58) Hex：(#fb0000)
 Id：(59) Hex：(#9c7352)
 Id：(60) Hex：(#946b4a)
 Id：(61) Hex：(#734a29)
 Id：(62) Hex：(#523118)
 Id：(63) Hex：(#8c4a18)
 Id：(64) Hex：(#884411)
 Id：(65) Hex：(#4a2100)
 Id：(66) Hex：(#211810)
 Id：(67) Hex：(#d6945a)
 Id：(68) Hex：(#c66b21)
 Id：(69) Hex：(#ef6b00)
 Id：(70) Hex：(#ff7700)
 Id：(71) Hex：(#a59484)
 Id：(72) Hex：(#423121)
 Id：(73) Hex：(#181008)
 Id：(74) Hex：(#291808)
 Id：(75) Hex：(#211000)
 Id：(76) Hex：(#392918)
 Id：(77) Hex：(#8c6339)
 Id：(78) Hex：(#422910)
 Id：(79) Hex：(#6b4218)
 Id：(80) Hex：(#7b4a18)
 Id：(81) Hex：(#944a00)
 Id：(82) Hex：(#8c847b)
 Id：(83) Hex：(#6b635a)
 Id：(84) Hex：(#4a4239)
 Id：(85) Hex：(#292118)
 Id：(86) Hex：(#463929)
 Id：(87) Hex：(#b5a594)
 Id：(88) Hex：(#7b6b5a)
 Id：(89) Hex：(#ceb194)
 Id：(90) Hex：(#a58c73)
 Id：(91) Hex：(#8c735a)
 Id：(92) Hex：(#b59473)
 Id：(93) Hex：(#d6a573)
 Id：(94) Hex：(#efa54a)
 Id：(95) Hex：(#efc68c)
 Id：(96) Hex：(#7b6342)
 Id：(97) Hex：(#6b5639)
 Id：(98) Hex：(#bd945a)
 Id：(99) Hex：(#633900)
 Id：(100) Hex：(#d6c6ad)
 Id：(101) Hex：(#524229)
 Id：(102) Hex：(#946318)
 Id：(103) Hex：(#efd6ad)
 Id：(104) Hex：(#a58c63)
 Id：(105) Hex：(#635a4a)
 Id：(106) Hex：(#bda57b)
 Id：(107) Hex：(#5a4218)
 Id：(108) Hex：(#bd8c31)
 Id：(109) Hex：(#353129)
 Id：(110) Hex：(#948463)
 Id：(111) Hex：(#7b6b4a)
 Id：(112) Hex：(#a58c5a)
 Id：(113) Hex：(#5a4a29)
 Id：(114) Hex：(#9c7b39)
 Id：(115) Hex：(#423110)
 Id：(116) Hex：(#efad21)
 Id：(117) Hex：(#181000)
 Id：(118) Hex：(#292100)
 Id：(119) Hex：(#9c6b00)
 Id：(120) Hex：(#94845a)
 Id：(121) Hex：(#524218)
 Id：(122) Hex：(#6b5a29)
 Id：(123) Hex：(#7b6321)
 Id：(124) Hex：(#9c7b21)
 Id：(125) Hex：(#dea500)
 Id：(126) Hex：(#5a5239)
 Id：(127) Hex：(#312910)
 Id：(128) Hex：(#cebd7b)
 Id：(129) Hex：(#635a39)
 Id：(130) Hex：(#94844a)
 Id：(131) Hex：(#c6a529)
 Id：(132) Hex：(#109c18)
 Id：(133) Hex：(#428c4a)
 Id：(134) Hex：(#318c42)
 Id：(135) Hex：(#109429)
 Id：(136) Hex：(#081810)
 Id：(137) Hex：(#081818)
 Id：(138) Hex：(#082910)
 Id：(139) Hex：(#184229)
 Id：(140) Hex：(#a5b5ad)
 Id：(141) Hex：(#6b7373)
 Id：(142) Hex：(#182929)
 Id：(143) Hex：(#18424a)
 Id：(144) Hex：(#31424a)
 Id：(145) Hex：(#63c6de)
 Id：(146) Hex：(#44ddff)
 Id：(147) Hex：(#8cd6ef)
 Id：(148) Hex：(#736b39)
 Id：(149) Hex：(#f7de39)
 Id：(150) Hex：(#f7ef8c)
 Id：(151) Hex：(#f7e700)
 Id：(152) Hex：(#6b6b5a)
 Id：(153) Hex：(#5a8ca5)
 Id：(154) Hex：(#39b5ef)
 Id：(155) Hex：(#4a9cce)
 Id：(156) Hex：(#3184b5)
 Id：(157) Hex：(#31526b)
 Id：(158) Hex：(#deded6)
 Id：(159) Hex：(#bdbdb5)
 Id：(160) Hex：(#8c8c84)
 Id：(161) Hex：(#f7f7de)
 Id：(162) Hex：(#000818)
 Id：(163) Hex：(#081839)
 Id：(164) Hex：(#081029)
 Id：(165) Hex：(#081800)
 Id：(166) Hex：(#082900)
 Id：(167) Hex：(#0052a5)
 Id：(168) Hex：(#007bde)
 Id：(169) Hex：(#10294a)
 Id：(170) Hex：(#10396b)
 Id：(171) Hex：(#10528c)
 Id：(172) Hex：(#215aa5)
 Id：(173) Hex：(#10315a)
 Id：(174) Hex：(#104284)
 Id：(175) Hex：(#315284)
 Id：(176) Hex：(#182131)
 Id：(177) Hex：(#4a5a7b)
 Id：(178) Hex：(#526ba5)
 Id：(179) Hex：(#293963)
 Id：(180) Hex：(#4169E1)
 Id：(181) Hex：(#292921)
 Id：(182) Hex：(#4a4a39)
 Id：(183) Hex：(#292918)
 Id：(184) Hex：(#4a4a29)
 Id：(185) Hex：(#7b7b42)
 Id：(186) Hex：(#9c9c4a)
 Id：(187) Hex：(#5a5a29)
 Id：(188) Hex：(#424214)
 Id：(189) Hex：(#393900)
 Id：(190) Hex：(#595900)
 Id：(191) Hex：(#ca352c)
 Id：(192) Hex：(#6b7321)
 Id：(193) Hex：(#293100)
 Id：(194) Hex：(#313910)
 Id：(195) Hex：(#313918)
 Id：(196) Hex：(#424a00)
 Id：(197) Hex：(#526318)
 Id：(198) Hex：(#5a7329)
 Id：(199) Hex：(#314a18)
 Id：(200) Hex：(#182100)
 Id：(201) Hex：(#183100)
 Id：(202) Hex：(#183910)
 Id：(203) Hex：(#63844a)
 Id：(204) Hex：(#6bbd4a)
 Id：(205) Hex：(#63b54a)
 Id：(206) Hex：(#63bd4a)
 Id：(207) Hex：(#5a9c4a)
 Id：(208) Hex：(#4a8c39)
 Id：(209) Hex：(#63c64a)
 Id：(210) Hex：(#63d64a)
 Id：(211) Hex：(#52844a)
 Id：(212) Hex：(#317329)
 Id：(213) Hex：(#63c65a)
 Id：(214) Hex：(#52bd4a)
 Id：(215) Hex：(#10ff00)
 Id：(216) Hex：(#182918)
 Id：(217) Hex：(#4a884a)
 Id：(218) Hex：(#4ae74a)
 Id：(219) Hex：(#005a00)
 Id：(220) Hex：(#008800)
 Id：(221) Hex：(#009400)
 Id：(222) Hex：(#00de00)
 Id：(223) Hex：(#00ee00)
 Id：(224) Hex：(#00fb00)
 Id：(225) Hex：(#4a5a94)
 Id：(226) Hex：(#6373b5)
 Id：(227) Hex：(#7b8cd6)
 Id：(228) Hex：(#6b7bd6)
 Id：(229) Hex：(#7788ff)
 Id：(230) Hex：(#c6c6ce)
 Id：(231) Hex：(#94949c)
 Id：(232) Hex：(#9c94c6)
 Id：(233) Hex：(#313139)
 Id：(234) Hex：(#291884)
 Id：(235) Hex：(#180084)
 Id：(236) Hex：(#4a4252)
 Id：(237) Hex：(#52427b)
 Id：(238) Hex：(#635a73)
 Id：(239) Hex：(#ceb5f7)
 Id：(240) Hex：(#8c7b9c)
 Id：(241) Hex：(#7722cc)
 Id：(242) Hex：(#ddaaff)
 Id：(243) Hex：(#f0b42a)
 Id：(244) Hex：(#df009f)
 Id：(245) Hex：(#e317b3)
 Id：(246) Hex：(#fffbf0)
 Id：(247) Hex：(#a0a0a4)
 Id：(248) Hex：(#808080)
 Id：(249) Hex：(#ff0000)
 Id：(250) Hex：(#00ff00)
 Id：(251) Hex：(#ffff00)
 Id：(252) Hex：(#4169E1)
 Id：(253) Hex：(#ff00ff)
 Id：(254) Hex：(#00ffff)
 Id：(255) Hex：(#ffffff)
```

**------------**
# 音效
#### 播放按钮点击音效
- `SL:PlayBtnClickAudio()`

#### 播放音效
- `SL:PlaySound(id, isLoop)`

|参数名|必选|类型|说明|
|:-- |:- |:--- |----- |
|id |是 |int|cfg_sound表对应id|
|isLoop|否 |boolean|是否循环|

#### 播放登陆-选角音效
- `SL:PlaySelectRoleAudio()`

#### 播放开宝箱音效 [3.40.6版本]
- `SL:PlayOpenBoxAudio()`

#### 播放宝箱内选中音效 [3.40.6版本]
- `SL:PlayFlashBoxAudio()`

#### 停止音效
- `SL:StopSound(id)`

|参数名|必选|类型|说明|
|:-- |:- |:--- |----- |
|id |是 |int|cfg_sound表对应id|

#### 停止所有音效
- `SL:StopAllAudio()`

**------------**
# 聊天
#### 发送文本显示到聊天页输入框
- `SL:SendInputMsgToChat(str)`

|参数名|必选|类型|说明|
|:-- |:- |:--- |----- |
|str |是 |string|文本内容|

------------
#### 发送[普通消息]到聊天 [3.40.2版本]
- `SL:SendNormalMsgToChat(msg, channel)`

|参数名|必选|类型|说明|
|:-- |:- |:--- |----- |
|msg 	 |是 |string|消息内容|
|channel |否 |int|设置频道, 不设置默认当前聊天频道|

------------
#### 发送[系统提示]到聊天框 [3.40.2版本]
- `SL:SendSystemMsgToChat(data)`

|参数名|必选|类型|说明|
|:-- |:- |:--- |----- |
|data 	 |是 |table|Msg: 提示内容<br> FColor: 字体颜色ID <br> BColor: 背景颜色ID|

```
	local mdata = {
		Msg        = string.format("自动移动坐标点(%s:%s)不可到达", mapX, mapY),
		FColor     = 154,
		BColor     = 255,
	}
	SL:SendSystemMsgToChat(mdata)
```

------------
#### 发送[装备]到聊天
- `SL:SendEquipMsgToChat(itemData, channel)`

|参数名|必选|类型|说明|
|:-- |:- |:--- |----- |
|itemData |是 |table|装备数据|
|channel |否 |int|设置频道, 不设置默认当前聊天频道|

------------
#### 发送[位置]到聊天
- `SL:SendPosMsgToChat(channel)`

|参数名|必选|类型|说明|
|:-- |:- |:--- |----- |
|channel |否 |int|设置频道, 不设置默认当前聊天频道|

------------
#### 发送[表情]到聊天
- `SL:SendEmojiMsgToChat(data, channel)`

|参数名|必选|类型|说明|
|:-- |:- |:--- |----- |
|data |是 |table |表情配置 |
|channel |否 |int|设置频道, 不设置默认当前聊天频道|

------------
#### 私聊目标
- `SL:PrivateChatWithTarget(targetID, targetName)`

|参数名|必选|类型|说明|
|:-- |:- |:-- |----- |
|targetID |是 |string |目标玩家ID |
|targetName |是 |string |目标玩家名字 |

------------
#### 新增本地掉落消息到聊天 [3.40.7版本] 
- `SL:AddDropChatMsgShow(data)`

|参数名|必选|类型|说明|
|:-- |:- |:--- |----- |
|data 	 |是 |table|Msg: 掉落内容富文本<br> FColor: 字体颜色ID <br> BColor: 背景颜色ID <br> dropType: 掉落分类ID (1-10)|

例: 
```
	SL:AddDropChatMsgShow({
        FColor = 253,
        BColor = 255,
        Msg = "测试掉落<outline size='1' color='#000'><font color='#ffffff'>物品 </font><font color='#ffffff'> 从 </font><font color='#28ef01'>一只牛</font><font color='#ffffff'> 身上掉落在 </font><font color='#FFA500'>盟重省(222,333)</font><font color='#ffffff'> 附近</font></outline>",
        dropType = 1,
    })
```

**------------**
# 资源下载
- `SL:DownLoadRes(path, url, downloadCB)`

|参数名|必选|类型|说明|
|:-- |:- |:-- |----- |
|path |是 |string |保存的文件路径 |
|url |是 |string |下载资源地址 |
|downloadCB |否 |function |回调函数 |

```lua
SL:DownLoadRes("res/02.png", "https://engine-doc.996m2.com/Public/Uploads/2022-08-09/62f25c9fe04c0.png",test)

 function test(...)
 print("test",...)
end
```
![](https://engine-doc.996m2.com/server/index.php?s=/api/attachment/visitFile/sign/cdc2209b2ca8e0c748fb6a29a60295f8)

------------

#### 小地图资源下载
- `SL:DownloadMiniMapRes(mapId, callback)`

|参数名|必选|类型|说明|
|:-- |:- |:-- |----- |
|mapId |是 |int |小地图Id |
|callback |是 |function |回调函数 |

```
    local function callBack(isOk, path) -- isOk 下载是否成功, path 返回小地图路径 
        if isOk then 
            print("下载成功")
        else 
            print("下载失败")
        end 
        print("小地图路径",path)
    end 
    SL:DownloadMiniMapRes(100, callBack)
```

### 删除GM缓存资源 [3.40.6版本]
- `SL:RemoveGMResFile(filePath)`

|参数名|必选|类型|说明|
|:-- |:- |:-- |----- |
|filePath |是 |string |文件路径 |


**---------------**
# Actor
------------
#### 清空选中目标actor
- `SL:ClearTarget()`

------------
#### 快速选择目标
- `SL:QuickSelectTarget(data)`

|参数名|必选|类型|说明|
|:---- |:---|:----- |-----|
|data |是 |table|type:<br>&emsp;0: 玩家<br>&emsp;50: 怪物<br>&emsp;400: 英雄<br>imgNotice: 没有目标时是否创建范围圈<br>systemTips: 没有目标时是否弹提示|

------------
#### 获取视野内的玩家
- `SL:FindPlayerInCurrViewField(noMainPlayer)`

|参数名|必选|类型|说明|
|:---- |:---|:----- |-----|
|noMainPlayer |否|boolean |false: 包含自己， 反之不包含|

- 返回值：table

------------
#### 获取视野内的怪物
- `SL:FindMonsterInCurrViewField(noPetOfMainPlayer, noPetOfNetPlayer)`

|参数名|必选|类型|说明|
|:---- |:---|:----- |-----|
|noPetOfMainPlayer |否|boolean |true: 不包含自己的宠物， 反之包含|
|noPetOfNetPlayer |否|boolean |false: 包含别人的宠物， 反之不包含|

- 返回值：table

------------
#### 控件加入到元变量自动刷新的组件
- `SL:CustomAttrWidgetAdd(metaValue, widget)`

|参数名|必选|类型|说明|
|:---- |:---|:----- |-----|
|metaValue |是 |string|传入已配置元变量的字符串 <br>&<元变量KEY/参数>& <br>例 : <br> 红点变量U91: &<REDKEY/U91>& <br>角色名: &<USER_NAME>& |
|widget|是|object|文本控件 Text|

- 示例
```
	local Text_count = GUI:Text_Create(GUI:Attach_LeftBottom(), "MONEY_COUNT", 200, 100, 16, "#00FF00", "")
    SL:CustomAttrWidgetAdd("元宝数量: &<TMONEY/元宝>&", Text_count)
	-- 多货币
	-- SL:CustomAttrWidgetAdd("货币1,2总数量: &<TMONEY/1,2>&", Text_count)
```

------------
#### 检测控件是否可视 (用于检测在列表/滚动容器内控件)
- `SL:CheckNodeCanCallBack(node, touchPos)`
- 默认检测层数 : 6

|参数名|必选|类型|说明|
|:---- |:---|:----- |-----|
|node|是|object|控件 |
|touchPos|是|table|当前接触坐标|

- 示例

```
	GUI:addMouseMoveEvent(node, {
		onEnterFunc = function(touchPos)
			if SL:CheckNodeCanCallBack(node, touchPos) then
				local info = {
					str = "tttt",
					worldPos = touchPos,
				}
				SL:OpenCommonDescTipsPop(info)
			end
		end,
		onLeaveFunc = function()
			SL:CloseCommonDescTipsPop()
		end
	})
```

**------------**
# 提升按钮
#### 添加提升按钮
- `SL:AddUpgradeBtn(id, name, func)`

- 等同TXT脚本命令addbutshow

|参数名|必选|类型|说明|
|:---- |:---|:----- |-----|
|id |是 |int|按钮id 必须唯一!!!! (同脚本命令加的id也不能重复)|
|name|是|string|按钮展示文本|
|func|是|function|点击按钮跳转函数|

#### 删除提升按钮
- `SL:RemoveUpgradeBtn(id)`

- 等同TXT脚本命令delbutshow

|参数名|必选|类型|说明|
|:---- |:---|:----- |-----|
|id |是 |int|按钮id 必须唯一!!!! (同脚本命令加的id也不能重复)|

**------------**
# 鼠标模拟事件
#### 模拟左键点击事件
- `SL:WinClick(widget)`

|参数名|必选|说明|
|:---- |:---|-----|
|widget |是 |控件对象|


**------------**
#坐标转换 [3.40.2版本]
#### 世界坐标转化为地图坐标
- `SL:ConvertWorldPos2MapPos(worldX, worldY)`

|参数名|必选|说明|
|:---- |:---|-----|
|worldX |是 |世界坐标X|
|worldY |是 |世界坐标Y|

#### 地图坐标转化为世界坐标
- `SL:ConvertMapPos2WorldPos(mapX, mapY, centerOfGrid)`

|参数名|必选|说明|
|:---- |:---|-----|
|mapX |是 |地图坐标X|
|mapY |是 |地图坐标Y|
|centerOfGrid|否| 是否在地图格中心|

#### 世界坐标转化为屏幕坐标
- `SL:ConvertWorldPos2Screen(worldX, worldY)`

|参数名|必选|说明|
|:---- |:---|-----|
|worldX |是 |世界坐标X|
|worldY |是 |世界坐标Y|

#### 屏幕坐标转化为世界坐标
- `SL:ConvertScreen2WorldPos(screenX, screenY)`

|参数名|必选|说明|
|:---- |:---|-----|
|screenX |是 |屏幕坐标X|
|screenY |是 |屏幕坐标Y|


**------------**
# 移动端交互 [3.40.2版本]
#### 打开QQ
- `SL:OpenQQ()`

#### 加QQ
- `SL:JoinQQ(id)`

|参数名|必选|说明|
|:---- |:---|-----|
|id |是 |QQ号|

#### 加QQ群
- `SL:JoinQQGroup(key)`

|参数名|必选|说明|
|:---- |:---|-----|
|key |是 |QQ群key|

#### 打开微信
- `SL:OpenWX()`


#### 添加地图特效 [3.40.4版本]
- `SL:AddMapSpecialEffect(ID, mapID, sfxId, x, y, loop)`

|参数名|必选|类型|说明|
|:---- |:---|:----- |-----|
|ID |是 |int|该地图特效标识 必须唯一!!!! |
|mapID |是 |string|添加到的地图ID|
|sfxId |是 |int|特效ID|
|x |是 |int|地图坐标X|
|y |是 |int|地图坐标Y|
|loop |否 |boolean|是否循环播放特效, 不填默认循环播放|
|showType |否 |int|显示位置 0:在后面 1: 在前面 [3.40.8版本新增]|

#### 删除地图特效 [3.40.4版本]
- `SL:RmvMapSpecialEffect(ID, mapID)`

|参数名|必选|类型|说明|
|:---- |:---|:----- |-----|
|ID |是 |int|该地图特效标识 必须唯一!!!! |
|mapID |是 |string|添加到的地图ID|

- 示例

```
	local mapID = SL:GetMetaValue("MAP_ID")
    SL:AddMapSpecialEffect(1111, mapID, 10, 295, 305)
```

#### 添加Actor特效 [3.40.5版本]
- `SL:AddActorEffect(actorID, sfxID, isFront, offX, offY)`

|参数名|必选|类型|说明|
|:---- |:---|:----- |-----|
|actorID |是 |int|玩家id|
|sfxID |是 |int|特效ID|
|isFront |否 |boolen|是否在模型前  默认在前面|
|offX |否 |int|x偏移|
|offY |否 |int|y偏移|

#### 删除Actor特效 [3.40.5版本]
- `SL:RmvActorEffect(actorID, sfxID)`

|参数名|必选|类型|说明|
|:---- |:---|:----- |-----|
|actorID |是 |int|玩家id|
|sfxID |是 |int|特效ID|

#### 强攻 [3.40.7版本]
- `SL:ForceAttack()`

**------------**
# 请求类
#### 拉起充值
- `SL:RequestPay(payWay, currencyID, price, productIndex)`

|参数名|必选|类型|说明|
|:---- |:---|:----- |-----|
|payWay |是 |int|1 支付宝 2 花呗 3 微信 -1不选择(手机端接入SDK不选择支付渠道)|
|currencyID|是|int|货币ID|
|price|是|int|支付金额|
|productIndex|是|int| 商品索引/商品ID|

#### 兑换激活码
- `SL:RequestCDK(cdk)`

|参数名|必选|说明|
|:---- |:---|-----|
|cdk |是 |激活码|

#### 请求改变PK模式
- `SL:RequestChangePKMode(pkmode)`

|参数名|必选|说明|
|:---- |:---|-----|
|pkmode |是 |pk模式|

#### 请求改变宠物战斗模式
- `SL:RequestChangePetPKMode(pkmode)`

|参数名|必选|说明|
|:---- |:---|-----|
|pkmode |是 |宝宝模式|

#### 请求从仓库取出道具
- `SL:RequestPutOutStorageData(data)`

|参数名|必选|说明|
|:---- |:---|-----|
|data |是 |table -- 道具数据|

#### 请求道具放入仓库
- `SL:RequestSaveItemToNpcStorage(data, pageIndex)`

|参数名|必选|说明|
|:---- |:---|-----|
|data |是 |table -- 道具数据|
|pageIndex|否 |int -- 指定仓库页下标 [3.40.9版本新增]|

#### 请求使用道具
- `SL:RequestUseItem(itemData)`

|参数名|必选|说明|
|:---- |:---|-----|
|itemData |是 |table -- 道具数据|

#### 请求使用英雄道具
- `SL:RequestUseHeroItem(itemData)`

|参数名|必选|说明|
|:---- |:---|-----|
|itemData |是 |table -- 道具数据|

#### 拆分道具
- `SL:RequestSplitItem(data, num)`

|参数名|必选|说明|
|:---- |:---|-----|
|data |是 |table -- 道具数据|
|num |是 |int -- 数量|

#### 拆分道具(英雄)
- `SL:RequestSplitHeroItem(data, num)`

|参数名|必选|说明|
|:---- |:---|-----|
|data |是 |table -- 道具数据|
|num |是 |int -- 数量|

#### 请求购买商品 [3.40.3版本]
- `SL:RequestStoreBuy(index, count)`

|参数名|必选|说明|
|:---- |:---|-----|
|index |是 |int -- 商品Index|
|count |是 |int -- 购买数量|

#### 召唤英雄或收回
- `SL:RequestCallOrOutHero()`

#### 请求玩家首饰盒状态
- `SL:RequestOpenPlayerBestRings()`

#### 请求英雄首饰盒状态
- `SL:RequestOpenHeroBestRings()`

#### 请求宠物锁定
- `SL:RequestLockPetID(targetID)`

|参数名|必选|说明|
|:---- |:---|-----|
|targetID |是 |目标宠物ID|

#### 请求取消宠物锁定
- `SL:RequestUnLockPetID(targetID)`

|参数名|必选|说明|
|:---- |:---|-----|
|targetID |是 |目标宠物ID|

#### 释放技能
- `SL:RequestLaunchSkill(skillID)`

|参数名|必选|说明|
|:---- |:---|-----|
|skillID |是 |技能ID|

#### 请求施法合击
- `SL:RequestMagicJointAttack()`

#### 查看目标玩家信息
- `SL:RequestLookPlayer(targetId, notForbid)`

|参数名|必选|说明|
|:---- |:---|-----|
|targetID |是 |目标ID|
|notForbid|否 |boolean --是否不判断地图禁止查看|

#### 请求开关开关型技能 [3.40.7版本]
- `SL:RequestOnOffSkill(skillID)`

|参数名|必选|说明|
|:---- |:---|-----|
|skillID |是 |技能ID|


###行会
#### 请求行会申请列表
- `SL:RequestGuildAllyApplyList()`

#### 行会同盟申请操作
- `SL:RequestAllyOperate(guildID, param)`

|参数名|必选|说明|
|:---- |:---|-----|
|guildID |是 |行会ID|
|param|是 |操作编号 1同意 2拒绝|

#### 请求行会成员列表
- `SL:RequestGuildMemberList()`

#### 请求世界行会列表 
- `SL:RequestWorldGuildList(page)`

|参数名|必选|说明|
|:---- |:---|-----|
|page |是 |分页id|

#### 邀请玩家入会
- `SL:RequestGuildInviteOther(uid)`

|参数名|必选|说明|
|:---- |:---|-----|
|uid |是 |玩家id|

#### 踢出行会
- `SL:RequestSubGuildMember(uid)`

|参数名|必选|说明|
|:---- |:---|-----|
|uid |是 |玩家id|

#### 任命行会职位
- `SL:RequestAppointGuildRank(uid, rank)`

|参数名|必选|说明|
|:---- |:---|-----|
|uid |是 |玩家id|
|rank|是 |职位id 1-5|

### 组队
#### 请求创建队伍
- `SL:RequestCreateTeam()`

#### 邀请玩家入队
- `SL:RequestInviteJoinTeam(uid, name)`

|参数名|必选|说明|
|:---- |:---|-----|
|uid |否 |玩家id|
|name|否 [ 两参数必须填一个 ] |玩家昵称|

#### 拒绝组队邀请
- `SL:RequestRefuseTeamInvite(uid)`

|参数名|必选|说明|
|:---- |:---|-----|
|uid |是 |玩家id|

#### 同意组队邀请
- `SL:RequestAgreeTeamInvite(uid)`

|参数名|必选|说明|
|:---- |:---|-----|
|uid |是 |玩家id|

#### 同意申请入队
- `SL:RequestApplyAgree(uid)`

|参数名|必选|说明|
|:---- |:---|-----|
|uid |是 |玩家id|

#### 请求入队申请列表
- `SL:RequestApplyData()`

#### 请求附近队伍
- `SL:RequestNearTeam()`

#### 请求加入队伍
- `SL:RequestApplyJoinTeam(uid)`

|参数名|必选|说明|
|:---- |:---|-----|
|uid |是 |队长id/队伍内任意玩家id|

#### 召集队友
- `SL:RequestCallTeamMember()`

#### 离开队伍
- `SL:RequestLeaveTeam()`

#### 保存允许组队状态
- `SL:RequestSetTeamPermitStatus(status)`

|参数名|必选|说明|
|:---- |:---|-----|
|status |是 |int -- 1允许 0不允许|

#### 踢出队伍
- `SL:RequestSubTeamMember(uid)`

|参数名|必选|说明|
|:---- |:---|-----|
|uid |是 |玩家id|

#### 移交队长
- `SL:RequestTransferTeamLeader(uid)`

|参数名|必选|说明|
|:---- |:---|-----|
|uid |是 |玩家id|

### 交易
#### 请求进行交易
- `SL:RequestTrade(uid)`

|参数名|必选|说明|
|:---- |:---|-----|
|uid |是 |玩家id|

#### 请求放入交易物品 [3.40.7版本]
- `SL:RequestPutInItem(makeindex, name)`

|参数名|必选|说明|
|:---- |:---|-----|
|makeindex |是 |物品唯一ID|
|name |是 |物品名称|


### 好友
#### 请求好友列表
- `SL:RequestFriendList()`

#### 请求添加好友
- `SL:RequestAddFriend(uname)`

|参数名|必选|说明|
|:---- |:---|-----|
|uname|是 |玩家昵称|

#### 删除好友
- `SL:RequestDelFriend(uid)`

|参数名|必选|说明|
|:---- |:---|-----|
|uid |是 |玩家id|

#### 好友加到黑名单
- `SL:RequestAddBlacklistByName(uname)`

|参数名|必选|说明|
|:---- |:---|-----|
|uname|是 |玩家昵称|

#### 移出黑名单
- `SL:RequestOutBlacklist(uid)`

|参数名|必选|说明|
|:---- |:---|-----|
|uid |是 |玩家id|

#### 同意好友申请
- `SL:RequestAgreeFriendApply(uname)`

|参数名|必选|说明|
|:---- |:---|-----|
|uname|是 |玩家昵称|

#### 删除好友申请数据
- `SL:RequestDelFriendApplyData(uname)`

|参数名|必选|说明|
|:---- |:---|-----|
|uname|是 |玩家昵称|

#### 清空好友申请列表
- `SL:RequestClearFriendApplyList()`

### 邮件
#### 请求获取邮件列表 一次十条
- `SL:RequestMailList()`

#### 删除已读邮件
- `SL:RequestDelReadMail()`

#### 读邮件
- `SL:RequestReadMail(mailId)`

|参数名|必选|说明|
|:---- |:---|-----|
|mailId|是 |邮件ID|

#### 删除邮件
- `SL:RequestDelMail(mailId)`

|参数名|必选|说明|
|:---- |:---|-----|
|mailId|是 |邮件ID|

#### 邮件全部提取
- `SL:RequestGetAllMailItems()`

#### 邮件提取
- `SL:RequestGetMailItems(mailId)`

|参数名|必选|说明|
|:---- |:---|-----|
|mailId|是 |邮件ID|

### 拍卖行
#### 请求拍卖行上架列表
- `SL:RequestAuctionPutList(listType)`

|参数名|必选|说明|
|:---- |:---|-----|
|listType|是 |int -- 1: 表示查询自己上架的物品，2: 表示查询参与过的|

#### 拍卖行请求上架
- `SL:RequestAuctionPutin(makeindex, count, bidPrice, buyPrice, currencyID, rebate)`

|参数名|必选|说明|
|:---- |:---|-----|
|makeindex|是 |物品唯一ID|
|count |是 |数量|
|bidPrice |是 |竞拍价格|
|buyPrice |是 |一口价|
|currencyID|是 |货币ID|
|rebate |否 |折扣|

#### 拍卖行请求下架
- `SL:RequestAuctionPutout(makeindex)`

|参数名|必选|说明|
|:---- |:---|-----|
|makeindex|是 |物品唯一ID|

#### 拍卖行请求重新上架
- `SL:RequestAuctionRePutin(makeindex, count, bidPrice, buyPrice, currencyID, rebate)`

|参数名|必选|说明|
|:---- |:---|-----|
|makeindex|是 |物品唯一ID|
|count |是 |数量|
|bidPrice |是 |竞拍价格|
|buyPrice |是 |一口价|
|currencyID|是 |货币ID|
|rebate |否 |折扣|

#### 拍卖行请求竞价
- `SL:RequestAuctionBid(makeindex, price)`

|参数名|必选|说明|
|:---- |:---|-----|
|makeindex|是 |物品唯一ID|
|price |是 |竞拍价|

#### 拍卖行请求领取竞拍成功物品 [3.40.3版本]
- `SL:RequestAcquireBidItem(makeindex)`

|参数名|必选|说明|
|:---- |:---|-----|
|makeindex|是 |物品唯一ID|

### 排行榜
#### 请求排行榜数据
- `SL:RequestRankData(type)`

|参数名|必选|说明|
|:---- |:---|-----|
|type|是 |类别ID|

#### 请求玩家排行榜数据
- `SL:RequestPlayerRankData(userID, type)`

|参数名|必选|说明|
|:---- |:---|-----|
|userID |是|玩家ID|
|type|是 |int -- 玩家/英雄 1玩家 2英雄|

### 任务
#### 提交任务
- `SL:RequestSubmitMission(missionID)`

|参数名|必选|说明|
|:---- |:---|-----|
|missionID |是|任务ID|

### 玩家
#### 请求玩家称号数据
- `SL:ResquestTitleList()`

#### 请求取下称号
- `SL:ResquestDisboardTitle()`

#### 请求激活称号
- `SL:ResquestActivateTitle(titleId)`

|参数名|必选|说明|
|:---- |:---|-----|
|titleId |是|称号id|

#### 通知服务端 时装显示开关
- `SL:SendSuperEquipSetting(type)`

|参数名|必选|说明|
|:---- |:---|-----|
|type |是|int -- 2 : 设置显示神魔<br> 1 : 设置时装显示|

### 英雄
#### 切换英雄状态
- `SL:RequestChangeHeroMode(type)`

|参数名|必选|说明|
|:---- |:---|-----|
|type |是|状态值|

#### 请求英雄称号数据
- `SL:ResquestTitleList_Hero()`

#### 英雄请求取下称号
- `SL:ResquestDisboardTitle_Hero()`

#### 英雄请求激活称号
- `SL:ResquestActivateTitle_Hero(titleId)`

|参数名|必选|说明|
|:---- |:---|-----|
|titleId |是|称号id|

#### 通知服务端 英雄时装显示开关
- `SL:SendSuperEquipSetting_Hero(type)`

|参数名|必选|说明|
|:---- |:---|-----|
|type |是|int -- 2 : 设置显示神魔<br> 1 : 设置时装显示|

#### 英雄请求锁定目标 [3.40.7版本]
- `SL:RequestLockTargetByHero(actorID, isPlayer)`

|参数名|必选|说明|
|:---- |:---|-----|
|actorID |是|actorID|
|isPlayer|是|boolean -- 是否人物|

#### 英雄取消锁定 [3.40.7版本]
- `SL:RequestCancelLockByHero()`


### 合成
#### 请求合成
- `SL:ResquestCompoundItem()`

#### 请求敏感词检测
- `SL:RequestCheckSensitiveWord(str, type, callback)`

|参数名|必选|说明|
|:---- |:---|-----|
|str |是|string -- 需要检测的文本|
|type|是|文本类型 int <br> 1 : 昵称类<br> 2 : 聊天类<br> 3 : 行会公告|
|callback|是|function -- 检测完毕的回调事件<br> 事件传入参数: param1: boolean 能否通过 param2: 文本 |

#### 邀请上马
- `SL:RequestInviteInHorse(uid)`

|参数名|必选|说明|
|:---- |:---|-----|
|uid |是 |玩家id|

### 小地图 [3.40.2版本]
#### 请求地图组队成员数据 
- `SL:RequestMiniMapTeam()`

#### 请求地图怪物数据 
- `SL:RequestMiniMapMonsters()`

### 内功 [3.40.2版本]
#### 请求内功技能数据
- `SL:RequestInternalSkillData(isHero)`

|参数名|必选|说明|
|:---- |:---|-----|
|isHero |否 |boolean -- 是否请求英雄|

#### 请求经络穴位激活
- `SL:RequestAucPointOpen(typeID, aucPointID, isHero)`

|参数名|必选|说明|
|:---- |:---|-----|
|typeID |是 |经络ID|
|aucPointID|是|穴位ID|
|isHero |否 |boolean -- 是否请求英雄|

#### 修炼经络
- `SL:RequestMeridianLevelUp(typeID, isHero)`

|参数名|必选|说明|
|:---- |:---|-----|
|typeID |是 |经络ID|
|isHero |否 |boolean -- 是否请求英雄|

#### 设置连击技能
- `SL:RequestSetComboSkill(key, skillID, isHero)`

|参数名|必选|说明|
|:---- |:---|-----|
|key |是 |int -- 键位 (1, 2, 3, 4)|
|skillID|是 |技能ID|
|isHero |否 |boolean -- 是否请求英雄|

#### 请求设置内功条前置开关 并刷新显示 [3.40.8版本]
- `SL:RequestNGHudShow(show)`

|参数名|必选|说明|
|:---- |:---|-----|
|show |是 |boolean -- 是否开启 默认true|

### 宝箱 [3.40.3版本]
#### 请求获取宝箱物品奖励
- `SL:RequestGetGoldBoxReward()`

#### 请求再开启宝箱
- `SL:RequestOpenGoldBox()`

### 属性加点 [3.40.4版本]
#### 请求确认加属性点 [新版属性加点]
- `SL:RequestAddReinAttr_N(data, m_nBonusPoint)`

|参数名|必选|说明|
|:---- |:---|-----|
|data |是 |table -- 加点数据table `{"Bonus":[{"id":1,"value":1}, ...]}`|
|m_nBonusPoint|是 |int -- 剩余加点数|

### 求购 [3.40.5版本]
#### 请求求购数据 
- `SL:RequestPurchaseItemList(data)`

|参数名|必选|说明|
|:---- |:---|-----|
|data |是 |table -- 请求参数|
```
	参数如下:
	{
		type 	 = 类型(int),					-- 0: 世界求购, 1: 我的求购, 2: 我的已收
		pageIndex = 请求页码(int),
		stdmode 	= 筛选的stdmode(string),		-- #分隔需要筛选的stdmode 例: "1#2#3#4"
		currency	= 筛选货币(string), 			-- ,分隔需要筛选的货币ID 例: "1,2,3"
		sort		= 排序规则(int),				-- 0: 不排序 1: 单价正序 2: 单价倒序 3: 总价正序 4: 总价倒序
		itemids 	= 筛选道具idx(string), 		-- ,分隔筛选的道具Index 例: "1001,1002,1003"
	}
```

#### 请求求购出售物品
- `SL:RequestPurchaseSell(data)`

|参数名|必选|说明|
|:---- |:---|-----|
|data |是 |table -- 请求参数 {guid = 求购列表标识id, qty = 出售数量}|

#### 请求上架求购物品
- `SL:RequestPurchasePutIn(data)`

|参数名|必选|说明|
|:---- |:---|-----|
|data |是 |table -- 请求参数|

```
	参数如下: 
	{
		qty 	= 求购数量(int),
		minqty	= 求购最小数量(int),
		price 	= 物品单价(int),
		itemid	= 道具Index,
		currency = 货币ID
	}
```

#### 请求下架求购物品
- `SL:RequestPurchasePutOut(guid)`

|参数名|必选|说明|
|:---- |:---|-----|
|guid |否|求购列表标识id, 不填则全部下架|

#### 请求取出求购已收物品
- `SL:RequestPurchaseTakeOut(guid)`

|参数名|必选|说明|
|:---- |:---|-----|
|guid |否|求购列表标识id, 不填则全部取出|

#### 请求点击NPC [3.40.5版本]
- `SL:RequestNPCTalk(npcID)`

|参数名|必选|说明|
|:---- |:---|-----|
|npcID |是|NPCID|

### 996客服
#### 请求打开996客服界面
- `SL:RequestOpen996ManualService()`

### 鸿蒙 [3.40.4版本]
#### 鸿蒙账号解绑
- `SL:HarmonyUnbind()`

### 交易行截图相关 [3.40.7版本]
#### 交易行截图测试
- `SL:TradingTestCapture()`
- PC端可以调用调试 报错的话可以查看控制台日志, 截图图片在当前项目cache中

#### 交易行lua自定义截图
- `SL:AddTradingCustomCaptureTaskLua(openFunc, closeFunc, getNodeFunc)`

|参数名|必选|说明|
|:---- |:---|-----|
|openFunc |是|function -- 打开当前界面方法|
|closeFunc |是|function -- 关闭当前界面方法|
|getNodeFunc |是|function -- 返回一个当前页面父节点panel，会截图这个父节点上所有子节点，并且这个父节点可以获取到getContentSize的可视截图大小|

#### 删除交易行lua自定义截图任务
- `SL:RemoveTradingCustomCaptureTask()`

























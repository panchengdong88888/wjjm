# 检查点333：doInit_UI直接子原型child11-child22逐段核对

日期：2026-11-11

## 范围

VM `root.children[42]`的直接子原型child11-child22，包含child11/14/22的嵌套闭包；源码对照唯一交付文件对应工厂与doInit_UI调用点。

## 子原型对照表

| VM子原型 | 指令数 | 对应源码 | 核对重点与结论 |
|---|---:|---|---|
| child11 Nested_Helper_4 | 12 | `make_Nested_Helper_4` | 固定提示文本、8项捕获顺序、创建保存回调并调用输入弹窗；一致 |
| child11.child0 Nested_Helper_5 | 35 | `make_Nested_Helper_5` | 写入失败分支提示/路径日志并return；成功分支通知、格式化日志、启动黑名单定时器、同步blacklistbut状态；一致 |
| child12 Nested_04d_02d_02d | 43 | `make_Nested_04d_02d_02d` | os.date("*t")、79205-79208秒窗口、YYYYMMDD去重、更新日期cell、GETGLOBAL LuaSendMsg固定参数及通知；发送入口已按VM修正 |
| child13 Nested_ClearBlacklistItems | 6 | `make_Nested_ClearBlacklistItems` | 通知“清空黑名单”后GETGLOBAL调用ClearBlacklistItems；已在检查点331修正为直接环境查找 |
| child14 Nested_Helper_7 | 12 | `make_Nested_Helper_7` | 固定阈值提示、8项捕获顺序、创建阈值保存回调并打开输入弹窗；一致 |
| child14.child0 Nested_Helper_8 | 34 | `make_Nested_Helper_8` | 保存失败路径日志/通知；成功通知、格式化日志、启动采集并同步yinguaibut状态；一致 |
| child15 Nested_Helper_9 | 30 | `make_Nested_Helper_9` | 按uiState.isHidden选择hide/show、通知及hidebut透明度0/255；一致 |
| child16 quick-slot callback | 26 | doInit_UI循环内callback | ipairs遍历names、ITEM_INDEX_BY_NAME查询、GETGLOBAL MoveItemToQuickUse(itemIndex,slot)、日志、成功即return；一致 |
| child17 Nested_blacklistTimer | 28 | `make_Nested_blacklistTimer` | 距离参数缺失时读取配置、写config.distance、无距离false、GETGLOBAL BlacklistItems、0.1秒Schedule、格式化通知；全局函数身份已修正 |
| child18 Nested_Helper_10 | 39 | `make_Nested_Helper_10` | blacklistTimer开关、取消句柄/状态清理、读取距离、正值启动、缺值打开输入框及返回值；一致 |
| child19 Nested_TakeItems | 29 | `make_Nested_TakeItems` | takeTimer开关、isTaking清理、GETGLOBAL TakeItems立即调用及1秒Schedule；全局函数身份已修正 |
| child20 Nested_s | 21 | `make_Nested_s` | 检查blacklist_distance文件、成功/失败通知和路径格式日志；一致 |
| child21 Nested_dropTimer | 29 | `make_Nested_dropTimer` | dropTimer开关、isDiuing状态、GETGLOBAL DiuItems立即调用及1秒Schedule；全局函数身份已修正 |
| child22 Nested_Anonymous | 8 | `make_Nested_Anonymous` | 固定参数promptText/successCallback，内部T[2]保持nil；创建Nested_str；一致 |
| child22.child0 Nested_str | 27 | `make_Nested_Anonymous`内部Nested_str | editParams/inputMode/maxLength、prompt字符串、Nested_match回调、OpenCommonTipsPop；一致 |

## 重点闭包语义

1. child11/14的输入保存回调参数值按VM传入，成功/失败分支及后续按钮状态同步顺序一致。
2. child12的第二个捕获值在其VM主体中没有被读取；源码保留工厂参数位置，但消息发送严格使用GETGLOBAL LuaSendMsg，不读取MainLeftBottom.a.LuaSendMsg。
3. child16/17/19/21中VM通过GETGLOBAL取得根级函数；源码已统一改为`getfenv(1).函数名`查找/传递，不再把本地包装器函数对象交给Schedule。
4. child22.child0内部的Nested_match按status==1门控，去除输入空白后要求纯数字；有效值调用successCallback。无效值先日志，再0.1秒后调用T[2]；该槽按VM确定为nil，因此原始路径会产生attempt-to-call-nil。源码保留这一原始行为，没有自行补造第三回调。

## 结论

child11-child22及其嵌套闭包本轮逐段静态核对完成；除检查点331已记录并修正的全局函数身份偏差外，未发现新的明确指令/参数/receiver/返回值错配。本批不新增源码修改。

未执行Lua 5.1编译和目标游戏运行验证。

## 下一步

入口root PC1-PC412、AccountIDValidation、doInit_UI主体419条及23个直接子原型静态核对均已完成。接下来做跨段共享状态/闭包一致性复查，随后对唯一交付文件执行Lua 5.1禁用语法/API扫描及可用语法验证；任何无法实际执行的验证必须明确标记未通过/未执行。
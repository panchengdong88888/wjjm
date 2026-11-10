# 检查点231：短函数复核（GetWritablePath / InstallDamageHook）

日期：2026-11-10

## 本批工作范围

按用户要求继续优先处理简单函数。检查点231开始时重新读取README、机器状态、checkpoint协议、新框架API映射、原型总索引、函数状态CSV和集中主源码。确认此前点名的root.children[33]、root.children[56]、root.children[57]以及其他20条以内短原型均已存在于集中主源码，不重复追加。

本批选择两个状态表仍标为first-pass、但已有候选主体和完整PC级证据的短函数进行复核。

## 1. GetWritablePath

- 原型：root.children[2] / legacy root/3。
- 10条指令，4常量，无子原型，vararg_flag=1。
- PC1-PC4：取得cc.FileUtils，并以FileUtils为receiver调用getInstance()。
- PC5-PC6：以FileUtils实例为receiver调用getWritablePath()。
- PC7：读取首个可变参数作为path。
- PC8：按writablePath .. path顺序拼接。
- PC9：返回拼接结果；PC10为不可达尾部return。
- 函数源码已在主文件中，签名保留function GetWritablePath(...)，读取首个vararg；本轮没有改动函数体，只将prototype_index的过时first-pass状态修正为complete_static_reconstruction_not_runtime_verified。
- CSV原先已标记“完整静态恢复（未运行时验证）”，本轮统一主文件状态与CSV。

## 2. InstallDamageHook

- 原型：root.children[6] / legacy root/7。
- 父原型40条指令、9常量、1个子原型；子原型root.children[6].children[0] / legacy root/7/1有18条指令。
- 父函数逐项检查gameMapController、mNetMsgHandle类型、global.MsgType、MSG_SC_DAMAGE_HP、对应原处理器以及幂等标记；任一前置条件不满足即返回。
- 创建包装器时，子原型捕获当前gameMapController与originalHandler。
- 父PC31读取UP[0]后PC32立即覆盖该寄存器；不把这个读取误解成对后续业务的影响。
- 父PC33把包装器写入messageHandlers[damageMessageType]。
- 父PC34-PC36严格按字节码读取originalHandler.mNetMsgHandle[damageMessageType]，写入originalHandler.__ylwHookedOrigin；没有增加原字节码不存在的nil保护。
- 父PC37-PC39调用UP[1]提示回调。
- 子函数检查gameMapController.onDamageMsg是否为function；若是则pcall(optionalCallback,arg1,arg2)，忽略pcall返回值；无论可选回调是否存在或是否抛错，最终调用originalHandler(arg1,arg2)并原样返回全部返回值。
- 父子原型的所有活动指令及分支已映射。主文件已有完整工厂及子原型表达，本轮只修正prototype_index中遗留的first-pass状态。

## 本批未做的事情

- 没有重复添加已经在主文件中的函数主体。
- 没有进行宿主运行时验证；runtime_verified仍为false。
- 完整静态恢复计数不增加：这两个函数在CSV和总体统计中原本已计为完整静态恢复，只是主文件索引状态滞后。

## 下一步

继续处理简单/中等短函数状态中仍标为first-pass的条目，优先复核ReadNumericConfig（45条，重点确认vararg入口与调用参数契约），再看DeathAutoBlacklist、MoveTo、ClearBlacklistItems和onDamageMsg。大型PickUpItems、doInit_UI及根模块闭包装配继续后置。


## 检查点235参数元数据纠正

原始VM实现M()证明GetWritablePath原型固定参数数量为1，正确入口是function(path)，不是function(...)后读取首个vararg。主源码与候选文件已修正。

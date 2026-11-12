--[[
    MainLeftBottom 11.9 明文源码恢复文件

    唯一工作文件：
      11.9/MainLeftBottom_11.9_明文.lua

    原始加密文件（只读）：
      11.9/MainLeftBottom_11.9.lua

    恢复规则：
      1. 本文件是 11.9 版本唯一明文交付文件，后续所有源码只在本文件中持续完善。
      2. 只使用 Lua 5.1 兼容语法。
      3. 以 11.9 新框架开发文档为 API、参数和调用方式的主要依据。
      4. 结合新版函数名、常量、调用关系、UI链路及旧版只读源码恢复业务逻辑。
      5. 其他目录中的源码、文档和反汇编资料只允许读取参考，禁止修改。
      6. 不覆盖、不修改任何旧版源码，也不覆盖原始加密文件。
      7. 不确定的行为必须标注“待确认”，不得伪装成已恢复的原版逻辑。
      8. 优先恢复可明确确认的函数，逐步补全；不因复杂函数阻塞整体进度。

    状态说明：
      当前为唯一明文文件的初始骨架。尚未填入未经核实的业务实现。
]]

-- ============================================================
--  1. 加载入口与全局初始化
-- ============================================================

-- TODO：依据 11.9 新框架开发文档及新版入口线索恢复。

-- ============================================================
--  2. 基础框架 API 包装函数
-- ============================================================

-- TODO：优先根据新框架开发文档恢复参数、返回值明确的包装函数。

-- ============================================================
--  3. 通用辅助函数与配置
-- ============================================================

-- TODO：结合新版常量、函数名和旧版只读源码恢复。

-- ============================================================
--  4. UI 初始化、窗口与按钮创建
-- ============================================================

-- TODO：恢复 doInit_UI、createButton 及完整按钮事件链。

-- ============================================================
--  5. 怪物查找与引怪系统
-- ============================================================

-- TODO：恢复 FindMonsterInCurrViewField、FindMonsterCandidates、
--       InitGatherMonsters、MainLoop、StopGatherMonsters 等函数。

-- ============================================================
--  6. 物品处理与仓库系统
-- ============================================================

-- TODO：恢复 DiuItems、TakeItems、PickUpItems、StorageItems 等函数。

-- ============================================================
--  7. 黑名单、伤害消息与 Hook
-- ============================================================

-- TODO：结合新版函数线索及新框架 API 文档恢复。

-- ============================================================
--  8. 新版新增功能及其他业务模块
-- ============================================================

-- 8.1 自动购买金条（当前优先恢复项；仅记录已确认的新版证据）
--
-- 新版原型身份（来自 11.9/MainLeftBottom_11.9_整体框架结构.md）：
--   proto48：createButton，总按钮创建与事件入口；其子原型包含本功能按钮事件。
--   proto50：proto48 的子原型，23条指令、含1个子原型；常量线索：
--            SL、Schedule、“开始检测金币(>200W买金条)”、buygoldTimer。
--            功能判断：位于createButton的按钮事件子函数，且含购买金条提示和定时器；
--   proto51：proto50 的子原型，77条指令；常量线索：
--            “买金条成功，当前金币：%d”、ShowSystemTips、
--            GetMoneyIdByName、ProxyTable、GetMoneyCountById、MoneyProxy、
--            “金条”、“金币”、buygoldTimer、“买金条失败：”。
--            功能判断：proto50唯一子函数，含金币/金条查询及成功失败提示；
--   proto2：根原型子函数，69条指令；常量包含 buygoldTimer、UnSchedule、
--           GUI:setVisible 等；需核对其定时器清理分支与本功能的关联。
--   proto36：根原型子函数，149条指令、2个Upvalues；常量包含 RequestBuy、
--            PageStoreProxy、Condition、Facade、SL，属于商城购买逻辑候选。
--            目前没有直接调用边证据证明proto51会调用proto36，不能先认定两者相连。
--
-- 已确认：功能涉及按钮点击处理、buygoldTimer、金币/金条查询及成功/失败提示；
--         提示文字中明确出现“>200W买金条”。
-- 尚未确认：按钮的真实key和显示文案、Schedule周期/启停分支、
--           金币阈值的比较操作数、金条数量判断、商城购买辅助函数的确切实参、
--           proto51与proto36之间的调用关系，以及退出清理时的准确调用顺序。
-- 新框架(3_40_xx)的43份开发文档中未检索到 PageStoreProxy / RequestBuy / MoneyProxy
-- 的接口签名；目前只能确认SL:Schedule(callback,time)与SL:UnSchedule(scheduleID)
-- 的框架用法，不能从框架文档推导商城代理的参数契约。
--
-- 资料边界：资料文件/03_静态反汇编中的阶段三反汇编属于旧统计口径（110原型/5580指令），
--            不能拿它的原型编号或PC内容套用到11.9（105原型/6156指令）。
--            11.9当前可用的购买金条证据来自本目录整体结构表的原型树和常量线索。
-- 注意：当前只有函数名/常量/原型父子关系线索，不能据此编造RequestBuy参数、
--       购买数量或定时周期。待完成定点函数控制流核对后，再写入实际Lua函数体。
--       不得将“>200W”直接擅自改写为 >2000000，除非比较常量/单位证据闭合。

--
-- 2026-11-12 定点解析原始二进制后的新增证据（11.9专用，不引用旧版VM dump）：
--   外层Base36/LZW与XOR 0x4A解码后得到79573字节；按原文件内嵌加载器M()的
--   原型序列化规则解析，完整得到105个原型、根原型455条指令、54个根级子原型，
--   解码消费位置恰好到79573字节末尾。与11.9整体结构报告统计吻合。
--   proto48：按钮配置指令PC228-229明确构造 key="buygoldbut"、name="购买金条"；
--            PC277-278绑定该按钮事件。
--   proto50：字节范围34666..36029；23条指令、5个常量、1个子原型；常量含0.5。
--            PC11-20包含SL.Schedule、子闭包和0.5，确认调度周期为0.5。
--   proto51：字节范围34759..35817；77条指令、21个常量；常量含2000000、
--            “金币不足200W，买金条结束”、成功/失败提示、金币/金条查询接口。
--            PC20使用2000000参与金币数量比较；实际比较方向为2000000 < 当前金币数，
--            成立时跳过PC21的跳转，进入后续处理段；不成立则跳至PC58后的结束分支。
--   proto2：字节范围2942..3710；69条指令；PC35-44显式涉及buygoldTimer、
--            SL.UnSchedule及buygoldTimer清理，证明存在清理路径，但触发时机仍待还原。
--   proto36：字节范围26100..27984；149条指令、36个常量；含RequestBuy、
--            PageStoreProxy、Condition、BuyCount等商城购买线索，但它是根级独立原型，
--            当前仍无证据证明proto51调用它。proto51自身常量表没有RequestBuy字符串。
--
-- 尚未恢复：proto51在金币>2000000分支中的具体商城请求/购买动作及其准确实参；
--          不能因proto36存在RequestBuy就将其接到proto51，也不能把“成功”提示路径
--          直接等同于真实购买请求已成功。下一步继续按11.9解释器的实际opcode分支
--          解读proto50/51调用帧与条件跳转，再恢复可确认的Lua 5.1函数体。
--
--
-- 2026-11-12 购买金条回调proto51进一步控制流核对：
--   proto51完整77条指令已逐条提取。PC1-7先从global.Facade/ProxyTable取得MoneyProxy；
--   PC10-18通过MoneyProxy.GetMoneyIdByName("金币")和GetMoneyCountById查询金币余额。
--   PC20使用常量2000000与当前金币数量比较；按11.9解释器opcode367的实际分支语义，
--   条件为“2000000 < 当前金币数”时跳过PC21跳转，继续执行高金币分支；否则跳到PC58。
--   高金币分支PC22-26继续查询“金条”对应ID及数量；PC26依据返回值真假选择后续
--   成功/失败提示路径。PC28-46含成功文案格式化与失败文案/tostring提示处理。
--   PC48-57存在取消buygoldTimer并将其清理的路径；PC59-76为低于门槛时取消定时器、
--   清空buygoldTimer并提示“金币不足200W，买金条结束”的路径。
--   关键结论：proto51自身77条指令及常量表没有RequestBuy、PageStoreProxy或商城代理，
--   也没有直接引用proto36的可见证据。当前恢复出的行为更接近余额/金条数量检查和提示，
--   不能称为已经找到真实购买请求。proto36的RequestBuy只能暂列为独立商城购买辅助函数。
--   注意：金条数量API返回值为真/假判断的确切含义，仍需结合接口返回约定确认；
--   Lua中数字0也是真值，不能擅自把该判断改写为“数量大于0”。
--
--
-- 2026-11-12 全新版原型常量表交叉检索（105个原型）：
--   RequestBuy 与 PageStoreProxy 只出现在proto36；全新版其他原型常量表均未命中。
--   buygoldTimer 只出现在proto2、proto50、proto51；buygoldbut只出现在proto48。
--   MoneyProxy / GetMoneyIdByName / GetMoneyCountById 还出现在proto48和proto65/69，
--   其中proto65是资源统计窗口创建逻辑，proto69是资源统计刷新回调，不是购买请求。
--   这进一步说明：proto51不是通过字符串常量直接引用proto36；但仅凭常量表检索，
--   还不能排除间接闭包引用、代理事件或框架侧异步行为。proto36调用者仍需沿根原型
--   的闭包创建与调用关系继续追踪。
--
-- 2026-11-12 购买金条调用链进一步核查（11.9专属原始解释器）：
--   已从新版解释器确认opcode177为闭包创建；它读取子原型并按后续capture指令
--   捕获upvalue。由此可直接核对闭包捕获关系，而不是只凭常量字符串猜调用关系。
--   proto48在PC269创建proto50闭包，upvalue捕获来自proto48寄存器9；proto50再创建
--   proto51回调闭包（其捕获寄存器及语义仍需逐项解释）。
--   root在PC430创建proto48闭包，5个upvalue依次捕获root寄存器4、2、3、7、53。
--   root在PC46创建proto36闭包，只捕获root寄存器0。proto48的5个捕获寄存器中
--   没有proto36闭包所在的root寄存器5，因此proto36不是经proto48的直接upvalue
--   捕获传给购买金条按钮链。当前也未找到proto51直接引用proto36的常量或子闭包。
--   proto36本身是一个通用商城购买辅助函数：参数数为2；先取PageStoreProxy，检查代理，
--   读取ITEM_INDEX_BY_NAME并校验物品索引；遍历pageData/商品数据，检查Condition、
--   CheckCondition、LimitCount、BuyCount等限制；尾部取RequestBuy并提交商品Index与
--   购买数量相关参数。该函数可独立恢复，但尚无证据证明购买金条按钮调用它。
--   重要：proto50创建proto51时的upvalue捕获关系尚未完整解读，不能排除通过某个
--   已捕获代理/闭包间接完成业务；继续解读其capture和调用opcode后再下结论。
--

-- 2026-11-12 闭包捕获语义复核（修正前轮误读）：
--   11.9解释器的opcode177闭包创建处理器逐条读取后续capture指令：
--   只有capture指令opcode57才从父函数局部寄存器V取值；其他capture指令
--   从父函数upvalue数组A取值。此前把opcode374误读为局部寄存器捕获，现予纠正。
--   proto48 PC269创建proto50，紧随其后的PC270为opcode374、索引9：
--   因此proto48捕获的是其父函数upvalue A[9]，不是父函数局部寄存器9。
--   proto50 PC13创建proto51，PC14-17均为opcode374，索引依次2、3、0、1：
--   因此proto51捕获proto50的upvalue A[2]、A[3]、A[0]、A[1]，不是proto50局部寄存器。
--   proto50本身没有在这4项中新增局部变量捕获；proto51获得的是proto48上游
--   环境中对应的4个upvalue引用。它们的具体对象身份仍需继续沿proto48的父级
--   闭包环境追踪，当前不能据此确认是否包含商城购买代理或proto36闭包。
--   本修正撤回此前“proto48捕获root局部寄存器4、2、3、7、53”以及由此推导
--   “proto36不在直接upvalue捕获链”的表述；该推断不成立。


-- 2026-11-12 闭包解释器处理器核验（新增直接证据）：
--   直接读取11.9内嵌VM的opcode177处理器：它以J[E[3]]取子原型，E[4]为捕获项数量；
--   对紧随其后的每条捕获指令，若G[1]==57，则捕获当前函数局部寄存器V[G[3]]；
--   否则捕获当前函数upvalue数组A[G[3]]。每项保存为引用代理，子函数通过代理访问。
--   因此proto48 PC269创建proto50时，捕获数为1，PC270 opcode374 index9，
--   即proto50仅建立一个upvalue映射槽（槽0 -> proto48的A[9]）。
--   proto50 PC13创建proto51时，捕获数为4，PC14-17 opcode374索引为2、3、0、1，
--   按处理器字面语义分别读取proto50的A[2]、A[3]、A[0]、A[1]。
--   这与proto50在PC269处只显式建立一个捕获映射槽之间存在未解释的索引不匹配：
--   A[2]/A[3]/A[1]在该代理环境下是否有效，必须继续核实。可能涉及序列化字段解释、
--   VM环境复用或实际执行路径；当前不擅自判定为有效对象，也不据此恢复购买请求。
--   本轮结论是：捕获代理的处理器语义已直接确认，但proto50->proto51四个索引的
--   可达性仍待确认。proto36是否能通过该环境传入购买金条回调，仍未证实。

-- TODO：按新版原型身份映射逐项恢复。

-- ============================================================
--  9. 文件收尾与返回值
-- ============================================================

-- TODO：依据原始文件入口结构确认最终返回表达式，不提前猜测。


-- 2026-11-12 第十轮：按父原型子原型数组位置纠正闭包身份映射（重要纠错）
--   前几轮把递归先序原型ID误当成父函数J数组的子原型索引，导致把proto48 PC269
--   错认成创建proto50，并由此制造出“捕获数量/索引不匹配”的假异常。现已按解释器
--   J[E[3]]及加载器N[E-1]=M()的真实零起始子原型数组重新映射，撤回此前该异常结论。
--
--   root子原型数组位置与原型ID并非恒等。root PC438才是创建proto48的闭包指令：
--   子原型索引37 -> proto48，捕获数15；PC439-453全部为opcode57，依次捕获
--   root局部寄存器4、2、0、3、1、44、7、39、8、54、5、55、11、12、9。
--   因而proto48的upvalue槽0..14分别对应上述15个root局部寄存器。
--
--   proto48 PC269实际创建的是proto52：子原型索引2 -> proto52，捕获数1，
--   PC270 opcode374 index9；这条指令与购买金条的proto50/51链无关。
--   proto48 PC272才创建proto50：子原型索引1 -> proto50，捕获数4；
--   PC273-276 opcode374依次捕获proto48 A[3]、A[10]、A[11]、A[0]。
--   因此proto50的upvalue槽0..3依次映射到root局部寄存器3、5、55、4。
--   proto50 PC13创建proto51：子原型索引0 -> proto51，捕获数4；
--   PC14-17 opcode374依次捕获proto50 A[2]、A[3]、A[0]、A[1]。
--   因此proto51的upvalue槽0..3依次映射到root局部寄存器55、4、3、5。
--
--   结论：proto50->proto51的四项捕获完全有效；之前所谓“只有一个捕获槽却读取
--   A[2]/A[3]/A[1]”是把proto48 PC269错配到proto50造成的误判。序列化字段解析、
--   opcode177处理器及opcode374捕获语义在这几条指令上相互吻合，未发现字段偏移问题。
--
--   root PC436创建proto36的指令确实存在，但其创建点与proto48 PC438不同；
--   不能仅凭proto36是root子原型就认定它被proto50/51捕获。当前购买金条回调的
--   真实upvalue来源已经明确为root局部寄存器55、4、3、5；下一步要追查这些寄存器
--   在root中的赋值/初始化，以及proto51是否通过它们触发商城购买或代理事件。
--   之前关于root PC430创建proto48、root PC46创建proto36、proto48 PC269创建proto50，
--   以及据此推导的捕获异常/不可达判断，全部以本轮映射为准予以撤回。


-- 2026-11-12 第十一轮：确认购买金条回调实际调用商城购买辅助函数
--   在第十轮修正子原型数组索引后，继续沿捕获槽追踪到proto51的真实调用点：
--   root PC436：opcode177创建proto36，目标子原型索引29，结果写入root局部寄存器55。
--   root PC438：opcode177创建proto48，捕获数15；其PC450捕获root局部寄存器55，
--   即proto48 A[11]指向proto36闭包。
--   proto48 PC272：opcode177创建proto50，4项捕获依次为proto48 A[3]、A[10]、A[11]、A[0]；
--   因而proto50 A[2]指向proto36闭包。
--   proto50 PC13：opcode177创建proto51，4项捕获依次为proto50 A[2]、A[3]、A[0]、A[1]；
--   因而proto51 A[0]指向proto36闭包。
--
--   proto51 PC22为opcode17，解释器对应读取A[E[3]]，将A[0]（proto36闭包）放入V[3]。
--   PC23、PC24分别加载proto51常量索引8和11，即“金条”和数值1，放入V[4]、V[5]。
--   PC25为opcode39；解释器处理器明确执行V[E[2]](H(V,E[2]+1,E[3]))，
--   即调用V[3]，实参为V[4]、V[5]，并接收返回值到V[3]起始的结果寄存器。
--   proto36的参数数为2，故这条调用与proto36的两个形参完全对应。
--
--   关键结论：购买金条按钮的定时回调proto51确实调用proto36商城购买辅助函数，
--   调用参数已确认是物品名称“金条”和购买数量1。此前“proto51没有调用proto36”
--   的判断已被本轮捕获链和实际调用指令推翻；此前仅凭proto51常量表未出现RequestBuy
--   就判断无购买请求，是不完整的，因为RequestBuy封装在被捕获的proto36闭包内部。
--   PC20的金币门槛分支决定是否进入PC22-25的购买调用段；当前已确认该段属于
--   金币数量大于2000000时执行的高金币分支。PC26随后按购买辅助函数返回值真假分流，
--   但返回值的确切业务含义和后续成功/失败提示路径仍需继续核对proto36尾部与PC26之后。
--
--   本轮已闭合“按钮定时回调 -> proto51 -> 捕获的proto36 -> 购买‘金条’1个”调用链。
--   下一步：核对proto36内部RequestBuy的实参/返回值，再解读proto51 PC26-57的
--   成功/失败提示及定时器清理分支，随后把可确认的购买金条Lua 5.1函数体写入本文件。


-- 2026-11-12 第十二轮：修正新版指令常量操作数映射，并细化购买调用尾段
--
--   本轮重新对照11.9内嵌加载器M()的指令解码代码，校正指令flag中的常量替换位：
--   flag第4位映射操作数A，第5位映射操作数B，第6位映射操作数C；此前临时解析
--   输出曾把常量替换位整体错后一位，导致部分操作数显示位置不准确。以下以本轮
--   按加载器原始位定义重新解析的字段为准；此前PC级文字说明中若与此冲突，以本段为准。
--
--   proto36（root子原型索引29，2个形参，149条指令）重新核对：
--   * PC1-8：通过global.Facade.retrieveProxy(global.ProxyTable.PageStoreProxy)
--     获取商城代理；PC9起有代理有效性分支，失败文案为“商城代理不可用”。
--   * PC14-20：通过SL.GetMetaValue读取ITEM_INDEX_BY_NAME映射，并对返回值做类型/有效性检查；
--     未取得有效物品索引时，PC29-35附近构造“物品索引不存在”提示路径。
--   * PC37-58：遍历PageStoreProxy.pageData，按商品数据中的Id等字段定位对应商品记录。
--   * PC77-118：围绕商品Index、Condition/condis、SL.CheckCondition、CheckStoreLimitStatus
--     以及LimitCount/BuyCount进行条件和限购检查；常量表明确包含“条件不满足”、
--     “已到限购上限”和“限购剩余 0”等提示。
--   * PC141读取商城代理上的RequestBuy成员；PC142读取商品记录的Index字段；
--     PC143-148继续构造最终调用帧，PC149返回。当前已确认RequestBuy调用位于函数尾部，
--     但还没有把PC141-148的调用约定（receiver、显式参数顺序、返回值寄存器）
--     全部闭合，因此暂不把参数列表写成确定源码。
--
--   proto51（proto50的唯一子原型，77条指令）按正确常量操作数映射复核：
--   * PC10-18：取得MoneyProxy，调用GetMoneyIdByName("金币")，再调用
--     GetMoneyCountById查询当前金币数量。
--   * PC20的比较操作数之一确为常量2000000；结合已核实的opcode367分支语义，
--     只有当前金币数大于2000000才进入购买段。
--   * PC22-25：从捕获upvalue A[0]取proto36闭包，调用参数为“金条”和1。
--   * PC26-27根据proto36调用返回值进入两条不同结果路径；PC28-31包含成功文案
--     “买金条成功，当前金币：%d”的格式化路径；PC33-46包含失败文案
--     “买金条失败：%s”/“买金条失败：”及ShowSystemTips提示处理。
--     两条路径的真假极性仍需以opcode165/85的处理器语义最终确认，当前不擅自写成
--     “返回true必然成功”或“返回false必然失败”。
--   * PC48-57存在buygoldTimer取消与清理路径；PC59-76是金币不足时取消定时器、
--     清空buygoldTimer并显示“金币不足200W，买金条结束”的路径。
--
--   当前确认：购买金条按钮链最终会调用proto36，商品名“金条”、数量1；proto36尾部
--   确实读取商城代理RequestBuy成员；金币门槛、调度周期、低金币结束提示均已由新版
--   原始指令确认。
--   仍待确认：RequestBuy调用的receiver/参数顺序/返回寄存器；proto51 PC26-27真假分支
--   的极性；proto50按钮处理器的完整启停状态；proto2清理入口的具体触发时机。
--   本轮没有补写不确定的购买函数体，避免把尚未闭合的VM调用帧伪装成已恢复源码。


-- ============================================================
--  8.1 自动购买金条：已恢复的定时回调与按钮处理器
-- ============================================================

-- proto50/proto51的捕获映射（按新版opcode177及capture顺序）：
--   proto50 UP[0] = root状态表（其中保存buygoldTimer）
--   proto50 UP[1] = 启动提示函数
--   proto50 UP[2] = BuyStoreItem（proto36）
--   proto50 UP[3] = 格式化提示函数
--   proto51 UP[0] = BuyStoreItem，UP[1] = 格式化提示函数，
--                  UP[2] = root状态表，UP[3] = 启动/结束提示函数。
-- 注意：buygoldTimer是状态表字段，不是本文件内另建的独立局部变量。

-- 对应 proto36：按物品名称定位商城商品，检查购买条件和限购后提交请求。
-- 该函数的寄存器控制流已逐段对应新版PC1-PC149；API参数均按原指令调用帧恢复。
local function BuyStoreItem(itemName, buyCount)
    local pageStoreProxy = global.Facade:retrieveProxy(global.ProxyTable.PageStoreProxy)
    if not pageStoreProxy then
        return false, "商城代理不可用"
    end

    -- 原版通过pcall保护物品名称到索引的查询，避免元数据查询异常中断函数。
    local lookupOK, itemIndex = pcall(
        SL.GetMetaValue,
        SL,
        "ITEM_INDEX_BY_NAME",
        itemName
    )

    if not lookupOK
        or type(itemIndex) ~= "number"
        or itemIndex <= 0
    then
        return false, "物品索引不存在: " .. tostring(itemName)
    end

    -- pageData按页保存商城商品；只遍历数值页号且小于100的页面。
    -- 每页商品集合必须为table，商品Id与名称查询得到的索引直接比较。
    local foundGoods = nil
    local pageData = pageStoreProxy.pageData
    if not pageData then
        pageData = {}
    end

    for pageKey, pageItems in pairs(pageData) do
        local numericPageKey = tonumber(pageKey)
        if numericPageKey and numericPageKey < 100
            and type(pageItems) == "table"
        then
            for _, goods in pairs(pageItems) do
                if goods and goods.Id == itemIndex then
                    foundGoods = goods
                    break
                end
            end
        end

        if foundGoods then
            break
        end
    end

    if not foundGoods then
        return false, "商城没有这件道具"
    end

    if not pageStoreProxy:CheckStoreLimitStatus(foundGoods.Index) then
        return false, "已到限购上限"
    end

    -- 新版优先使用Condition；字段不存在/为假时回退到condis。
    local condition = foundGoods.Condition
    if not condition then
        condition = foundGoods.condis
    end

    if condition and condition ~= "" then
        if not SL:CheckCondition(condition) then
            return false, "条件不满足"
        end
    end

    -- 默认购买数量为传入值的数值转换结果；转换失败时使用1。
    buyCount = tonumber(buyCount) or 1

    -- CountMax大于0时，单次购买数不得超过该值。
    local countMax = tonumber(foundGoods.CountMax)
    if countMax and countMax > 0 and countMax < buyCount then
        buyCount = countMax
    end

    -- LimitCount为累计限购上限，BuyCount为已购买数量。
    local limitCount = tonumber(foundGoods.LimitCount)
    if limitCount and limitCount > 0 then
        local alreadyBought = tonumber(foundGoods.BuyCount) or 0
        local remainingCount = limitCount - alreadyBought

        if remainingCount < buyCount then
            buyCount = remainingCount
        end

        if buyCount <= 0 then
            return false, "限购剩余 0"
        end
    end

    -- 原始调用帧：PageStoreProxy:RequestBuy(goods.Index, buyCount, 0)。
    -- proto36不读取宿主RequestBuy返回值，而是在提交调用后主动返回true和数量。
    pageStoreProxy:RequestBuy(foundGoods.Index, buyCount, 0)
    return true, buyCount
end

-- 对应 proto51：购买金条的周期回调。
-- 四个参数按闭包捕获顺序传入，避免把root状态表误建成独立buygoldTimer变量。
local function MakeBuyGoldTimerCallback(
    BuyStoreItem,
    showLocalNotice,
    timerState,
    unusedCapturedFunction
)
    return function()
        local moneyProxy = global.Facade:retrieveProxy(global.ProxyTable.MoneyProxy)
        if not moneyProxy then
            return
        end

        local moneyId = moneyProxy:GetMoneyIdByName("金币")
        if not moneyId then
            return
        end

        local goldCount = moneyProxy:GetMoneyCountById(moneyId)
        if not goldCount then
            -- 原始控制流：余额值为假时停止定时器并提示结束。
            -- Lua数值0是真值，会继续进入下面的2000000比较。
            if timerState.buygoldTimer then
                SL:UnSchedule(timerState.buygoldTimer)
                timerState.buygoldTimer = nil
            end
            SL:ShowSystemTips("金币不足200W，买金条结束")
            return
        end

        if goldCount > 2000000 then
            local buyOK, buyResult = BuyStoreItem("金条", 1)

            if buyOK then
                -- 此捕获函数接收格式串和金币数；不是SL.ShowSystemTips直接调用。
                showLocalNotice("买金条成功，当前金币：%d", goldCount)
                -- 成功路径保留timer，继续周期检测。
            else
                SL:ShowSystemTips("买金条失败：" .. tostring(buyResult))
                if timerState.buygoldTimer then
                    SL:UnSchedule(timerState.buygoldTimer)
                    timerState.buygoldTimer = nil
                end
            end
        else
            if timerState.buygoldTimer then
                SL:UnSchedule(timerState.buygoldTimer)
                timerState.buygoldTimer = nil
            end
            SL:ShowSystemTips("金币不足200W，买金条结束")
        end
    end
end

-- 对应 proto48 PC277：把proto50闭包登记到按钮回调表的buygoldbut键；
-- 对应按钮配置为key="buygoldbut"、显示名="购买金条"。
-- proto48的15项捕获中，proto50按顺序捕获：
--   A[0] = root.MainLeftBottom状态表；A[1] = root的ShowLocalNotice包装函数；
--   A[2] = BuyStoreItem(proto36)；A[3] = root调试/日志闭包（proto50/51未使用）。
-- 因此proto50处理器参数顺序必须保持以下四项，不得交换第2/4项。
-- 已有buygoldTimer时原版直接返回true；没有timer才显示本地提示并Schedule。
local function OnBuyGoldButtonClick(
    timerState,
    showLocalNotice,
    BuyStoreItem,
    unusedCapturedFunction
)
    if timerState.buygoldTimer then
        return true
    end

    showLocalNotice("开始检测金币(>200W买金条)")
    local callback = MakeBuyGoldTimerCallback(
        BuyStoreItem,
        showLocalNotice,
        timerState,
        unusedCapturedFunction
    )
    timerState.buygoldTimer = SL:Schedule(callback, 0.5)
    return true
end

-- proto36的PC1-PC149已恢复为BuyStoreItem；proto50/51的timer字段及四项闭包捕获
-- 也按新版指令关系表达。按钮事件已有timer时原版直接返回true，不执行取消。

-- 检查点 #69 / #134：Builtsetting 完整静态恢复
-- root.children[23] / legacy root/24；55条物理指令；15常量；无子原型；无显式参数。
-- UP[0] <- root R5：身份未知，但可确认其调用契约为接收一条中文提示文本的回调。

local function MakeBuiltsetting(onSettingMessage)
    return function Builtsetting()
        -- PC1-PC9
        CHANGE_SETTING(27, { 0 })
        onSettingMessage("关闭背景音乐")

        -- PC10-PC18
        CHANGE_SETTING(52, { 0 })
        onSettingMessage("关闭游戏音乐")

        -- PC19-PC27
        CHANGE_SETTING(1002, { 0 })
        onSettingMessage("关闭高帧率")

        -- PC28-PC36
        CHANGE_SETTING(57, { 1 })
        onSettingMessage("开启人物简装")

        -- PC37-PC45
        CHANGE_SETTING(58, { 1 })
        onSettingMessage("开启怪物简装")

        -- PC46-PC54
        CHANGE_SETTING(2005, { 0 })
        onSettingMessage("关闭屏蔽怪物")

        -- PC55：return，无显式返回值。
    end
end

-- 静态复核：六组CHANGE_SETTING调用的编号、单元素数组值、顺序和后续提示均与PC对应。
-- UP[0]业务名称未知，不臆造为日志/通知API；55条指令均已映射，未运行时验证。

# 检查点 #108：Nested_ffffff批量按钮状态同步复核

日期：2026-11-09  
函数：Nested_ffffff  
规范路径：`root.children[42].children[5]`  
legacy：`root/43/6`  
物理指令：41；常量：10；子原型：0；vararg_flag=2。

## 捕获来源
doInit_UI PC236创建闭包：
- UP[0] <- 父T[12]：按钮配置数组。
- UP[1] <- 父UP[4]：按key索引的按钮对象注册表。

## 控制流恢复
### 配置遍历（PC1-PC11）
- PC1-PC3取得ipairs并开始遍历UP[0]。
- PC4是通用for循环入口跳转至PC10迭代器调用。
- PC5读取当前config.key。
- PC6比较config.key与首个参数key。
- 不相等时PC7跳至PC10继续迭代。
- 相等时PC8保留当前config，PC9写入config.toggled=第二个参数toggled。
- 循环不提前退出；若存在重复key，R2最终保留最后一个匹配配置。

### GUI更新前置条件（PC12-PC20）
- PC12-PC13读取UP[1][key]作为button。
- PC14-PC15 button false/nil时直接返回。
- PC16-PC17检查最后一个匹配配置；没有匹配配置时R2为nil，直接返回。
- PC18-PC20读取matchedConfig.toggle；false/nil时返回。

### 标题更新（PC21-PC30）
- 取得GUI.Button_setTitleText方法并保留GUI self。
- 若第二参数toggled为truthy且matchedConfig.toggle为truthy，标题值取matchedConfig.toggle。
- 否则标题值取matchedConfig.name。
- 调用GUI:Button_setTitleText(button,title)。

### 颜色更新（PC31-PC40）
- 取得GUI.Button_setTitleColor方法。
- toggled truthy时颜色为`#ff0000`；否则为`#ffffff`。
- 调用GUI:Button_setTitleColor(button,titleColor)。

## 等价控制逻辑
```lua
for _, config in ipairs(buttonConfigs) do
    if config.key == key then
        matchedConfig = config
        config.toggled = toggled
    end
end

local button = buttonByKey[key]
if not button or not matchedConfig or not matchedConfig.toggle then
    return
end

local title = toggled and matchedConfig.toggle or matchedConfig.name
GUI:Button_setTitleText(button, title)
GUI:Button_setTitleColor(button, toggled and "#ff0000" or "#ffffff")
```

## 结论与限制
- 41条物理指令的循环、key比较、字段写回、三项GUI更新前置检查、标题/颜色分支及返回路径闭合。
- 不可在循环首次命中后break；原指令会继续遍历，最后一次匹配覆盖R2。
- UP[0]/UP[1]的业务身份由使用行为命名，父寄存器的原作者变量名未恢复。
- 未进行游戏客户端运行时验证。

状态：完整静态恢复（未运行时验证）。

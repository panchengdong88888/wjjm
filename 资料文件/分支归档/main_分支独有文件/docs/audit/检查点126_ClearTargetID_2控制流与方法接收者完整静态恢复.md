# 检查点 #126：ClearTargetID_2控制流与方法接收者完整静态恢复

日期：2026-11-09

## 一、原型身份

- 函数：ClearTargetID_2
- 规范路径：`root.children[56]`
- legacy：`root/57`
- 原型索引：106
- 物理指令：22
- 常量：9
- 子原型：0
- vararg标记：0
- 父级创建点：root PC185，captures=0

父root PC185创建该闭包，捕获数为0；函数内部不存在UPVALUE读取，因此无需推测捕获身份。

## 二、逐段控制流

### 1. Facade存在性检查（PC1-PC5）

- PC1-PC2读取`global.Facade`。
- PC3进行truthy判断。
- PC4跳转至代理获取分支；Facade为假值时执行PC5直接return。

等价逻辑：Facade不存在则结束函数。

### 2. 获取PlayerInputProxy（PC6-PC15）

- PC6-PC8解析Facade上的`retrieveProxy`方法，并保留Facade作为方法接收者。
- PC9-PC11取得`global.ProxyTable.PlayerInputProxy`。
- PC12调用方法，实参为Facade接收者和PlayerInputProxy标识。
- PC13检查返回代理的truthy状态。
- PC14进入设置分支；代理不存在时PC15直接return。

等价调用：`facade:retrieveProxy(global.ProxyTable.PlayerInputProxy)`。

### 3. 设置查找目标ID（PC16-PC22）

- PC16取得代理的`SetTargetID`方法，并保留代理作为接收者。
- PC17准备数值参数`0`。
- PC18-PC20读取`global.MMO.SELETE_TARGET_TYPE_FIND`。
- PC21调用方法，参数为代理接收者、0和查找类型常量。
- PC22直接return，无显式返回值。

等价调用：`proxy:SetTargetID(0, global.MMO.SELETE_TARGET_TYPE_FIND)`。

## 三、恢复源码

```lua
local function ClearTargetID_2()
    local facade = global.Facade
    if not facade then
        return
    end

    local proxy = facade:retrieveProxy(global.ProxyTable.PlayerInputProxy)
    if not proxy then
        return
    end

    proxy:SetTargetID(0, global.MMO.SELETE_TARGET_TYPE_FIND)
end
```

## 四、静态结论与边界

- 22条物理指令均纳入控制流映射。
- 两个提前返回分别对应Facade不存在、PlayerInputProxy不存在。
- 两次对象方法调用均保留接收者；不能改写为丢失self的点调用。
- `SELETE_TARGET_TYPE_FIND`按字节码常量路径保留原拼写，不擅自纠正为其他枚举名称。
- 函数无显式返回值。
- 未进行目标客户端运行时验证。

## 五、修改与统计

- 修改：`04_源码候选/短函数草稿_第十六批.lua`。
- 新增：本审计文件。
- 函数状态CSV升级为完整静态恢复（未运行时验证）。
- 本批将既有草稿ClearTargetID_2升级为完整静态恢复，不新增普通Lua草稿。

统计：普通Lua草稿78；完整静态恢复68/110（61.8%）；运行时验证0。

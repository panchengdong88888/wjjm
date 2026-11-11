# 检查点283：根模块当前chunk ENV与ENV["_G"]语义区分

日期：2026-11-11  
工作分支：`work/functional-equivalent-rebuild-2026-11-11`  
基线：检查点282

## 一、发现的问题

原始根模块的环境访问由 `OP_137` / `OP_141` 等指令直接读写当前chunk环境 `ENV`。此前功能等价适配代码多处用 `_G` 代替该环境，隐含假设 `ENV == _G`。这不是原始指令本身保证的关系。

同时，PC44与普通全局导出的语义不同：

- PC44：读取 `ENV["_G"]` 的值放入父寄存器T[5]。
- PC45：对刚刚读取到的T[5]执行 `T[5].log = T[4]`。
- PC55、PC57等全局导出：直接执行 `ENV[name] = closure`。

因此，不能把PC45的 `ENV["_G"].log` 与PC55以后的 `ENV.GetMapId` 等操作混成同一种写入。

## 二、PC级对应关系

| 原始PC | 原始环境操作 | 本批源码表达 |
|---|---|---|
| PC2 | `ENV["MainLeftBottom"] = moduleTable` | `rootEnvironment.MainLeftBottom = MainLeftBottom` |
| PC4-PC5 | 重新读取 `ENV.MainLeftBottom`，写入其 `a` 字段 | `moduleForA = rootEnvironment.MainLeftBottom` 后写 `moduleForA.a` |
| PC31-PC32 | 再次读取 `ENV.MainLeftBottom`，写入其 `b` 字段 | `moduleForB = rootEnvironment.MainLeftBottom` 后写 `moduleForB.b` |
| PC34-PC35 | 再次读取 `ENV.MainLeftBottom`，写入其 `z` 字段 | `moduleForZ = rootEnvironment.MainLeftBottom` 后写 `moduleForZ.z` |
| PC44-PC45 | 先取 `ENV["_G"]`，再写入该表的 `log` | `rootRegisters[5] = rootEnvironment._G`；再写 `rootRegisters[5].log` |
| PC55-PC85 | 对应各PC将闭包写入 `ENV[name]` | 全部写入 `rootEnvironment.name` |
| PC213、237、246、255、258、260 | 全局导出入口闭包 | 写入 `rootEnvironment` 对应名称 |
| PC275、PC389 | 从当前chunk环境重新读取 `MainLeftBottom` | 分别通过 `rootEnvironment.MainLeftBottom` 获取 |
| PC382、PC388 | 全局导出 `BlacklistItems`、`ClearBlacklistItems` | 写入 `rootEnvironment` 对应字段 |
| PC411-PC412 | 向PC389读取到的模块表写入 `doInit`，随后返回根模块表 | `doInitModule.doInit = ...`，最终返回已装配根模块 |

## 三、代码修改

### 1. 当前chunk环境解析

`MainLeftBottom_恢复源码.lua` 的根模块来源块和独立根模块候选 `root_MainLeftBottom_Module.lua` 现在使用相同解析策略：

```lua
local rootEnvironment
if type(getfenv) == "function" then
    rootEnvironment = getfenv(1)
else
    rootEnvironment = _ENV or _G
end
assert(type(rootEnvironment) == "table")
```

Lua 5.1环境优先使用 `getfenv(1)`；Lua 5.2及更新版本使用词法 `_ENV`；只有运行环境不提供这两种机制时才回退到 `_G`。这是兼容性适配，不代表已经在目标游戏运行时确认环境对象身份。

### 2. 根表初始化与挂接

- PC2通过 `rootEnvironment.MainLeftBottom` 导出模块表。
- PC4、PC31、PC34分别显式读取同一个当前chunk环境里的 `MainLeftBottom`，并分别挂接a、b、z。
- 根模块来源表额外导出 `environment`，主装配区只从该来源读取环境对象，不再重新假定 `_G` 就是chunk环境。

### 3. 全局导出与PC44/45分离

- PC55-PC85、PC213、PC237、PC246、PC255、PC258、PC260、PC382、PC388的全局写入统一改为 `rootEnvironment[name] = closure`。
- PC44/45单独保留 `rootEnvironment._G` 读取，并把 `log` 写入读取所得的表。
- `AttachRecoveredPrototypes` 兼容适配器现在接受可选environment参数；未传入时优先使用已登记的根chunk环境。正式主装配段仍不调用该旧适配器。

### 4. 最终入口

PC275和PC389都从同一个 `rootEnvironment` 重新读取 `MainLeftBottom`。PC279和PC411分别将 `main`、`doInit` 写到各自读取到的模块表对象；没有把这两处重新读取简化成无条件访问 `_G`。

## 四、静态核对

已对两份根模块源码检查：

- 当前chunk环境解析代码在根模块来源块中存在。
- PC2、PC4、PC31、PC34的模块表环境读写均有对应语句。
- PC44读取 `rootEnvironment._G`；PC45写入读取结果的 `log`。
- 所列全局闭包导出已改为写入 `rootEnvironment`。
- PC275、PC389均通过 `rootEnvironment.MainLeftBottom` 重新读取模块表。
- 根候选中的PC1-PC412总账已将普通全局导出标为ENV，将PC45单独标为ENV["_G"].log。

本批只完成静态源码和证据账本一致性核对，没有可用Lua/luac/解析器；没有声称Lua语法编译通过，也没有进行目标游戏运行时验证。根模块仍未完成整体作者级连续源码恢复，静态函数统计109/110、普通Lua草稿72、运行时验证0均不变。

## 五、下一步

继续核对根模块PC86-PC412中共享cell、寄存器复用、模块字段及闭包捕获的逐PC一致性；随后按用户优先级系统复核 `doInit_UI` 父函数和23个子原型。背包、仓库业务仍暂缓。

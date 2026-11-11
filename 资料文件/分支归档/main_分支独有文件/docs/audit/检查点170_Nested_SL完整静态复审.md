# 检查点 #170：Nested_SL 完整静态复审

日期：2026-11-09
目标：root.children[15].children[0] / legacy root/16/1 / Nested_SL（13条）。

## 父级捕获来源

父函数 ClearBlacklistItems（root.children[15]）：PC52 创建 child[0]；PC53 OP_387 B=8，子 UP[0] 捕获父当前 R8，即当前条目 key；PC54 OP_387 B=0，子 UP[1] 捕获父 R0，即 FriendProxy。捕获顺序为 entryKey、FriendProxy。

## 子函数逐PC复核

- PC1-PC2：取得 SL.RequestOutBlacklist，保留 SL 为 receiver。
- PC3-PC4：读取 UP[0] 并调用 SL:RequestOutBlacklist(entryKey)，一个显式参数。
- PC5-PC6：读取 UP[1]._blacklistData。
- PC7-PC8：检查该字段 truthy；不存在则跳至返回。
- PC9-PC10：重新读取 FriendProxy._blacklistData。
- PC11-PC12：以 entryKey 为键写入 nil，删除对应条目。
- PC13：return，无显式返回值。

13条物理指令全部覆盖；无子原型、无 vararg、无其他返回值。普通Lua表达为：

```lua
local function make_Nested_SL(entryKey, friendProxy)
    return function Nested_SL()
        SL:RequestOutBlacklist(entryKey)
        if friendProxy._blacklistData then
            friendProxy._blacklistData[entryKey] = nil
        end
    end
end
```

## 状态

- Nested_SL：完整静态恢复，未运行时验证。
- 普通 Lua 草稿数：81。
- 完整静态恢复：92/110。
- 运行时验证：0。
- 已更新源码候选、函数状态CSV、机器状态JSON及checkpoint协议。

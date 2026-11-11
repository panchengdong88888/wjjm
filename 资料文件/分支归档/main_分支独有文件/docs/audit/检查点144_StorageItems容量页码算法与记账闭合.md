# 检查点 #144：StorageItems 容量页码算法与发送后记账闭合

日期：2026-11-09  
原型：`root.children[50]` / legacy `root/51`  
子原型：`root.children[50].children[1]` / legacy `root/51/2`

## 1. 父函数页计数表

PC37-PC53建立 `storedPageData`：

- PC37创建空表R4。
- 数值for循环遍历page=1..maxPage。
- 每页调用 `NPCStorageProxy:GetStorageDataByPage(page)`。
- PC48执行 `#pageData`；若该页数据不存在，PC51将计数设为0。
- PC52写入 `storedPageData[page] = pageData and #pageData or 0`。

因此R4不是合并后的物品明细表，而是以页码为键、该页当前物品数量为值的计数表。

## 2. 子原型1捕获映射

PC54创建子原型1，PC55-PC58捕获父函数R1/R2/R3/R4：

| upvalue | 父寄存器 | 业务值 |
|---|---|---|
| UP[0] | R1 | maxPage |
| UP[1] | R2 | pageCapacity |
| UP[2] | R3 | openSize |
| UP[3] | R4 | storedPageData |

闭包无显式参数，PC177-PC178零参数调用。

## 3. 子原型1逐PC化简

- PC1：R0=1（for循环初值）。
- PC2：R1=UP[0]（maxPage）。
- PC3：R2=1（步长）。
- PC4：R0=R0-R2，然后跳到PC24进入数值for循环。
- PC5：R4=UP[1]（默认页容量上限）。
- PC6：R5=UP[0]（maxPage）。
- PC7-PC8：判断当前循环页R3是否等于maxPage；不是最后一页则跳过末页容量计算。
- PC9-PC15是一条线性融合链，依次得到：
  - R5=UP[2]（openSize）
  - R6=UP[0]（maxPage）
  - R6=R6-1
  - R7=UP[1]（pageCapacity）
  - R6=R6*R7
  - R4=R5-R6
  - R5=UP[1]（pageCapacity）
- PC16比较pageCapacity是否小于剩余容量；若是，PC18将R4设回pageCapacity；否则保留剩余容量。
- 因此最后一页容量上限为 `min(pageCapacity, openSize - (maxPage - 1) * pageCapacity)`。
- PC19-PC20读取 `storedPageData[currentPage]`。
- PC21比较当前已存数量是否小于当前页容量上限；小于则PC23返回当前页码R3；否则PC22跳到PC24继续下一页。
- PC24为数值for循环步进，PC25清理循环控制槽；所有页都满时函数无显式返回值（nil）。

等价普通Lua：

```lua
local function findAvailableStoragePage()
    for page = 1, maxPage do
        local pageLimit = pageCapacity

        if page == maxPage then
            local remaining = openSize - (maxPage - 1) * pageCapacity
            if pageCapacity < remaining then
                pageLimit = pageCapacity
            else
                pageLimit = remaining
            end
        end

        if storedPageData[page] < pageLimit then
            return page
        end
    end
end
```

## 4. PC206-PC211发送后融合记账链

PC206带有5个线性融合载荷，连同本体依次覆盖PC206-PC211：

1. PC206：R22 = item.MakeIndex。
2. PC207：R12[R22] = true。
3. PC208：R22 = R4[R21]，即读取目标页当前计数。
4. PC209：R22 = R22 + 1。
5. PC210：R4[R21] = R22，写回目标页计数。
6. PC211：R13 = R13 + 1，成功存入计数递增。

交叉证据：
- PC100初始化R12为空表。
- PC109-PC112按当前物品MakeIndex查询R12，已存在则跳过该物品处理路径。
- 因而R12是本轮已处理/已发送MakeIndex集合。
- R21为子原型1返回的目标页码；R4是storedPageData。
- PC218-PC223使用R13生成“存仓完成, 共存入 N 件物品”提示。

## 5. LuaSendMsg第4实参

PC192-PC205构造七个实参，第4实参来自PC177-PC178子原型1返回值。由上述调用点数据流可确认它是目标仓库页码。服务端接收端协议中该字段的正式名称、编码含义尚未获得接收端证据，不在此臆造。

## 统计与状态

普通Lua草稿：78  
完整静态恢复：76 / 110  
运行时验证：0

本批闭合StorageItems两个剩余核心算法/记账问题，但由于服务端协议字段名称仍未确认，主函数继续保持“首版普通Lua草稿（待静态复审/未运行时验证）”，不升级完整静态恢复。

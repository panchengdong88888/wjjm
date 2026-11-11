# 检查点 #54：Nested_ffffff 首版普通 Lua 草稿

日期：2026-11-09  
对象：`root.children[42].children[5]`（legacy `root/43/6`）  
原型索引：64  
物理指令：41；常量：10；子原型：0；vararg_flag：2

## 本批产物

- 源码：`04_源码候选/短函数草稿_第三十二批.lua`
- 状态：首版普通 Lua 草稿，未运行时验证。
- 本批新增草稿：1。
- 草稿累计：41。
- 完整静态恢复累计：27/110（24.5%）。
- 运行时验证：0。

## 闭包捕获

- 父级 `root/43` 在 PC236 创建闭包，捕获数为2。
- PC237 捕获父级 R12 到子函数 UP[0]。
- PC238 捕获父级 UP[4] 到子函数 UP[1]。
- 父级 `root/43` 在 root PC390 创建，捕获数为20；其 UP[4] 对应 root 的 R1。
- 本草稿将 UP[0] 临时命名为 `buttonConfigs`，将 UP[1] 临时命名为 `buttonLookup`。具体业务对象名仍需沿 root R12、root R1 的定义和填充点复核。

## 控制流核对

1. PC1–4：以 `ipairs(UP[0])` 建立泛型循环。
2. PC5–9：比较每个配置项的 `key` 与第一个参数；匹配时保存该项，并写入 `toggled = 第二个参数`。
3. PC10–11：循环迭代与回边。
4. PC12–15：读取 `UP[1][key][key]`；不存在时结束函数。
5. PC16–20：检查是否找到配置项，以及其 `toggle` 字段是否为真值；任一不满足则结束。
6. PC21–30：调用 `GUI.Button_setTitleText(button, title)`。标题选择等价于 `(enabled and itemData.toggle) or itemData.name`。
7. PC31–40：调用 `GUI.Button_setTitleColor`；enabled 为真时使用 `#ff0000`，否则使用 `#ffffff`。
8. PC41：无值返回。

## 待静态复审

- 第一个参数作为 key、第二个参数作为 enabled 与寄存器使用一致；需结合调用点确认调用方命名。
- `buttonLookup[key][key]` 按 PC12–13 的双层动态索引保留；暂不擅自简化成单层索引。
- UP[0]/UP[1] 的临时业务名及其父级实际对象结构尚待追踪。
- 本函数依赖 `GUI.Button_setTitleText` / `GUI.Button_setTitleColor` 的静态调用形式，未做运行时验证。

## 结论

已形成可读普通 Lua 草稿。循环匹配、字段写入、双层按钮查找、保护条件、标题与颜色更新均已映射到 corrected PC；捕获对象的真实业务名和调用方参数名仍待复审。本批不计入完整静态恢复数。

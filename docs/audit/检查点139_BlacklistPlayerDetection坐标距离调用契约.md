# 检查点 #139：BlacklistPlayerDetection 玩家名称、坐标与距离调用契约

日期：2026-11-09
原型：root.children[47] / legacy root/48。

## 已确认
- PC94-PC101：ACTOR_NAME查询的对象实参来自当前视野列表元素player。若查询结果为假值，使用固定名称“黑名单玩家”继续处理。
- PC108-PC127：先对MAIN_ACTOR_ID读取ACTOR_MAP_X/Y，再对player读取ACTOR_MAP_X/Y。得到本机X/Y与目标X/Y四个值。
- PC128-PC134：UPVALUE_5调用栈为五个独立参数：mainActorX、mainActorY、playerX、playerY、state.distance。不是把四坐标包装成表传递。
- PC136-PC141：返回距离与nil哨兵比较；nil表示无效结果，非nil才继续通知/传送逻辑。

## 修订
已更新第五十九批草稿，将ACTOR_NAME实参改为player、加入默认名称回退、按MAIN_ACTOR_ID/player读取四坐标、以五实参调用UPVALUE_5，并将距离判断改为nil。

## 未完成
PC142-PC216的alertAt/nextTryAt细节、随机传送物品选择、table.concat路径及通知回调参数仍需逐PC核对；13个upvalue的业务身份未全部映射。函数仍是普通Lua草稿，不升级完整静态恢复。

统计：普通Lua草稿78；完整静态恢复76/110；运行时验证0。

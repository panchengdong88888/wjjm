-- MainLeftBottom.lua：全量 Lua 源码草稿（第二遍：寄存器语义提升）
-- 依据：阶段三校正反汇编 + 新框架(3_40_xx) API 文档。
-- 本稿将 110 个原型的逐条 VM 语义提升为 Lua 语句形态；寄存器仍以 r[n] 表示，复杂 VM 辅助操作保留原语义。
-- 注意：这是批量反编译草稿，不等于已完成控制流结构化或运行验证；未知运行时对象/辅助函数以 TODO 标记。
-- 不删除任何物理 PC；跳转、闭包捕获和融合载荷信息保留在注释中。

local __ENV = _G
local __VM_TODO = {}


-- ============================================================================
-- 原型 root | 候选名称：MainLeftBottom_Module | 指令记录：412 | 子原型：58 | 可变参数：0
-- 字节范围：0:71216
local function proto_MainLeftBottom_Module_root(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = '10000'
    -- K[1] = 10.0
    -- K[2] = 'isHidden'
    -- K[3] = 'TakeItems'
    -- K[4] = 21.0
    -- K[5] = 3600.0
    -- K[6] = 'StopGatherMonsters'
    -- K[7] = 'onDamageMsg'
    -- K[8] = 'LuaSendMsg'
    -- K[9] = 0.01
    -- K[10] = 30.0
    -- K[11] = 'hidebut'
    -- K[12] = 'floor'
    -- K[13] = 'Builtsetting'
    -- K[14] = 'distance'
    -- K[15] = 'isTaking'
    -- K[16] = '累计登录 2 天'
    -- K[17] = 'log'
    -- K[18] = 'isOutputted'
    -- K[19] = False
    -- K[20] = 'InitGatherMonsters'
    -- K[21] = 'destroy'
    -- K[22] = 'isDiuing'
    -- K[23] = '在线时长90分钟'
    -- K[24] = 18.0
    -- K[25] = 'BlacklistItems'
    -- K[26] = 'screenH'
    -- K[27] = '在线时长5分钟'
    -- K[28] = 20.0
    -- K[29] = 'MoveTo'
    -- K[30] = 19.0
    -- K[31] = 0.0
    -- K[32] = 'GetAvailableStoragePage'
    -- K[33] = 'screenW'
    -- K[34] = 'alertAt'
    -- K[35] = 'StorageItems'
    -- K[36] = '空闲状态'
    -- K[37] = -1.0
    -- K[38] = 'hide'
    -- K[39] = 'SendHookList'
    -- K[40] = '累计登录 4 天'
    -- K[41] = 'RecvHookList'
    -- K[42] = 'GATHER_THRESHOLD'
    -- K[43] = 9.0
    -- K[44] = 'ATTACKING'
    -- K[45] = '累计登录 7 天'
    -- K[46] = 'noStoneWarned'
    -- K[47] = 'isStoring'
    -- K[48] = 'SCREEN_WIDTH'
    -- K[49] = 'doInit'
    -- K[50] = 'GetMapName'
    -- K[51] = '在线时长30分钟'
    -- K[52] = 'nextTryAt'
    -- K[53] = 'deathHandled'
    -- K[54] = 'SL'
    -- K[55] = '在线时长10分钟'
    -- K[56] = '累计登录 1 天'
    -- K[57] = 'blacklist_distance.txt'
    -- K[58] = 'math'
    -- K[59] = 56011.0
    -- K[60] = '在线时长60分钟'
    -- K[61] = 'main'
    -- K[62] = '在线时长120分钟'
    -- K[63] = ['unknown', 2]
    -- K[64] = '引怪中'
    -- K[65] = '攻击中'
    -- K[66] = 'GATHERING'
    -- K[67] = 'z'
    -- K[68] = '累计登录 3 天'
    -- K[69] = 'IsInWhitelistMap'
    -- K[70] = 'isRunning'
    -- K[71] = '累计登录 6 天'
    -- K[72] = 0.5
    -- K[73] = 'show'
    -- K[74] = 'version'
    -- K[75] = 'PlayerPos'
    -- K[76] = 'a'
    -- K[77] = 'DiuItems'
    -- K[78] = 56061.0
    -- K[79] = 'isPaused'
    -- K[80] = 'GetStorageItemData'
    -- K[81] = 'MainLeftBottom'
    -- K[82] = 'MoveItemToQuickUse'
    -- K[83] = 'ATTACK_WAIT_TIME'
    -- K[84] = 'PickUpItems'
    -- K[85] = 'gather_monster_count.txt'
    -- K[86] = 'GetMapId'
    -- K[87] = 'b'
    -- K[88] = '累计登录 5 天'
    -- K[89] = 'Blocklist'
    -- K[90] = '_G'
    -- K[91] = 'ClearBlacklistItems'
    -- K[92] = 'lastAttacker'
    -- K[93] = 2.0
    -- K[94] = 'GetMetaValue'
    -- K[95] = 'IDLE'
    -- K[96] = 0.2
    -- K[97] = ''
    -- K[98] = '在线时长20分钟'
    -- K[99] = 1.0
    -- K[100] = '随机传送石'
    -- K[101] = 60000.0
    -- K[102] = 'lastHp'
    -- K[103] = 'CHECK_INTERVAL'
    -- K[104] = True
    -- K[105] = 'MainLoop'
    -- K[106] = 'GetDroppedItems'
    -- K[107] = 'blacklist'
    -- K[108] = 'SCREEN_HEIGHT'
    -- 指令语义：
    -- PC 0001 FLAG=0xC0 OP_410
    r[(0)]={}
    -- PC 0002 FLAG=0x92 OP_141
    __ENV[('MainLeftBottom')]=r[(0)]
    -- PC 0003 FLAG=0x80 OP_009 [linear-fusion-payloads=1]
    r[(0)]={}; -- 融合载荷：r[(0)]=__ENV[(0)]
    -- PC 0004 FLAG=0xD2 OP_137
    r[(1)]=__ENV[('MainLeftBottom')]
    -- PC 0005 FLAG=0x90 OP_355
    do local I=('a');local F=r[(0)];r[(1)][I]=F end
    -- PC 0006 FLAG=0x70 OP_146
    do local I=('version');local F=('10000');r[(0)][I]=F end
    -- PC 0007 FLAG=0xD2 OP_137
    r[(1)]=__ENV[('SL')]
    -- PC 0008 FLAG=0x20 OP_297 [linear-fusion-payloads=1]
    local I=r[(1)];r[(1)+1]=I;r[(1)]=I[('GetMetaValue')]; -- 融合载荷：r[(1)]=(1)
    -- PC 0009 FLAG=0x92 OP_346
    r[(3)]=('SCREEN_WIDTH')
    -- PC 0010 FLAG=0x80 OP_098
    r[(1)]=r[(1)](U(T,(1)+1,(3)))
    -- PC 0011 FLAG=0x10 OP_355
    do local I=('screenW');local F=r[(1)];r[(0)][I]=F end
    -- PC 0012 FLAG=0x52 OP_137
    r[(1)]=__ENV[('SL')]
    -- PC 0013 FLAG=0xA0 OP_297 [linear-fusion-payloads=1]
    local I=r[(1)];r[(1)+1]=I;r[(1)]=I[('GetMetaValue')]; -- 融合载荷：r[(1)]=(1)
    -- PC 0014 FLAG=0x52 OP_346
    r[(3)]=('SCREEN_HEIGHT')
    -- PC 0015 FLAG=0x80 OP_068
    r[(1)]=r[(1)](U(T,(1)+1,(3)))
    -- PC 0016 FLAG=0x90 OP_268
    do local I=('screenH');local F=r[(1)];r[(0)][I]=F end
    -- PC 0017 FLAG=0xC0 OP_090 [linear-fusion-payloads=1]
    r[(1)]={}; -- 融合载荷：r[(1)]=(4)
    -- PC 0018 FLAG=0x12 OP_371
    r[(2)]=(1.0)
    -- PC 0019 FLAG=0x92 OP_371
    r[(3)]=(9.0)
    -- PC 0020 FLAG=0xD2 OP_282 [linear-fusion-payloads=1]
    r[(4)]=(10.0); -- 融合载荷：r[(4)]=(10.0)
    -- PC 0021 FLAG=0x12 OP_346
    r[(5)]=(60000.0)
    -- PC 0022 FLAG=0xC0 OP_402
    do local I=(4);if I==0 then I=math.max(0,(4)-(1)) end;local F=r[(1)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(1)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(1)]=O else for O=1,I do F[L+O]=T[(1)+O] end end;end
    -- PC 0023 FLAG=0x90 OP_268
    do local I=('Blocklist');local F=r[(1)];r[(0)][I]=F end
    -- PC 0024 FLAG=0x00 OP_105
    r[(1)]={}
    -- PC 0025 FLAG=0x10 OP_355
    do local I=('SendHookList');local F=r[(1)];r[(0)][I]=F end
    -- PC 0026 FLAG=0x40 OP_410
    r[(1)]={}
    -- PC 0027 FLAG=0x50 OP_408 [linear-fusion-payloads=1]
    do local I=('RecvHookList');local F=r[(1)];r[(0)][I]=F end; -- 融合载荷：do local I=('RecvHookList');local F=(1);r[(0)][I]=F end
    -- PC 0028 FLAG=0xB0 OP_146
    do local I=('isHidden');local F=(true);r[(0)][I]=F end
    -- PC 0029 FLAG=0xF0 OP_146
    do local I=('hidebut');local F=(['unknown', 2]);r[(0)][I]=F end
    -- PC 0030 FLAG=0x40 OP_120
    r[(1)]={}
    -- PC 0031 FLAG=0x52 OP_137
    r[(2)]=__ENV[('MainLeftBottom')]
    -- PC 0032 FLAG=0x90 OP_268
    do local I=('b');local F=r[(1)];r[(2)][I]=F end
    -- PC 0033 FLAG=0x40 OP_009 [linear-fusion-payloads=1]
    r[(2)]={}; -- 融合载荷：r[(2)]=__ENV[(0)]
    -- PC 0034 FLAG=0x12 OP_137
    r[(3)]=__ENV[('MainLeftBottom')]
    -- PC 0035 FLAG=0x50 OP_408 [linear-fusion-payloads=1]
    do local I=('z');local F=r[(2)];r[(3)][I]=F end; -- 融合载荷：do local I=('z');local F=(2);r[(3)][I]=F end
    -- PC 0036 FLAG=0x70 OP_146
    do local I=('isPaused');local F=(false);r[(2)][I]=F end
    -- PC 0037 FLAG=0xB0 OP_156
    do local I=('isRunning');local F=(false);r[(2)][I]=F end
    -- PC 0038 FLAG=0xB0 OP_156
    do local I=('isStoring');local F=(false);r[(2)][I]=F end
    -- PC 0039 FLAG=0x30 OP_146
    do local I=('isTaking');local F=(false);r[(2)][I]=F end
    -- PC 0040 FLAG=0x30 OP_146
    do local I=('isDiuing');local F=(false);r[(2)][I]=F end
    -- PC 0041 FLAG=0x30 OP_156
    do local I=('isOutputted');local F=(false);r[(2)][I]=F end
    -- PC 0042 FLAG=0x40 OP_120
    r[(3)]={}
    -- PC 0043 FLAG=0x00 OP_027 [closure-child-index=16; captures=0; child-path=root/17]
    do local I=O[(16)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(4)]=M(I,U,S) end
    -- PC 0044 FLAG=0x12 OP_137
    r[(5)]=__ENV[('_G')]
    -- PC 0045 FLAG=0xD0 OP_355
    do local I=('log');local F=r[(4)];r[(5)][I]=F end
    -- PC 0046 FLAG=0xC0 OP_027 [linear-fusion-payloads=1, closure-child-index=20; captures=1; child-path=root/21]
    do local I=O[(20)];local F={};F[-1]=(1);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(1)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(5)]=M(I,U,S) end
    -- PC 0047 FLAG=0x80 OP_387
    r[(0)]=r[(0)]
    -- PC 0048 FLAG=0x00 OP_154 [linear-fusion-payloads=2, closure-child-index=12; captures=2; child-path=root/13]
    do local I=O[(12)];local F={};F[-1]=(2);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(2)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(6)]=M(I,U,S) end
    -- PC 0049 FLAG=0xC0 OP_387
    r[(0)]=r[(0)]
    -- PC 0050 FLAG=0x80 OP_387
    r[(0)]=r[(4)]
    -- PC 0051 FLAG=0x50 OP_355
    do local I=('LuaSendMsg');local F=r[(6)];r[(0)][I]=F end
    -- PC 0052 FLAG=0x00 OP_027 [closure-child-index=53; captures=0; child-path=root/54]
    do local I=O[(53)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(6)]=M(I,U,S) end
    -- PC 0053 FLAG=0xC0 OP_154 [closure-child-index=34; captures=0; child-path=root/35]
    do local I=O[(34)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(7)]=M(I,U,S) end
    -- PC 0054 FLAG=0xC0 OP_154 [closure-child-index=13; captures=0; child-path=root/14]
    do local I=O[(13)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(8)]=M(I,U,S) end
    -- PC 0055 FLAG=0xD2 OP_141
    __ENV[('GetMapId')]=r[(8)]
    -- PC 0056 FLAG=0xC0 OP_027 [closure-child-index=30; captures=0; child-path=root/31]
    do local I=O[(30)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(8)]=M(I,U,S) end
    -- PC 0057 FLAG=0x92 OP_141
    __ENV[('GetMapName')]=r[(8)]
    -- PC 0058 FLAG=0xC0 OP_027 [closure-child-index=57; captures=0; child-path=root/58]
    do local I=O[(57)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(8)]=M(I,U,S) end
    -- PC 0059 FLAG=0x52 OP_182
    __ENV[('PlayerPos')]=r[(8)]
    -- PC 0060 FLAG=0xC0 OP_027 [closure-child-index=4; captures=0; child-path=root/5]
    do local I=O[(4)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(8)]=M(I,U,S) end
    -- PC 0061 FLAG=0x52 OP_141
    __ENV[('GetDroppedItems')]=r[(8)]
    -- PC 0062 FLAG=0xC0 OP_027 [closure-child-index=3; captures=0; child-path=root/4]
    do local I=O[(3)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(8)]=M(I,U,S) end
    -- PC 0063 FLAG=0x52 OP_182
    __ENV[('MoveTo')]=r[(8)]
    -- PC 0064 FLAG=0x00 OP_027 [linear-fusion-payloads=2, closure-child-index=46; captures=2; child-path=root/47]
    do local I=O[(46)];local F={};F[-1]=(2);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(2)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(8)]=M(I,U,S) end
    -- PC 0065 FLAG=0xC0 OP_387
    r[(0)]=r[(2)]
    -- PC 0066 FLAG=0x80 OP_387
    r[(0)]=r[(5)]
    -- PC 0067 FLAG=0x12 OP_182
    __ENV[('DiuItems')]=r[(8)]
    -- PC 0068 FLAG=0x00 OP_027 [linear-fusion-payloads=1, closure-child-index=36; captures=1; child-path=root/37]
    do local I=O[(36)];local F={};F[-1]=(1);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(1)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(8)]=M(I,U,S) end
    -- PC 0069 FLAG=0x80 OP_387
    r[(0)]=r[(4)]
    -- PC 0070 FLAG=0x12 OP_141
    __ENV[('GetAvailableStoragePage')]=r[(8)]
    -- PC 0071 FLAG=0x80 OP_154 [linear-fusion-payloads=1, closure-child-index=1; captures=1; child-path=root/2]
    do local I=O[(1)];local F={};F[-1]=(1);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(1)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(8)]=M(I,U,S) end
    -- PC 0072 FLAG=0x00 OP_387
    r[(0)]=r[(4)]
    -- PC 0073 FLAG=0x52 OP_182
    __ENV[('GetStorageItemData')]=r[(8)]
    -- PC 0074 FLAG=0x80 OP_027 [linear-fusion-payloads=3, closure-child-index=50; captures=3; child-path=root/51]
    do local I=O[(50)];local F={};F[-1]=(3);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(3)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(8)]=M(I,U,S) end
    -- PC 0075 FLAG=0x40 OP_387
    r[(0)]=r[(2)]
    -- PC 0076 FLAG=0xC0 OP_387
    r[(0)]=r[(4)]
    -- PC 0077 FLAG=0xC0 OP_387
    r[(0)]=r[(5)]
    -- PC 0078 FLAG=0xD2 OP_141
    __ENV[('StorageItems')]=r[(8)]
    -- PC 0079 FLAG=0x80 OP_154 [linear-fusion-payloads=2, closure-child-index=5; captures=2; child-path=root/6]
    do local I=O[(5)];local F={};F[-1]=(2);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(2)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(8)]=M(I,U,S) end
    -- PC 0080 FLAG=0xC0 OP_387
    r[(0)]=r[(2)]
    -- PC 0081 FLAG=0xC0 OP_387
    r[(0)]=r[(5)]
    -- PC 0082 FLAG=0xD2 OP_182
    __ENV[('TakeItems')]=r[(8)]
    -- PC 0083 FLAG=0xC0 OP_154 [linear-fusion-payloads=1, closure-child-index=21; captures=1; child-path=root/22]
    do local I=O[(21)];local F={};F[-1]=(1);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(1)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(8)]=M(I,U,S) end
    -- PC 0084 FLAG=0x40 OP_387
    r[(0)]=r[(5)]
    -- PC 0085 FLAG=0x92 OP_182
    __ENV[('PickUpItems')]=r[(8)]
    -- PC 0086 FLAG=0xC0 OP_105
    r[(8)]={}
    -- PC 0087 FLAG=0x70 OP_156
    do local I=('GATHER_THRESHOLD');local F=(10.0);r[(8)][I]=F end
    -- PC 0088 FLAG=0xF0 OP_156
    do local I=('CHECK_INTERVAL');local F=(0.5);r[(8)][I]=F end
    -- PC 0089 FLAG=0x70 OP_146
    do local I=('ATTACK_WAIT_TIME');local F=(1.0);r[(8)][I]=F end
    -- PC 0090 FLAG=0xD2 OP_346
    r[(9)]=(0.2)
    -- PC 0091 FLAG=0x52 OP_217 [linear-fusion-payloads=2]
    r[(10)]=(3600.0); -- 融合载荷：r[(10)]=__ENV[(3600.0)]; -- 融合载荷：r[(10)]=r[(3600.0)][(nil)]
    -- PC 0092 FLAG=0x92 OP_397 [linear-fusion-payloads=1]
    r[(11)]=__ENV[('math')]; -- 融合载荷：r[(11)]=r[('math')][(nil)]
    -- PC 0093 FLAG=0x60 OP_363
    r[(11)]=r[(11)][('floor')]
    -- PC 0094 FLAG=0x40 OP_062
    r[(12)]=r[(10)]/r[(9)]
    -- PC 0095 FLAG=0x00 OP_098
    r[(11)]=r[(11)](U(T,(11)+1,(12)))
    -- PC 0096 FLAG=0x00 OP_019 [linear-fusion-payloads=1]
    r[(12)]={}; -- 融合载荷：r[(12)]={}
    -- PC 0097 FLAG=0x80 OP_090 [linear-fusion-payloads=1]
    r[(13)]={}; -- 融合载荷：r[(13)]=(3)
    -- PC 0098 FLAG=0xD2 OP_282 [linear-fusion-payloads=1]
    r[(14)]=(56061.0); -- 融合载荷：r[(14)]=(56061.0)
    -- PC 0099 FLAG=0x52 OP_282 [linear-fusion-payloads=1]
    r[(15)]=('累计登录 1 天'); -- 融合载荷：r[(15)]=('累计登录 1 天')
    -- PC 0100 FLAG=0x52 OP_371
    r[(16)]=(18.0)
    -- PC 0101 FLAG=0x40 OP_402
    do local I=(3);if I==0 then I=math.max(0,(3)-(13)) end;local F=r[(13)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(13)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(13)]=O else for O=1,I do F[L+O]=T[(13)+O] end end;end
    -- PC 0102 FLAG=0x80 OP_120
    r[(14)]={}
    -- PC 0103 FLAG=0x52 OP_346
    r[(15)]=(56061.0)
    -- PC 0104 FLAG=0x12 OP_282 [linear-fusion-payloads=1]
    r[(16)]=('累计登录 2 天'); -- 融合载荷：r[(16)]=('累计登录 2 天')
    -- PC 0105 FLAG=0x92 OP_346
    r[(17)]=(18.0)
    -- PC 0106 FLAG=0x80 OP_088
    do local I=(3);if I==0 then I=math.max(0,(3)-(14)) end;local F=r[(14)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(14)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(14)]=O else for O=1,I do F[L+O]=T[(14)+O] end end;end
    -- PC 0107 FLAG=0xC0 OP_090 [linear-fusion-payloads=1]
    r[(15)]={}; -- 融合载荷：r[(15)]=(3)
    -- PC 0108 FLAG=0x92 OP_061 [linear-fusion-payloads=2]
    r[(16)]=(56061.0); -- 融合载荷：r[(16)]=(56061.0); -- 融合载荷：r[(16)]=(56061.0)
    -- PC 0109 FLAG=0x92 OP_282 [linear-fusion-payloads=1]
    r[(17)]=('累计登录 3 天'); -- 融合载荷：r[(17)]=('累计登录 3 天')
    -- PC 0110 FLAG=0x92 OP_371
    r[(18)]=(18.0)
    -- PC 0111 FLAG=0x80 OP_402
    do local I=(3);if I==0 then I=math.max(0,(3)-(15)) end;local F=r[(15)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(15)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(15)]=O else for O=1,I do F[L+O]=T[(15)+O] end end;end
    -- PC 0112 FLAG=0xC0 OP_090 [linear-fusion-payloads=1]
    r[(16)]={}; -- 融合载荷：r[(16)]=(3)
    -- PC 0113 FLAG=0x12 OP_371
    r[(17)]=(56061.0)
    -- PC 0114 FLAG=0x92 OP_282 [linear-fusion-payloads=1]
    r[(18)]=('累计登录 4 天'); -- 融合载荷：r[(18)]=('累计登录 4 天')
    -- PC 0115 FLAG=0x92 OP_346
    r[(19)]=(18.0)
    -- PC 0116 FLAG=0x40 OP_153
    do local I=(3);if I==0 then I=math.max(0,(3)-(16)) end;local F=r[(16)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(16)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(16)]=O else for O=1,I do F[L+O]=T[(16)+O] end end;end
    -- PC 0117 FLAG=0xC0 OP_090 [linear-fusion-payloads=1]
    r[(17)]={}; -- 融合载荷：r[(17)]=(3)
    -- PC 0118 FLAG=0x12 OP_346
    r[(18)]=(56061.0)
    -- PC 0119 FLAG=0x12 OP_282 [linear-fusion-payloads=1]
    r[(19)]=('累计登录 5 天'); -- 融合载荷：r[(19)]=('累计登录 5 天')
    -- PC 0120 FLAG=0x52 OP_346
    r[(20)]=(18.0)
    -- PC 0121 FLAG=0x40 OP_088
    do local I=(3);if I==0 then I=math.max(0,(3)-(17)) end;local F=r[(17)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(17)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(17)]=O else for O=1,I do F[L+O]=T[(17)+O] end end;end
    -- PC 0122 FLAG=0x40 OP_120
    r[(18)]={}
    -- PC 0123 FLAG=0x92 OP_371
    r[(19)]=(56061.0)
    -- PC 0124 FLAG=0x92 OP_371
    r[(20)]=('累计登录 6 天')
    -- PC 0125 FLAG=0x52 OP_371
    r[(21)]=(18.0)
    -- PC 0126 FLAG=0xC0 OP_112
    do local I=(3);if I==0 then I=math.max(0,(3)-(18)) end;local F=r[(18)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(18)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(18)]=O else for O=1,I do F[L+O]=T[(18)+O] end end;end
    -- PC 0127 FLAG=0x40 OP_090 [linear-fusion-payloads=1]
    r[(19)]={}; -- 融合载荷：r[(19)]=(3)
    -- PC 0128 FLAG=0x12 OP_371
    r[(20)]=(56061.0)
    -- PC 0129 FLAG=0x12 OP_282 [linear-fusion-payloads=1]
    r[(21)]=('累计登录 7 天'); -- 融合载荷：r[(21)]=('累计登录 7 天')
    -- PC 0130 FLAG=0x12 OP_346
    r[(22)]=(18.0)
    -- PC 0131 FLAG=0x40 OP_088
    do local I=(3);if I==0 then I=math.max(0,(3)-(19)) end;local F=r[(19)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(19)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(19)]=O else for O=1,I do F[L+O]=T[(19)+O] end end;end
    -- PC 0132 FLAG=0x80 OP_090 [linear-fusion-payloads=1]
    r[(20)]={}; -- 融合载荷：r[(20)]=(3)
    -- PC 0133 FLAG=0xD2 OP_061 [linear-fusion-payloads=2]
    r[(21)]=(56011.0); -- 融合载荷：r[(21)]=(56011.0); -- 融合载荷：r[(21)]=(56011.0)
    -- PC 0134 FLAG=0x52 OP_282 [linear-fusion-payloads=1]
    r[(22)]=('在线时长5分钟'); -- 融合载荷：r[(22)]=('在线时长5分钟')
    -- PC 0135 FLAG=0x12 OP_371
    r[(23)]=(19.0)
    -- PC 0136 FLAG=0x40 OP_237
    do local I=(3);if I==0 then I=math.max(0,(3)-(20)) end;local F=r[(20)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(20)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(20)]=O else for O=1,I do F[L+O]=T[(20)+O] end end;end
    -- PC 0137 FLAG=0x40 OP_120
    r[(21)]={}
    -- PC 0138 FLAG=0x52 OP_371
    r[(22)]=(56011.0)
    -- PC 0139 FLAG=0x12 OP_282 [linear-fusion-payloads=1]
    r[(23)]=('在线时长10分钟'); -- 融合载荷：r[(23)]=('在线时长10分钟')
    -- PC 0140 FLAG=0x12 OP_371
    r[(24)]=(20.0)
    -- PC 0141 FLAG=0x80 OP_112
    do local I=(3);if I==0 then I=math.max(0,(3)-(21)) end;local F=r[(21)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(21)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(21)]=O else for O=1,I do F[L+O]=T[(21)+O] end end;end
    -- PC 0142 FLAG=0x80 OP_090 [linear-fusion-payloads=1]
    r[(22)]={}; -- 融合载荷：r[(22)]=(3)
    -- PC 0143 FLAG=0x12 OP_061 [linear-fusion-payloads=2]
    r[(23)]=(56011.0); -- 融合载荷：r[(23)]=(56011.0); -- 融合载荷：r[(23)]=(56011.0)
    -- PC 0144 FLAG=0x12 OP_282 [linear-fusion-payloads=1]
    r[(24)]=('在线时长20分钟'); -- 融合载荷：r[(24)]=('在线时长20分钟')
    -- PC 0145 FLAG=0x52 OP_371
    r[(25)]=(20.0)
    -- PC 0146 FLAG=0x80 OP_112
    do local I=(3);if I==0 then I=math.max(0,(3)-(22)) end;local F=r[(22)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(22)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(22)]=O else for O=1,I do F[L+O]=T[(22)+O] end end;end
    -- PC 0147 FLAG=0x80 OP_090 [linear-fusion-payloads=1]
    r[(23)]={}; -- 融合载荷：r[(23)]=(3)
    -- PC 0148 FLAG=0xD2 OP_061 [linear-fusion-payloads=2]
    r[(24)]=(56011.0); -- 融合载荷：r[(24)]=(56011.0); -- 融合载荷：r[(24)]=(56011.0)
    -- PC 0149 FLAG=0x52 OP_282 [linear-fusion-payloads=1]
    r[(25)]=('在线时长30分钟'); -- 融合载荷：r[(25)]=('在线时长30分钟')
    -- PC 0150 FLAG=0x12 OP_346
    r[(26)]=(20.0)
    -- PC 0151 FLAG=0x00 OP_112
    do local I=(3);if I==0 then I=math.max(0,(3)-(23)) end;local F=r[(23)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(23)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(23)]=O else for O=1,I do F[L+O]=T[(23)+O] end end;end
    -- PC 0152 FLAG=0xC0 OP_410
    r[(24)]={}
    -- PC 0153 FLAG=0x92 OP_061 [linear-fusion-payloads=2]
    r[(25)]=(56011.0); -- 融合载荷：r[(25)]=(56011.0); -- 融合载荷：r[(25)]=(56011.0)
    -- PC 0154 FLAG=0x12 OP_282 [linear-fusion-payloads=1]
    r[(26)]=('在线时长60分钟'); -- 融合载荷：r[(26)]=('在线时长60分钟')
    -- PC 0155 FLAG=0x12 OP_346
    r[(27)]=(20.0)
    -- PC 0156 FLAG=0x00 OP_112
    do local I=(3);if I==0 then I=math.max(0,(3)-(24)) end;local F=r[(24)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(24)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(24)]=O else for O=1,I do F[L+O]=T[(24)+O] end end;end
    -- PC 0157 FLAG=0x00 OP_120
    r[(25)]={}
    -- PC 0158 FLAG=0xD2 OP_061 [linear-fusion-payloads=2]
    r[(26)]=(56011.0); -- 融合载荷：r[(26)]=(56011.0); -- 融合载荷：r[(26)]=(56011.0)
    -- PC 0159 FLAG=0xD2 OP_282 [linear-fusion-payloads=1]
    r[(27)]=('在线时长90分钟'); -- 融合载荷：r[(27)]=('在线时长90分钟')
    -- PC 0160 FLAG=0x52 OP_346
    r[(28)]=(20.0)
    -- PC 0161 FLAG=0x00 OP_237
    do local I=(3);if I==0 then I=math.max(0,(3)-(25)) end;local F=r[(25)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(25)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(25)]=O else for O=1,I do F[L+O]=T[(25)+O] end end;end
    -- PC 0162 FLAG=0x00 OP_090 [linear-fusion-payloads=1]
    r[(26)]={}; -- 融合载荷：r[(26)]=(3)
    -- PC 0163 FLAG=0x92 OP_061 [linear-fusion-payloads=2]
    r[(27)]=(56011.0); -- 融合载荷：r[(27)]=(56011.0); -- 融合载荷：r[(27)]=(56011.0)
    -- PC 0164 FLAG=0x92 OP_282 [linear-fusion-payloads=1]
    r[(28)]=('在线时长120分钟'); -- 融合载荷：r[(28)]=('在线时长120分钟')
    -- PC 0165 FLAG=0xD2 OP_371
    r[(29)]=(21.0)
    -- PC 0166 FLAG=0x00 OP_237
    do local I=(3);if I==0 then I=math.max(0,(3)-(26)) end;local F=r[(26)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(26)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(26)]=O else for O=1,I do F[L+O]=T[(26)+O] end end;end
    -- PC 0167 FLAG=0xC0 OP_402
    do local I=(14);if I==0 then I=math.max(0,(14)-(12)) end;local F=r[(12)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(12)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(12)]=O else for O=1,I do F[L+O]=T[(12)+O] end end;end
    -- PC 0168 FLAG=0x00 OP_105
    r[(13)]={}
    -- PC 0169 FLAG=0x70 OP_156
    do local I=('IDLE');local F=('空闲状态');r[(13)][I]=F end
    -- PC 0170 FLAG=0x70 OP_146
    do local I=('GATHERING');local F=('引怪中');r[(13)][I]=F end
    -- PC 0171 FLAG=0xB0 OP_156
    do local I=('ATTACKING');local F=('攻击中');r[(13)][I]=F end
    -- PC 0172 FLAG=0xA0 OP_053
    r[(14)]=r[(13)][('IDLE')]
    -- PC 0173 FLAG=0xC0 OP_090 [linear-fusion-payloads=1]
    r[(15)]={}; -- 融合载荷：r[(15)]=(0)
    -- PC 0174 FLAG=0xD2 OP_371
    r[(16)]=(0.0)
    -- PC 0175 FLAG=0x92 OP_346
    r[(17)]=(0.0)
    -- PC 0176 FLAG=0x80 OP_401
    r[(18)]=(0)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0177 FLAG=0x40 OP_338
    r[(19)]=(0)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0178 FLAG=0xD2 OP_346
    r[(20)]=(0.0)
    -- PC 0179 FLAG=0x80 OP_125
    for I=(21),(21) do T[I]=nil end
    -- PC 0180 FLAG=0x52 OP_346
    r[(22)]=('')
    -- PC 0181 FLAG=0x00 OP_154 [linear-fusion-payloads=2, closure-child-index=8; captures=2; child-path=root/9]
    do local I=O[(8)];local F={};F[-1]=(2);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(2)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(23)]=M(I,U,S) end
    -- PC 0182 FLAG=0xC0 OP_387
    r[(0)]=r[(4)]
    -- PC 0183 FLAG=0x40 OP_387
    r[(0)]=r[(14)]
    -- PC 0184 FLAG=0x40 OP_154 [closure-child-index=35; captures=0; child-path=root/36]
    do local I=O[(35)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(24)]=M(I,U,S) end
    -- PC 0185 FLAG=0xC0 OP_154 [closure-child-index=56; captures=0; child-path=root/57]
    do local I=O[(56)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(25)]=M(I,U,S) end
    -- PC 0186 FLAG=0x00 OP_154 [closure-child-index=39; captures=0; child-path=root/40]
    do local I=O[(39)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(26)]=M(I,U,S) end
    -- PC 0187 FLAG=0x00 OP_154 [closure-child-index=18; captures=0; child-path=root/19]
    do local I=O[(18)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(27)]=M(I,U,S) end
    -- PC 0188 FLAG=0x00 OP_027 [closure-child-index=44; captures=0; child-path=root/45]
    do local I=O[(44)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(28)]=M(I,U,S) end
    -- PC 0189 FLAG=0xC0 OP_154 [closure-child-index=11; captures=0; child-path=root/12]
    do local I=O[(11)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(29)]=M(I,U,S) end
    -- PC 0190 FLAG=0x80 OP_027 [closure-child-index=29; captures=0; child-path=root/30]
    do local I=O[(29)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(30)]=M(I,U,S) end
    -- PC 0191 FLAG=0x00 OP_027 [closure-child-index=7; captures=0; child-path=root/8]
    do local I=O[(7)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(31)]=M(I,U,S) end
    -- PC 0192 FLAG=0x00 OP_154 [closure-child-index=38; captures=0; child-path=root/39]
    do local I=O[(38)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(32)]=M(I,U,S) end
    -- PC 0193 FLAG=0x00 OP_027 [closure-child-index=43; captures=0; child-path=root/44]
    do local I=O[(43)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(33)]=M(I,U,S) end
    -- PC 0194 FLAG=0x40 OP_027 [linear-fusion-payloads=5, closure-child-index=28; captures=5; child-path=root/29]
    do local I=O[(28)];local F={};F[-1]=(5);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(5)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(34)]=M(I,U,S) end
    -- PC 0195 FLAG=0x40 OP_387
    r[(0)]=r[(27)]
    -- PC 0196 FLAG=0x40 OP_387
    r[(0)]=r[(30)]
    -- PC 0197 FLAG=0x80 OP_387
    r[(0)]=r[(28)]
    -- PC 0198 FLAG=0xC0 OP_387
    r[(0)]=r[(29)]
    -- PC 0199 FLAG=0xC0 OP_387
    r[(0)]=r[(8)]
    -- PC 0200 FLAG=0x40 OP_154 [linear-fusion-payloads=9, closure-child-index=26; captures=9; child-path=root/27]
    do local I=O[(26)];local F={};F[-1]=(9);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(9)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(35)]=M(I,U,S) end
    -- PC 0201 FLAG=0x80 OP_387
    r[(0)]=r[(15)]
    -- PC 0202 FLAG=0x00 OP_387
    r[(0)]=r[(16)]
    -- PC 0203 FLAG=0x40 OP_387
    r[(0)]=r[(17)]
    -- PC 0204 FLAG=0x40 OP_387
    r[(0)]=r[(25)]
    -- PC 0205 FLAG=0xC0 OP_387
    r[(0)]=r[(19)]
    -- PC 0206 FLAG=0x40 OP_387
    r[(0)]=r[(20)]
    -- PC 0207 FLAG=0x00 OP_387
    r[(0)]=r[(21)]
    -- PC 0208 FLAG=0x00 OP_387
    r[(0)]=r[(22)]
    -- PC 0209 FLAG=0x80 OP_387
    r[(0)]=r[(4)]
    -- PC 0210 FLAG=0x40 OP_154 [linear-fusion-payloads=1, closure-child-index=14; captures=1; child-path=root/15]
    do local I=O[(14)];local F={};F[-1]=(1);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(1)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(36)]=M(I,U,S) end
    -- PC 0211 FLAG=0x40 OP_387
    r[(0)]=r[(30)]
    -- PC 0212 FLAG=0xC0 OP_154 [closure-child-index=31; captures=0; child-path=root/32]
    do local I=O[(31)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(37)]=M(I,U,S) end
    -- PC 0213 FLAG=0x52 OP_182
    __ENV[('IsInWhitelistMap')]=r[(37)]
    -- PC 0214 FLAG=0x80 OP_027 [linear-fusion-payloads=22, closure-child-index=45; captures=22; child-path=root/46]
    do local I=O[(45)];local F={};F[-1]=(22);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(22)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(37)]=M(I,U,S) end
    -- PC 0215 FLAG=0x40 OP_387
    r[(0)]=r[(18)]
    -- PC 0216 FLAG=0xC0 OP_387
    r[(0)]=r[(14)]
    -- PC 0217 FLAG=0xC0 OP_387
    r[(0)]=r[(13)]
    -- PC 0218 FLAG=0x80 OP_387
    r[(0)]=r[(4)]
    -- PC 0219 FLAG=0xC0 OP_387
    r[(0)]=r[(23)]
    -- PC 0220 FLAG=0x00 OP_387
    r[(0)]=r[(35)]
    -- PC 0221 FLAG=0x40 OP_387
    r[(0)]=r[(26)]
    -- PC 0222 FLAG=0x80 OP_387
    r[(0)]=r[(34)]
    -- PC 0223 FLAG=0xC0 OP_387
    r[(0)]=r[(15)]
    -- PC 0224 FLAG=0x40 OP_387
    r[(0)]=r[(32)]
    -- PC 0225 FLAG=0x00 OP_387
    r[(0)]=r[(17)]
    -- PC 0226 FLAG=0xC0 OP_387
    r[(0)]=r[(16)]
    -- PC 0227 FLAG=0x40 OP_387
    r[(0)]=r[(19)]
    -- PC 0228 FLAG=0xC0 OP_387
    r[(0)]=r[(20)]
    -- PC 0229 FLAG=0x80 OP_387
    r[(0)]=r[(22)]
    -- PC 0230 FLAG=0xC0 OP_387
    r[(0)]=r[(36)]
    -- PC 0231 FLAG=0xC0 OP_387
    r[(0)]=r[(21)]
    -- PC 0232 FLAG=0xC0 OP_387
    r[(0)]=r[(31)]
    -- PC 0233 FLAG=0x80 OP_387
    r[(0)]=r[(30)]
    -- PC 0234 FLAG=0x80 OP_387
    r[(0)]=r[(33)]
    -- PC 0235 FLAG=0x80 OP_387
    r[(0)]=r[(24)]
    -- PC 0236 FLAG=0x80 OP_387
    r[(0)]=r[(8)]
    -- PC 0237 FLAG=0x12 OP_141
    __ENV[('MainLoop')]=r[(37)]
    -- PC 0238 FLAG=0x00 OP_027 [linear-fusion-payloads=7, closure-child-index=19; captures=7; child-path=root/20]
    do local I=O[(19)];local F={};F[-1]=(7);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(7)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(37)]=M(I,U,S) end
    -- PC 0239 FLAG=0xC0 OP_387
    r[(0)]=r[(3)]
    -- PC 0240 FLAG=0x80 OP_387
    r[(0)]=r[(18)]
    -- PC 0241 FLAG=0x80 OP_387
    r[(0)]=r[(23)]
    -- PC 0242 FLAG=0x00 OP_387
    r[(0)]=r[(13)]
    -- PC 0243 FLAG=0x00 OP_387
    r[(0)]=r[(35)]
    -- PC 0244 FLAG=0x40 OP_387
    r[(0)]=r[(8)]
    -- PC 0245 FLAG=0x80 OP_387
    r[(0)]=r[(4)]
    -- PC 0246 FLAG=0x92 OP_141
    __ENV[('InitGatherMonsters')]=r[(37)]
    -- PC 0247 FLAG=0xC0 OP_027 [linear-fusion-payloads=7, closure-child-index=27; captures=7; child-path=root/28]
    do local I=O[(27)];local F={};F[-1]=(7);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(7)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(37)]=M(I,U,S) end
    -- PC 0248 FLAG=0xC0 OP_387
    r[(0)]=r[(18)]
    -- PC 0249 FLAG=0xC0 OP_387
    r[(0)]=r[(3)]
    -- PC 0250 FLAG=0x80 OP_387
    r[(0)]=r[(25)]
    -- PC 0251 FLAG=0xC0 OP_387
    r[(0)]=r[(23)]
    -- PC 0252 FLAG=0x40 OP_387
    r[(0)]=r[(13)]
    -- PC 0253 FLAG=0xC0 OP_387
    r[(0)]=r[(35)]
    -- PC 0254 FLAG=0x40 OP_387
    r[(0)]=r[(4)]
    -- PC 0255 FLAG=0xD2 OP_182
    __ENV[('StopGatherMonsters')]=r[(37)]
    -- PC 0256 FLAG=0x40 OP_154 [linear-fusion-payloads=1, closure-child-index=23; captures=1; child-path=root/24]
    do local I=O[(23)];local F={};F[-1]=(1);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(1)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(37)]=M(I,U,S) end
    -- PC 0257 FLAG=0x00 OP_387
    r[(0)]=r[(5)]
    -- PC 0258 FLAG=0x92 OP_141
    __ENV[('Builtsetting')]=r[(37)]
    -- PC 0259 FLAG=0x40 OP_154 [closure-child-index=41; captures=0; child-path=root/42]
    do local I=O[(41)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(37)]=M(I,U,S) end
    -- PC 0260 FLAG=0xD2 OP_182
    __ENV[('MoveItemTopcuickUse')]=r[(37)]
    -- PC 0261 FLAG=0x40 OP_154 [linear-fusion-payloads=3, closure-child-index=37; captures=3; child-path=root/38]
    do local I=O[(37)];local F={};F[-1]=(3);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(3)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(37)]=M(I,U,S) end
    -- PC 0262 FLAG=0x00 OP_387
    r[(0)]=r[(0)]
    -- PC 0263 FLAG=0xC0 OP_387
    r[(0)]=r[(3)]
    -- PC 0264 FLAG=0xC0 OP_387
    r[(0)]=r[(1)]
    -- PC 0265 FLAG=0x90 OP_355
    do local I=('hide');local F=r[(37)];r[(0)][I]=F end
    -- PC 0266 FLAG=0x40 OP_027 [linear-fusion-payloads=2, closure-child-index=10; captures=2; child-path=root/11]
    do local I=O[(10)];local F={};F[-1]=(2);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(2)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(37)]=M(I,U,S) end
    -- PC 0267 FLAG=0x40 OP_387
    r[(0)]=r[(0)]
    -- PC 0268 FLAG=0x80 OP_387
    r[(0)]=r[(1)]
    -- PC 0269 FLAG=0x90 OP_268
    do local I=('show');local F=r[(37)];r[(0)][I]=F end
    -- PC 0270 FLAG=0x80 OP_154 [linear-fusion-payloads=3, closure-child-index=40; captures=3; child-path=root/41]
    do local I=O[(40)];local F={};F[-1]=(3);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(3)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(37)]=M(I,U,S) end
    -- PC 0271 FLAG=0x00 OP_387
    r[(0)]=r[(3)]
    -- PC 0272 FLAG=0x00 OP_387
    r[(0)]=r[(1)]
    -- PC 0273 FLAG=0x00 OP_387
    r[(0)]=r[(0)]
    -- PC 0274 FLAG=0x10 OP_355
    do local I=('destroy');local F=r[(37)];r[(0)][I]=F end
    -- PC 0275 FLAG=0x92 OP_137
    r[(37)]=__ENV[('MainLeftBottom')]
    -- PC 0276 FLAG=0x00 OP_027 [linear-fusion-payloads=2, closure-child-index=55; captures=2; child-path=root/56]
    do local I=O[(55)];local F={};F[-1]=(2);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(2)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(38)]=M(I,U,S) end
    -- PC 0277 FLAG=0x00 OP_387
    r[(0)]=r[(4)]
    -- PC 0278 FLAG=0x00 OP_387
    r[(0)]=r[(5)]
    -- PC 0279 FLAG=0xD0 OP_268
    do local I=('main');local F=r[(38)];r[(37)][I]=F end
    -- PC 0280 FLAG=0x00 OP_090 [linear-fusion-payloads=1]
    r[(37)]={}; -- 融合载荷：r[(37)]=(1)
    -- PC 0281 FLAG=0x52 OP_371
    r[(38)]=('随机传送石')
    -- PC 0282 FLAG=0x80 OP_153
    do local I=(1);if I==0 then I=math.max(0,(1)-(37)) end;local F=r[(37)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(37)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(37)]=O else for O=1,I do F[L+O]=T[(37)+O] end end;end
    -- PC 0283 FLAG=0x92 OP_346
    r[(38)]=(2.0)
    -- PC 0284 FLAG=0x12 OP_282 [linear-fusion-payloads=1]
    r[(39)]=(0.01); -- 融合载荷：r[(39)]=(0.01)
    -- PC 0285 FLAG=0xD2 OP_346
    r[(40)]=(30.0)
    -- PC 0286 FLAG=0x80 OP_120
    r[(41)]={}
    -- PC 0287 FLAG=0xB0 OP_146
    do local I=('lastAttacker');local F=(['unknown', 2]);r[(41)][I]=F end
    -- PC 0288 FLAG=0x70 OP_146
    do local I=('lastHp');local F=(['unknown', 2]);r[(41)][I]=F end
    -- PC 0289 FLAG=0x70 OP_146
    do local I=('deathHandled');local F=(false);r[(41)][I]=F end
    -- PC 0290 FLAG=0x70 OP_146
    do local I=('alertAt');local F=(0.0);r[(41)][I]=F end
    -- PC 0291 FLAG=0x70 OP_156
    do local I=('nextTryAt');local F=(0.0);r[(41)][I]=F end
    -- PC 0292 FLAG=0xF0 OP_156
    do local I=('noStoneWarned');local F=(false);r[(41)][I]=F end
    -- PC 0293 FLAG=0x30 OP_156
    do local I=('distance');local F=(['unknown', 2]);r[(41)][I]=F end
    -- PC 0294 FLAG=0x50 OP_268
    do local I=('blacklist');local F=r[(41)];r[(0)][I]=F end
    -- PC 0295 FLAG=0x12 OP_282 [linear-fusion-payloads=1]
    r[(42)]=('blacklist_distance.txt'); -- 融合载荷：r[(42)]=('blacklist_distance.txt')
    -- PC 0296 FLAG=0x92 OP_371
    r[(43)]=('gather_monster_count.txt')
    -- PC 0297 FLAG=0xC0 OP_154 [closure-child-index=2; captures=0; child-path=root/3]
    do local I=O[(2)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(44)]=M(I,U,S) end
    -- PC 0298 FLAG=0x00 OP_027 [linear-fusion-payloads=1, closure-child-index=9; captures=1; child-path=root/10]
    do local I=O[(9)];local F={};F[-1]=(1);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(1)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(45)]=M(I,U,S) end
    -- PC 0299 FLAG=0xC0 OP_387
    r[(0)]=r[(44)]
    -- PC 0300 FLAG=0x40 OP_027 [linear-fusion-payloads=1, closure-child-index=17; captures=1; child-path=root/18]
    do local I=O[(17)];local F={};F[-1]=(1);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(1)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(46)]=M(I,U,S) end
    -- PC 0301 FLAG=0xC0 OP_387
    r[(0)]=r[(44)]
    -- PC 0302 FLAG=0x40 OP_154 [linear-fusion-payloads=1, closure-child-index=0; captures=1; child-path=root/1]
    do local I=O[(0)];local F={};F[-1]=(1);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(1)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(47)]=M(I,U,S) end
    -- PC 0303 FLAG=0x80 OP_387
    r[(0)]=r[(44)]
    -- PC 0304 FLAG=0x80 OP_154 [linear-fusion-payloads=2, closure-child-index=49; captures=2; child-path=root/50]
    do local I=O[(49)];local F={};F[-1]=(2);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(2)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(48)]=M(I,U,S) end
    -- PC 0305 FLAG=0x00 OP_387
    r[(0)]=r[(45)]
    -- PC 0306 FLAG=0x00 OP_387
    r[(0)]=r[(42)]
    -- PC 0307 FLAG=0x00 OP_027 [linear-fusion-payloads=2, closure-child-index=32; captures=2; child-path=root/33]
    do local I=O[(32)];local F={};F[-1]=(2);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(2)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(49)]=M(I,U,S) end
    -- PC 0308 FLAG=0x80 OP_387
    r[(0)]=r[(46)]
    -- PC 0309 FLAG=0x00 OP_387
    r[(0)]=r[(42)]
    -- PC 0310 FLAG=0x40 OP_154 [linear-fusion-payloads=2, closure-child-index=33; captures=2; child-path=root/34]
    do local I=O[(33)];local F={};F[-1]=(2);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(2)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(50)]=M(I,U,S) end
    -- PC 0311 FLAG=0x40 OP_387
    r[(0)]=r[(45)]
    -- PC 0312 FLAG=0x00 OP_387
    r[(0)]=r[(43)]
    -- PC 0313 FLAG=0x80 OP_027 [linear-fusion-payloads=2, closure-child-index=54; captures=2; child-path=root/55]
    do local I=O[(54)];local F={};F[-1]=(2);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(2)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(51)]=M(I,U,S) end
    -- PC 0314 FLAG=0x80 OP_387
    r[(0)]=r[(46)]
    -- PC 0315 FLAG=0xC0 OP_387
    r[(0)]=r[(43)]
    -- PC 0316 FLAG=0x80 OP_019 [linear-fusion-payloads=1]
    r[(52)]={}; -- 融合载荷：r[(52)]={}
    -- PC 0317 FLAG=0x00 OP_090 [linear-fusion-payloads=1]
    r[(53)]={}; -- 融合载荷：r[(53)]=(2)
    -- PC 0318 FLAG=0xD2 OP_282 [linear-fusion-payloads=1]
    r[(54)]=(1.0); -- 融合载荷：r[(54)]=(1.0)
    -- PC 0319 FLAG=0x92 OP_346
    r[(55)]=(0.0)
    -- PC 0320 FLAG=0x80 OP_153
    do local I=(2);if I==0 then I=math.max(0,(2)-(53)) end;local F=r[(53)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(53)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(53)]=O else for O=1,I do F[L+O]=T[(53)+O] end end;end
    -- PC 0321 FLAG=0x00 OP_105
    r[(54)]={}
    -- PC 0322 FLAG=0x52 OP_371
    r[(55)]=(-1.0)
    -- PC 0323 FLAG=0x12 OP_346
    r[(56)]=(0.0)
    -- PC 0324 FLAG=0xC0 OP_088
    do local I=(2);if I==0 then I=math.max(0,(2)-(54)) end;local F=r[(54)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(54)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(54)]=O else for O=1,I do F[L+O]=T[(54)+O] end end;end
    -- PC 0325 FLAG=0x80 OP_090 [linear-fusion-payloads=1]
    r[(55)]={}; -- 融合载荷：r[(55)]=(2)
    -- PC 0326 FLAG=0x92 OP_282 [linear-fusion-payloads=1]
    r[(56)]=(0.0); -- 融合载荷：r[(56)]=(0.0)
    -- PC 0327 FLAG=0x92 OP_371
    r[(57)]=(1.0)
    -- PC 0328 FLAG=0xC0 OP_112
    do local I=(2);if I==0 then I=math.max(0,(2)-(55)) end;local F=r[(55)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(55)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(55)]=O else for O=1,I do F[L+O]=T[(55)+O] end end;end
    -- PC 0329 FLAG=0x00 OP_090 [linear-fusion-payloads=1]
    r[(56)]={}; -- 融合载荷：r[(56)]=(2)
    -- PC 0330 FLAG=0x52 OP_282 [linear-fusion-payloads=1]
    r[(57)]=(0.0); -- 融合载荷：r[(57)]=(0.0)
    -- PC 0331 FLAG=0xD2 OP_346
    r[(58)]=(-1.0)
    -- PC 0332 FLAG=0x40 OP_153
    do local I=(2);if I==0 then I=math.max(0,(2)-(56)) end;local F=r[(56)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(56)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(56)]=O else for O=1,I do F[L+O]=T[(56)+O] end end;end
    -- PC 0333 FLAG=0x80 OP_090 [linear-fusion-payloads=1]
    r[(57)]={}; -- 融合载荷：r[(57)]=(2)
    -- PC 0334 FLAG=0x52 OP_282 [linear-fusion-payloads=1]
    r[(58)]=(1.0); -- 融合载荷：r[(58)]=(1.0)
    -- PC 0335 FLAG=0x92 OP_346
    r[(59)]=(1.0)
    -- PC 0336 FLAG=0xC0 OP_402
    do local I=(2);if I==0 then I=math.max(0,(2)-(57)) end;local F=r[(57)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(57)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(57)]=O else for O=1,I do F[L+O]=T[(57)+O] end end;end
    -- PC 0337 FLAG=0x40 OP_090 [linear-fusion-payloads=1]
    r[(58)]={}; -- 融合载荷：r[(58)]=(2)
    -- PC 0338 FLAG=0x12 OP_282 [linear-fusion-payloads=1]
    r[(59)]=(1.0); -- 融合载荷：r[(59)]=(1.0)
    -- PC 0339 FLAG=0xD2 OP_371
    r[(60)]=(-1.0)
    -- PC 0340 FLAG=0x40 OP_237
    do local I=(2);if I==0 then I=math.max(0,(2)-(58)) end;local F=r[(58)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(58)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(58)]=O else for O=1,I do F[L+O]=T[(58)+O] end end;end
    -- PC 0341 FLAG=0xC0 OP_090 [linear-fusion-payloads=1]
    r[(59)]={}; -- 融合载荷：r[(59)]=(2)
    -- PC 0342 FLAG=0x52 OP_282 [linear-fusion-payloads=1]
    r[(60)]=(-1.0); -- 融合载荷：r[(60)]=(-1.0)
    -- PC 0343 FLAG=0x12 OP_346
    r[(61)]=(1.0)
    -- PC 0344 FLAG=0xC0 OP_153
    do local I=(2);if I==0 then I=math.max(0,(2)-(59)) end;local F=r[(59)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(59)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(59)]=O else for O=1,I do F[L+O]=T[(59)+O] end end;end
    -- PC 0345 FLAG=0x00 OP_090 [linear-fusion-payloads=1]
    r[(60)]={}; -- 融合载荷：r[(60)]=(2)
    -- PC 0346 FLAG=0x12 OP_282 [linear-fusion-payloads=1]
    r[(61)]=(-1.0); -- 融合载荷：r[(61)]=(-1.0)
    -- PC 0347 FLAG=0xD2 OP_346
    r[(62)]=(-1.0)
    -- PC 0348 FLAG=0x40 OP_088
    do local I=(2);if I==0 then I=math.max(0,(2)-(60)) end;local F=r[(60)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(60)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(60)]=O else for O=1,I do F[L+O]=T[(60)+O] end end;end
    -- PC 0349 FLAG=0x80 OP_112
    do local I=(8);if I==0 then I=math.max(0,(8)-(52)) end;local F=r[(52)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(52)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(52)]=O else for O=1,I do F[L+O]=T[(52)+O] end end;end
    -- PC 0350 FLAG=0x00 OP_154 [linear-fusion-payloads=1, closure-child-index=22; captures=1; child-path=root/23]
    do local I=O[(22)];local F={};F[-1]=(1);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(1)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(53)]=M(I,U,S) end
    -- PC 0351 FLAG=0x80 OP_387
    r[(0)]=r[(52)]
    -- PC 0352 FLAG=0x00 OP_154 [closure-child-index=48; captures=0; child-path=root/49]
    do local I=O[(48)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(54)]=M(I,U,S) end
    -- PC 0353 FLAG=0x00 OP_154 [linear-fusion-payloads=1, closure-child-index=51; captures=1; child-path=root/52]
    do local I=O[(51)];local F={};F[-1]=(1);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(1)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(55)]=M(I,U,S) end
    -- PC 0354 FLAG=0xC0 OP_387
    r[(0)]=r[(54)]
    -- PC 0355 FLAG=0x00 OP_154 [linear-fusion-payloads=1, closure-child-index=24; captures=1; child-path=root/25]
    do local I=O[(24)];local F={};F[-1]=(1);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(1)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(56)]=M(I,U,S) end
    -- PC 0356 FLAG=0x80 OP_387
    r[(0)]=r[(37)]
    -- PC 0357 FLAG=0x40 OP_027 [linear-fusion-payloads=1, closure-child-index=52; captures=1; child-path=root/53]
    do local I=O[(52)];local F={};F[-1]=(1);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(1)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(57)]=M(I,U,S) end
    -- PC 0358 FLAG=0x00 OP_387
    r[(0)]=r[(41)]
    -- PC 0359 FLAG=0xD0 OP_355
    do local I=('onDamageMsg');local F=r[(57)];r[(0)][I]=F end
    -- PC 0360 FLAG=0x00 OP_027 [linear-fusion-payloads=2, closure-child-index=6; captures=2; child-path=root/7]
    do local I=O[(6)];local F={};F[-1]=(2);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(2)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(57)]=M(I,U,S) end
    -- PC 0361 FLAG=0xC0 OP_387
    r[(0)]=r[(0)]
    -- PC 0362 FLAG=0x40 OP_387
    r[(0)]=r[(4)]
    -- PC 0363 FLAG=0xC0 OP_027 [linear-fusion-payloads=4, closure-child-index=25; captures=4; child-path=root/26]
    do local I=O[(25)];local F={};F[-1]=(4);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(4)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(58)]=M(I,U,S) end
    -- PC 0364 FLAG=0x80 OP_387
    r[(0)]=r[(41)]
    -- PC 0365 FLAG=0x00 OP_387
    r[(0)]=r[(4)]
    -- PC 0366 FLAG=0x00 OP_387
    r[(0)]=r[(55)]
    -- PC 0367 FLAG=0x00 OP_387
    r[(0)]=r[(5)]
    -- PC 0368 FLAG=0x00 OP_154 [linear-fusion-payloads=13, closure-child-index=47; captures=13; child-path=root/48]
    do local I=O[(47)];local F={};F[-1]=(13);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(13)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(59)]=M(I,U,S) end
    -- PC 0369 FLAG=0xC0 OP_387
    r[(0)]=r[(2)]
    -- PC 0370 FLAG=0xC0 OP_387
    r[(0)]=r[(57)]
    -- PC 0371 FLAG=0x80 OP_387
    r[(0)]=r[(41)]
    -- PC 0372 FLAG=0x00 OP_387
    r[(0)]=r[(58)]
    -- PC 0373 FLAG=0x00 OP_387
    r[(0)]=r[(55)]
    -- PC 0374 FLAG=0x40 OP_387
    r[(0)]=r[(53)]
    -- PC 0375 FLAG=0xC0 OP_387
    r[(0)]=r[(38)]
    -- PC 0376 FLAG=0xC0 OP_387
    r[(0)]=r[(4)]
    -- PC 0377 FLAG=0x40 OP_387
    r[(0)]=r[(56)]
    -- PC 0378 FLAG=0x40 OP_387
    r[(0)]=r[(39)]
    -- PC 0379 FLAG=0x00 OP_387
    r[(0)]=r[(5)]
    -- PC 0380 FLAG=0x40 OP_387
    r[(0)]=r[(40)]
    -- PC 0381 FLAG=0x80 OP_387
    r[(0)]=r[(37)]
    -- PC 0382 FLAG=0x92 OP_182
    __ENV[('BlacklistItems')]=r[(59)]
    -- PC 0383 FLAG=0xC0 OP_027 [linear-fusion-payloads=4, closure-child-index=15; captures=4; child-path=root/16]
    do local I=O[(15)];local F={};F[-1]=(4);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(4)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(59)]=M(I,U,S) end
    -- PC 0384 FLAG=0x80 OP_387
    r[(0)]=r[(54)]
    -- PC 0385 FLAG=0x80 OP_387
    r[(0)]=r[(4)]
    -- PC 0386 FLAG=0x80 OP_387
    r[(0)]=r[(5)]
    -- PC 0387 FLAG=0x40 OP_387
    r[(0)]=r[(41)]
    -- PC 0388 FLAG=0x92 OP_141
    __ENV[('ClearBlacklistItems')]=r[(59)]
    -- PC 0389 FLAG=0x52 OP_137
    r[(59)]=__ENV[('MainLeftBottom')]
    -- PC 0390 FLAG=0x00 OP_027 [linear-fusion-payloads=20, closure-child-index=42; captures=20; child-path=root/43]
    do local I=O[(42)];local F={};F[-1]=(20);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(20)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(60)]=M(I,U,S) end
    -- PC 0391 FLAG=0x80 OP_387
    r[(0)]=r[(4)]
    -- PC 0392 FLAG=0xC0 OP_387
    r[(0)]=r[(2)]
    -- PC 0393 FLAG=0x00 OP_387
    r[(0)]=r[(3)]
    -- PC 0394 FLAG=0x00 OP_387
    r[(0)]=r[(0)]
    -- PC 0395 FLAG=0x40 OP_387
    r[(0)]=r[(1)]
    -- PC 0396 FLAG=0x00 OP_387
    r[(0)]=r[(41)]
    -- PC 0397 FLAG=0x40 OP_387
    r[(0)]=r[(48)]
    -- PC 0398 FLAG=0x00 OP_387
    r[(0)]=r[(7)]
    -- PC 0399 FLAG=0xC0 OP_387
    r[(0)]=r[(8)]
    -- PC 0400 FLAG=0x40 OP_387
    r[(0)]=r[(50)]
    -- PC 0401 FLAG=0x00 OP_387
    r[(0)]=r[(49)]
    -- PC 0402 FLAG=0x00 OP_387
    r[(0)]=r[(5)]
    -- PC 0403 FLAG=0x00 OP_387
    r[(0)]=r[(44)]
    -- PC 0404 FLAG=0x80 OP_387
    r[(0)]=r[(42)]
    -- PC 0405 FLAG=0xC0 OP_387
    r[(0)]=r[(51)]
    -- PC 0406 FLAG=0x40 OP_387
    r[(0)]=r[(43)]
    -- PC 0407 FLAG=0xC0 OP_387
    r[(0)]=r[(47)]
    -- PC 0408 FLAG=0x40 OP_387
    r[(0)]=r[(11)]
    -- PC 0409 FLAG=0xC0 OP_387
    r[(0)]=r[(12)]
    -- PC 0410 FLAG=0x00 OP_387
    r[(0)]=r[(9)]
    -- PC 0411 FLAG=0x90 OP_268
    do local I=('doInit');local F=r[(60)];r[(59)][I]=F end
    -- PC 0412 FLAG=0xC0 OP_001
    return
end
-- 原型入口：proto_MainLeftBottom_Module_root

-- ============================================================================
-- 原型 root/1 | 候选名称：GetStorageItemData | 指令记录：32 | 子原型：1 | 可变参数：1
-- 字节范围：5323:5760
local function proto_GetStorageItemData_root_1(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'pcall'
    -- K[1] = 'isFileExist'
    -- K[2] = 'cc'
    -- K[3] = 'getInstance'
    -- K[4] = 'FileUtils'
    -- 指令语义：
    -- PC 0001 FLAG=0xD2 OP_309 [linear-fusion-payloads=2]
    r[(1)]=__ENV[('cc')]; -- 融合载荷：r[(1)]=r[('cc')][(nil)]; -- 融合载荷：local I=r[('cc')];r[(1)+1]=I;r[(1)]=I[(nil)]
    -- PC 0002 FLAG=0xA0 OP_270 [linear-fusion-payloads=1]
    r[(1)]=r[(1)][('FileUtils')]; -- 融合载荷：local I=r[(1)];r[(1)+1]=I;r[(1)]=I[('FileUtils')]
    -- PC 0003 FLAG=0xE0 OP_238
    local I=r[(1)];r[(1)+1]=I;r[(1)]=I[('getInstance')]
    -- PC 0004 FLAG=0x40 OP_068
    r[(1)]=r[(1)](U(T,(1)+1,(2)))
    -- PC 0005 FLAG=0x00 OP_130
    r[(2)]=up[(0)]
    -- PC 0006 FLAG=0xC0 OP_308
    r[(3)]=r[(0)]
    -- PC 0007 FLAG=0xC0 OP_098
    r[(2)]=r[(2)](U(T,(2)+1,(3)))
    -- PC 0008 FLAG=0xA0 OP_142 [linear-fusion-payloads=1]
    local I=r[(1)];r[(3)+1]=I;r[(3)]=I[('isFileExist')]; -- 融合载荷：r[(3)]=r[(1)]
    -- PC 0009 FLAG=0x00 OP_184
    r[(5)]=r[(2)]
    -- PC 0010 FLAG=0x80 OP_098
    r[(3)]=r[(3)](U(T,(3)+1,(5)))
    -- PC 0011 FLAG=0x40 OP_342
    if (not not r[(3)])~=((1)~=0) then pc=pc+1 end
    -- PC 0012 FLAG=0xC2 OP_215 [jump-target=16]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(15)
    -- PC 0013 FLAG=0x40 OP_011
    r[(3)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0014 FLAG=0x40 OP_184
    r[(4)]=r[(2)]
    -- PC 0015 FLAG=0x40 OP_220
    return U(T,(3),(4))
    -- PC 0016 FLAG=0x52 OP_137
    r[(3)]=__ENV[('pcall')]
    -- PC 0017 FLAG=0xC0 OP_027 [linear-fusion-payloads=2, closure-child-index=0; captures=2; child-path=root/1/1]
    do local I=O[(0)];local F={};F[-1]=(2);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(2)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(4)]=M(I,U,S) end
    -- PC 0018 FLAG=0x40 OP_387
    r[(0)]=r[(1)]
    -- PC 0019 FLAG=0x80 OP_387
    r[(0)]=r[(2)]
    -- PC 0020 FLAG=0xC0 OP_068
    r[(3)]=r[(3)](U(T,(3)+1,(4)))
    -- PC 0021 FLAG=0x40 OP_342
    if (not not r[(3)])~=((1)~=0) then pc=pc+1 end
    -- PC 0022 FLAG=0xC2 OP_215 [jump-target=26]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(25)
    -- PC 0023 FLAG=0x00 OP_011
    r[(4)]=(0)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0024 FLAG=0x00 OP_308
    r[(5)]=r[(2)]
    -- PC 0025 FLAG=0x00 OP_220
    return U(T,(4),(5))
    -- PC 0026 FLAG=0x60 OP_142 [linear-fusion-payloads=1]
    local I=r[(1)];r[(4)+1]=I;r[(4)]=I[('isFileExist')]; -- 融合载荷：r[(4)]=r[(1)]
    -- PC 0027 FLAG=0x00 OP_184
    r[(6)]=r[(2)]
    -- PC 0028 FLAG=0xC0 OP_068
    r[(4)]=r[(4)](U(T,(4)+1,(6)))
    -- PC 0029 FLAG=0x40 OP_172
    r[(4)]=not r[(4)]
    -- PC 0030 FLAG=0xC0 OP_184
    r[(5)]=r[(2)]
    -- PC 0031 FLAG=0x00 OP_220
    return U(T,(4),(5))
    -- PC 0032 FLAG=0xC0 OP_250
    return
end
-- 原型入口：proto_GetStorageItemData_root_1

-- ============================================================================
-- 原型 root/1/1 | 候选名称：Prototype_root_1_1 | 指令记录：5 | 子原型：0 | 可变参数：0
-- 字节范围：5686:5759
local function proto_Prototype_root_1_1_root_1_1(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'removeFile'
    -- 指令语义：
    -- PC 0001 FLAG=0x40 OP_130
    r[(0)]=up[(0)]
    -- PC 0002 FLAG=0xA0 OP_238
    local I=r[(0)];r[(0)+1]=I;r[(0)]=I[('removeFile')]
    -- PC 0003 FLAG=0x80 OP_130
    r[(2)]=up[(1)]
    -- PC 0004 FLAG=0x80 OP_187
    r[(0)](U(T,(0)+1,(2)))
    -- PC 0005 FLAG=0xC0 OP_250
    return
end
-- 原型入口：proto_Prototype_root_1_1_root_1_1

-- ============================================================================
-- 原型 root/2 | 候选名称：GetWritablePath | 指令记录：77 | 子原型：0 | 可变参数：0
-- 字节范围：5760:6712
local function proto_GetWritablePath_root_2(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = '仓库总可用格子: '
    -- K[1] = 'GUIDefine'
    -- K[2] = 'type'
    -- K[3] = 'GetOpenSize'
    -- K[4] = 'table'
    -- K[5] = 'insert'
    -- K[6] = 0.0
    -- K[7] = 'global'
    -- K[8] = 'ipairs'
    -- K[9] = 'NPC_STORAGE_MAX_PAGE'
    -- K[10] = 'NPCStorageProxy'
    -- K[11] = 'MMO'
    -- K[12] = 1.0
    -- K[13] = 'STORAGE_PER_PAGE_MAX'
    -- K[14] = 'GetMaxPage'
    -- K[15] = 'GetStorageDataByPage'
    -- 指令语义：
    -- PC 0001 FLAG=0x80 OP_009 [linear-fusion-payloads=1]
    r[(0)]={}; -- 融合载荷：r[(0)]=__ENV[(0)]
    -- PC 0002 FLAG=0x52 OP_137
    r[(1)]=__ENV[('NPCStorageProxy')]
    -- PC 0003 FLAG=0xC0 OP_342
    if (not not r[(1)])~=((1)~=0) then pc=pc+1 end
    -- PC 0004 FLAG=0x02 OP_140 [jump-target=7]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(6)
    -- PC 0005 FLAG=0x40 OP_234
    for I=(1),(1) do T[I]=nil end
    -- PC 0006 FLAG=0x80 OP_220
    return U(T,(1),(1))
    -- PC 0007 FLAG=0xD2 OP_137
    r[(1)]=__ENV[('NPCStorageProxy')]
    -- PC 0008 FLAG=0x80 OP_016
    if (not not r[(1)])~=((0)~=0) then pc=pc+1 end
    -- PC 0009 FLAG=0xC2 OP_215 [jump-target=76]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(75)
    -- PC 0010 FLAG=0x52 OP_335 [linear-fusion-payloads=1]
    r[(1)]=__ENV[('NPCStorageProxy')]; -- 融合载荷：local I=r[('NPCStorageProxy')];r[(1)+1]=I;r[(1)]=I[(nil)]
    -- PC 0011 FLAG=0xE0 OP_033
    local I=r[(1)];r[(1)+1]=I;r[(1)]=I[('GetMaxPage')]
    -- PC 0012 FLAG=0x00 OP_098
    r[(1)]=r[(1)](U(T,(1)+1,(2)))
    -- PC 0013 FLAG=0xD2 OP_314 [linear-fusion-payloads=3]
    r[(2)]=(0.0); -- 融合载荷：r[(2)]=(0.0); -- 融合载荷：r[(2)]=r[(0.0)]; -- 融合载荷：r[(2)]=(0.0)
    -- PC 0014 FLAG=0x12 OP_101 [linear-fusion-payloads=2]
    r[(3)]=(1.0); -- 融合载荷：r[(3)]=r[(1.0)]; -- 融合载荷：r[(3)]=(1.0)
    -- PC 0015 FLAG=0x80 OP_288 [linear-fusion-payloads=1]
    r[(4)]=r[(1)]; -- 融合载荷：r[(4)]=(1)
    -- PC 0016 FLAG=0x52 OP_346
    r[(5)]=(1.0)
    -- PC 0017 FLAG=0x82 OP_023 [jump-target=68]
    r[(3)]=r[(3)]-r[(3)+2];pc=(67)
    -- PC 0018 FLAG=0x92 OP_300 [linear-fusion-payloads=2]
    r[(7)]=__ENV[('NPCStorageProxy')]; -- 融合载荷：local I=r[('NPCStorageProxy')];r[(7)+1]=I;r[(7)]=I[(nil)]; -- 融合载荷：r[(7)]=r[('NPCStorageProxy')]
    -- PC 0019 FLAG=0xE0 OP_142 [linear-fusion-payloads=1]
    local I=r[(7)];r[(7)+1]=I;r[(7)]=I[('GetStorageDataByPage')]; -- 融合载荷：r[(7)]=r[(7)]
    -- PC 0020 FLAG=0x80 OP_308
    r[(9)]=r[(6)]
    -- PC 0021 FLAG=0xC0 OP_098
    r[(7)]=r[(7)](U(T,(7)+1,(9)))
    -- PC 0022 FLAG=0x40 OP_016
    if (not not r[(7)])~=((0)~=0) then pc=pc+1 end
    -- PC 0023 FLAG=0x82 OP_215 [jump-target=42]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(41)
    -- PC 0024 FLAG=0xD2 OP_071 [linear-fusion-payloads=1]
    r[(8)]=__ENV[('type')]; -- 融合载荷：r[(8)]=r[('type')]
    -- PC 0025 FLAG=0x40 OP_308
    r[(9)]=r[(7)]
    -- PC 0026 FLAG=0xC0 OP_098
    r[(8)]=r[(8)](U(T,(8)+1,(9)))
    -- PC 0027 FLAG=0xA0 OP_271
    if (r[(8)]==('table'))~=((0)~=0) then pc=pc+1 end
    -- PC 0028 FLAG=0xC2 OP_215 [jump-target=42]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(41)
    -- PC 0029 FLAG=0xD2 OP_071 [linear-fusion-payloads=1]
    r[(8)]=__ENV[('ipairs')]; -- 融合载荷：r[(8)]=r[('ipairs')]
    -- PC 0030 FLAG=0x00 OP_184
    r[(9)]=r[(7)]
    -- PC 0031 FLAG=0x40 OP_359
    do local I={ r[(8)](U(T,(8)+1,(9))) };local F=0;for U=(8),(10) do F=F+1;T[U]=I[F] end end
    -- PC 0032 FLAG=0x42 OP_255 [jump-target=40]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(39)
    -- PC 0033 FLAG=0x80 OP_016
    if (not not r[(12)])~=((0)~=0) then pc=pc+1 end
    -- PC 0034 FLAG=0x42 OP_255 [jump-target=40]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(39)
    -- PC 0035 FLAG=0xD2 OP_010 [linear-fusion-payloads=3]
    r[(13)]=__ENV[('table')]; -- 融合载荷：r[(13)]=r[('table')][(nil)]; -- 融合载荷：r[(13)]=r[('table')]; -- 融合载荷：r[(13)]=r[('table')]
    -- PC 0036 FLAG=0xA0 OP_363
    r[(13)]=r[(13)][('insert')]
    -- PC 0037 FLAG=0xC0 OP_078 [linear-fusion-payloads=1]
    r[(14)]=r[(0)]; -- 融合载荷：r[(14)]=r[(0)]
    -- PC 0038 FLAG=0x80 OP_308
    r[(15)]=r[(12)]
    -- PC 0039 FLAG=0x00 OP_187
    r[(13)](U(T,(13)+1,(15)))
    -- PC 0040 FLAG=0x00 OP_339
    do local I,F=E(r[(8)](r[(8)+1],r[(8)+2]));for U=1,(2) do T[(8)+2+U]=I[U] end;if r[(8)+3]==nil then pc=pc+1 else r[(8)+2]=r[(8)+3] end end
    -- PC 0041 FLAG=0xC2 OP_255 [jump-target=33]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(32)
    -- PC 0042 FLAG=0x40 OP_016
    if (not not r[(7)])~=((0)~=0) then pc=pc+1 end
    -- PC 0043 FLAG=0x42 OP_140 [jump-target=47]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(46)
    -- PC 0044 FLAG=0x80 OP_115
    r[(8)]=#r[(7)]
    -- PC 0045 FLAG=0xC0 OP_342
    if (not not r[(8)])~=((1)~=0) then pc=pc+1 end
    -- PC 0046 FLAG=0x82 OP_255 [jump-target=48]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(47)
    -- PC 0047 FLAG=0x92 OP_217 [linear-fusion-payloads=2]
    r[(8)]=(0.0); -- 融合载荷：r[(8)]=__ENV[(0.0)]; -- 融合载荷：r[(8)]=r[(0.0)][(nil)]
    -- PC 0048 FLAG=0x92 OP_137
    r[(9)]=__ENV[('GUIDefine')]
    -- PC 0049 FLAG=0xE0 OP_363
    r[(9)]=r[(9)][('STORAGE_PER_PAGE_MAX')]
    -- PC 0050 FLAG=0xC0 OP_342
    if (not not r[(9)])~=((1)~=0) then pc=pc+1 end
    -- PC 0051 FLAG=0x42 OP_140 [jump-target=55]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(54)
    -- PC 0052 FLAG=0xD2 OP_070 [linear-fusion-payloads=4]
    r[(9)]=__ENV[('global')]; -- 融合载荷：r[(9)]=r[('global')][(nil)]; -- 融合载荷：r[(9)]=r[('global')][(nil)]; -- 融合载荷：r[(9)]=__ENV[('global')]; -- 融合载荷：local I=r[('global')];r[(9)+1]=I;r[(9)]=I[(nil)]
    -- PC 0053 FLAG=0x60 OP_049 [linear-fusion-payloads=1]
    r[(9)]=r[(9)][('MMO')]; -- 融合载荷：r[(9)]=r[(9)][('MMO')]
    -- PC 0054 FLAG=0x20 OP_032
    r[(9)]=r[(9)][('NPC_STORAGE_MAX_PAGE')]
    -- PC 0055 FLAG=0x12 OP_335 [linear-fusion-payloads=1]
    r[(10)]=__ENV[('NPCStorageProxy')]; -- 融合载荷：local I=r[('NPCStorageProxy')];r[(10)+1]=I;r[(10)]=I[(nil)]
    -- PC 0056 FLAG=0x20 OP_033
    local I=r[(10)];r[(10)+1]=I;r[(10)]=I[('GetOpenSize')]
    -- PC 0057 FLAG=0x80 OP_068
    r[(10)]=r[(10)](U(T,(10)+1,(11)))
    -- PC 0058 FLAG=0x60 OP_073 [linear-fusion-payloads=2]
    r[(11)]=r[(6)]-(1.0); -- 融合载荷：r[(11)]=r[(6)]*r[(1.0)]; -- 融合载荷：r[(11)]=r[(6)]-r[(1.0)]
    -- PC 0059 FLAG=0x40 OP_316
    r[(11)]=r[(11)]*r[(9)]
    -- PC 0060 FLAG=0x40 OP_340
    r[(10)]=r[(10)]-r[(11)]
    -- PC 0061 FLAG=0xC0 OP_253
    if (r[(9)]<r[(10)])~=((0)~=0) then pc=pc+1 end
    -- PC 0062 FLAG=0x42 OP_215 [jump-target=64]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(63)
    -- PC 0063 FLAG=0x80 OP_308
    r[(10)]=r[(9)]
    -- PC 0064 FLAG=0x50 OP_364
    if ((0.0)<r[(10)])~=((0)~=0) then pc=pc+1 end
    -- PC 0065 FLAG=0x82 OP_255 [jump-target=68]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(67)
    -- PC 0066 FLAG=0xC0 OP_340
    r[(11)]=r[(10)]-r[(8)]
    -- PC 0067 FLAG=0x00 OP_029
    r[(2)]=r[(2)]+r[(11)]
    -- PC 0068 FLAG=0x82 OP_412 [loop-target=18]
    do local I=(3);local F=T[I+2];local U=T[I]+F;T[I]=U;local L=T[I+1];if (F>0 and U<=L) or (F<=0 and U>=L) then T[I+3]=U;pc=(17) end end
    -- PC 0069 FLAG=0x10 OP_364
    if ((0.0)<r[(2)])~=((0)~=0) then pc=pc+1 end
    -- PC 0070 FLAG=0xC2 OP_215 [jump-target=76]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(75)
    -- PC 0071 FLAG=0xC0 OP_145 [linear-fusion-payloads=3]
    r[(3)]=up[(0)]; -- 融合载荷：r[(3)]=(0); -- 融合载荷：r[(3)]=r[(0)]; -- 融合载荷：do local I=r[(0)];for F=(0)-1,(0),-1 do I=T[F]..I end;r[(3)]=I end
    -- PC 0072 FLAG=0x12 OP_320 [linear-fusion-payloads=2]
    r[(4)]=('仓库总可用格子: '); -- 融合载荷：r[(4)]=r[('仓库总可用格子: ')]; -- 融合载荷：do local I=r[(nil)];for F=(nil)-1,('仓库总可用格子: '),-1 do I=T[F]..I end;r[(4)]=I end
    -- PC 0073 FLAG=0x40 OP_345 [linear-fusion-payloads=1]
    r[(5)]=r[(2)]; -- 融合载荷：do local I=r[(0)];for F=(0)-1,(2),-1 do I=T[F]..I end;r[(5)]=I end
    -- PC 0074 FLAG=0xC0 OP_210
    do local I=r[(5)];for F=(5)-1,(4),-1 do I=T[F]..I end;r[(4)]=I end
    -- PC 0075 FLAG=0x00 OP_358
    r[(3)](U(T,(3)+1,(4)))
    -- PC 0076 FLAG=0x00 OP_220
    return U(T,(0),(0))
    -- PC 0077 FLAG=0x40 OP_055
    return
end
-- 原型入口：proto_GetWritablePath_root_2

-- ============================================================================
-- 原型 root/3 | 候选名称：MoveTo | 指令记录：10 | 子原型：0 | 可变参数：1
-- 字节范围：6712:6872
local function proto_MoveTo_root_3(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'FileUtils'
    -- K[1] = 'getInstance'
    -- K[2] = 'getWritablePath'
    -- K[3] = 'cc'
    -- 指令语义：
    -- PC 0001 FLAG=0xD2 OP_137
    r[(1)]=__ENV[('cc')]
    -- PC 0002 FLAG=0xE0 OP_270 [linear-fusion-payloads=1]
    r[(1)]=r[(1)][('FileUtils')]; -- 融合载荷：local I=r[(1)];r[(1)+1]=I;r[(1)]=I[('FileUtils')]
    -- PC 0003 FLAG=0x20 OP_033
    local I=r[(1)];r[(1)+1]=I;r[(1)]=I[('getInstance')]
    -- PC 0004 FLAG=0x00 OP_098
    r[(1)]=r[(1)](U(T,(1)+1,(2)))
    -- PC 0005 FLAG=0x60 OP_121
    local I=r[(1)];r[(1)+1]=I;r[(1)]=I[('getWritablePath')]
    -- PC 0006 FLAG=0x40 OP_098
    r[(1)]=r[(1)](U(T,(1)+1,(2)))
    -- PC 0007 FLAG=0x80 OP_184
    r[(2)]=r[(0)]
    -- PC 0008 FLAG=0xC0 OP_210
    do local I=r[(2)];for F=(2)-1,(1),-1 do I=T[F]..I end;r[(1)]=I end
    -- PC 0009 FLAG=0xC0 OP_220
    return U(T,(1),(1))
    -- PC 0010 FLAG=0x00 OP_100
    return
end
-- 原型入口：proto_MoveTo_root_3

-- ============================================================================
-- 原型 root/4 | 候选名称：GetDroppedItems | 指令记录：51 | 子原型：0 | 可变参数：3
-- 字节范围：6872:7583
local function proto_GetDroppedItems_root_4(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'sendNotification'
    -- K[1] = 'global'
    -- K[2] = 'range'
    -- K[3] = 'Facade'
    -- K[4] = 'x'
    -- K[5] = 'PlayerPos'
    -- K[6] = 'InputMove'
    -- K[7] = 'NoticeTable'
    -- K[8] = 'GetMetaValue'
    -- K[9] = 'mapID'
    -- K[10] = 'INPUT_MOVE_TYPE_AUTOMOVE'
    -- K[11] = 'SL'
    -- K[12] = 'abs'
    -- K[13] = 'y'
    -- K[14] = 'math'
    -- K[15] = 'MMO'
    -- K[16] = 'tonumber'
    -- K[17] = 0.0
    -- K[18] = 'type'
    -- K[19] = 'MAP_ID'
    -- 指令语义：
    -- PC 0001 FLAG=0x80 OP_225 [linear-fusion-payloads=3]
    r[(3)]={}; -- 融合载荷：r[(3)]=__ENV[(0)]; -- 融合载荷：local I=r[(0)];r[(3)+1]=I;r[(3)]=I[(5)]; -- 融合载荷：r[(3)]=(0)
    -- PC 0002 FLAG=0x12 OP_137
    r[(4)]=__ENV[('SL')]
    -- PC 0003 FLAG=0xA0 OP_238
    local I=r[(4)];r[(4)+1]=I;r[(4)]=I[('GetMetaValue')]
    -- PC 0004 FLAG=0xD2 OP_346
    r[(6)]=('MAP_ID')
    -- PC 0005 FLAG=0x80 OP_098
    r[(4)]=r[(4)](U(T,(4)+1,(6)))
    -- PC 0006 FLAG=0x10 OP_268
    do local I=('mapID');local F=r[(4)];r[(3)][I]=F end
    -- PC 0007 FLAG=0x52 OP_137
    r[(4)]=__ENV[('tonumber')]
    -- PC 0008 FLAG=0x40 OP_184
    r[(5)]=r[(0)]
    -- PC 0009 FLAG=0x40 OP_068
    r[(4)]=r[(4)](U(T,(4)+1,(5)))
    -- PC 0010 FLAG=0x90 OP_353 [linear-fusion-payloads=2]
    do local I=('x');local F=r[(4)];r[(3)][I]=F end; -- 融合载荷：r[(3)]=__ENV[('x')]; -- 融合载荷：r[(3)]=r[('x')]
    -- PC 0011 FLAG=0x92 OP_137
    r[(4)]=__ENV[('tonumber')]
    -- PC 0012 FLAG=0x80 OP_184
    r[(5)]=r[(1)]
    -- PC 0013 FLAG=0x80 OP_068
    r[(4)]=r[(4)](U(T,(4)+1,(5)))
    -- PC 0014 FLAG=0x10 OP_355
    do local I=('y');local F=r[(4)];r[(3)][I]=F end
    -- PC 0015 FLAG=0x12 OP_137
    r[(4)]=__ENV[('global')]
    -- PC 0016 FLAG=0xE0 OP_032
    r[(4)]=r[(4)][('MMO')]
    -- PC 0017 FLAG=0xE0 OP_404 [linear-fusion-payloads=1]
    r[(4)]=r[(4)][('INPUT_MOVE_TYPE_AUTOMOVE')]; -- 融合载荷：do local I=(4);local F=r[('INPUT_MOVE_TYPE_AUTOMOVE')];r[(4)][I]=F end
    -- PC 0018 FLAG=0x50 OP_268
    do local I=('type');local F=r[(4)];r[(3)][I]=F end
    -- PC 0019 FLAG=0xC0 OP_362
    local I=r[(2)];if (not not I)==((1)~=0) then r[(4)]=I else pc=pc+1 end
    -- PC 0020 FLAG=0xC2 OP_255 [jump-target=22]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(21)
    -- PC 0021 FLAG=0xD2 OP_222 [linear-fusion-payloads=6]
    r[(4)]=(0.0); -- 融合载荷：do local I=(0.0);local F=r[(nil)];r[(4)][I]=F end; -- 融合载荷：r[(4)]=__ENV[(0.0)]; -- 融合载荷：r[(4)]=r[(0.0)][(nil)]; -- 融合载荷：local I=r[(0.0)];r[(4)+1]=I;r[(4)]=I[(nil)]; -- 融合载荷：r[(4)]=__ENV[(0.0)]; -- 融合载荷：r[(4)]=r[(0.0)][(nil)]
    -- PC 0022 FLAG=0x90 OP_355
    do local I=('range');local F=r[(4)];r[(3)][I]=F end
    -- PC 0023 FLAG=0xD2 OP_394 [linear-fusion-payloads=6]
    r[(4)]=__ENV[('global')]; -- 融合载荷：r[(4)]=r[('global')][(nil)]; -- 融合载荷：local I=r[('global')];r[(4)+1]=I;r[(4)]=I[(nil)]; -- 融合载荷：r[(4)]=__ENV[('global')]; -- 融合载荷：r[(4)]=r[('global')][(nil)]; -- 融合载荷：r[(4)]=r[('global')][(nil)]; -- 融合载荷：r[(4)]=r[('global')]
    -- PC 0024 FLAG=0xA0 OP_260 [linear-fusion-payloads=4]
    r[(4)]=r[(4)][('Facade')]; -- 融合载荷：local I=r[(4)];r[(4)+1]=I;r[(4)]=I[('Facade')]; -- 融合载荷：r[(4)]=__ENV[(4)]; -- 融合载荷：r[(4)]=r[(4)][('Facade')]; -- 融合载荷：r[(4)]=r[(4)][('Facade')]
    -- PC 0025 FLAG=0xA0 OP_205 [linear-fusion-payloads=4]
    local I=r[(4)];r[(4)+1]=I;r[(4)]=I[('sendNotification')]; -- 融合载荷：r[(4)]=__ENV[(4)]; -- 融合载荷：r[(4)]=r[(4)][('sendNotification')]; -- 融合载荷：r[(4)]=r[(4)][('sendNotification')]; -- 融合载荷：r[(4)]=r[(4)]
    -- PC 0026 FLAG=0x92 OP_296 [linear-fusion-payloads=3]
    r[(6)]=__ENV[('global')]; -- 融合载荷：r[(6)]=r[('global')][(nil)]; -- 融合载荷：r[(6)]=r[('global')][(nil)]; -- 融合载荷：r[(6)]=r[('global')]
    -- PC 0027 FLAG=0xA0 OP_389 [linear-fusion-payloads=2]
    r[(6)]=r[(6)][('NoticeTable')]; -- 融合载荷：r[(6)]=r[(6)][('NoticeTable')]; -- 融合载荷：r[(6)]=r[(6)]
    -- PC 0028 FLAG=0x60 OP_398 [linear-fusion-payloads=1]
    r[(6)]=r[(6)][('InputMove')]; -- 融合载荷：r[(6)]=r[(6)]
    -- PC 0029 FLAG=0x00 OP_184
    r[(7)]=r[(3)]
    -- PC 0030 FLAG=0x00 OP_187
    r[(4)](U(T,(4)+1,(7)))
    -- PC 0031 FLAG=0x12 OP_137
    r[(4)]=__ENV[('PlayerPos')]
    -- PC 0032 FLAG=0x00 OP_359
    do local I={ r[(4)](U(T,(4)+1,(4))) };local F=0;for U=(4),(5) do F=F+1;T[U]=I[F] end end
    -- PC 0033 FLAG=0x92 OP_137
    r[(6)]=__ENV[('math')]
    -- PC 0034 FLAG=0xA0 OP_228 [linear-fusion-payloads=2]
    r[(6)]=r[(6)][('abs')]; -- 融合载荷：r[(6)]=r[(6)][('abs')]; -- 融合载荷：r[(6)]=r[(6)]-r[('abs')]
    -- PC 0035 FLAG=0x20 OP_384 [linear-fusion-payloads=1]
    r[(7)]=r[(3)][('x')]; -- 融合载荷：r[(7)]=r[(3)]-r[('x')]
    -- PC 0036 FLAG=0x40 OP_340
    r[(7)]=r[(7)]-r[(4)]
    -- PC 0037 FLAG=0x00 OP_098
    r[(6)]=r[(6)](U(T,(6)+1,(7)))
    -- PC 0038 FLAG=0x00 OP_236
    if (r[(6)]<=r[(2)])~=((0)~=0) then pc=pc+1 end
    -- PC 0039 FLAG=0x42 OP_255 [jump-target=49]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(48)
    -- PC 0040 FLAG=0x12 OP_203 [linear-fusion-payloads=3]
    r[(6)]=__ENV[('math')]; -- 融合载荷：r[(6)]=r[('math')][(nil)]; -- 融合载荷：r[(6)]=r[('math')][(nil)]; -- 融合载荷：r[(6)]=r[('math')]-r[(nil)]
    -- PC 0041 FLAG=0x20 OP_032
    r[(6)]=r[(6)][('abs')]
    -- PC 0042 FLAG=0xE0 OP_384 [linear-fusion-payloads=1]
    r[(7)]=r[(3)][('y')]; -- 融合载荷：r[(7)]=r[(3)]-r[('y')]
    -- PC 0043 FLAG=0xC0 OP_340
    r[(7)]=r[(7)]-r[(5)]
    -- PC 0044 FLAG=0x40 OP_068
    r[(6)]=r[(6)](U(T,(6)+1,(7)))
    -- PC 0045 FLAG=0x40 OP_258
    if (r[(6)]<=r[(2)])~=((0)~=0) then pc=pc+1 end
    -- PC 0046 FLAG=0x42 OP_215 [jump-target=49]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(48)
    -- PC 0047 FLAG=0x40 OP_011
    r[(6)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0048 FLAG=0xC0 OP_220
    return U(T,(6),(6))
    -- PC 0049 FLAG=0x40 OP_011
    r[(6)]=(0)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0050 FLAG=0x40 OP_220
    return U(T,(6),(6))
    -- PC 0051 FLAG=0x40 OP_001
    return
end
-- 原型入口：proto_GetDroppedItems_root_4

-- ============================================================================
-- 原型 root/5 | 候选名称：TakeItems | 指令记录：8 | 子原型：0 | 可变参数：0
-- 字节范围：7583:7734
local function proto_TakeItems_root_5(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'FindDropItemInCurrViewFieldAll'
    -- K[1] = 'global'
    -- K[2] = 'dropItemManager'
    -- 指令语义：
    -- PC 0001 FLAG=0x12 OP_309 [linear-fusion-payloads=2]
    r[(0)]=__ENV[('global')]; -- 融合载荷：r[(0)]=r[('global')][(nil)]; -- 融合载荷：local I=r[('global')];r[(0)+1]=I;r[(0)]=I[(nil)]
    -- PC 0002 FLAG=0xA0 OP_270 [linear-fusion-payloads=1]
    r[(0)]=r[(0)][('dropItemManager')]; -- 融合载荷：local I=r[(0)];r[(0)+1]=I;r[(0)]=I[('dropItemManager')]
    -- PC 0003 FLAG=0x60 OP_121
    local I=r[(0)];r[(1)+1]=I;r[(1)]=I[('FindDropItemInCurrViewFieldAll')]
    -- PC 0004 FLAG=0x80 OP_233
    do local I={ r[(1)](U(T,(1)+1,(2))) };local F=0;for U=(1),(2) do F=F+1;T[U]=I[F] end end
    -- PC 0005 FLAG=0x80 OP_308
    r[(3)]=r[(1)]
    -- PC 0006 FLAG=0xC0 OP_184
    r[(4)]=r[(2)]
    -- PC 0007 FLAG=0x40 OP_220
    return U(T,(3),(4))
    -- PC 0008 FLAG=0xC0 OP_055
    return
end
-- 原型入口：proto_TakeItems_root_5

-- ============================================================================
-- 原型 root/6 | 候选名称：InstallDamageHook | 指令记录：99 | 子原型：0 | 可变参数：0
-- 字节范围：7734:8941
local function proto_InstallDamageHook_root_6(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = '取: '
    -- K[1] = 'string'
    -- K[2] = 'isTaking'
    -- K[3] = 'MakeIndex'
    -- K[4] = 999999999.0
    -- K[5] = 0.0
    -- K[6] = False
    -- K[7] = 'LuaSendMsg'
    -- K[8] = 'global'
    -- K[9] = '待定'
    -- K[10] = 'len'
    -- K[11] = 'GetStorageItemData'
    -- K[12] = 'MSG_CS_STORAGE_PICK_OUT_REQUEST'
    -- K[13] = 'find'
    -- K[14] = 'MsgType'
    -- K[15] = 'ipairs'
    -- K[16] = '取出物品完成, 共取出 '
    -- K[17] = 1.0
    -- K[18] = 'trim'
    -- K[19] = ' 件'
    -- K[20] = True
    -- K[21] = 'Name'
    -- K[22] = '仓库无可取物品'
    -- 指令语义：
    -- PC 0001 FLAG=0xC0 OP_130
    r[(0)]=up[(0)]
    -- PC 0002 FLAG=0xE0 OP_375
    r[(0)]=r[(0)][('isTaking')]
    -- PC 0003 FLAG=0x80 OP_016
    if (not not r[(0)])~=((0)~=0) then pc=pc+1 end
    -- PC 0004 FLAG=0xC2 OP_140 [jump-target=6]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(5)
    -- PC 0005 FLAG=0x00 OP_055
    return
    -- PC 0006 FLAG=0x80 OP_008 [linear-fusion-payloads=4]
    r[(0)]=up[(0)]; -- 融合载荷：do local I=(0);local F=(0);r[(0)][I]=F end; -- 融合载荷：r[(0)]=(0); -- 融合载荷：r[(0)]={}; -- 融合载荷：r[(0)]=(0)
    -- PC 0007 FLAG=0xB0 OP_156
    do local I=('isTaking');local F=(true);r[(0)][I]=F end
    -- PC 0008 FLAG=0x92 OP_040 [linear-fusion-payloads=2]
    r[(0)]=(1.0); -- 融合载荷：r[(0)]={}; -- 融合载荷：r[(0)]=(1.0)
    -- PC 0009 FLAG=0xC0 OP_090 [linear-fusion-payloads=1]
    r[(1)]={}; -- 融合载荷：r[(1)]=(1)
    -- PC 0010 FLAG=0x92 OP_346
    r[(2)]=('待定')
    -- PC 0011 FLAG=0x40 OP_402
    do local I=(1);if I==0 then I=math.max(0,(1)-(1)) end;local F=r[(1)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(1)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(1)]=O else for O=1,I do F[L+O]=T[(1)+O] end end;end
    -- PC 0012 FLAG=0x12 OP_137
    r[(2)]=__ENV[('GetStorageItemData')]
    -- PC 0013 FLAG=0xC0 OP_068
    r[(2)]=r[(2)](U(T,(2)+1,(2)))
    -- PC 0014 FLAG=0x80 OP_016
    if (not not r[(2)])~=((0)~=0) then pc=pc+1 end
    -- PC 0015 FLAG=0x82 OP_215 [jump-target=19]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(18)
    -- PC 0016 FLAG=0x00 OP_115
    r[(3)]=#r[(2)]
    -- PC 0017 FLAG=0x20 OP_045
    if (r[(3)]==(0.0))~=((0)~=0) then pc=pc+1 end
    -- PC 0018 FLAG=0x82 OP_140 [jump-target=25]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(24)
    -- PC 0019 FLAG=0x40 OP_130
    r[(3)]=up[(1)]
    -- PC 0020 FLAG=0x52 OP_371
    r[(4)]=('仓库无可取物品')
    -- PC 0021 FLAG=0x00 OP_358
    r[(3)](U(T,(3)+1,(4)))
    -- PC 0022 FLAG=0x80 OP_089 [linear-fusion-payloads=1]
    r[(3)]=up[(0)]; -- 融合载荷：do local I=(0);local F=(0);r[(3)][I]=F end
    -- PC 0023 FLAG=0xB0 OP_146
    do local I=('isTaking');local F=(false);r[(3)][I]=F end
    -- PC 0024 FLAG=0x80 OP_250
    return
    -- PC 0025 FLAG=0x12 OP_173 [linear-fusion-payloads=2]
    r[(3)]=(0.0); -- 融合载荷：r[(3)]=__ENV[(0.0)]; -- 融合载荷：r[(3)]=r[(0.0)]
    -- PC 0026 FLAG=0xD2 OP_137
    r[(4)]=__ENV[('ipairs')]
    -- PC 0027 FLAG=0x80 OP_184
    r[(5)]=r[(2)]
    -- PC 0028 FLAG=0x40 OP_359
    do local I={ r[(4)](U(T,(4)+1,(5))) };local F=0;for U=(4),(6) do F=F+1;T[U]=I[F] end end
    -- PC 0029 FLAG=0x82 OP_140 [jump-target=87]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(86)
    -- PC 0030 FLAG=0x00 OP_016
    if (not not r[(8)])~=((0)~=0) then pc=pc+1 end
    -- PC 0031 FLAG=0xC2 OP_255 [jump-target=87]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(86)
    -- PC 0032 FLAG=0xA0 OP_363
    r[(9)]=r[(8)][('Name')]
    -- PC 0033 FLAG=0x40 OP_016
    if (not not r[(9)])~=((0)~=0) then pc=pc+1 end
    -- PC 0034 FLAG=0x02 OP_255 [jump-target=87]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(86)
    -- PC 0035 FLAG=0xE0 OP_032
    r[(9)]=r[(8)][('MakeIndex')]
    -- PC 0036 FLAG=0xC0 OP_016
    if (not not r[(9)])~=((0)~=0) then pc=pc+1 end
    -- PC 0037 FLAG=0x82 OP_140 [jump-target=87]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(86)
    -- PC 0038 FLAG=0xD2 OP_198 [linear-fusion-payloads=2]
    r[(9)]=__ENV[('string')]; -- 融合载荷：r[(9)]=r[('string')][(nil)]; -- 融合载荷：r[(9)]=r[('string')][(nil)]
    -- PC 0039 FLAG=0x20 OP_375
    r[(9)]=r[(9)][('trim')]
    -- PC 0040 FLAG=0xE0 OP_375
    r[(10)]=r[(8)][('Name')]
    -- PC 0041 FLAG=0x40 OP_098
    r[(9)]=r[(9)](U(T,(9)+1,(10)))
    -- PC 0042 FLAG=0x20 OP_092
    if (r[(0)]==(1.0))~=((1)~=0) then pc=pc+1 end
    -- PC 0043 FLAG=0x42 OP_140 [jump-target=45]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(44)
    -- PC 0044 FLAG=0x80 OP_082
    r[(10)]=(0)~=0;if (1)~=0 then pc=pc+1 end
    -- PC 0045 FLAG=0xC0 OP_338
    r[(10)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0046 FLAG=0xE0 OP_271
    if (r[(0)]==(0.0))~=((0)~=0) then pc=pc+1 end
    -- PC 0047 FLAG=0x82 OP_140 [jump-target=65]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(64)
    -- PC 0048 FLAG=0x12 OP_071 [linear-fusion-payloads=1]
    r[(11)]=__ENV[('ipairs')]; -- 融合载荷：r[(11)]=r[('ipairs')]
    -- PC 0049 FLAG=0xC0 OP_184
    r[(12)]=r[(1)]
    -- PC 0050 FLAG=0x40 OP_233
    do local I={ r[(11)](U(T,(11)+1,(12))) };local F=0;for U=(11),(13) do F=F+1;T[U]=I[F] end end
    -- PC 0051 FLAG=0x82 OP_215 [jump-target=63]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(62)
    -- PC 0052 FLAG=0xD2 OP_397 [linear-fusion-payloads=1]
    r[(16)]=__ENV[('string')]; -- 融合载荷：r[(16)]=r[('string')][(nil)]
    -- PC 0053 FLAG=0x60 OP_375
    r[(16)]=r[(16)][('find')]
    -- PC 0054 FLAG=0xC0 OP_184
    r[(17)]=r[(9)]
    -- PC 0055 FLAG=0x00 OP_184
    r[(18)]=r[(15)]
    -- PC 0056 FLAG=0x92 OP_346
    r[(19)]=(1.0)
    -- PC 0057 FLAG=0xC0 OP_401
    r[(20)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0058 FLAG=0x00 OP_068
    r[(16)]=r[(16)](U(T,(16)+1,(20)))
    -- PC 0059 FLAG=0xC0 OP_016
    if (not not r[(16)])~=((0)~=0) then pc=pc+1 end
    -- PC 0060 FLAG=0x02 OP_215 [jump-target=63]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(62)
    -- PC 0061 FLAG=0x80 OP_338
    r[(10)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0062 FLAG=0x82 OP_140 [jump-target=65]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(64)
    -- PC 0063 FLAG=0xC0 OP_386
    do local I,F=E(r[(11)](r[(11)+1],r[(11)+2]));for U=1,(2) do T[(11)+2+U]=I[U] end;if r[(11)+3]==nil then pc=pc+1 else r[(11)+2]=r[(11)+3] end end
    -- PC 0064 FLAG=0x82 OP_255 [jump-target=52]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(51)
    -- PC 0065 FLAG=0x80 OP_016
    if (not not r[(10)])~=((0)~=0) then pc=pc+1 end
    -- PC 0066 FLAG=0x82 OP_255 [jump-target=87]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(86)
    -- PC 0067 FLAG=0x00 OP_145 [linear-fusion-payloads=3]
    r[(11)]=up[(1)]; -- 融合载荷：r[(11)]=(1); -- 融合载荷：r[(11)]=r[(1)]; -- 融合载荷：do local I=r[(0)];for F=(0)-1,(1),-1 do I=T[F]..I end;r[(11)]=I end
    -- PC 0068 FLAG=0x92 OP_320 [linear-fusion-payloads=2]
    r[(12)]=('取: '); -- 融合载荷：r[(12)]=r[('取: ')]; -- 融合载荷：do local I=r[(nil)];for F=(nil)-1,('取: '),-1 do I=T[F]..I end;r[(12)]=I end
    -- PC 0069 FLAG=0xC0 OP_345 [linear-fusion-payloads=1]
    r[(13)]=r[(9)]; -- 融合载荷：do local I=r[(0)];for F=(0)-1,(9),-1 do I=T[F]..I end;r[(13)]=I end
    -- PC 0070 FLAG=0x40 OP_210
    do local I=r[(13)];for F=(13)-1,(12),-1 do I=T[F]..I end;r[(12)]=I end
    -- PC 0071 FLAG=0x80 OP_358
    r[(11)](U(T,(11)+1,(12)))
    -- PC 0072 FLAG=0x12 OP_276 [linear-fusion-payloads=5]
    r[(11)]=__ENV[('LuaSendMsg')]; -- 融合载荷：r[(11)]=__ENV[('LuaSendMsg')]; -- 融合载荷：r[(11)]=r[('LuaSendMsg')][(nil)]; -- 融合载荷：r[(11)]=r[('LuaSendMsg')][(nil)]; -- 融合载荷：r[(11)]=('LuaSendMsg'); -- 融合载荷：r[(11)]=r[('LuaSendMsg')][(nil)]
    -- PC 0073 FLAG=0x12 OP_397 [linear-fusion-payloads=1]
    r[(12)]=__ENV[('global')]; -- 融合载荷：r[(12)]=r[('global')][(nil)]
    -- PC 0074 FLAG=0x20 OP_375
    r[(12)]=r[(12)][('MsgType')]
    -- PC 0075 FLAG=0x20 OP_046 [linear-fusion-payloads=8]
    r[(12)]=r[(12)][('MSG_CS_STORAGE_PICK_OUT_REpcUEST')]; -- 融合载荷：r[(12)]=(12); -- 融合载荷：r[(12)]=r[(12)][('MSG_CS_STORAGE_PICK_OUT_REpcUEST')]; -- 融合载荷：r[(12)]=(12); -- 融合载荷：r[(12)]=(12); -- 融合载荷：r[(12)]=r[(12)]; -- 融合载荷：r[(12)]=__ENV[(12)]; -- 融合载荷：r[(12)]=r[(12)][('MSG_CS_STORAGE_PICK_OUT_REpcUEST')]; -- 融合载荷：r[(12)]=r[(12)]
    -- PC 0076 FLAG=0x52 OP_295 [linear-fusion-payloads=7]
    r[(13)]=(999999999.0); -- 融合载荷：r[(13)]=r[(999999999.0)][(nil)]; -- 融合载荷：r[(13)]=(999999999.0); -- 融合载荷：r[(13)]=(999999999.0); -- 融合载荷：r[(13)]=r[(999999999.0)]; -- 融合载荷：r[(13)]=__ENV[(999999999.0)]; -- 融合载荷：r[(13)]=r[(999999999.0)][(nil)]; -- 融合载荷：r[(13)]=r[(999999999.0)]
    -- PC 0077 FLAG=0xE0 OP_025 [linear-fusion-payloads=2]
    r[(14)]=r[(8)][('MakeIndex')]; -- 融合载荷：r[(14)]=(8); -- 融合载荷：r[(14)]=(8)
    -- PC 0078 FLAG=0x12 OP_050 [linear-fusion-payloads=5]
    r[(15)]=(0.0); -- 融合载荷：r[(15)]=(0.0); -- 融合载荷：r[(15)]=r[(0.0)]; -- 融合载荷：r[(15)]=__ENV[(0.0)]; -- 融合载荷：r[(15)]=r[(0.0)][(nil)]; -- 融合载荷：r[(15)]=r[(0.0)]
    -- PC 0079 FLAG=0x12 OP_232 [linear-fusion-payloads=4]
    r[(16)]=(0.0); -- 融合载荷：r[(16)]=r[(0.0)]; -- 融合载荷：r[(16)]=__ENV[(0.0)]; -- 融合载荷：r[(16)]=r[(0.0)][(nil)]; -- 融合载荷：r[(16)]=r[(0.0)]
    -- PC 0080 FLAG=0x40 OP_113 [linear-fusion-payloads=3]
    r[(17)]=r[(9)]; -- 融合载荷：r[(17)]=__ENV[(9)]; -- 融合载荷：r[(17)]=r[(9)][(0)]; -- 融合载荷：r[(17)]=r[(9)]
    -- PC 0081 FLAG=0x52 OP_307 [linear-fusion-payloads=2]
    r[(18)]=__ENV[('string')]; -- 融合载荷：r[(18)]=r[('string')][(nil)]; -- 融合载荷：r[(18)]=r[('string')]
    -- PC 0082 FLAG=0xA0 OP_398 [linear-fusion-payloads=1]
    r[(18)]=r[(18)][('len')]; -- 融合载荷：r[(18)]=r[(18)]
    -- PC 0083 FLAG=0xC0 OP_308
    r[(19)]=r[(9)]
    -- PC 0084 FLAG=0x40 OP_392
    do local I,F=E(r[(18)](U(T,(18)+1,(19))));(19)=F+(18)-1;local U=0;for L=(18),(19) do U=U+1;T[L]=I[U] end end
    -- PC 0085 FLAG=0x80 OP_370
    r[(11)](U(T,(11)+1,(0)))
    -- PC 0086 FLAG=0x20 OP_124
    r[(3)]=r[(3)]+(1.0)
    -- PC 0087 FLAG=0xC0 OP_386
    do local I,F=E(r[(4)](r[(4)+1],r[(4)+2]));for U=1,(2) do T[(4)+2+U]=I[U] end;if r[(4)+3]==nil then pc=pc+1 else r[(4)+2]=r[(4)+3] end end
    -- PC 0088 FLAG=0xC2 OP_255 [jump-target=30]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(29)
    -- PC 0089 FLAG=0x80 OP_089 [linear-fusion-payloads=1]
    r[(4)]=up[(0)]; -- 融合载荷：do local I=(0);local F=(0);r[(4)][I]=F end
    -- PC 0090 FLAG=0x70 OP_146
    do local I=('isTaking');local F=(false);r[(4)][I]=F end
    -- PC 0091 FLAG=0xD0 OP_352
    if ((0.0)<r[(3)])~=((0)~=0) then pc=pc+1 end
    -- PC 0092 FLAG=0x42 OP_255 [jump-target=99]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(98)
    -- PC 0093 FLAG=0x00 OP_266 [linear-fusion-payloads=4]
    r[(4)]=up[(1)]; -- 融合载荷：r[(4)]=(1); -- 融合载荷：r[(4)]=r[(1)]; -- 融合载荷：r[(4)]=(1); -- 融合载荷：do local I=r[(0)];for F=(0)-1,(1),-1 do I=T[F]..I end;r[(4)]=I end
    -- PC 0094 FLAG=0xD2 OP_101 [linear-fusion-payloads=2]
    r[(5)]=('取出物品完成, 共取出 '); -- 融合载荷：r[(5)]=r[('取出物品完成, 共取出 ')]; -- 融合载荷：r[(5)]=('取出物品完成, 共取出 ')
    -- PC 0095 FLAG=0x80 OP_293 [linear-fusion-payloads=2]
    r[(6)]=r[(3)]; -- 融合载荷：r[(6)]=(3); -- 融合载荷：do local I=r[(0)];for F=(0)-1,(3),-1 do I=T[F]..I end;r[(6)]=I end
    -- PC 0096 FLAG=0x92 OP_371
    r[(7)]=(' 件')
    -- PC 0097 FLAG=0x80 OP_210
    do local I=r[(7)];for F=(7)-1,(5),-1 do I=T[F]..I end;r[(5)]=I end
    -- PC 0098 FLAG=0x00 OP_358
    r[(4)](U(T,(4)+1,(5)))
    -- PC 0099 FLAG=0x80 OP_100
    return
end
-- 原型入口：proto_InstallDamageHook_root_6

-- ============================================================================
-- 原型 root/7 | 候选名称：GetOwnerIDText | 指令记录：40 | 子原型：1 | 可变参数：0
-- 字节范围：8941:9715
local function proto_GetOwnerIDText_root_7(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'gameMapController'
    -- K[1] = '__ylwHookedOrigin'
    -- K[2] = '已挂接伤害消息钩子（击杀拉黑用）'
    -- K[3] = 'MSG_SC_DAMAGE_HP'
    -- K[4] = 'mNetMsgHandle'
    -- K[5] = 'type'
    -- K[6] = 'global'
    -- K[7] = 'MsgType'
    -- K[8] = 'table'
    -- 指令语义：
    -- PC 0001 FLAG=0x12 OP_397 [linear-fusion-payloads=1]
    r[(0)]=__ENV[('global')]; -- 融合载荷：r[(0)]=r[('global')][(nil)]
    -- PC 0002 FLAG=0xA0 OP_363
    r[(0)]=r[(0)][('gameMapController')]
    -- PC 0003 FLAG=0x00 OP_016
    if (not not r[(0)])~=((0)~=0) then pc=pc+1 end
    -- PC 0004 FLAG=0x02 OP_255 [jump-target=10]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(9)
    -- PC 0005 FLAG=0x12 OP_137
    r[(1)]=__ENV[('type')]
    -- PC 0006 FLAG=0xA0 OP_363
    r[(2)]=r[(0)][('mNetMsgHandle')]
    -- PC 0007 FLAG=0xC0 OP_068
    r[(1)]=r[(1)](U(T,(1)+1,(2)))
    -- PC 0008 FLAG=0x60 OP_045
    if (r[(1)]==('table'))~=((1)~=0) then pc=pc+1 end
    -- PC 0009 FLAG=0x42 OP_140 [jump-target=11]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(10)
    -- PC 0010 FLAG=0x40 OP_001
    return
    -- PC 0011 FLAG=0x52 OP_397 [linear-fusion-payloads=1]
    r[(1)]=__ENV[('global')]; -- 融合载荷：r[(1)]=r[('global')][(nil)]
    -- PC 0012 FLAG=0xA0 OP_375
    r[(1)]=r[(1)][('MsgType')]
    -- PC 0013 FLAG=0xC0 OP_016
    if (not not r[(1)])~=((0)~=0) then pc=pc+1 end
    -- PC 0014 FLAG=0x42 OP_255 [jump-target=18]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(17)
    -- PC 0015 FLAG=0x12 OP_198 [linear-fusion-payloads=2]
    r[(1)]=__ENV[('global')]; -- 融合载荷：r[(1)]=r[('global')][(nil)]; -- 融合载荷：r[(1)]=r[('global')][(nil)]
    -- PC 0016 FLAG=0x60 OP_363
    r[(1)]=r[(1)][('MsgType')]
    -- PC 0017 FLAG=0xA0 OP_053
    r[(1)]=r[(1)][('MSG_SC_DAMAGE_HP')]
    -- PC 0018 FLAG=0xC0 OP_342
    if (not not r[(1)])~=((1)~=0) then pc=pc+1 end
    -- PC 0019 FLAG=0x42 OP_140 [jump-target=21]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(20)
    -- PC 0020 FLAG=0xC0 OP_001
    return
    -- PC 0021 FLAG=0xA0 OP_366 [linear-fusion-payloads=1]
    r[(2)]=r[(0)][('mNetMsgHandle')]; -- 融合载荷：r[(2)]=r[(0)][r[('mNetMsgHandle')]]
    -- PC 0022 FLAG=0xC0 OP_231
    r[(2)]=r[(2)][r[(1)]]
    -- PC 0023 FLAG=0x40 OP_016
    if (not not r[(2)])~=((0)~=0) then pc=pc+1 end
    -- PC 0024 FLAG=0x82 OP_140 [jump-target=28]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(27)
    -- PC 0025 FLAG=0x20 OP_375
    r[(3)]=r[(0)][('__ylwHookedOrigin')]
    -- PC 0026 FLAG=0x00 OP_099
    if (r[(3)]==r[(2)])~=((0)~=0) then pc=pc+1 end
    -- PC 0027 FLAG=0x02 OP_255 [jump-target=29]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(28)
    -- PC 0028 FLAG=0x00 OP_001
    return
    -- PC 0029 FLAG=0x60 OP_032
    r[(3)]=r[(0)][('mNetMsgHandle')]
    -- PC 0030 FLAG=0x40 OP_027 [linear-fusion-payloads=2, closure-child-index=0; captures=2; child-path=root/7/1]
    do local I=O[(0)];local F={};F[-1]=(2);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(2)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(4)]=M(I,U,S) end
    -- PC 0031 FLAG=0x80 OP_325
    r[(0)]=up[(0)]
    -- PC 0032 FLAG=0x80 OP_387
    r[(0)]=r[(2)]
    -- PC 0033 FLAG=0x80 OP_174
    do local I=r[(1)];local F=r[(4)];r[(3)][I]=F end
    -- PC 0034 FLAG=0x20 OP_053
    r[(3)]=r[(0)][('mNetMsgHandle')]
    -- PC 0035 FLAG=0x40 OP_304
    r[(3)]=r[(3)][r[(1)]]
    -- PC 0036 FLAG=0x10 OP_268
    do local I=('__ylwHookedOrigin');local F=r[(3)];r[(0)][I]=F end
    -- PC 0037 FLAG=0x80 OP_134 [linear-fusion-payloads=1]
    r[(3)]=up[(1)]; -- 融合载荷：r[(3)]=(1)
    -- PC 0038 FLAG=0x52 OP_371
    r[(4)]=('已挂接伤害消息钩子（击杀拉黑用）')
    -- PC 0039 FLAG=0xC0 OP_187
    r[(3)](U(T,(3)+1,(4)))
    -- PC 0040 FLAG=0xC0 OP_001
    return
end
-- 原型入口：proto_GetOwnerIDText_root_7

-- ============================================================================
-- 原型 root/7/1 | 候选名称：Prototype_root_7_1 | 指令记录：18 | 子原型：0 | 可变参数：2
-- 字节范围：9491:9714
local function proto_Prototype_root_7_1_root_7_1(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'onDamageMsg'
    -- K[1] = 'pcall'
    -- K[2] = 'type'
    -- K[3] = 'function'
    -- 指令语义：
    -- PC 0001 FLAG=0xD2 OP_095 [linear-fusion-payloads=1]
    r[(2)]=__ENV[('type')]; -- 融合载荷：r[(2)]=up[('type')]
    -- PC 0002 FLAG=0x80 OP_159 [linear-fusion-payloads=1]
    r[(3)]=up[(0)]; -- 融合载荷：r[(3)]=r[(0)][(0)]
    -- PC 0003 FLAG=0x20 OP_032
    r[(3)]=r[(3)][('onDamageMsg')]
    -- PC 0004 FLAG=0x00 OP_098
    r[(2)]=r[(2)](U(T,(2)+1,(3)))
    -- PC 0005 FLAG=0xA0 OP_271
    if (r[(2)]==('function'))~=((0)~=0) then pc=pc+1 end
    -- PC 0006 FLAG=0xC2 OP_255 [jump-target=13]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(12)
    -- PC 0007 FLAG=0x52 OP_137
    r[(2)]=__ENV[('pcall')]
    -- PC 0008 FLAG=0x40 OP_159 [linear-fusion-payloads=1]
    r[(3)]=up[(0)]; -- 融合载荷：r[(3)]=r[(0)][(0)]
    -- PC 0009 FLAG=0x20 OP_032
    r[(3)]=r[(3)][('onDamageMsg')]
    -- PC 0010 FLAG=0xC0 OP_078 [linear-fusion-payloads=1]
    r[(4)]=r[(0)]; -- 融合载荷：r[(4)]=r[(0)]
    -- PC 0011 FLAG=0xC0 OP_308
    r[(5)]=r[(1)]
    -- PC 0012 FLAG=0x00 OP_358
    r[(2)](U(T,(2)+1,(5)))
    -- PC 0013 FLAG=0x00 OP_348 [linear-fusion-payloads=2]
    r[(2)]=up[(1)]; -- 融合载荷：r[(2)]=r[(1)]; -- 融合载荷：r[(2)]=r[(1)]
    -- PC 0014 FLAG=0x80 OP_078 [linear-fusion-payloads=1]
    r[(3)]=r[(0)]; -- 融合载荷：r[(3)]=r[(0)]
    -- PC 0015 FLAG=0x00 OP_184
    r[(4)]=r[(1)]
    -- PC 0016 FLAG=0x40 OP_164
    return r[(2)](U(T,(2)+1,(4)))
    -- PC 0017 FLAG=0xC0 OP_143
    return U(T,(2),(0))
    -- PC 0018 FLAG=0x80 OP_250
    return
end
-- 原型入口：proto_Prototype_root_7_1_root_7_1

-- ============================================================================
-- 原型 root/8 | 候选名称：FormatStateChange | 指令记录：31 | 子原型：0 | 可变参数：2
-- 字节范围：9715:10070
local function proto_FormatStateChange_root_8(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = -1.0
    -- K[1] = 'type'
    -- K[2] = 'string'
    -- K[3] = ''
    -- K[4] = 'GetOwnerID'
    -- K[5] = 'tostring'
    -- K[6] = ['unknown', 2]
    -- 指令语义：
    -- PC 0001 FLAG=0xE0 OP_033
    local I=r[(0)];r[(2)+1]=I;r[(2)]=I[('GetOwnerID')]
    -- PC 0002 FLAG=0x00 OP_098
    r[(2)]=r[(2)](U(T,(2)+1,(3)))
    -- PC 0003 FLAG=0x20 OP_279
    if (r[(2)]==(['unknown', 2]))~=((1)~=0) then pc=pc+1 end
    -- PC 0004 FLAG=0x42 OP_140 [jump-target=9]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(8)
    -- PC 0005 FLAG=0xA0 OP_271
    if (r[(2)]==(''))~=((1)~=0) then pc=pc+1 end
    -- PC 0006 FLAG=0x02 OP_215 [jump-target=9]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(8)
    -- PC 0007 FLAG=0xA0 OP_279
    if (r[(2)]==(-1.0))~=((0)~=0) then pc=pc+1 end
    -- PC 0008 FLAG=0x02 OP_215 [jump-target=12]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(11)
    -- PC 0009 FLAG=0x00 OP_401
    r[(3)]=(0)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0010 FLAG=0xC0 OP_220
    return U(T,(3),(3))
    -- PC 0011 FLAG=0x82 OP_255 [jump-target=31]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(30)
    -- PC 0012 FLAG=0xD2 OP_071 [linear-fusion-payloads=1]
    r[(3)]=__ENV[('type')]; -- 融合载荷：r[(3)]=r[('type')]
    -- PC 0013 FLAG=0xC0 OP_184
    r[(4)]=r[(2)]
    -- PC 0014 FLAG=0xC0 OP_068
    r[(3)]=r[(3)](U(T,(3)+1,(4)))
    -- PC 0015 FLAG=0xA0 OP_045
    if (r[(3)]==('string'))~=((0)~=0) then pc=pc+1 end
    -- PC 0016 FLAG=0x82 OP_255 [jump-target=26]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(25)
    -- PC 0017 FLAG=0x92 OP_071 [linear-fusion-payloads=1]
    r[(3)]=__ENV[('tostring')]; -- 融合载荷：r[(3)]=r[('tostring')]
    -- PC 0018 FLAG=0xC0 OP_184
    r[(4)]=r[(1)]
    -- PC 0019 FLAG=0x80 OP_068
    r[(3)]=r[(3)](U(T,(3)+1,(4)))
    -- PC 0020 FLAG=0x40 OP_294
    if (r[(2)]==r[(3)])~=((1)~=0) then pc=pc+1 end
    -- PC 0021 FLAG=0x02 OP_255 [jump-target=23]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(22)
    -- PC 0022 FLAG=0x40 OP_082
    r[(3)]=(0)~=0;if (1)~=0 then pc=pc+1 end
    -- PC 0023 FLAG=0x00 OP_011
    r[(3)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0024 FLAG=0x40 OP_220
    return U(T,(3),(3))
    -- PC 0025 FLAG=0xC2 OP_140 [jump-target=31]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(30)
    -- PC 0026 FLAG=0x00 OP_381
    if (r[(2)]==r[(1)])~=((1)~=0) then pc=pc+1 end
    -- PC 0027 FLAG=0x42 OP_255 [jump-target=29]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(28)
    -- PC 0028 FLAG=0xC0 OP_082
    r[(3)]=(0)~=0;if (1)~=0 then pc=pc+1 end
    -- PC 0029 FLAG=0x00 OP_338
    r[(3)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0030 FLAG=0x00 OP_220
    return U(T,(3),(3))
    -- PC 0031 FLAG=0xC0 OP_001
    return
end
-- 原型入口：proto_FormatStateChange_root_8

-- ============================================================================
-- 原型 root/9 | 候选名称：ReadNumericConfig | 指令记录：10 | 子原型：0 | 可变参数：1
-- 字节范围：10070:10222
local function proto_ReadNumericConfig_root_9(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'format'
    -- K[1] = '状态切换: %s -> %s'
    -- K[2] = 'string'
    -- 指令语义：
    -- PC 0001 FLAG=0xC0 OP_052 [linear-fusion-payloads=5]
    r[(1)]=up[(0)]; -- 融合载荷：r[(1)]=__ENV[(0)]; -- 融合载荷：r[(1)]=r[(0)][(0)]; -- 融合载荷：r[(1)]=(0); -- 融合载荷：r[(1)]=up[(0)]; -- 融合载荷：r[(1)]=r[(0)]
    -- PC 0002 FLAG=0x12 OP_132 [linear-fusion-payloads=4]
    r[(2)]=__ENV[('string')]; -- 融合载荷：r[(2)]=r[('string')][(nil)]; -- 融合载荷：r[(2)]=('string'); -- 融合载荷：r[(2)]=up[('string')]; -- 融合载荷：r[(2)]=r[('string')]
    -- PC 0003 FLAG=0xE0 OP_363
    r[(2)]=r[(2)][('format')]
    -- PC 0004 FLAG=0x92 OP_080 [linear-fusion-payloads=2]
    r[(3)]=('状态切换: %s -> %s'); -- 融合载荷：r[(3)]=up[('状态切换: %s -> %s')]; -- 融合载荷：r[(3)]=r[('状态切换: %s -> %s')]
    -- PC 0005 FLAG=0xC0 OP_131 [linear-fusion-payloads=1]
    r[(4)]=up[(1)]; -- 融合载荷：r[(4)]=r[(1)]
    -- PC 0006 FLAG=0x40 OP_308
    r[(5)]=r[(0)]
    -- PC 0007 FLAG=0x00 OP_252
    do local I,F=E(r[(2)](U(T,(2)+1,(5))));(5)=F+(2)-1;local U=0;for L=(2),(5) do U=U+1;T[L]=I[U] end end
    -- PC 0008 FLAG=0x80 OP_093
    r[(1)](U(T,(1)+1,(0)))
    -- PC 0009 FLAG=0xC0 OP_114
    up[(1)]=r[(0)]
    -- PC 0010 FLAG=0xC0 OP_001
    return
end
-- 原型入口：proto_ReadNumericConfig_root_9

-- ============================================================================
-- 原型 root/10 | 候选名称：SetButtonVisibilityState | 指令记录：45 | 子原型：0 | 可变参数：1
-- 字节范围：10222:10789
local function proto_SetButtonVisibilityState_root_10(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = '%s'
    -- K[1] = 'string'
    -- K[2] = 'gsub'
    -- K[3] = 'tonumber'
    -- K[4] = ''
    -- K[5] = 'getStringFromFile'
    -- K[6] = 'match'
    -- K[7] = '^%d+$'
    -- K[8] = 'getInstance'
    -- K[9] = 'isFileExist'
    -- K[10] = 'type'
    -- K[11] = 'cc'
    -- K[12] = 'FileUtils'
    -- 指令语义：
    -- PC 0001 FLAG=0x52 OP_309 [linear-fusion-payloads=2]
    r[(1)]=__ENV[('cc')]; -- 融合载荷：r[(1)]=r[('cc')][(nil)]; -- 融合载荷：local I=r[('cc')];r[(1)+1]=I;r[(1)]=I[(nil)]
    -- PC 0002 FLAG=0x60 OP_375
    r[(1)]=r[(1)][('FileUtils')]
    -- PC 0003 FLAG=0x20 OP_033
    local I=r[(1)];r[(1)+1]=I;r[(1)]=I[('getInstance')]
    -- PC 0004 FLAG=0xC0 OP_098
    r[(1)]=r[(1)](U(T,(1)+1,(2)))
    -- PC 0005 FLAG=0x80 OP_131 [linear-fusion-payloads=1]
    r[(2)]=up[(0)]; -- 融合载荷：r[(2)]=r[(0)]
    -- PC 0006 FLAG=0x00 OP_184
    r[(3)]=r[(0)]
    -- PC 0007 FLAG=0x40 OP_068
    r[(2)]=r[(2)](U(T,(2)+1,(3)))
    -- PC 0008 FLAG=0x60 OP_142 [linear-fusion-payloads=1]
    local I=r[(1)];r[(3)+1]=I;r[(3)]=I[('isFileExist')]; -- 融合载荷：r[(3)]=r[(1)]
    -- PC 0009 FLAG=0xC0 OP_308
    r[(5)]=r[(2)]
    -- PC 0010 FLAG=0x40 OP_068
    r[(3)]=r[(3)](U(T,(3)+1,(5)))
    -- PC 0011 FLAG=0x00 OP_342
    if (not not r[(3)])~=((1)~=0) then pc=pc+1 end
    -- PC 0012 FLAG=0xC2 OP_215 [jump-target=15]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(14)
    -- PC 0013 FLAG=0xC0 OP_248
    for I=(3),(3) do T[I]=nil end
    -- PC 0014 FLAG=0x00 OP_220
    return U(T,(3),(3))
    -- PC 0015 FLAG=0x20 OP_142 [linear-fusion-payloads=1]
    local I=r[(1)];r[(3)+1]=I;r[(3)]=I[('getStringFromFile')]; -- 融合载荷：r[(3)]=r[(1)]
    -- PC 0016 FLAG=0x00 OP_184
    r[(5)]=r[(2)]
    -- PC 0017 FLAG=0x40 OP_068
    r[(3)]=r[(3)](U(T,(3)+1,(5)))
    -- PC 0018 FLAG=0xD2 OP_071 [linear-fusion-payloads=1]
    r[(4)]=__ENV[('type')]; -- 融合载荷：r[(4)]=r[('type')]
    -- PC 0019 FLAG=0x80 OP_308
    r[(5)]=r[(3)]
    -- PC 0020 FLAG=0x80 OP_098
    r[(4)]=r[(4)](U(T,(4)+1,(5)))
    -- PC 0021 FLAG=0xA0 OP_279
    if (r[(4)]==('string'))~=((1)~=0) then pc=pc+1 end
    -- PC 0022 FLAG=0x42 OP_140 [jump-target=25]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(24)
    -- PC 0023 FLAG=0x00 OP_248
    for I=(4),(4) do T[I]=nil end
    -- PC 0024 FLAG=0x80 OP_220
    return U(T,(4),(4))
    -- PC 0025 FLAG=0x92 OP_307 [linear-fusion-payloads=2]
    r[(4)]=__ENV[('string')]; -- 融合载荷：r[(4)]=r[('string')][(nil)]; -- 融合载荷：r[(4)]=r[('string')]
    -- PC 0026 FLAG=0xE0 OP_383 [linear-fusion-payloads=3]
    r[(4)]=r[(4)][('gsub')]; -- 融合载荷：r[(4)]=r[(4)]; -- 融合载荷：r[(4)]=(4); -- 融合载荷：r[(4)]=(4)
    -- PC 0027 FLAG=0x80 OP_308
    r[(5)]=r[(3)]
    -- PC 0028 FLAG=0x12 OP_371
    r[(6)]=('%s')
    -- PC 0029 FLAG=0x92 OP_371
    r[(7)]=('')
    -- PC 0030 FLAG=0x40 OP_098
    r[(4)]=r[(4)](U(T,(4)+1,(7)))
    -- PC 0031 FLAG=0xC0 OP_113 [linear-fusion-payloads=3]
    r[(3)]=r[(4)]; -- 融合载荷：r[(3)]=__ENV[(4)]; -- 融合载荷：r[(3)]=r[(4)][(0)]; -- 融合载荷：r[(3)]=r[(4)]
    -- PC 0032 FLAG=0x52 OP_307 [linear-fusion-payloads=2]
    r[(4)]=__ENV[('string')]; -- 融合载荷：r[(4)]=r[('string')][(nil)]; -- 融合载荷：r[(4)]=r[('string')]
    -- PC 0033 FLAG=0xE0 OP_176 [linear-fusion-payloads=2]
    r[(4)]=r[(4)][('match')]; -- 融合载荷：r[(4)]=r[(4)]; -- 融合载荷：r[(4)]=(4)
    -- PC 0034 FLAG=0xC0 OP_288 [linear-fusion-payloads=1]
    r[(5)]=r[(3)]; -- 融合载荷：r[(5)]=(3)
    -- PC 0035 FLAG=0x92 OP_371
    r[(6)]=('^%d+$')
    -- PC 0036 FLAG=0x40 OP_068
    r[(4)]=r[(4)](U(T,(4)+1,(6)))
    -- PC 0037 FLAG=0x80 OP_342
    if (not not r[(4)])~=((1)~=0) then pc=pc+1 end
    -- PC 0038 FLAG=0x42 OP_140 [jump-target=41]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(40)
    -- PC 0039 FLAG=0xC0 OP_125
    for I=(4),(4) do T[I]=nil end
    -- PC 0040 FLAG=0x80 OP_220
    return U(T,(4),(4))
    -- PC 0041 FLAG=0x92 OP_071 [linear-fusion-payloads=1]
    r[(4)]=__ENV[('tonumber')]; -- 融合载荷：r[(4)]=r[('tonumber')]
    -- PC 0042 FLAG=0x40 OP_308
    r[(5)]=r[(3)]
    -- PC 0043 FLAG=0x00 OP_149
    return r[(4)](U(T,(4)+1,(5)))
    -- PC 0044 FLAG=0x80 OP_143
    return U(T,(4),(0))
    -- PC 0045 FLAG=0x40 OP_250
    return
end
-- 原型入口：proto_SetButtonVisibilityState_root_10

-- ============================================================================
-- 原型 root/11 | 候选名称：DistanceCalculation | 指令记录：15 | 子原型：0 | 可变参数：0
-- 字节范围：10789:10985
local function proto_DistanceCalculation_root_11(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'isHidden'
    -- K[1] = 'setVisible'
    -- K[2] = 'pairs'
    -- K[3] = 'GUI'
    -- K[4] = True
    -- 指令语义：
    -- PC 0001 FLAG=0x40 OP_315 [linear-fusion-payloads=2]
    r[(0)]=up[(0)]; -- 融合载荷：do local I=(0);local F=(0);r[(0)][I]=F end; -- 融合载荷：r[(0)]=__ENV[(0)]
    -- PC 0002 FLAG=0x30 OP_146
    do local I=('isHidden');local F=(true);r[(0)][I]=F end
    -- PC 0003 FLAG=0x92 OP_095 [linear-fusion-payloads=1]
    r[(0)]=__ENV[('pairs')]; -- 融合载荷：r[(0)]=up[('pairs')]
    -- PC 0004 FLAG=0x00 OP_130
    r[(1)]=up[(1)]
    -- PC 0005 FLAG=0xC0 OP_183
    do local I={ r[(0)](U(T,(0)+1,(1))) };local F=0;for U=(0),(2) do F=F+1;T[U]=I[F] end end
    -- PC 0006 FLAG=0xC2 OP_255 [jump-target=13]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(12)
    -- PC 0007 FLAG=0xD2 OP_335 [linear-fusion-payloads=1]
    r[(5)]=__ENV[('GUI')]; -- 融合载荷：local I=r[('GUI')];r[(5)+1]=I;r[(5)]=I[(nil)]
    -- PC 0008 FLAG=0xA0 OP_033
    local I=r[(5)];r[(5)+1]=I;r[(5)]=I[('setVisible')]
    -- PC 0009 FLAG=0xC0 OP_028 [linear-fusion-payloads=1]
    r[(7)]=up[(1)]; -- 融合载荷：r[(7)]=r[(1)][r[(0)]]
    -- PC 0010 FLAG=0x00 OP_231
    r[(7)]=r[(7)][r[(3)]]
    -- PC 0011 FLAG=0x00 OP_401
    r[(8)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0012 FLAG=0x40 OP_187
    r[(5)](U(T,(5)+1,(8)))
    -- PC 0013 FLAG=0x40 OP_117
    do local I,F=E(r[(0)](r[(0)+1],r[(0)+2]));for U=1,(2) do T[(0)+2+U]=I[U] end;if r[(0)+3]==nil then pc=pc+1 else r[(0)+2]=r[(0)+3] end end
    -- PC 0014 FLAG=0x82 OP_215 [jump-target=7]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(6)
    -- PC 0015 FLAG=0xC0 OP_250
    return
end
-- 原型入口：proto_DistanceCalculation_root_11

-- ============================================================================
-- 原型 root/12 | 候选名称：LuaSendMsg | 指令记录：25 | 子原型：0 | 可变参数：2
-- 字节范围：10985:11269
local function proto_LuaSendMsg_root_12(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'x'
    -- K[1] = 'abs'
    -- K[2] = 'y'
    -- K[3] = 'max'
    -- K[4] = 'math'
    -- K[5] = 99999.0
    -- 指令语义：
    -- PC 0001 FLAG=0xC0 OP_016
    if (not not r[(0)])~=((0)~=0) then pc=pc+1 end
    -- PC 0002 FLAG=0x02 OP_140 [jump-target=5]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(4)
    -- PC 0003 FLAG=0x40 OP_342
    if (not not r[(1)])~=((1)~=0) then pc=pc+1 end
    -- PC 0004 FLAG=0x42 OP_140 [jump-target=7]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(6)
    -- PC 0005 FLAG=0xD2 OP_371
    r[(2)]=(99999.0)
    -- PC 0006 FLAG=0x80 OP_220
    return U(T,(2),(2))
    -- PC 0007 FLAG=0x92 OP_251 [linear-fusion-payloads=4]
    r[(2)]=__ENV[('math')]; -- 融合载荷：r[(2)]=r[('math')][(nil)]; -- 融合载荷：r[(2)]=r[('math')][(nil)]; -- 融合载荷：r[(2)]=r[('math')][(nil)]; -- 融合载荷：r[(2)]=r[('math')]-r[(nil)]
    -- PC 0008 FLAG=0x60 OP_063 [linear-fusion-payloads=3]
    r[(2)]=r[(2)][('abs')]; -- 融合载荷：r[(2)]=r[(2)][('abs')]; -- 融合载荷：r[(2)]=r[(2)][('abs')]; -- 融合载荷：r[(2)]=r[(2)]-r[('abs')]
    -- PC 0009 FLAG=0xE0 OP_053
    r[(3)]=r[(0)][('x')]
    -- PC 0010 FLAG=0xE0 OP_384 [linear-fusion-payloads=1]
    r[(4)]=r[(1)][('x')]; -- 融合载荷：r[(4)]=r[(1)]-r[('x')]
    -- PC 0011 FLAG=0x40 OP_340
    r[(3)]=r[(3)]-r[(4)]
    -- PC 0012 FLAG=0x00 OP_098
    r[(2)]=r[(2)](U(T,(2)+1,(3)))
    -- PC 0013 FLAG=0x12 OP_251 [linear-fusion-payloads=4]
    r[(3)]=__ENV[('math')]; -- 融合载荷：r[(3)]=r[('math')][(nil)]; -- 融合载荷：r[(3)]=r[('math')][(nil)]; -- 融合载荷：r[(3)]=r[('math')][(nil)]; -- 融合载荷：r[(3)]=r[('math')]-r[(nil)]
    -- PC 0014 FLAG=0xE0 OP_049 [linear-fusion-payloads=1]
    r[(3)]=r[(3)][('abs')]; -- 融合载荷：r[(3)]=r[(3)][('abs')]
    -- PC 0015 FLAG=0xA0 OP_228 [linear-fusion-payloads=2]
    r[(4)]=r[(0)][('y')]; -- 融合载荷：r[(4)]=r[(0)][('y')]; -- 融合载荷：r[(4)]=r[(0)]-r[('y')]
    -- PC 0016 FLAG=0xE0 OP_384 [linear-fusion-payloads=1]
    r[(5)]=r[(1)][('y')]; -- 融合载荷：r[(5)]=r[(1)]-r[('y')]
    -- PC 0017 FLAG=0x00 OP_340
    r[(4)]=r[(4)]-r[(5)]
    -- PC 0018 FLAG=0xC0 OP_098
    r[(3)]=r[(3)](U(T,(3)+1,(4)))
    -- PC 0019 FLAG=0x52 OP_137
    r[(4)]=__ENV[('math')]
    -- PC 0020 FLAG=0x60 OP_269 [linear-fusion-payloads=2]
    r[(4)]=r[(4)][('max')]; -- 融合载荷：r[(4)]=r[(4)]; -- 融合载荷：r[(4)]=r[(4)]
    -- PC 0021 FLAG=0xC0 OP_184
    r[(5)]=r[(2)]
    -- PC 0022 FLAG=0x80 OP_184
    r[(6)]=r[(3)]
    -- PC 0023 FLAG=0x80 OP_405
    return r[(4)](U(T,(4)+1,(6)))
    -- PC 0024 FLAG=0x40 OP_143
    return U(T,(4),(0))
    -- PC 0025 FLAG=0x40 OP_055
    return
end
-- 原型入口：proto_LuaSendMsg_root_12

-- ============================================================================
-- 原型 root/13 | 候选名称：GetMapId | 指令记录：92 | 子原型：0 | 可变参数：0
-- 字节范围：11269:12464
local function proto_GetMapId_root_13(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 2.0
    -- K[1] = ')'
    -- K[2] = 'string'
    -- K[3] = ', '
    -- K[4] = 'param4'
    -- K[5] = 'networkCtl'
    -- K[6] = 'tonumber'
    -- K[7] = 'recog'
    -- K[8] = 'Blocklist'
    -- K[9] = 'ipairs'
    -- K[10] = 'table'
    -- K[11] = 'concat'
    -- K[12] = 0.0
    -- K[13] = True
    -- K[14] = 'SendHookList'
    -- K[15] = 'type'
    -- K[16] = 'param1'
    -- K[17] = 5.0
    -- K[18] = 'tostring'
    -- K[19] = 'global'
    -- K[20] = 'find'
    -- K[21] = 3.0
    -- K[22] = 'SendMsg'
    -- K[23] = 'LuaSendMsg('
    -- K[24] = 6.0
    -- K[25] = 1.0
    -- K[26] = 'param3'
    -- K[27] = 'insert'
    -- K[28] = 'msgId'
    -- K[29] = 'function'
    -- K[30] = 'pcall'
    -- K[31] = 4.0
    -- K[32] = "'"
    -- K[33] = 'param2'
    -- 指令语义：
    -- PC 0001 FLAG=0x00 OP_410
    r[(1)]={}
    -- PC 0002 FLAG=0x00 OP_006
    (0)=(2)+(2)-1;for I=(2),(0) do T[I]=X[I-(2)] end
    -- PC 0003 FLAG=0x40 OP_402
    do local I=(0);if I==0 then I=math.max(0,(0)-(1)) end;local F=r[(1)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(1)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(1)]=O else for O=1,I do F[L+O]=T[(1)+O] end end;end
    -- PC 0004 FLAG=0xA0 OP_363
    r[(2)]=r[(1)][(6.0)]
    -- PC 0005 FLAG=0x60 OP_375
    r[(3)]=r[(1)][(1.0)]
    -- PC 0006 FLAG=0x40 OP_105
    r[(4)]={}
    -- PC 0007 FLAG=0xF0 OP_229 [linear-fusion-payloads=3]
    do local I=('recog');local F=(0.0);r[(4)][I]=F end; -- 融合载荷：r[(4)]=r[('recog')][(0.0)]; -- 融合载荷：do local I=('recog');local F=r[(0.0)];r[(4)][I]=F end; -- 融合载荷：r[(4)]=r[('recog')][(0.0)]
    -- PC 0008 FLAG=0xA0 OP_302 [linear-fusion-payloads=5]
    r[(5)]=r[(1)][(1.0)]; -- 融合载荷：do local I=(1);local F=r[(1.0)];r[(5)][I]=F end; -- 融合载荷：r[(5)]=r[(1)][(1.0)]; -- 融合载荷：do local I=(1);local F=r[(1.0)];r[(5)][I]=F end; -- 融合载荷：r[(5)]=r[(1)][(1.0)]; -- 融合载荷：do local I=(1);local F=r[(1.0)];r[(5)][I]=F end
    -- PC 0009 FLAG=0x10 OP_268
    do local I=('msgId');local F=r[(5)];r[(4)][I]=F end
    -- PC 0010 FLAG=0x20 OP_377 [linear-fusion-payloads=8]
    r[(5)]=r[(1)][(2.0)]; -- 融合载荷：do local I=(1);local F=r[(2.0)];r[(5)][I]=F end; -- 融合载荷：r[(5)]=r[(1)][(2.0)]; -- 融合载荷：do local I=(1);local F=r[(2.0)];r[(5)][I]=F end; -- 融合载荷：r[(5)]=r[(1)][(2.0)]; -- 融合载荷：do local I=(1);local F=r[(2.0)];r[(5)][I]=F end; -- 融合载荷：r[(5)]=r[(1)][(2.0)]; -- 融合载荷：do local I=(1);local F=r[(2.0)];r[(5)][I]=F end; -- 融合载荷：r[(5)]=__ENV[(1)]
    -- PC 0011 FLAG=0x50 OP_326 [linear-fusion-payloads=2]
    do local I=('param1');local F=r[(5)];r[(4)][I]=F end; -- 融合载荷：r[(4)]=r[('param1')][(5)]; -- 融合载荷：do local I=('param1');local F=r[(5)];r[(4)][I]=F end
    -- PC 0012 FLAG=0xA0 OP_053
    r[(5)]=r[(1)][(3.0)]
    -- PC 0013 FLAG=0x10 OP_268
    do local I=('param2');local F=r[(5)];r[(4)][I]=F end
    -- PC 0014 FLAG=0x60 OP_036 [linear-fusion-payloads=4]
    r[(5)]=r[(1)][(4.0)]; -- 融合载荷：do local I=(1);local F=r[(4.0)];r[(5)][I]=F end; -- 融合载荷：r[(5)]=r[(1)][(4.0)]; -- 融合载荷：do local I=(1);local F=r[(4.0)];r[(5)][I]=F end; -- 融合载荷：r[(5)]=__ENV[(1)]
    -- PC 0015 FLAG=0x90 OP_355
    do local I=('param3');local F=r[(5)];r[(4)][I]=F end
    -- PC 0016 FLAG=0x60 OP_161 [linear-fusion-payloads=2]
    r[(5)]=r[(1)][(5.0)]; -- 融合载荷：do local I=(1);local F=r[(5.0)];r[(5)][I]=F end; -- 融合载荷：r[(5)]=__ENV[(1)]
    -- PC 0017 FLAG=0xD0 OP_291 [linear-fusion-payloads=3]
    do local I=('param4');local F=r[(5)];r[(4)][I]=F end; -- 融合载荷：r[(4)]=__ENV[('param4')]; -- 融合载荷：r[(4)]=r[('param4')][(5)]; -- 融合载荷：r[(4)]=up[('param4')]
    -- PC 0018 FLAG=0x12 OP_284 [linear-fusion-payloads=5]
    r[(5)]=__ENV[('table')]; -- 融合载荷：r[(5)]=r[('table')][(nil)]; -- 融合载荷：r[(5)]=up[('table')]; -- 融合载荷：r[(5)]=r[('table')][(nil)]; -- 融合载荷：r[(5)]=__ENV[('table')]; -- 融合载荷：r[(5)]=r[('table')]
    -- PC 0019 FLAG=0x20 OP_227 [linear-fusion-payloads=4]
    r[(5)]=r[(5)][('find')]; -- 融合载荷：r[(5)]=up[(5)]; -- 融合载荷：r[(5)]=r[(5)][('find')]; -- 融合载荷：r[(5)]=__ENV[(5)]; -- 融合载荷：r[(5)]=r[(5)]
    -- PC 0020 FLAG=0x40 OP_209 [linear-fusion-payloads=2]
    r[(6)]=up[(0)]; -- 融合载荷：r[(6)]=r[(0)][(0)]; -- 融合载荷：r[(6)]=__ENV[(0)]
    -- PC 0021 FLAG=0x20 OP_181 [linear-fusion-payloads=2]
    r[(6)]=r[(6)][('Blocklist')]; -- 融合载荷：r[(6)]=__ENV[(6)]; -- 融合载荷：r[(6)]=r[(6)]
    -- PC 0022 FLAG=0xD2 OP_071 [linear-fusion-payloads=1]
    r[(7)]=__ENV[('tonumber')]; -- 融合载荷：r[(7)]=r[('tonumber')]
    -- PC 0023 FLAG=0x00 OP_308
    r[(8)]=r[(3)]
    -- PC 0024 FLAG=0xC0 OP_392
    do local I,F=E(r[(7)](U(T,(7)+1,(8))));(8)=F+(7)-1;local U=0;for L=(7),(8) do U=U+1;T[L]=I[U] end end
    -- PC 0025 FLAG=0x80 OP_242
    r[(5)]=r[(5)](U(T,(5)+1,(0)))
    -- PC 0026 FLAG=0x40 OP_342
    if (not not r[(5)])~=((1)~=0) then pc=pc+1 end
    -- PC 0027 FLAG=0xC2 OP_255 [jump-target=63]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(62)
    -- PC 0028 FLAG=0x80 OP_230 [linear-fusion-payloads=2]
    r[(5)]={}; -- 融合载荷：r[(5)]=__ENV[(0)]; -- 融合载荷：r[(5)]=r[(0)]
    -- PC 0029 FLAG=0x12 OP_071 [linear-fusion-payloads=1]
    r[(6)]=__ENV[('ipairs')]; -- 融合载荷：r[(6)]=r[('ipairs')]
    -- PC 0030 FLAG=0x00 OP_308
    r[(7)]=r[(1)]
    -- PC 0031 FLAG=0xC0 OP_233
    do local I={ r[(6)](U(T,(6)+1,(7))) };local F=0;for U=(6),(8) do F=F+1;T[U]=I[F] end end
    -- PC 0032 FLAG=0x42 OP_255 [jump-target=51]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(50)
    -- PC 0033 FLAG=0x52 OP_137
    r[(11)]=__ENV[('table')]
    -- PC 0034 FLAG=0xA0 OP_200 [linear-fusion-payloads=3]
    r[(11)]=r[(11)][('insert')]; -- 融合载荷：r[(11)]=r[(11)]; -- 融合载荷：r[(11)]=__ENV[(11)]; -- 融合载荷：r[(11)]=r[(11)]
    -- PC 0035 FLAG=0x40 OP_044 [linear-fusion-payloads=2]
    r[(12)]=r[(5)]; -- 融合载荷：r[(12)]=__ENV[(5)]; -- 融合载荷：r[(12)]=r[(5)]
    -- PC 0036 FLAG=0xD2 OP_071 [linear-fusion-payloads=1]
    r[(13)]=__ENV[('type')]; -- 融合载荷：r[(13)]=r[('type')]
    -- PC 0037 FLAG=0xC0 OP_308
    r[(14)]=r[(10)]
    -- PC 0038 FLAG=0xC0 OP_098
    r[(13)]=r[(13)](U(T,(13)+1,(14)))
    -- PC 0039 FLAG=0x60 OP_045
    if (r[(13)]==('string'))~=((0)~=0) then pc=pc+1 end
    -- PC 0040 FLAG=0xC2 OP_140 [jump-target=47]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(46)
    -- PC 0041 FLAG=0x52 OP_317 [linear-fusion-payloads=3]
    r[(13)]=("'"); -- 融合载荷：r[(13)]=r[("'")]; -- 融合载荷：r[(13)]=("'"); -- 融合载荷：do local I=r[(nil)];for F=(nil)-1,("'"),-1 do I=T[F]..I end;r[(13)]=I end
    -- PC 0042 FLAG=0xC0 OP_293 [linear-fusion-payloads=2]
    r[(14)]=r[(10)]; -- 融合载荷：r[(14)]=(10); -- 融合载荷：do local I=r[(0)];for F=(0)-1,(10),-1 do I=T[F]..I end;r[(14)]=I end
    -- PC 0043 FLAG=0x12 OP_346
    r[(15)]=("'")
    -- PC 0044 FLAG=0x80 OP_210
    do local I=r[(15)];for F=(15)-1,(13),-1 do I=T[F]..I end;r[(13)]=I end
    -- PC 0045 FLAG=0x00 OP_342
    if (not not r[(13)])~=((1)~=0) then pc=pc+1 end
    -- PC 0046 FLAG=0xC2 OP_255 [jump-target=50]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(49)
    -- PC 0047 FLAG=0x12 OP_071 [linear-fusion-payloads=1]
    r[(13)]=__ENV[('tostring')]; -- 融合载荷：r[(13)]=r[('tostring')]
    -- PC 0048 FLAG=0x40 OP_308
    r[(14)]=r[(10)]
    -- PC 0049 FLAG=0xC0 OP_068
    r[(13)]=r[(13)](U(T,(13)+1,(14)))
    -- PC 0050 FLAG=0x80 OP_187
    r[(11)](U(T,(11)+1,(13)))
    -- PC 0051 FLAG=0xC0 OP_386
    do local I,F=E(r[(6)](r[(6)+1],r[(6)+2]));for U=1,(2) do T[(6)+2+U]=I[U] end;if r[(6)+3]==nil then pc=pc+1 else r[(6)+2]=r[(6)+3] end end
    -- PC 0052 FLAG=0x02 OP_255 [jump-target=33]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(32)
    -- PC 0053 FLAG=0x00 OP_134 [linear-fusion-payloads=1]
    r[(6)]=up[(1)]; -- 融合载荷：r[(6)]=(1)
    -- PC 0054 FLAG=0x12 OP_102 [linear-fusion-payloads=4]
    r[(7)]=('LuaSendMsg('); -- 融合载荷：r[(7)]=__ENV[('LuaSendMsg(')]; -- 融合载荷：r[(7)]=r[('LuaSendMsg(')][(nil)]; -- 融合载荷：r[(7)]=r[('LuaSendMsg(')]; -- 融合载荷：r[(7)]=('LuaSendMsg(')
    -- PC 0055 FLAG=0x12 OP_137
    r[(8)]=__ENV[('table')]
    -- PC 0056 FLAG=0x20 OP_176 [linear-fusion-payloads=2]
    r[(8)]=r[(8)][('concat')]; -- 融合载荷：r[(8)]=r[(8)]; -- 融合载荷：r[(8)]=(8)
    -- PC 0057 FLAG=0xC0 OP_288 [linear-fusion-payloads=1]
    r[(9)]=r[(5)]; -- 融合载荷：r[(9)]=(5)
    -- PC 0058 FLAG=0x52 OP_371
    r[(10)]=(', ')
    -- PC 0059 FLAG=0x40 OP_098
    r[(8)]=r[(8)](U(T,(8)+1,(10)))
    -- PC 0060 FLAG=0x92 OP_047 [linear-fusion-payloads=1]
    r[(9)]=(')'); -- 融合载荷：do local I=r[(nil)];for F=(nil)-1,(')'),-1 do I=T[F]..I end;r[(9)]=I end
    -- PC 0061 FLAG=0x00 OP_210
    do local I=r[(9)];for F=(9)-1,(7),-1 do I=T[F]..I end;r[(7)]=I end
    -- PC 0062 FLAG=0x40 OP_187
    r[(6)](U(T,(6)+1,(7)))
    -- PC 0063 FLAG=0x40 OP_130
    r[(5)]=up[(0)]
    -- PC 0064 FLAG=0xA0 OP_366 [linear-fusion-payloads=1]
    r[(5)]=r[(5)][('SendHookList')]; -- 融合载荷：r[(5)]=r[(5)][r[('SendHookList')]]
    -- PC 0065 FLAG=0xC0 OP_231
    r[(5)]=r[(5)][r[(3)]]
    -- PC 0066 FLAG=0xC0 OP_016
    if (not not r[(5)])~=((0)~=0) then pc=pc+1 end
    -- PC 0067 FLAG=0x42 OP_255 [jump-target=87]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(86)
    -- PC 0068 FLAG=0x40 OP_158 [linear-fusion-payloads=4]
    r[(5)]=up[(0)]; -- 融合载荷：r[(5)]=r[(0)][(0)]; -- 融合载荷：r[(5)]=r[(0)][r[(0)]]; -- 融合载荷：r[(5)]=__ENV[(0)]; -- 融合载荷：r[(5)]=r[(0)]
    -- PC 0069 FLAG=0xA0 OP_020 [linear-fusion-payloads=3]
    r[(5)]=r[(5)][('SendHookList')]; -- 融合载荷：r[(5)]=r[(5)][r[('SendHookList')]]; -- 融合载荷：r[(5)]=__ENV[(5)]; -- 融合载荷：r[(5)]=r[(5)]
    -- PC 0070 FLAG=0xC0 OP_007 [linear-fusion-payloads=2]
    r[(5)]=r[(5)][r[(3)]]; -- 融合载荷：r[(5)]=__ENV[(5)]; -- 融合载荷：r[(5)]=r[(5)]
    -- PC 0071 FLAG=0x12 OP_137
    r[(6)]=__ENV[('type')]
    -- PC 0072 FLAG=0x00 OP_308
    r[(7)]=r[(5)]
    -- PC 0073 FLAG=0x80 OP_098
    r[(6)]=r[(6)](U(T,(6)+1,(7)))
    -- PC 0074 FLAG=0xA0 OP_092
    if (r[(6)]==('function'))~=((0)~=0) then pc=pc+1 end
    -- PC 0075 FLAG=0xC2 OP_215 [jump-target=87]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(86)
    -- PC 0076 FLAG=0x12 OP_303 [linear-fusion-payloads=4]
    r[(6)]=__ENV[('pcall')]; -- 融合载荷：r[(6)]=r[('pcall')]; -- 融合载荷：r[(6)]=r[('pcall')]; -- 融合载荷：r[(6)]=r[('pcall')]; -- 融合载荷：r[(6)]=r[('pcall')]
    -- PC 0077 FLAG=0x40 OP_372 [linear-fusion-payloads=3]
    r[(7)]=r[(5)]; -- 融合载荷：r[(7)]=r[(5)]; -- 融合载荷：r[(7)]=r[(5)]; -- 融合载荷：r[(7)]=r[(5)]
    -- PC 0078 FLAG=0x00 OP_385 [linear-fusion-payloads=2]
    r[(8)]=r[(3)]; -- 融合载荷：r[(8)]=r[(3)]; -- 融合载荷：r[(8)]=r[(3)]
    -- PC 0079 FLAG=0x00 OP_078 [linear-fusion-payloads=1]
    r[(9)]=r[(2)]; -- 融合载荷：r[(9)]=r[(2)]
    -- PC 0080 FLAG=0x80 OP_184
    r[(10)]=r[(4)]
    -- PC 0081 FLAG=0x80 OP_233
    do local I={ r[(6)](U(T,(6)+1,(10))) };local F=0;for U=(6),(7) do F=F+1;T[U]=I[F] end end
    -- PC 0082 FLAG=0x00 OP_342
    if (not not r[(6)])~=((1)~=0) then pc=pc+1 end
    -- PC 0083 FLAG=0xC2 OP_140 [jump-target=84]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(83)
    -- PC 0084 FLAG=0x20 OP_045
    if (r[(7)]==(true))~=((0)~=0) then pc=pc+1 end
    -- PC 0085 FLAG=0x42 OP_140 [jump-target=87]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(86)
    -- PC 0086 FLAG=0x80 OP_055
    return
    -- PC 0087 FLAG=0x12 OP_137
    r[(5)]=__ENV[('global')]
    -- PC 0088 FLAG=0x20 OP_270 [linear-fusion-payloads=1]
    r[(5)]=r[(5)][('networkCtl')]; -- 融合载荷：local I=r[(5)];r[(5)+1]=I;r[(5)]=I[('networkCtl')]
    -- PC 0089 FLAG=0x20 OP_238
    local I=r[(5)];r[(5)+1]=I;r[(5)]=I[('SendMsg')]
    -- PC 0090 FLAG=0x80 OP_012
    (0)=(7)+(7)-1;for I=(7),(0) do T[I]=X[I-(7)] end
    -- PC 0091 FLAG=0x80 OP_370
    r[(5)](U(T,(5)+1,(0)))
    -- PC 0092 FLAG=0x80 OP_001
    return
end
-- 原型入口：proto_GetMapId_root_13

-- ============================================================================
-- 原型 root/14 | 候选名称：FindMonsterInCurrViewField | 指令记录：9 | 子原型：0 | 可变参数：0
-- 字节范围：12464:12602
local function proto_FindMonsterInCurrViewField_root_14(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'SL'
    -- K[1] = 'MAP_ID'
    -- K[2] = 0.0
    -- K[3] = 'GetMetaValue'
    -- 指令语义：
    -- PC 0001 FLAG=0xD2 OP_137
    r[(0)]=__ENV[('SL')]
    -- PC 0002 FLAG=0x20 OP_121
    local I=r[(0)];r[(0)+1]=I;r[(0)]=I[('GetMetaValue')]
    -- PC 0003 FLAG=0x12 OP_371
    r[(2)]=('MAP_ID')
    -- PC 0004 FLAG=0x80 OP_068
    r[(0)]=r[(0)](U(T,(0)+1,(2)))
    -- PC 0005 FLAG=0xC0 OP_342
    if (not not r[(0)])~=((1)~=0) then pc=pc+1 end
    -- PC 0006 FLAG=0xC2 OP_255 [jump-target=8]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(7)
    -- PC 0007 FLAG=0x92 OP_371
    r[(0)]=(0.0)
    -- PC 0008 FLAG=0x40 OP_220
    return U(T,(0),(0))
    -- PC 0009 FLAG=0x80 OP_100
    return
end
-- 原型入口：proto_FindMonsterInCurrViewField_root_14

-- ============================================================================
-- 原型 root/15 | 候选名称：ClearBlacklistItems | 指令记录：27 | 子原型：0 | 可变参数：0
-- 字节范围：12602:12917
local function proto_ClearBlacklistItems_root_15(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'FindMonsterInCurrViewField'
    -- K[1] = 'ipairs'
    -- K[2] = 'SL'
    -- K[3] = 'GetID'
    -- 指令语义：
    -- PC 0001 FLAG=0x12 OP_137
    r[(0)]=__ENV[('SL')]
    -- PC 0002 FLAG=0xE0 OP_121
    local I=r[(0)];r[(0)+1]=I;r[(0)]=I[('FindMonsterInCurrViewField')]
    -- PC 0003 FLAG=0xC0 OP_011
    r[(2)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0004 FLAG=0x80 OP_011
    r[(3)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0005 FLAG=0x40 OP_098
    r[(0)]=r[(0)](U(T,(0)+1,(3)))
    -- PC 0006 FLAG=0x80 OP_342
    if (not not r[(0)])~=((1)~=0) then pc=pc+1 end
    -- PC 0007 FLAG=0x42 OP_140 [jump-target=9]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(8)
    -- PC 0008 FLAG=0x80 OP_410
    r[(0)]={}
    -- PC 0009 FLAG=0x00 OP_410
    r[(1)]={}
    -- PC 0010 FLAG=0x12 OP_071 [linear-fusion-payloads=1]
    r[(2)]=__ENV[('ipairs')]; -- 融合载荷：r[(2)]=r[('ipairs')]
    -- PC 0011 FLAG=0x00 OP_184
    r[(3)]=r[(0)]
    -- PC 0012 FLAG=0xC0 OP_233
    do local I={ r[(2)](U(T,(2)+1,(3))) };local F=0;for U=(2),(4) do F=F+1;T[U]=I[F] end end
    -- PC 0013 FLAG=0x42 OP_215 [jump-target=24]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(23)
    -- PC 0014 FLAG=0x80 OP_131 [linear-fusion-payloads=1]
    r[(7)]=up[(0)]; -- 融合载荷：r[(7)]=r[(0)]
    -- PC 0015 FLAG=0x40 OP_184
    r[(8)]=r[(6)]
    -- PC 0016 FLAG=0x40 OP_068
    r[(7)]=r[(7)](U(T,(7)+1,(8)))
    -- PC 0017 FLAG=0x00 OP_016
    if (not not r[(7)])~=((0)~=0) then pc=pc+1 end
    -- PC 0018 FLAG=0xC2 OP_255 [jump-target=24]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(23)
    -- PC 0019 FLAG=0x20 OP_238
    local I=r[(6)];r[(7)+1]=I;r[(7)]=I[('GetID')]
    -- PC 0020 FLAG=0x00 OP_068
    r[(7)]=r[(7)](U(T,(7)+1,(8)))
    -- PC 0021 FLAG=0x40 OP_016
    if (not not r[(7)])~=((0)~=0) then pc=pc+1 end
    -- PC 0022 FLAG=0xC2 OP_140 [jump-target=24]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(23)
    -- PC 0023 FLAG=0x80 OP_327
    do local I=r[(7)];local F=r[(6)];r[(1)][I]=F end
    -- PC 0024 FLAG=0x00 OP_117
    do local I,F=E(r[(2)](r[(2)+1],r[(2)+2]));for U=1,(2) do T[(2)+2+U]=I[U] end;if r[(2)+3]==nil then pc=pc+1 else r[(2)+2]=r[(2)+3] end end
    -- PC 0025 FLAG=0xC2 OP_255 [jump-target=14]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(13)
    -- PC 0026 FLAG=0x00 OP_220
    return U(T,(1),(1))
    -- PC 0027 FLAG=0x00 OP_001
    return
end
-- 原型入口：proto_ClearBlacklistItems_root_15

-- ============================================================================
-- 原型 root/16 | 候选名称：PrintLog | 指令记录：63 | 子原型：1 | 可变参数：0
-- 字节范围：12917:13975
local function proto_PrintLog_root_16(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = '_blacklistData'
    -- K[1] = 'SL'
    -- K[2] = 'pairs'
    -- K[3] = 'ScheduleOnce'
    -- K[4] = '清空黑名单失败'
    -- K[5] = '黑名单本来就是空的'
    -- K[6] = ['unknown', 2]
    -- K[7] = 0.01
    -- K[8] = 1.0
    -- K[9] = 'ipairs'
    -- K[10] = 0.0
    -- K[11] = '黑名单为空'
    -- K[12] = '开始清空黑名单，共 %d 人'
    -- K[13] = '清空黑名单 '
    -- K[14] = ' 人'
    -- K[15] = 'lastAttacker'
    -- K[16] = '取不到好友代理，清空失败'
    -- 指令语义：
    -- PC 0001 FLAG=0xC0 OP_130
    r[(0)]=up[(0)]
    -- PC 0002 FLAG=0xC0 OP_068
    r[(0)]=r[(0)](U(T,(0)+1,(0)))
    -- PC 0003 FLAG=0x00 OP_247
    local I=r[(0)];if (not not I)==((0)~=0) then r[(1)]=I else pc=pc+1 end
    -- PC 0004 FLAG=0x42 OP_255 [jump-target=6]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(5)
    -- PC 0005 FLAG=0x60 OP_032
    r[(1)]=r[(0)][('_blacklistData')]
    -- PC 0006 FLAG=0x80 OP_342
    if (not not r[(1)])~=((1)~=0) then pc=pc+1 end
    -- PC 0007 FLAG=0x42 OP_215 [jump-target=15]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(14)
    -- PC 0008 FLAG=0xC0 OP_134 [linear-fusion-payloads=1]
    r[(2)]=up[(1)]; -- 融合载荷：r[(2)]=(1)
    -- PC 0009 FLAG=0x12 OP_371
    r[(3)]=('取不到好友代理，清空失败')
    -- PC 0010 FLAG=0x00 OP_187
    r[(2)](U(T,(2)+1,(3)))
    -- PC 0011 FLAG=0x00 OP_134 [linear-fusion-payloads=1]
    r[(2)]=up[(2)]; -- 融合载荷：r[(2)]=(2)
    -- PC 0012 FLAG=0x52 OP_346
    r[(3)]=('清空黑名单失败')
    -- PC 0013 FLAG=0x00 OP_187
    r[(2)](U(T,(2)+1,(3)))
    -- PC 0014 FLAG=0x40 OP_250
    return
    -- PC 0015 FLAG=0x00 OP_410
    r[(2)]={}
    -- PC 0016 FLAG=0x12 OP_071 [linear-fusion-payloads=1]
    r[(3)]=__ENV[('pairs')]; -- 融合载荷：r[(3)]=r[('pairs')]
    -- PC 0017 FLAG=0xC0 OP_308
    r[(4)]=r[(1)]
    -- PC 0018 FLAG=0x40 OP_359
    do local I={ r[(3)](U(T,(3)+1,(4))) };local F=0;for U=(3),(5) do F=F+1;T[U]=I[F] end end
    -- PC 0019 FLAG=0x42 OP_215 [jump-target=23]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(22)
    -- PC 0020 FLAG=0x40 OP_115
    r[(7)]=#r[(2)]
    -- PC 0021 FLAG=0xE0 OP_124
    r[(7)]=r[(7)]+(1.0)
    -- PC 0022 FLAG=0x40 OP_368
    do local I=r[(7)];local F=r[(6)];r[(2)][I]=F end
    -- PC 0023 FLAG=0x40 OP_386
    do local I,F=E(r[(3)](r[(3)+1],r[(3)+2]));for U=1,(1) do T[(3)+2+U]=I[U] end;if r[(3)+3]==nil then pc=pc+1 else r[(3)+2]=r[(3)+3] end end
    -- PC 0024 FLAG=0xC2 OP_255 [jump-target=20]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(19)
    -- PC 0025 FLAG=0x00 OP_115
    r[(3)]=#r[(2)]
    -- PC 0026 FLAG=0x60 OP_045
    if (r[(3)]==(0.0))~=((0)~=0) then pc=pc+1 end
    -- PC 0027 FLAG=0x42 OP_255 [jump-target=35]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(34)
    -- PC 0028 FLAG=0x40 OP_134 [linear-fusion-payloads=1]
    r[(3)]=up[(1)]; -- 融合载荷：r[(3)]=(1)
    -- PC 0029 FLAG=0x12 OP_346
    r[(4)]=('黑名单本来就是空的')
    -- PC 0030 FLAG=0x00 OP_358
    r[(3)](U(T,(3)+1,(4)))
    -- PC 0031 FLAG=0x00 OP_134 [linear-fusion-payloads=1]
    r[(3)]=up[(2)]; -- 融合载荷：r[(3)]=(2)
    -- PC 0032 FLAG=0xD2 OP_371
    r[(4)]=('黑名单为空')
    -- PC 0033 FLAG=0x40 OP_358
    r[(3)](U(T,(3)+1,(4)))
    -- PC 0034 FLAG=0x40 OP_055
    return
    -- PC 0035 FLAG=0x40 OP_134 [linear-fusion-payloads=1]
    r[(3)]=up[(1)]; -- 融合载荷：r[(3)]=(1)
    -- PC 0036 FLAG=0x92 OP_371
    r[(4)]=('开始清空黑名单，共 %d 人')
    -- PC 0037 FLAG=0xC0 OP_115
    r[(5)]=#r[(2)]
    -- PC 0038 FLAG=0x80 OP_358
    r[(3)](U(T,(3)+1,(5)))
    -- PC 0039 FLAG=0x40 OP_134 [linear-fusion-payloads=1]
    r[(3)]=up[(2)]; -- 融合载荷：r[(3)]=(2)
    -- PC 0040 FLAG=0x92 OP_346
    r[(4)]=('清空黑名单 ')
    -- PC 0041 FLAG=0x40 OP_115
    r[(5)]=#r[(2)]
    -- PC 0042 FLAG=0x12 OP_047 [linear-fusion-payloads=1]
    r[(6)]=(' 人'); -- 融合载荷：do local I=r[(nil)];for F=(nil)-1,(' 人'),-1 do I=T[F]..I end;r[(6)]=I end
    -- PC 0043 FLAG=0x80 OP_210
    do local I=r[(6)];for F=(6)-1,(4),-1 do I=T[F]..I end;r[(4)]=I end
    -- PC 0044 FLAG=0x00 OP_187
    r[(3)](U(T,(3)+1,(4)))
    -- PC 0045 FLAG=0x12 OP_071 [linear-fusion-payloads=1]
    r[(3)]=__ENV[('ipairs')]; -- 融合载荷：r[(3)]=r[('ipairs')]
    -- PC 0046 FLAG=0x00 OP_308
    r[(4)]=r[(2)]
    -- PC 0047 FLAG=0x40 OP_183
    do local I={ r[(3)](U(T,(3)+1,(4))) };local F=0;for U=(3),(5) do F=F+1;T[U]=I[F] end end
    -- PC 0048 FLAG=0x02 OP_215 [jump-target=59]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(58)
    -- PC 0049 FLAG=0x00 OP_184
    r[(8)]=r[(7)]
    -- PC 0050 FLAG=0xD2 OP_137
    r[(9)]=__ENV[('SL')]
    -- PC 0051 FLAG=0xA0 OP_033
    local I=r[(9)];r[(9)+1]=I;r[(9)]=I[('ScheduleOnce')]
    -- PC 0052 FLAG=0xC0 OP_154 [linear-fusion-payloads=2, closure-child-index=0; captures=2; child-path=root/16/1]
    do local I=O[(0)];local F={};F[-1]=(2);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(2)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(11)]=M(I,U,S) end
    -- PC 0053 FLAG=0x00 OP_387
    r[(0)]=r[(8)]
    -- PC 0054 FLAG=0x80 OP_387
    r[(0)]=r[(0)]
    -- PC 0055 FLAG=0xA0 OP_347
    r[(12)]=r[(6)]-(1.0)
    -- PC 0056 FLAG=0xD0 OP_160
    r[(12)]=(0.01)*r[(12)]
    -- PC 0057 FLAG=0xC0 OP_358
    r[(9)](U(T,(9)+1,(12)))
    -- PC 0058 FLAG=0xC0 OP_262
    do local I=(8);local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (0)=K[2];if Z==T and I<=(0) then F[(0)]=Z[(0)];K[1]=F end end end end end
    -- PC 0059 FLAG=0x00 OP_386
    do local I,F=E(r[(3)](r[(3)+1],r[(3)+2]));for U=1,(2) do T[(3)+2+U]=I[U] end;if r[(3)+3]==nil then pc=pc+1 else r[(3)+2]=r[(3)+3] end end
    -- PC 0060 FLAG=0x02 OP_215 [jump-target=49]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(48)
    -- PC 0061 FLAG=0x40 OP_130
    r[(3)]=up[(3)]
    -- PC 0062 FLAG=0xB0 OP_146
    do local I=('lastAttacker');local F=(['unknown', 2]);r[(3)][I]=F end
    -- PC 0063 FLAG=0x40 OP_001
    return
end
-- 原型入口：proto_PrintLog_root_16

-- ============================================================================
-- 原型 root/16/1 | 候选名称：Prototype_root_16_1 | 指令记录：13 | 子原型：0 | 可变参数：0
-- 字节范围：13793:13974
local function proto_Prototype_root_16_1_root_16_1(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'SL'
    -- K[1] = 'RequestOutBlacklist'
    -- K[2] = ['unknown', 2]
    -- K[3] = '_blacklistData'
    -- 指令语义：
    -- PC 0001 FLAG=0x92 OP_137
    r[(0)]=__ENV[('SL')]
    -- PC 0002 FLAG=0xE0 OP_121
    local I=r[(0)];r[(0)+1]=I;r[(0)]=I[('RequestOutBlacklist')]
    -- PC 0003 FLAG=0x40 OP_130
    r[(2)]=up[(0)]
    -- PC 0004 FLAG=0x00 OP_187
    r[(0)](U(T,(0)+1,(2)))
    -- PC 0005 FLAG=0xC0 OP_159 [linear-fusion-payloads=1]
    r[(0)]=up[(1)]; -- 融合载荷：r[(0)]=r[(1)][(0)]
    -- PC 0006 FLAG=0xA0 OP_053
    r[(0)]=r[(0)][('_blacklistData')]
    -- PC 0007 FLAG=0x00 OP_016
    if (not not r[(0)])~=((0)~=0) then pc=pc+1 end
    -- PC 0008 FLAG=0x82 OP_140 [jump-target=13]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(12)
    -- PC 0009 FLAG=0x40 OP_159 [linear-fusion-payloads=1]
    r[(0)]=up[(1)]; -- 融合载荷：r[(0)]=r[(1)][(0)]
    -- PC 0010 FLAG=0x60 OP_032
    r[(0)]=r[(0)][('_blacklistData')]
    -- PC 0011 FLAG=0xC0 OP_130
    r[(1)]=up[(0)]
    -- PC 0012 FLAG=0xA0 OP_069
    do local I=r[(1)];local F=(['unknown', 2]);r[(0)][I]=F end
    -- PC 0013 FLAG=0x40 OP_001
    return
end
-- 原型入口：proto_Prototype_root_16_1_root_16_1

-- ============================================================================
-- 原型 root/17 | 候选名称：PCallHelper | 指令记录：38 | 子原型：0 | 可变参数：1
-- 字节范围：13975:14463
local function proto_PCallHelper_root_17(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'format'
    -- K[1] = '#'
    -- K[2] = 'Print'
    -- K[3] = 'type'
    -- K[4] = 'pcall'
    -- K[5] = 'tostring'
    -- K[6] = 'string'
    -- K[7] = 'table'
    -- K[8] = 'dump'
    -- K[9] = 'SL'
    -- K[10] = 'select'
    -- K[11] = '【超本】'
    -- K[12] = 0.0
    -- 指令语义：
    -- PC 0001 FLAG=0x92 OP_071 [linear-fusion-payloads=1]
    r[(2)]=__ENV[('type')]; -- 融合载荷：r[(2)]=r[('type')]
    -- PC 0002 FLAG=0x40 OP_184
    r[(3)]=r[(0)]
    -- PC 0003 FLAG=0x00 OP_068
    r[(2)]=r[(2)](U(T,(2)+1,(3)))
    -- PC 0004 FLAG=0xE0 OP_092
    if (r[(2)]==('table'))~=((0)~=0) then pc=pc+1 end
    -- PC 0005 FLAG=0x42 OP_255 [jump-target=12]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(11)
    -- PC 0006 FLAG=0xD2 OP_287 [linear-fusion-payloads=3]
    r[(2)]=__ENV[('SL')]; -- 融合载荷：local I=r[('SL')];r[(2)+1]=I;r[(2)]=I[(nil)]; -- 融合载荷：r[(2)]=r[('SL')]; -- 融合载荷：r[(2)]=('SL')
    -- PC 0007 FLAG=0x20 OP_033
    local I=r[(2)];r[(2)+1]=I;r[(2)]=I[('dump')]
    -- PC 0008 FLAG=0xC0 OP_184
    r[(4)]=r[(0)]
    -- PC 0009 FLAG=0x12 OP_346
    r[(5)]=('【超本】')
    -- PC 0010 FLAG=0xC0 OP_187
    r[(2)](U(T,(2)+1,(5)))
    -- PC 0011 FLAG=0x40 OP_250
    return
    -- PC 0012 FLAG=0x52 OP_071 [linear-fusion-payloads=1]
    r[(2)]=__ENV[('tostring')]; -- 融合载荷：r[(2)]=r[('tostring')]
    -- PC 0013 FLAG=0x80 OP_308
    r[(3)]=r[(0)]
    -- PC 0014 FLAG=0x00 OP_068
    r[(2)]=r[(2)](U(T,(2)+1,(3)))
    -- PC 0015 FLAG=0xD2 OP_168 [linear-fusion-payloads=1]
    r[(3)]=__ENV[('select')]; -- 融合载荷：r[(3)]=('select')
    -- PC 0016 FLAG=0x52 OP_346
    r[(4)]=('#')
    -- PC 0017 FLAG=0xC0 OP_006
    (0)=(5)+(5)-1;for I=(5),(0) do T[I]=X[I-(5)] end
    -- PC 0018 FLAG=0x80 OP_223
    r[(3)]=r[(3)](U(T,(3)+1,(0)))
    -- PC 0019 FLAG=0x50 OP_352
    if ((0.0)<r[(3)])~=((0)~=0) then pc=pc+1 end
    -- PC 0020 FLAG=0x82 OP_215 [jump-target=31]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(30)
    -- PC 0021 FLAG=0x12 OP_137
    r[(3)]=__ENV[('pcall')]
    -- PC 0022 FLAG=0x52 OP_307 [linear-fusion-payloads=2]
    r[(4)]=__ENV[('string')]; -- 融合载荷：r[(4)]=r[('string')][(nil)]; -- 融合载荷：r[(4)]=r[('string')]
    -- PC 0023 FLAG=0x20 OP_398 [linear-fusion-payloads=1]
    r[(4)]=r[(4)][('format')]; -- 融合载荷：r[(4)]=r[(4)]
    -- PC 0024 FLAG=0x00 OP_308
    r[(5)]=r[(0)]
    -- PC 0025 FLAG=0x80 OP_006
    (0)=(6)+(6)-1;for I=(6),(0) do T[I]=X[I-(6)] end
    -- PC 0026 FLAG=0x00 OP_014
    do local I={ r[(3)](U(T,(3)+1,(0))) };local F=0;for U=(3),(4) do F=F+1;T[U]=I[F] end end
    -- PC 0027 FLAG=0x40 OP_016
    if (not not r[(3)])~=((0)~=0) then pc=pc+1 end
    -- PC 0028 FLAG=0x82 OP_255 [jump-target=31]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(30)
    -- PC 0029 FLAG=0xC0 OP_035
    local I=r[(4)];if (not not I)==((1)~=0) then r[(2)]=I else pc=pc+1 end
    -- PC 0030 FLAG=0xC2 OP_140 [jump-target=31]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(30)
    -- PC 0031 FLAG=0x92 OP_137
    r[(3)]=__ENV[('SL')]
    -- PC 0032 FLAG=0x40 OP_016
    if (not not r[(3)])~=((0)~=0) then pc=pc+1 end
    -- PC 0033 FLAG=0x02 OP_215 [jump-target=38]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(37)
    -- PC 0034 FLAG=0x52 OP_397 [linear-fusion-payloads=1]
    r[(3)]=__ENV[('SL')]; -- 融合载荷：r[(3)]=r[('SL')][(nil)]
    -- PC 0035 FLAG=0x60 OP_363
    r[(3)]=r[(3)][('Print')]
    -- PC 0036 FLAG=0x80 OP_016
    if (not not r[(3)])~=((0)~=0) then pc=pc+1 end
    -- PC 0037 FLAG=0x42 OP_140 [jump-target=38]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(37)
    -- PC 0038 FLAG=0xC0 OP_001
    return
end
-- 原型入口：proto_PCallHelper_root_17

-- ============================================================================
-- 原型 root/18 | 候选名称：GetPlayerPosition | 指令记录：14 | 子原型：1 | 可变参数：2
-- 字节范围：14463:14825
local function proto_GetPlayerPosition_root_18(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = False
    -- K[1] = 'pcall'
    -- 指令语义：
    -- PC 0001 FLAG=0x92 OP_137
    r[(2)]=__ENV[('pcall')]
    -- PC 0002 FLAG=0x00 OP_154 [linear-fusion-payloads=3, closure-child-index=0; captures=3; child-path=root/18/1]
    do local I=O[(0)];local F={};F[-1]=(3);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(3)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(3)]=M(I,U,S) end
    -- PC 0003 FLAG=0x40 OP_387
    r[(0)]=r[(1)]
    -- PC 0004 FLAG=0x00 OP_325
    r[(0)]=up[(0)]
    -- PC 0005 FLAG=0x80 OP_387
    r[(0)]=r[(0)]
    -- PC 0006 FLAG=0x40 OP_233
    do local I={ r[(2)](U(T,(2)+1,(3))) };local F=0;for U=(2),(3) do F=F+1;T[U]=I[F] end end
    -- PC 0007 FLAG=0x00 OP_247
    local I=r[(2)];if (not not I)==((0)~=0) then r[(4)]=I else pc=pc+1 end
    -- PC 0008 FLAG=0x42 OP_215 [jump-target=13]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(12)
    -- PC 0009 FLAG=0xA0 OP_092
    if (r[(3)]==(false))~=((0)~=0) then pc=pc+1 end
    -- PC 0010 FLAG=0x42 OP_140 [jump-target=12]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(11)
    -- PC 0011 FLAG=0x80 OP_082
    r[(4)]=(0)~=0;if (1)~=0 then pc=pc+1 end
    -- PC 0012 FLAG=0x80 OP_011
    r[(4)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0013 FLAG=0x80 OP_220
    return U(T,(4),(4))
    -- PC 0014 FLAG=0xC0 OP_001
    return
end
-- 原型入口：proto_GetPlayerPosition_root_18

-- ============================================================================
-- 原型 root/18/1 | 候选名称：Prototype_root_18_1 | 指令记录：14 | 子原型：0 | 可变参数：0
-- 字节范围：14613:14824
local function proto_Prototype_root_18_1_root_18_1(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'tostring'
    -- K[1] = 'cc'
    -- K[2] = 'getInstance'
    -- K[3] = 'FileUtils'
    -- K[4] = 'writeStringToFile'
    -- 指令语义：
    -- PC 0001 FLAG=0xD2 OP_309 [linear-fusion-payloads=2]
    r[(0)]=__ENV[('cc')]; -- 融合载荷：r[(0)]=r[('cc')][(nil)]; -- 融合载荷：local I=r[('cc')];r[(0)+1]=I;r[(0)]=I[(nil)]
    -- PC 0002 FLAG=0x60 OP_270 [linear-fusion-payloads=1]
    r[(0)]=r[(0)][('FileUtils')]; -- 融合载荷：local I=r[(0)];r[(0)+1]=I;r[(0)]=I[('FileUtils')]
    -- PC 0003 FLAG=0xE0 OP_121
    local I=r[(0)];r[(0)+1]=I;r[(0)]=I[('getInstance')]
    -- PC 0004 FLAG=0x80 OP_098
    r[(0)]=r[(0)](U(T,(0)+1,(1)))
    -- PC 0005 FLAG=0xE0 OP_121
    local I=r[(0)];r[(0)+1]=I;r[(0)]=I[('writeStringToFile')]
    -- PC 0006 FLAG=0xD2 OP_095 [linear-fusion-payloads=1]
    r[(2)]=__ENV[('tostring')]; -- 融合载荷：r[(2)]=up[('tostring')]
    -- PC 0007 FLAG=0xC0 OP_130
    r[(3)]=up[(0)]
    -- PC 0008 FLAG=0xC0 OP_098
    r[(2)]=r[(2)](U(T,(2)+1,(3)))
    -- PC 0009 FLAG=0x80 OP_004 [linear-fusion-payloads=1]
    r[(3)]=up[(1)]; -- 融合载荷：r[(3)]=up[(1)]
    -- PC 0010 FLAG=0xC0 OP_130
    r[(4)]=up[(2)]
    -- PC 0011 FLAG=0xC0 OP_252
    do local I,F=E(r[(3)](U(T,(3)+1,(4))));(4)=F+(3)-1;local U=0;for L=(3),(4) do U=U+1;T[L]=I[U] end end
    -- PC 0012 FLAG=0x40 OP_133
    return r[(0)](U(T,(0)+1,(0)))
    -- PC 0013 FLAG=0x40 OP_175
    return U(T,(0),(0))
    -- PC 0014 FLAG=0xC0 OP_100
    return
end
-- 原型入口：proto_Prototype_root_18_1_root_18_1

-- ============================================================================
-- 原型 root/19 | 候选名称：InitGatherMonsters | 指令记录：19 | 子原型：0 | 可变参数：0
-- 字节范围：14825:15066
local function proto_InitGatherMonsters_root_19(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'X'
    -- K[1] = 'y'
    -- K[2] = 'GetMetaValue'
    -- K[3] = 'x'
    -- K[4] = 'Y'
    -- K[5] = 0.0
    -- K[6] = 'SL'
    -- 指令语义：
    -- PC 0001 FLAG=0x52 OP_137
    r[(0)]=__ENV[('SL')]
    -- PC 0002 FLAG=0x20 OP_297 [linear-fusion-payloads=1]
    local I=r[(0)];r[(0)+1]=I;r[(0)]=I[('GetMetaValue')]; -- 融合载荷：r[(0)]=(0)
    -- PC 0003 FLAG=0xD2 OP_371
    r[(2)]=('X')
    -- PC 0004 FLAG=0x80 OP_098
    r[(0)]=r[(0)](U(T,(0)+1,(2)))
    -- PC 0005 FLAG=0x00 OP_342
    if (not not r[(0)])~=((1)~=0) then pc=pc+1 end
    -- PC 0006 FLAG=0x42 OP_255 [jump-target=8]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(7)
    -- PC 0007 FLAG=0x12 OP_328 [linear-fusion-payloads=3]
    r[(0)]=(0.0); -- 融合载荷：r[(0)]=__ENV[(0.0)]; -- 融合载荷：local I=r[(0.0)];r[(0)+1]=I;r[(0)]=I[(nil)]; -- 融合载荷：r[(0)]=(0.0)
    -- PC 0008 FLAG=0x12 OP_137
    r[(1)]=__ENV[('SL')]
    -- PC 0009 FLAG=0x60 OP_238
    local I=r[(1)];r[(1)+1]=I;r[(1)]=I[('GetMetaValue')]
    -- PC 0010 FLAG=0x12 OP_346
    r[(3)]=('Y')
    -- PC 0011 FLAG=0x00 OP_068
    r[(1)]=r[(1)](U(T,(1)+1,(3)))
    -- PC 0012 FLAG=0x00 OP_342
    if (not not r[(1)])~=((1)~=0) then pc=pc+1 end
    -- PC 0013 FLAG=0x02 OP_215 [jump-target=15]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(14)
    -- PC 0014 FLAG=0x92 OP_107 [linear-fusion-payloads=3]
    r[(1)]=(0.0); -- 融合载荷：r[(1)]={}; -- 融合载荷：do local I=(0.0);local F=r[(nil)];r[(1)][I]=F end; -- 融合载荷：do local I=(0.0);local F=r[(nil)];r[(1)][I]=F end
    -- PC 0015 FLAG=0x00 OP_410
    r[(2)]={}
    -- PC 0016 FLAG=0x50 OP_285 [linear-fusion-payloads=1]
    do local I=('x');local F=r[(0)];r[(2)][I]=F end; -- 融合载荷：do local I=('x');local F=r[(0)];r[(2)][I]=F end
    -- PC 0017 FLAG=0x50 OP_268
    do local I=('y');local F=r[(1)];r[(2)][I]=F end
    -- PC 0018 FLAG=0x40 OP_220
    return U(T,(2),(2))
    -- PC 0019 FLAG=0xC0 OP_001
    return
end
-- 原型入口：proto_InitGatherMonsters_root_19

-- ============================================================================
-- 原型 root/20 | 候选名称：ShowLocalNoticeByType | 指令记录：36 | 子原型：1 | 可变参数：0
-- 字节范围：15066:15618
local function proto_ShowLocalNoticeByType_root_20(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'gatherTimer'
    -- K[1] = 'CHECK_INTERVAL'
    -- K[2] = 'format'
    -- K[3] = 'IDLE'
    -- K[4] = 'Schedule'
    -- K[5] = 'GATHER_THRESHOLD'
    -- K[6] = '引怪功能已启动 (阈值: %d)'
    -- K[7] = 'SL'
    -- K[8] = 'string'
    -- K[9] = ['unknown', 2]
    -- K[10] = 'UnSchedule'
    -- 指令语义：
    -- PC 0001 FLAG=0x40 OP_130
    r[(0)]=up[(0)]
    -- PC 0002 FLAG=0x20 OP_053
    r[(0)]=r[(0)][('gatherTimer')]
    -- PC 0003 FLAG=0x40 OP_016
    if (not not r[(0)])~=((0)~=0) then pc=pc+1 end
    -- PC 0004 FLAG=0x82 OP_215 [jump-target=12]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(11)
    -- PC 0005 FLAG=0x52 OP_335 [linear-fusion-payloads=1]
    r[(0)]=__ENV[('SL')]; -- 融合载荷：local I=r[('SL')];r[(0)+1]=I;r[(0)]=I[(nil)]
    -- PC 0006 FLAG=0xE0 OP_238
    local I=r[(0)];r[(0)+1]=I;r[(0)]=I[('UnSchedule')]
    -- PC 0007 FLAG=0x00 OP_130
    r[(2)]=up[(0)]
    -- PC 0008 FLAG=0x20 OP_375
    r[(2)]=r[(2)][('gatherTimer')]
    -- PC 0009 FLAG=0xC0 OP_358
    r[(0)](U(T,(0)+1,(2)))
    -- PC 0010 FLAG=0xC0 OP_130
    r[(0)]=up[(0)]
    -- PC 0011 FLAG=0xB0 OP_156
    do local I=('gatherTimer');local F=(['unknown', 2]);r[(0)][I]=F end
    -- PC 0012 FLAG=0x00 OP_338
    r[(0)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0013 FLAG=0x40 OP_106
    up[(1)]=r[(0)]
    -- PC 0014 FLAG=0x00 OP_087 [linear-fusion-payloads=2]
    r[(0)]=up[(2)]; -- 融合载荷：r[(0)]=up[(2)]; -- 融合载荷：r[(0)]=r[(2)][(0)]
    -- PC 0015 FLAG=0xC0 OP_159 [linear-fusion-payloads=1]
    r[(1)]=up[(3)]; -- 融合载荷：r[(1)]=r[(3)][(0)]
    -- PC 0016 FLAG=0xE0 OP_375
    r[(1)]=r[(1)][('IDLE')]
    -- PC 0017 FLAG=0x40 OP_358
    r[(0)](U(T,(0)+1,(1)))
    -- PC 0018 FLAG=0xC0 OP_130
    r[(0)]=up[(4)]
    -- PC 0019 FLAG=0x80 OP_358
    r[(0)](U(T,(0)+1,(0)))
    -- PC 0020 FLAG=0xC0 OP_130
    r[(0)]=up[(0)]
    -- PC 0021 FLAG=0x52 OP_335 [linear-fusion-payloads=1]
    r[(1)]=__ENV[('SL')]; -- 融合载荷：local I=r[('SL')];r[(1)+1]=I;r[(1)]=I[(nil)]
    -- PC 0022 FLAG=0x20 OP_121
    local I=r[(1)];r[(1)+1]=I;r[(1)]=I[('Schedule')]
    -- PC 0023 FLAG=0x80 OP_027 [closure-child-index=0; captures=0; child-path=root/20/1]
    do local I=O[(0)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(3)]=M(I,U,S) end
    -- PC 0024 FLAG=0x40 OP_159 [linear-fusion-payloads=1]
    r[(4)]=up[(5)]; -- 融合载荷：r[(4)]=r[(5)][(0)]
    -- PC 0025 FLAG=0x20 OP_375
    r[(4)]=r[(4)][('CHECK_INTERVAL')]
    -- PC 0026 FLAG=0xC0 OP_098
    r[(1)]=r[(1)](U(T,(1)+1,(4)))
    -- PC 0027 FLAG=0x50 OP_355
    do local I=('gatherTimer');local F=r[(1)];r[(0)][I]=F end
    -- PC 0028 FLAG=0xC0 OP_344 [linear-fusion-payloads=3]
    r[(0)]=up[(6)]; -- 融合载荷：r[(0)]=__ENV[(6)]; -- 融合载荷：r[(0)]=r[(6)][(0)]; -- 融合载荷：r[(0)]=(6)
    -- PC 0029 FLAG=0x52 OP_194 [linear-fusion-payloads=3]
    r[(1)]=__ENV[('string')]; -- 融合载荷：r[(1)]=r[('string')][(nil)]; -- 融合载荷：r[(1)]=('string'); -- 融合载荷：r[(1)]=up[('string')]
    -- PC 0030 FLAG=0xE0 OP_375
    r[(1)]=r[(1)][('format')]
    -- PC 0031 FLAG=0x12 OP_391 [linear-fusion-payloads=2]
    r[(2)]=('引怪功能已启动 (阈值: %d)'); -- 融合载荷：r[(2)]=up[('引怪功能已启动 (阈值: %d)')]; -- 融合载荷：r[(2)]=r[('引怪功能已启动 (阈值: %d)')][(nil)]
    -- PC 0032 FLAG=0xC0 OP_159 [linear-fusion-payloads=1]
    r[(3)]=up[(5)]; -- 融合载荷：r[(3)]=r[(5)][(0)]
    -- PC 0033 FLAG=0xE0 OP_032
    r[(3)]=r[(3)][('GATHER_THRESHOLD')]
    -- PC 0034 FLAG=0xC0 OP_392
    do local I,F=E(r[(1)](U(T,(1)+1,(3))));(3)=F+(1)-1;local U=0;for L=(1),(3) do U=U+1;T[L]=I[U] end end
    -- PC 0035 FLAG=0x40 OP_093
    r[(0)](U(T,(0)+1,(0)))
    -- PC 0036 FLAG=0x00 OP_250
    return
end
-- 原型入口：proto_ShowLocalNoticeByType_root_20

-- ============================================================================
-- 原型 root/20/1 | 候选名称：Prototype_root_20_1 | 指令记录：3 | 子原型：0 | 可变参数：0
-- 字节范围：15564:15617
local function proto_Prototype_root_20_1_root_20_1(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'MainLoop'
    -- 指令语义：
    -- PC 0001 FLAG=0x52 OP_137
    r[(0)]=__ENV[('MainLoop')]
    -- PC 0002 FLAG=0x80 OP_187
    r[(0)](U(T,(0)+1,(0)))
    -- PC 0003 FLAG=0x00 OP_250
    return
end
-- 原型入口：proto_Prototype_root_20_1_root_20_1

-- ============================================================================
-- 原型 root/21 | 候选名称：PickUpItems | 指令记录：15 | 子原型：0 | 可变参数：1
-- 字节范围：15618:15907
local function proto_PickUpItems_root_21(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 5.0
    -- K[1] = 'screenH'
    -- K[2] = 'Y'
    -- K[3] = 'SL'
    -- K[4] = 0.0
    -- K[5] = 'Type'
    -- K[6] = 'Msg'
    -- K[7] = 'ShowLocalNoticeByType'
    -- K[8] = 249.0
    -- K[9] = 'BColor'
    -- K[10] = 'FColor'
    -- K[11] = 'X'
    -- K[12] = 50.0
    -- K[13] = 10.0
    -- 指令语义：
    -- PC 0001 FLAG=0x00 OP_083 [linear-fusion-payloads=3]
    r[(1)]={}; -- 融合载荷：do local I=(0);local F=(6);r[(1)][I]=F end; -- 融合载荷：do local I=(0);local F=r[(6)];r[(1)][I]=F end; -- 融合载荷：do local I=(0);local F=(6);r[(1)][I]=F end
    -- PC 0002 FLAG=0xF0 OP_146
    do local I=('Type');local F=(10.0);r[(1)][I]=F end
    -- PC 0003 FLAG=0x50 OP_408 [linear-fusion-payloads=1]
    do local I=('Msg');local F=r[(0)];r[(1)][I]=F end; -- 融合载荷：do local I=('Msg');local F=(0);r[(1)][I]=F end
    -- PC 0004 FLAG=0xF0 OP_305 [linear-fusion-payloads=8]
    do local I=('FColor');local F=(249.0);r[(1)][I]=F end; -- 融合载荷：do local I=('FColor');local F=(249.0);r[(1)][I]=F end; -- 融合载荷：do local I=('FColor');local F=(249.0);r[(1)][I]=F end; -- 融合载荷：r[(1)]=up[('FColor')]; -- 融合载荷：r[(1)]=r[('FColor')][(249.0)]; -- 融合载荷：r[(1)]=r[('FColor')]-(249.0); -- 融合载荷：do local I=('FColor');local F=r[(249.0)];r[(1)][I]=F end; -- 融合载荷：r[(1)]=__ENV[('FColor')]; -- 融合载荷：local I=r[('FColor')];r[(1)+1]=I;r[(1)]=I[(249.0)]
    -- PC 0005 FLAG=0xF0 OP_146
    do local I=('BColor');local F=(0.0);r[(1)][I]=F end
    -- PC 0006 FLAG=0xB0 OP_144 [linear-fusion-payloads=3]
    do local I=('X');local F=(5.0);r[(1)][I]=F end; -- 融合载荷：r[(1)]=up[('X')]; -- 融合载荷：r[(1)]=r[('X')][(5.0)]; -- 融合载荷：r[(1)]=r[('X')]-(5.0)
    -- PC 0007 FLAG=0x80 OP_130
    r[(2)]=up[(0)]
    -- PC 0008 FLAG=0x60 OP_363
    r[(2)]=r[(2)][('screenH')]
    -- PC 0009 FLAG=0x20 OP_034 [linear-fusion-payloads=4]
    r[(2)]=r[(2)]-(50.0); -- 融合载荷：do local I=(2);local F=r[(50.0)];r[(2)][I]=F end; -- 融合载荷：r[(2)]=__ENV[(2)]; -- 融合载荷：local I=r[(2)];r[(2)+1]=I;r[(2)]=I[(50.0)]; -- 融合载荷：r[(2)]=r[(2)]
    -- PC 0010 FLAG=0x10 OP_193 [linear-fusion-payloads=3]
    do local I=('Y');local F=r[(2)];r[(1)][I]=F end; -- 融合载荷：r[(1)]=__ENV[('Y')]; -- 融合载荷：local I=r[('Y')];r[(1)+1]=I;r[(1)]=I[(2)]; -- 融合载荷：r[(1)]=r[('Y')]
    -- PC 0011 FLAG=0x92 OP_300 [linear-fusion-payloads=2]
    r[(2)]=__ENV[('SL')]; -- 融合载荷：local I=r[('SL')];r[(2)+1]=I;r[(2)]=I[(nil)]; -- 融合载荷：r[(2)]=r[('SL')]
    -- PC 0012 FLAG=0x60 OP_142 [linear-fusion-payloads=1]
    local I=r[(2)];r[(2)+1]=I;r[(2)]=I[('ShowLocalNoticeByType')]; -- 融合载荷：r[(2)]=r[(2)]
    -- PC 0013 FLAG=0xC0 OP_308
    r[(4)]=r[(1)]
    -- PC 0014 FLAG=0x40 OP_187
    r[(2)](U(T,(2)+1,(4)))
    -- PC 0015 FLAG=0xC0 OP_055
    return
end
-- 原型入口：proto_PickUpItems_root_21

-- ============================================================================
-- 原型 root/22 | 候选名称：GetMapData2DPtr | 指令记录：172 | 子原型：2 | 可变参数：0
-- 字节范围：15907:18157
local function proto_GetMapData2DPtr_root_22(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = '地面无可拾取物品'
    -- K[1] = 'abs'
    -- K[2] = 'MoveTo'
    -- K[3] = 'PlayerPos'
    -- K[4] = 'mapY'
    -- K[5] = 'global'
    -- K[6] = 'sort'
    -- K[7] = 'ipairs'
    -- K[8] = 'dist'
    -- K[9] = 'find'
    -- K[10] = 'MapY'
    -- K[11] = 'math'
    -- K[12] = 'mCurrMapX'
    -- K[13] = 'mapX'
    -- K[14] = 'MapX'
    -- K[15] = 0.0
    -- K[16] = ''
    -- K[17] = 'mName'
    -- K[18] = 'string'
    -- K[19] = 1.0
    -- K[20] = 'mCurrMapY'
    -- K[21] = 'item'
    -- K[22] = 'mONameStr'
    -- K[23] = 'table'
    -- K[24] = 'GetDroppedItems'
    -- K[25] = 'name'
    -- K[26] = 'x'
    -- K[27] = 'kIdx'
    -- K[28] = 'PickMainPlayerPosItem'
    -- K[29] = 'insert'
    -- K[30] = 'dropItemController'
    -- K[31] = 'y'
    -- K[32] = 'Name'
    -- K[33] = '拾取: '
    -- 指令语义：
    -- PC 0001 FLAG=0x40 OP_009 [linear-fusion-payloads=1]
    r[(0)]={}; -- 融合载荷：r[(0)]=__ENV[(0)]
    -- PC 0002 FLAG=0x52 OP_137
    r[(1)]=__ENV[('GetDroppedItems')]
    -- PC 0003 FLAG=0x40 OP_233
    do local I={ r[(1)](U(T,(1)+1,(1))) };local F=0;for U=(1),(2) do F=F+1;T[U]=I[F] end end
    -- PC 0004 FLAG=0xE0 OP_045
    if (r[(2)]==(0.0))~=((0)~=0) then pc=pc+1 end
    -- PC 0005 FLAG=0x82 OP_255 [jump-target=10]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(9)
    -- PC 0006 FLAG=0x00 OP_134 [linear-fusion-payloads=1]
    r[(3)]=up[(0)]; -- 融合载荷：r[(3)]=(0)
    -- PC 0007 FLAG=0x92 OP_371
    r[(4)]=('地面无可拾取物品')
    -- PC 0008 FLAG=0x00 OP_187
    r[(3)](U(T,(3)+1,(4)))
    -- PC 0009 FLAG=0x40 OP_100
    return
    -- PC 0010 FLAG=0xD2 OP_137
    r[(3)]=__ENV[('PlayerPos')]
    -- PC 0011 FLAG=0x80 OP_183
    do local I={ r[(3)](U(T,(3)+1,(3))) };local F=0;for U=(3),(4) do F=F+1;T[U]=I[F] end end
    -- PC 0012 FLAG=0xC0 OP_264 [linear-fusion-payloads=3]
    r[(5)]={}; -- 融合载荷：r[(5)]={}; -- 融合载荷：r[(5)]=__ENV[(0)]; -- 融合载荷：r[(5)]=r[(0)]
    -- PC 0013 FLAG=0xC0 OP_230 [linear-fusion-payloads=2]
    r[(6)]={}; -- 融合载荷：r[(6)]=__ENV[(0)]; -- 融合载荷：r[(6)]=r[(0)]
    -- PC 0014 FLAG=0x52 OP_071 [linear-fusion-payloads=1]
    r[(7)]=__ENV[('ipairs')]; -- 融合载荷：r[(7)]=r[('ipairs')]
    -- PC 0015 FLAG=0x80 OP_308
    r[(8)]=r[(1)]
    -- PC 0016 FLAG=0xC0 OP_233
    do local I={ r[(7)](U(T,(7)+1,(8))) };local F=0;for U=(7),(9) do F=F+1;T[U]=I[F] end end
    -- PC 0017 FLAG=0xC2 OP_140 [jump-target=102]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(101)
    -- PC 0018 FLAG=0x60 OP_053
    r[(12)]=r[(11)][('mName')]
    -- PC 0019 FLAG=0xC0 OP_342
    if (not not r[(12)])~=((1)~=0) then pc=pc+1 end
    -- PC 0020 FLAG=0x42 OP_255 [jump-target=31]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(30)
    -- PC 0021 FLAG=0xA0 OP_053
    r[(12)]=r[(11)][('mONameStr')]
    -- PC 0022 FLAG=0xC0 OP_342
    if (not not r[(12)])~=((1)~=0) then pc=pc+1 end
    -- PC 0023 FLAG=0x02 OP_140 [jump-target=31]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(30)
    -- PC 0024 FLAG=0xE0 OP_375
    r[(12)]=r[(11)][('Name')]
    -- PC 0025 FLAG=0x80 OP_342
    if (not not r[(12)])~=((1)~=0) then pc=pc+1 end
    -- PC 0026 FLAG=0x42 OP_255 [jump-target=31]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(30)
    -- PC 0027 FLAG=0xA0 OP_032
    r[(12)]=r[(11)][('name')]
    -- PC 0028 FLAG=0x40 OP_342
    if (not not r[(12)])~=((1)~=0) then pc=pc+1 end
    -- PC 0029 FLAG=0x42 OP_140 [jump-target=31]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(30)
    -- PC 0030 FLAG=0x12 OP_165 [linear-fusion-payloads=1]
    r[(12)]=(''); -- 融合载荷：r[(12)]=r[('')][(nil)]
    -- PC 0031 FLAG=0x60 OP_032
    r[(13)]=r[(11)][('mCurrMapX')]
    -- PC 0032 FLAG=0x40 OP_342
    if (not not r[(13)])~=((1)~=0) then pc=pc+1 end
    -- PC 0033 FLAG=0xC2 OP_140 [jump-target=41]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(40)
    -- PC 0034 FLAG=0xE0 OP_363
    r[(13)]=r[(11)][('MapX')]
    -- PC 0035 FLAG=0xC0 OP_342
    if (not not r[(13)])~=((1)~=0) then pc=pc+1 end
    -- PC 0036 FLAG=0x82 OP_215 [jump-target=41]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(40)
    -- PC 0037 FLAG=0x20 OP_375
    r[(13)]=r[(11)][('mapX')]
    -- PC 0038 FLAG=0xC0 OP_342
    if (not not r[(13)])~=((1)~=0) then pc=pc+1 end
    -- PC 0039 FLAG=0x82 OP_215 [jump-target=41]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(40)
    -- PC 0040 FLAG=0xA0 OP_049 [linear-fusion-payloads=1]
    r[(13)]=r[(11)][('x')]; -- 融合载荷：r[(13)]=r[(11)][('x')]
    -- PC 0041 FLAG=0xA0 OP_032
    r[(14)]=r[(11)][('mCurrMapY')]
    -- PC 0042 FLAG=0x40 OP_342
    if (not not r[(14)])~=((1)~=0) then pc=pc+1 end
    -- PC 0043 FLAG=0x02 OP_215 [jump-target=51]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(50)
    -- PC 0044 FLAG=0xA0 OP_375
    r[(14)]=r[(11)][('MapY')]
    -- PC 0045 FLAG=0x40 OP_342
    if (not not r[(14)])~=((1)~=0) then pc=pc+1 end
    -- PC 0046 FLAG=0x42 OP_215 [jump-target=51]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(50)
    -- PC 0047 FLAG=0xA0 OP_363
    r[(14)]=r[(11)][('mapY')]
    -- PC 0048 FLAG=0x80 OP_342
    if (not not r[(14)])~=((1)~=0) then pc=pc+1 end
    -- PC 0049 FLAG=0x42 OP_255 [jump-target=51]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(50)
    -- PC 0050 FLAG=0x60 OP_032
    r[(14)]=r[(11)][('y')]
    -- PC 0051 FLAG=0x80 OP_016
    if (not not r[(13)])~=((0)~=0) then pc=pc+1 end
    -- PC 0052 FLAG=0x42 OP_255 [jump-target=102]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(101)
    -- PC 0053 FLAG=0x40 OP_016
    if (not not r[(14)])~=((0)~=0) then pc=pc+1 end
    -- PC 0054 FLAG=0x82 OP_255 [jump-target=102]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(101)
    -- PC 0055 FLAG=0x92 OP_397 [linear-fusion-payloads=1]
    r[(15)]=__ENV[('math')]; -- 融合载荷：r[(15)]=r[('math')][(nil)]
    -- PC 0056 FLAG=0x60 OP_384 [linear-fusion-payloads=1]
    r[(15)]=r[(15)][('abs')]; -- 融合载荷：r[(15)]=r[(15)]-r[('abs')]
    -- PC 0057 FLAG=0x00 OP_340
    r[(16)]=r[(3)]-r[(13)]
    -- PC 0058 FLAG=0xC0 OP_068
    r[(15)]=r[(15)](U(T,(15)+1,(16)))
    -- PC 0059 FLAG=0x92 OP_021 [linear-fusion-payloads=2]
    r[(16)]=__ENV[('math')]; -- 融合载荷：r[(16)]=r[('math')][(nil)]; -- 融合载荷：r[(16)]=r[('math')]-r[(nil)]
    -- PC 0060 FLAG=0x60 OP_384 [linear-fusion-payloads=1]
    r[(16)]=r[(16)][('abs')]; -- 融合载荷：r[(16)]=r[(16)]-r[('abs')]
    -- PC 0061 FLAG=0x40 OP_340
    r[(17)]=r[(4)]-r[(14)]
    -- PC 0062 FLAG=0x00 OP_098
    r[(16)]=r[(16)](U(T,(16)+1,(17)))
    -- PC 0063 FLAG=0x00 OP_273 [linear-fusion-payloads=3]
    r[(15)]=r[(15)]+r[(16)]; -- 融合载荷：r[(15)]=(15); -- 融合载荷：r[(15)]=__ENV[(15)]; -- 融合载荷：r[(15)]=r[(15)]
    -- PC 0064 FLAG=0xD2 OP_173 [linear-fusion-payloads=2]
    r[(16)]=(0.0); -- 融合载荷：r[(16)]=__ENV[(0.0)]; -- 融合载荷：r[(16)]=r[(0.0)]
    -- PC 0065 FLAG=0x12 OP_137
    r[(17)]=__ENV[('ipairs')]
    -- PC 0066 FLAG=0x40 OP_308
    r[(18)]=r[(0)]
    -- PC 0067 FLAG=0xC0 OP_359
    do local I={ r[(17)](U(T,(17)+1,(18))) };local F=0;for U=(17),(19) do F=F+1;T[U]=I[F] end end
    -- PC 0068 FLAG=0x02 OP_140 [jump-target=78]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(77)
    -- PC 0069 FLAG=0x52 OP_010 [linear-fusion-payloads=3]
    r[(22)]=__ENV[('string')]; -- 融合载荷：r[(22)]=r[('string')][(nil)]; -- 融合载荷：r[(22)]=r[('string')]; -- 融合载荷：r[(22)]=r[('string')]
    -- PC 0070 FLAG=0x60 OP_269 [linear-fusion-payloads=2]
    r[(22)]=r[(22)][('find')]; -- 融合载荷：r[(22)]=r[(22)]; -- 融合载荷：r[(22)]=r[(22)]
    -- PC 0071 FLAG=0x00 OP_078 [linear-fusion-payloads=1]
    r[(23)]=r[(12)]; -- 融合载荷：r[(23)]=r[(12)]
    -- PC 0072 FLAG=0xC0 OP_184
    r[(24)]=r[(21)]
    -- PC 0073 FLAG=0x00 OP_068
    r[(22)]=r[(22)](U(T,(22)+1,(24)))
    -- PC 0074 FLAG=0x40 OP_016
    if (not not r[(22)])~=((0)~=0) then pc=pc+1 end
    -- PC 0075 FLAG=0x02 OP_215 [jump-target=78]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(77)
    -- PC 0076 FLAG=0xC0 OP_308
    r[(16)]=r[(20)]
    -- PC 0077 FLAG=0x42 OP_215 [jump-target=80]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(79)
    -- PC 0078 FLAG=0x40 OP_386
    do local I,F=E(r[(17)](r[(17)+1],r[(17)+2]));for U=1,(2) do T[(17)+2+U]=I[U] end;if r[(17)+3]==nil then pc=pc+1 else r[(17)+2]=r[(17)+3] end end
    -- PC 0079 FLAG=0x02 OP_255 [jump-target=69]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(68)
    -- PC 0080 FLAG=0x10 OP_352
    if ((0.0)<r[(16)])~=((0)~=0) then pc=pc+1 end
    -- PC 0081 FLAG=0x42 OP_140 [jump-target=93]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(92)
    -- PC 0082 FLAG=0xD2 OP_137
    r[(17)]=__ENV[('table')]
    -- PC 0083 FLAG=0x20 OP_051 [linear-fusion-payloads=4]
    r[(17)]=r[(17)][('insert')]; -- 融合载荷：r[(17)]=r[(17)]; -- 融合载荷：r[(17)]={}; -- 融合载荷：do local I=(17);local F=r[('insert')];r[(17)][I]=F end; -- 融合载荷：do local I=(17);local F=r[('insert')];r[(17)][I]=F end
    -- PC 0084 FLAG=0xC0 OP_249 [linear-fusion-payloads=6]
    r[(18)]=r[(5)]; -- 融合载荷：r[(18)]={}; -- 融合载荷：do local I=(5);local F=r[(0)];r[(18)][I]=F end; -- 融合载荷：do local I=(5);local F=r[(0)];r[(18)][I]=F end; -- 融合载荷：do local I=(5);local F=r[(0)];r[(18)][I]=F end; -- 融合载荷：do local I=(5);local F=r[(0)];r[(18)][I]=F end; -- 融合载荷：do local I=(5);local F=r[(0)];r[(18)][I]=F end
    -- PC 0085 FLAG=0xC0 OP_148 [linear-fusion-payloads=5]
    r[(19)]={}; -- 融合载荷：do local I=(0);local F=r[(5)];r[(19)][I]=F end; -- 融合载荷：do local I=(0);local F=r[(5)];r[(19)][I]=F end; -- 融合载荷：do local I=(0);local F=r[(5)];r[(19)][I]=F end; -- 融合载荷：do local I=(0);local F=r[(5)];r[(19)][I]=F end; -- 融合载荷：do local I=(0);local F=r[(5)];r[(19)][I]=F end
    -- PC 0086 FLAG=0xD0 OP_268
    do local I=('item');local F=r[(11)];r[(19)][I]=F end
    -- PC 0087 FLAG=0x50 OP_076 [linear-fusion-payloads=3]
    do local I=('dist');local F=r[(15)];r[(19)][I]=F end; -- 融合载荷：do local I=('dist');local F=r[(15)];r[(19)][I]=F end; -- 融合载荷：do local I=('dist');local F=r[(15)];r[(19)][I]=F end; -- 融合载荷：do local I=('dist');local F=r[(15)];r[(19)][I]=F end
    -- PC 0088 FLAG=0x50 OP_119 [linear-fusion-payloads=2]
    do local I=('kIdx');local F=r[(16)];r[(19)][I]=F end; -- 融合载荷：do local I=('kIdx');local F=r[(16)];r[(19)][I]=F end; -- 融合载荷：do local I=('kIdx');local F=r[(16)];r[(19)][I]=F end
    -- PC 0089 FLAG=0x50 OP_268
    do local I=('x');local F=r[(13)];r[(19)][I]=F end
    -- PC 0090 FLAG=0x50 OP_268
    do local I=('y');local F=r[(14)];r[(19)][I]=F end
    -- PC 0091 FLAG=0x40 OP_187
    r[(17)](U(T,(17)+1,(19)))
    -- PC 0092 FLAG=0x82 OP_140 [jump-target=102]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(101)
    -- PC 0093 FLAG=0x92 OP_350 [linear-fusion-payloads=7]
    r[(17)]=__ENV[('table')]; -- 融合载荷：r[(17)]=r[('table')][(nil)]; -- 融合载荷：r[(17)]=r[('table')]; -- 融合载荷：r[(17)]={}; -- 融合载荷：do local I=('table');local F=r[(nil)];r[(17)][I]=F end; -- 融合载荷：do local I=('table');local F=r[(nil)];r[(17)][I]=F end; -- 融合载荷：do local I=('table');local F=r[(nil)];r[(17)][I]=F end; -- 融合载荷：do local I=('table');local F=r[(nil)];r[(17)][I]=F end
    -- PC 0094 FLAG=0xE0 OP_360 [linear-fusion-payloads=6]
    r[(17)]=r[(17)][('insert')]; -- 融合载荷：r[(17)]=r[(17)]; -- 融合载荷：r[(17)]={}; -- 融合载荷：do local I=(17);local F=r[('insert')];r[(17)][I]=F end; -- 融合载荷：do local I=(17);local F=r[('insert')];r[(17)][I]=F end; -- 融合载荷：do local I=(17);local F=r[('insert')];r[(17)][I]=F end; -- 融合载荷：do local I=(17);local F=r[('insert')];r[(17)][I]=F end
    -- PC 0095 FLAG=0xC0 OP_399 [linear-fusion-payloads=5]
    r[(18)]=r[(6)]; -- 融合载荷：r[(18)]={}; -- 融合载荷：do local I=(6);local F=r[(0)];r[(18)][I]=F end; -- 融合载荷：do local I=(6);local F=r[(0)];r[(18)][I]=F end; -- 融合载荷：do local I=(6);local F=r[(0)];r[(18)][I]=F end; -- 融合载荷：do local I=(6);local F=r[(0)];r[(18)][I]=F end
    -- PC 0096 FLAG=0x80 OP_041 [linear-fusion-payloads=4]
    r[(19)]={}; -- 融合载荷：do local I=(0);local F=r[(4)];r[(19)][I]=F end; -- 融合载荷：do local I=(0);local F=r[(4)];r[(19)][I]=F end; -- 融合载荷：do local I=(0);local F=r[(4)];r[(19)][I]=F end; -- 融合载荷：do local I=(0);local F=r[(4)];r[(19)][I]=F end
    -- PC 0097 FLAG=0xD0 OP_076 [linear-fusion-payloads=3]
    do local I=('item');local F=r[(11)];r[(19)][I]=F end; -- 融合载荷：do local I=('item');local F=r[(11)];r[(19)][I]=F end; -- 融合载荷：do local I=('item');local F=r[(11)];r[(19)][I]=F end; -- 融合载荷：do local I=('item');local F=r[(11)];r[(19)][I]=F end
    -- PC 0098 FLAG=0x10 OP_119 [linear-fusion-payloads=2]
    do local I=('dist');local F=r[(15)];r[(19)][I]=F end; -- 融合载荷：do local I=('dist');local F=r[(15)];r[(19)][I]=F end; -- 融合载荷：do local I=('dist');local F=r[(15)];r[(19)][I]=F end
    -- PC 0099 FLAG=0x50 OP_285 [linear-fusion-payloads=1]
    do local I=('x');local F=r[(13)];r[(19)][I]=F end; -- 融合载荷：do local I=('x');local F=r[(13)];r[(19)][I]=F end
    -- PC 0100 FLAG=0x50 OP_268
    do local I=('y');local F=r[(14)];r[(19)][I]=F end
    -- PC 0101 FLAG=0x40 OP_358
    r[(17)](U(T,(17)+1,(19)))
    -- PC 0102 FLAG=0x40 OP_386
    do local I,F=E(r[(7)](r[(7)+1],r[(7)+2]));for U=1,(2) do T[(7)+2+U]=I[U] end;if r[(7)+3]==nil then pc=pc+1 else r[(7)+2]=r[(7)+3] end end
    -- PC 0103 FLAG=0x02 OP_255 [jump-target=18]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(17)
    -- PC 0104 FLAG=0xC0 OP_027 [closure-child-index=0; captures=0; child-path=root/22/1]
    do local I=O[(0)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(7)]=M(I,U,S) end
    -- PC 0105 FLAG=0xD2 OP_307 [linear-fusion-payloads=2]
    r[(8)]=__ENV[('table')]; -- 融合载荷：r[(8)]=r[('table')][(nil)]; -- 融合载荷：r[(8)]=r[('table')]
    -- PC 0106 FLAG=0xA0 OP_363
    r[(8)]=r[(8)][('sort')]
    -- PC 0107 FLAG=0x80 OP_078 [linear-fusion-payloads=1]
    r[(9)]=r[(5)]; -- 融合载荷：r[(9)]=r[(5)]
    -- PC 0108 FLAG=0x40 OP_308
    r[(10)]=r[(7)]
    -- PC 0109 FLAG=0x00 OP_187
    r[(8)](U(T,(8)+1,(10)))
    -- PC 0110 FLAG=0x92 OP_307 [linear-fusion-payloads=2]
    r[(8)]=__ENV[('table')]; -- 融合载荷：r[(8)]=r[('table')][(nil)]; -- 融合载荷：r[(8)]=r[('table')]
    -- PC 0111 FLAG=0x60 OP_398 [linear-fusion-payloads=1]
    r[(8)]=r[(8)][('sort')]; -- 融合载荷：r[(8)]=r[(8)]
    -- PC 0112 FLAG=0x00 OP_184
    r[(9)]=r[(6)]
    -- PC 0113 FLAG=0xC0 OP_027 [closure-child-index=1; captures=0; child-path=root/22/2]
    do local I=O[(1)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(10)]=M(I,U,S) end
    -- PC 0114 FLAG=0x00 OP_187
    r[(8)](U(T,(8)+1,(10)))
    -- PC 0115 FLAG=0x80 OP_120
    r[(8)]={}
    -- PC 0116 FLAG=0x12 OP_071 [linear-fusion-payloads=1]
    r[(9)]=__ENV[('ipairs')]; -- 融合载荷：r[(9)]=r[('ipairs')]
    -- PC 0117 FLAG=0x80 OP_308
    r[(10)]=r[(5)]
    -- PC 0118 FLAG=0xC0 OP_183
    do local I={ r[(9)](U(T,(9)+1,(10))) };local F=0;for U=(9),(11) do F=F+1;T[U]=I[F] end end
    -- PC 0119 FLAG=0x42 OP_140 [jump-target=125]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(124)
    -- PC 0120 FLAG=0xD2 OP_010 [linear-fusion-payloads=3]
    r[(14)]=__ENV[('table')]; -- 融合载荷：r[(14)]=r[('table')][(nil)]; -- 融合载荷：r[(14)]=r[('table')]; -- 融合载荷：r[(14)]=r[('table')]
    -- PC 0121 FLAG=0xA0 OP_269 [linear-fusion-payloads=2]
    r[(14)]=r[(14)][('insert')]; -- 融合载荷：r[(14)]=r[(14)]; -- 融合载荷：r[(14)]=r[(14)]
    -- PC 0122 FLAG=0x00 OP_308
    r[(15)]=r[(8)]
    -- PC 0123 FLAG=0x40 OP_308
    r[(16)]=r[(13)]
    -- PC 0124 FLAG=0x00 OP_358
    r[(14)](U(T,(14)+1,(16)))
    -- PC 0125 FLAG=0xC0 OP_117
    do local I,F=E(r[(9)](r[(9)+1],r[(9)+2]));for U=1,(2) do T[(9)+2+U]=I[U] end;if r[(9)+3]==nil then pc=pc+1 else r[(9)+2]=r[(9)+3] end end
    -- PC 0126 FLAG=0x42 OP_255 [jump-target=120]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(119)
    -- PC 0127 FLAG=0xD2 OP_137
    r[(9)]=__ENV[('ipairs')]
    -- PC 0128 FLAG=0x00 OP_184
    r[(10)]=r[(6)]
    -- PC 0129 FLAG=0xC0 OP_183
    do local I={ r[(9)](U(T,(9)+1,(10))) };local F=0;for U=(9),(11) do F=F+1;T[U]=I[F] end end
    -- PC 0130 FLAG=0x02 OP_255 [jump-target=136]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(135)
    -- PC 0131 FLAG=0x52 OP_397 [linear-fusion-payloads=1]
    r[(14)]=__ENV[('table')]; -- 融合载荷：r[(14)]=r[('table')][(nil)]
    -- PC 0132 FLAG=0xE0 OP_269 [linear-fusion-payloads=2]
    r[(14)]=r[(14)][('insert')]; -- 融合载荷：r[(14)]=r[(14)]; -- 融合载荷：r[(14)]=r[(14)]
    -- PC 0133 FLAG=0x40 OP_078 [linear-fusion-payloads=1]
    r[(15)]=r[(8)]; -- 融合载荷：r[(15)]=r[(8)]
    -- PC 0134 FLAG=0xC0 OP_184
    r[(16)]=r[(13)]
    -- PC 0135 FLAG=0xC0 OP_187
    r[(14)](U(T,(14)+1,(16)))
    -- PC 0136 FLAG=0x80 OP_117
    do local I,F=E(r[(9)](r[(9)+1],r[(9)+2]));for U=1,(2) do T[(9)+2+U]=I[U] end;if r[(9)+3]==nil then pc=pc+1 else r[(9)+2]=r[(9)+3] end end
    -- PC 0137 FLAG=0x82 OP_215 [jump-target=131]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(130)
    -- PC 0138 FLAG=0x40 OP_115
    r[(9)]=#r[(8)]
    -- PC 0139 FLAG=0x60 OP_092
    if (r[(9)]==(0.0))~=((0)~=0) then pc=pc+1 end
    -- PC 0140 FLAG=0x82 OP_140 [jump-target=142]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(141)
    -- PC 0141 FLAG=0x80 OP_250
    return
    -- PC 0142 FLAG=0xA0 OP_042 [linear-fusion-payloads=4]
    r[(9)]=r[(8)][(1.0)]; -- 融合载荷：r[(9)]=__ENV[(8)]; -- 融合载荷：r[(9)]=r[(8)][(1.0)]; -- 融合载荷：r[(9)]=r[(8)][(1.0)]; -- 融合载荷：r[(9)]=(8)
    -- PC 0143 FLAG=0x92 OP_137
    r[(10)]=__ENV[('MoveTo')]
    -- PC 0144 FLAG=0xE0 OP_312 [linear-fusion-payloads=2]
    r[(11)]=r[(9)][('x')]; -- 融合载荷：r[(11)]=r[(9)][('x')]; -- 融合载荷：r[(11)]=(9)
    -- PC 0145 FLAG=0xE0 OP_363
    r[(12)]=r[(9)][('y')]
    -- PC 0146 FLAG=0x92 OP_371
    r[(13)]=(0.0)
    -- PC 0147 FLAG=0xC0 OP_358
    r[(10)](U(T,(10)+1,(13)))
    -- PC 0148 FLAG=0x52 OP_137
    r[(10)]=__ENV[('math')]
    -- PC 0149 FLAG=0xE0 OP_228 [linear-fusion-payloads=2]
    r[(10)]=r[(10)][('abs')]; -- 融合载荷：r[(10)]=r[(10)][('abs')]; -- 融合载荷：r[(10)]=r[(10)]-r[('abs')]
    -- PC 0150 FLAG=0xE0 OP_032
    r[(11)]=r[(9)][('x')]
    -- PC 0151 FLAG=0xC0 OP_340
    r[(11)]=r[(3)]-r[(11)]
    -- PC 0152 FLAG=0xC0 OP_068
    r[(10)]=r[(10)](U(T,(10)+1,(11)))
    -- PC 0153 FLAG=0xA0 OP_216
    if (r[(10)]<=(1.0))~=((0)~=0) then pc=pc+1 end
    -- PC 0154 FLAG=0xC2 OP_255 [jump-target=166]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(165)
    -- PC 0155 FLAG=0x52 OP_137
    r[(10)]=__ENV[('math')]
    -- PC 0156 FLAG=0xE0 OP_375
    r[(10)]=r[(10)][('abs')]
    -- PC 0157 FLAG=0xE0 OP_384 [linear-fusion-payloads=1]
    r[(11)]=r[(9)][('y')]; -- 融合载荷：r[(11)]=r[(9)]-r[('y')]
    -- PC 0158 FLAG=0x80 OP_340
    r[(11)]=r[(4)]-r[(11)]
    -- PC 0159 FLAG=0x80 OP_098
    r[(10)]=r[(10)](U(T,(10)+1,(11)))
    -- PC 0160 FLAG=0x20 OP_216
    if (r[(10)]<=(1.0))~=((0)~=0) then pc=pc+1 end
    -- PC 0161 FLAG=0x42 OP_140 [jump-target=166]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(165)
    -- PC 0162 FLAG=0x12 OP_137
    r[(10)]=__ENV[('global')]
    -- PC 0163 FLAG=0x60 OP_053
    r[(10)]=r[(10)][('dropItemController')]
    -- PC 0164 FLAG=0xA0 OP_121
    local I=r[(10)];r[(10)+1]=I;r[(10)]=I[('PickMainPlayerPosItem')]
    -- PC 0165 FLAG=0x00 OP_187
    r[(10)](U(T,(10)+1,(11)))
    -- PC 0166 FLAG=0x40 OP_130
    r[(10)]=up[(0)]
    -- PC 0167 FLAG=0x12 OP_165 [linear-fusion-payloads=1]
    r[(11)]=('拾取: '); -- 融合载荷：r[(11)]=r[('拾取: ')][(nil)]
    -- PC 0168 FLAG=0xE0 OP_281 [linear-fusion-payloads=2]
    r[(12)]=r[(9)][('item')]; -- 融合载荷：r[(12)]=r[(9)][('item')]; -- 融合载荷：do local I=r[('item')];for F=('item')-1,(9),-1 do I=T[F]..I end;r[(12)]=I end
    -- PC 0169 FLAG=0x60 OP_097 [linear-fusion-payloads=1]
    r[(12)]=r[(12)][('mName')]; -- 融合载荷：do local I=r[('mName')];for F=('mName')-1,(12),-1 do I=T[F]..I end;r[(12)]=I end
    -- PC 0170 FLAG=0x40 OP_210
    do local I=r[(12)];for F=(12)-1,(11),-1 do I=T[F]..I end;r[(11)]=I end
    -- PC 0171 FLAG=0x40 OP_187
    r[(10)](U(T,(10)+1,(11)))
    -- PC 0172 FLAG=0xC0 OP_055
    return
end
-- 原型入口：proto_GetMapData2DPtr_root_22

-- ============================================================================
-- 原型 root/22/1 | 候选名称：Prototype_root_22_1 | 指令记录：19 | 子原型：0 | 可变参数：2
-- 字节范围：17860:18062
local function proto_Prototype_root_22_1_root_22_1(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'dist'
    -- K[1] = 'kIdx'
    -- 指令语义：
    -- PC 0001 FLAG=0xE0 OP_049 [linear-fusion-payloads=1]
    r[(2)]=r[(0)][('kIdx')]; -- 融合载荷：r[(2)]=r[(0)][('kIdx')]
    -- PC 0002 FLAG=0xE0 OP_032
    r[(3)]=r[(1)][('kIdx')]
    -- PC 0003 FLAG=0x80 OP_381
    if (r[(2)]==r[(3)])~=((1)~=0) then pc=pc+1 end
    -- PC 0004 FLAG=0x42 OP_215 [jump-target=12]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(11)
    -- PC 0005 FLAG=0x20 OP_049 [linear-fusion-payloads=1]
    r[(2)]=r[(0)][('kIdx')]; -- 融合载荷：r[(2)]=r[(0)][('kIdx')]
    -- PC 0006 FLAG=0xA0 OP_032
    r[(3)]=r[(1)][('kIdx')]
    -- PC 0007 FLAG=0x00 OP_180
    if (r[(2)]<r[(3)])~=((1)~=0) then pc=pc+1 end
    -- PC 0008 FLAG=0x82 OP_140 [jump-target=10]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(9)
    -- PC 0009 FLAG=0xC0 OP_082
    r[(2)]=(0)~=0;if (1)~=0 then pc=pc+1 end
    -- PC 0010 FLAG=0x80 OP_011
    r[(2)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0011 FLAG=0x00 OP_220
    return U(T,(2),(2))
    -- PC 0012 FLAG=0xA0 OP_049 [linear-fusion-payloads=1]
    r[(2)]=r[(0)][('dist')]; -- 融合载荷：r[(2)]=r[(0)][('dist')]
    -- PC 0013 FLAG=0x20 OP_363
    r[(3)]=r[(1)][('dist')]
    -- PC 0014 FLAG=0xC0 OP_002
    if (r[(2)]<r[(3)])~=((1)~=0) then pc=pc+1 end
    -- PC 0015 FLAG=0xC2 OP_215 [jump-target=17]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(16)
    -- PC 0016 FLAG=0x80 OP_082
    r[(2)]=(0)~=0;if (1)~=0 then pc=pc+1 end
    -- PC 0017 FLAG=0xC0 OP_401
    r[(2)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0018 FLAG=0x80 OP_220
    return U(T,(2),(2))
    -- PC 0019 FLAG=0xC0 OP_250
    return
end
-- 原型入口：proto_Prototype_root_22_1_root_22_1

-- ============================================================================
-- 原型 root/22/2 | 候选名称：Prototype_root_22_2 | 指令记录：8 | 子原型：0 | 可变参数：2
-- 字节范围：18062:18156
local function proto_Prototype_root_22_2_root_22_2(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'dist'
    -- 指令语义：
    -- PC 0001 FLAG=0x60 OP_049 [linear-fusion-payloads=1]
    r[(2)]=r[(0)][('dist')]; -- 融合载荷：r[(2)]=r[(0)][('dist')]
    -- PC 0002 FLAG=0xE0 OP_375
    r[(3)]=r[(1)][('dist')]
    -- PC 0003 FLAG=0xC0 OP_219
    if (r[(2)]<r[(3)])~=((1)~=0) then pc=pc+1 end
    -- PC 0004 FLAG=0x02 OP_255 [jump-target=6]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(5)
    -- PC 0005 FLAG=0x80 OP_082
    r[(2)]=(0)~=0;if (1)~=0 then pc=pc+1 end
    -- PC 0006 FLAG=0xC0 OP_338
    r[(2)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0007 FLAG=0x00 OP_220
    return U(T,(2),(2))
    -- PC 0008 FLAG=0x00 OP_001
    return
end
-- 原型入口：proto_Prototype_root_22_2_root_22_2

-- ============================================================================
-- 原型 root/23 | 候选名称：Builtsetting | 指令记录：144 | 子原型：0 | 可变参数：5
-- 字节范围：18157:19639
local function proto_Builtsetting_root_23(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'GetMapData2DPtr'
    -- K[1] = 'abs'
    -- K[2] = 'isObstacle'
    -- K[3] = ['unknown', 2]
    -- K[4] = 10000.0
    -- K[5] = 'getMapDataCols'
    -- K[6] = 0.0
    -- K[7] = 'global'
    -- K[8] = 'floor'
    -- K[9] = 'math'
    -- K[10] = 1.0
    -- K[11] = 2.0
    -- K[12] = 'getMapDataRows'
    -- K[13] = 'max'
    -- K[14] = 'sceneManager'
    -- 指令语义：
    -- PC 0001 FLAG=0x00 OP_016
    if (not not r[(0)])~=((0)~=0) then pc=pc+1 end
    -- PC 0002 FLAG=0x02 OP_215 [jump-target=11]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(10)
    -- PC 0003 FLAG=0x80 OP_016
    if (not not r[(1)])~=((0)~=0) then pc=pc+1 end
    -- PC 0004 FLAG=0x42 OP_140 [jump-target=11]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(10)
    -- PC 0005 FLAG=0x00 OP_016
    if (not not r[(2)])~=((0)~=0) then pc=pc+1 end
    -- PC 0006 FLAG=0x02 OP_215 [jump-target=11]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(10)
    -- PC 0007 FLAG=0x80 OP_016
    if (not not r[(3)])~=((0)~=0) then pc=pc+1 end
    -- PC 0008 FLAG=0x02 OP_140 [jump-target=11]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(10)
    -- PC 0009 FLAG=0x40 OP_342
    if (not not r[(4)])~=((1)~=0) then pc=pc+1 end
    -- PC 0010 FLAG=0x42 OP_255 [jump-target=13]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(12)
    -- PC 0011 FLAG=0xC0 OP_248
    for I=(5),(5) do T[I]=nil end
    -- PC 0012 FLAG=0x80 OP_220
    return U(T,(5),(5))
    -- PC 0013 FLAG=0xC0 OP_099
    if (r[(0)]==r[(2)])~=((0)~=0) then pc=pc+1 end
    -- PC 0014 FLAG=0x02 OP_215 [jump-target=19]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(18)
    -- PC 0015 FLAG=0x00 OP_099
    if (r[(1)]==r[(3)])~=((0)~=0) then pc=pc+1 end
    -- PC 0016 FLAG=0xC2 OP_140 [jump-target=19]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(18)
    -- PC 0017 FLAG=0x52 OP_371
    r[(5)]=(0.0)
    -- PC 0018 FLAG=0x40 OP_220
    return U(T,(5),(5))
    -- PC 0019 FLAG=0x20 OP_216
    if (r[(4)]<=(0.0))~=((0)~=0) then pc=pc+1 end
    -- PC 0020 FLAG=0x42 OP_255 [jump-target=23]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(22)
    -- PC 0021 FLAG=0x40 OP_125
    for I=(5),(5) do T[I]=nil end
    -- PC 0022 FLAG=0x80 OP_220
    return U(T,(5),(5))
    -- PC 0023 FLAG=0x12 OP_397 [linear-fusion-payloads=1]
    r[(5)]=__ENV[('math')]; -- 融合载荷：r[(5)]=r[('math')][(nil)]
    -- PC 0024 FLAG=0xA0 OP_375
    r[(5)]=r[(5)][('max')]
    -- PC 0025 FLAG=0x52 OP_021 [linear-fusion-payloads=2]
    r[(6)]=__ENV[('math')]; -- 融合载荷：r[(6)]=r[('math')][(nil)]; -- 融合载荷：r[(6)]=r[('math')]-r[(nil)]
    -- PC 0026 FLAG=0x60 OP_384 [linear-fusion-payloads=1]
    r[(6)]=r[(6)][('abs')]; -- 融合载荷：r[(6)]=r[(6)]-r[('abs')]
    -- PC 0027 FLAG=0x40 OP_340
    r[(7)]=r[(2)]-r[(0)]
    -- PC 0028 FLAG=0x40 OP_098
    r[(6)]=r[(6)](U(T,(6)+1,(7)))
    -- PC 0029 FLAG=0x12 OP_021 [linear-fusion-payloads=2]
    r[(7)]=__ENV[('math')]; -- 融合载荷：r[(7)]=r[('math')][(nil)]; -- 融合载荷：r[(7)]=r[('math')]-r[(nil)]
    -- PC 0030 FLAG=0xA0 OP_384 [linear-fusion-payloads=1]
    r[(7)]=r[(7)][('abs')]; -- 融合载荷：r[(7)]=r[(7)]-r[('abs')]
    -- PC 0031 FLAG=0x40 OP_340
    r[(8)]=r[(3)]-r[(1)]
    -- PC 0032 FLAG=0x40 OP_252
    do local I,F=E(r[(7)](U(T,(7)+1,(8))));(8)=F+(7)-1;local U=0;for L=(7),(8) do U=U+1;T[L]=I[U] end end
    -- PC 0033 FLAG=0x40 OP_242
    r[(5)]=r[(5)](U(T,(5)+1,(0)))
    -- PC 0034 FLAG=0xC0 OP_219
    if (r[(4)]<r[(5)])~=((0)~=0) then pc=pc+1 end
    -- PC 0035 FLAG=0x42 OP_215 [jump-target=38]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(37)
    -- PC 0036 FLAG=0xC0 OP_125
    for I=(5),(5) do T[I]=nil end
    -- PC 0037 FLAG=0xC0 OP_220
    return U(T,(5),(5))
    -- PC 0038 FLAG=0x52 OP_137
    r[(5)]=__ENV[('global')]
    -- PC 0039 FLAG=0xE0 OP_375
    r[(5)]=r[(5)][('sceneManager')]
    -- PC 0040 FLAG=0x80 OP_016
    if (not not r[(5)])~=((0)~=0) then pc=pc+1 end
    -- PC 0041 FLAG=0xC2 OP_215 [jump-target=46]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(45)
    -- PC 0042 FLAG=0x52 OP_309 [linear-fusion-payloads=2]
    r[(5)]=__ENV[('global')]; -- 融合载荷：r[(5)]=r[('global')][(nil)]; -- 融合载荷：local I=r[('global')];r[(5)+1]=I;r[(5)]=I[(nil)]
    -- PC 0043 FLAG=0xA0 OP_270 [linear-fusion-payloads=1]
    r[(5)]=r[(5)][('sceneManager')]; -- 融合载荷：local I=r[(5)];r[(5)+1]=I;r[(5)]=I[('sceneManager')]
    -- PC 0044 FLAG=0xA0 OP_121
    local I=r[(5)];r[(5)+1]=I;r[(5)]=I[('GetMapData2DPtr')]
    -- PC 0045 FLAG=0xC0 OP_068
    r[(5)]=r[(5)](U(T,(5)+1,(6)))
    -- PC 0046 FLAG=0xC0 OP_342
    if (not not r[(5)])~=((1)~=0) then pc=pc+1 end
    -- PC 0047 FLAG=0x02 OP_140 [jump-target=50]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(49)
    -- PC 0048 FLAG=0x40 OP_125
    for I=(6),(6) do T[I]=nil end
    -- PC 0049 FLAG=0x00 OP_220
    return U(T,(6),(6))
    -- PC 0050 FLAG=0xA0 OP_121
    local I=r[(5)];r[(6)+1]=I;r[(6)]=I[('getMapDataRows')]
    -- PC 0051 FLAG=0x80 OP_068
    r[(6)]=r[(6)](U(T,(6)+1,(7)))
    -- PC 0052 FLAG=0xE0 OP_238
    local I=r[(5)];r[(7)+1]=I;r[(7)]=I[('getMapDataCols')]
    -- PC 0053 FLAG=0x40 OP_068
    r[(7)]=r[(7)](U(T,(7)+1,(8)))
    -- PC 0054 FLAG=0x20 OP_043
    if (r[(2)]<(0.0))~=((1)~=0) then pc=pc+1 end
    -- PC 0055 FLAG=0x02 OP_140 [jump-target=62]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(61)
    -- PC 0056 FLAG=0x60 OP_043
    if (r[(3)]<(0.0))~=((1)~=0) then pc=pc+1 end
    -- PC 0057 FLAG=0x82 OP_215 [jump-target=62]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(61)
    -- PC 0058 FLAG=0x80 OP_236
    if (r[(7)]<=r[(2)])~=((1)~=0) then pc=pc+1 end
    -- PC 0059 FLAG=0x42 OP_255 [jump-target=62]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(61)
    -- PC 0060 FLAG=0xC0 OP_236
    if (r[(6)]<=r[(3)])~=((0)~=0) then pc=pc+1 end
    -- PC 0061 FLAG=0x42 OP_215 [jump-target=64]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(63)
    -- PC 0062 FLAG=0x00 OP_248
    for I=(8),(8) do T[I]=nil end
    -- PC 0063 FLAG=0x80 OP_220
    return U(T,(8),(8))
    -- PC 0064 FLAG=0x20 OP_136 [linear-fusion-payloads=2]
    local I=r[(5)];r[(8)+1]=I;r[(8)]=I[('isObstacle')]; -- 融合载荷：r[(8)]=r[(5)]; -- 融合载荷：r[(8)]=r[(5)]
    -- PC 0065 FLAG=0xC0 OP_078 [linear-fusion-payloads=1]
    r[(10)]=r[(2)]; -- 融合载荷：r[(10)]=r[(2)]
    -- PC 0066 FLAG=0xC0 OP_308
    r[(11)]=r[(3)]
    -- PC 0067 FLAG=0x40 OP_098
    r[(8)]=r[(8)](U(T,(8)+1,(11)))
    -- PC 0068 FLAG=0xA0 OP_045
    if (r[(8)]==(0.0))~=((1)~=0) then pc=pc+1 end
    -- PC 0069 FLAG=0x02 OP_140 [jump-target=72]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(71)
    -- PC 0070 FLAG=0xC0 OP_234
    for I=(8),(8) do T[I]=nil end
    -- PC 0071 FLAG=0xC0 OP_220
    return U(T,(8),(8))
    -- PC 0072 FLAG=0x00 OP_120
    r[(8)]={}
    -- PC 0073 FLAG=0xC0 OP_316
    r[(9)]=r[(0)]*r[(6)]
    -- PC 0074 FLAG=0x00 OP_029
    r[(9)]=r[(9)]+r[(1)]
    -- PC 0075 FLAG=0xA0 OP_283
    do local I=r[(9)];local F=(0.0);r[(8)][I]=F end
    -- PC 0076 FLAG=0xC0 OP_410
    r[(9)]={}
    -- PC 0077 FLAG=0x00 OP_316
    r[(10)]=r[(0)]*r[(6)]
    -- PC 0078 FLAG=0x00 OP_155
    r[(10)]=r[(10)]+r[(1)]
    -- PC 0079 FLAG=0xC0 OP_112
    do local I=(1);if I==0 then I=math.max(0,(1)-(9)) end;local F=r[(9)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(9)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(9)]=O else for O=1,I do F[L+O]=T[(9)+O] end end;end
    -- PC 0080 FLAG=0x52 OP_371
    r[(10)]=(1.0)
    -- PC 0081 FLAG=0xC0 OP_115
    r[(11)]=#r[(9)]
    -- PC 0082 FLAG=0x40 OP_236
    if (r[(10)]<=r[(11)])~=((0)~=0) then pc=pc+1 end
    -- PC 0083 FLAG=0x42 OP_255 [jump-target=142]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(141)
    -- PC 0084 FLAG=0x50 OP_364
    if ((10000.0)<r[(10)])~=((0)~=0) then pc=pc+1 end
    -- PC 0085 FLAG=0x02 OP_255 [jump-target=88]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(87)
    -- PC 0086 FLAG=0x40 OP_234
    for I=(11),(11) do T[I]=nil end
    -- PC 0087 FLAG=0xC0 OP_220
    return U(T,(11),(11))
    -- PC 0088 FLAG=0x80 OP_304
    r[(11)]=r[(9)][r[(10)]]
    -- PC 0089 FLAG=0x20 OP_124
    r[(10)]=r[(10)]+(1.0)
    -- PC 0090 FLAG=0x40 OP_231
    r[(12)]=r[(8)][r[(11)]]
    -- PC 0091 FLAG=0x00 OP_002
    if (r[(12)]<r[(4)])~=((0)~=0) then pc=pc+1 end
    -- PC 0092 FLAG=0x42 OP_215 [jump-target=81]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(80)
    -- PC 0093 FLAG=0xD2 OP_137
    r[(13)]=__ENV[('math')]
    -- PC 0094 FLAG=0xA0 OP_032
    r[(13)]=r[(13)][('floor')]
    -- PC 0095 FLAG=0xC0 OP_240
    r[(14)]=r[(11)]/r[(6)]
    -- PC 0096 FLAG=0x40 OP_098
    r[(13)]=r[(13)](U(T,(13)+1,(14)))
    -- PC 0097 FLAG=0x40 OP_280
    r[(14)]=r[(11)]%r[(6)]
    -- PC 0098 FLAG=0x52 OP_346
    r[(15)]=(1.0)
    -- PC 0099 FLAG=0x80 OP_324 [linear-fusion-payloads=1]
    r[(16)]=up[(0)]; -- 融合载荷：r[(16)]=#r[(0)]
    -- PC 0100 FLAG=0x00 OP_115
    r[(16)]=#r[(16)]
    -- PC 0101 FLAG=0x92 OP_371
    r[(17)]=(1.0)
    -- PC 0102 FLAG=0x02 OP_023 [jump-target=140]
    r[(15)]=r[(15)]-r[(15)+2];pc=(139)
    -- PC 0103 FLAG=0x40 OP_028 [linear-fusion-payloads=1]
    r[(19)]=up[(0)]; -- 融合载荷：r[(19)]=r[(0)][r[(0)]]
    -- PC 0104 FLAG=0x40 OP_304
    r[(19)]=r[(19)][r[(18)]]
    -- PC 0105 FLAG=0x20 OP_363
    r[(19)]=r[(19)][(1.0)]
    -- PC 0106 FLAG=0xC0 OP_155
    r[(19)]=r[(13)]+r[(19)]
    -- PC 0107 FLAG=0xC0 OP_028 [linear-fusion-payloads=1]
    r[(20)]=up[(0)]; -- 融合载荷：r[(20)]=r[(0)][r[(0)]]
    -- PC 0108 FLAG=0x00 OP_231
    r[(20)]=r[(20)][r[(18)]]
    -- PC 0109 FLAG=0x60 OP_032
    r[(20)]=r[(20)][(2.0)]
    -- PC 0110 FLAG=0x00 OP_029
    r[(20)]=r[(14)]+r[(20)]
    -- PC 0111 FLAG=0x50 OP_048
    if ((0.0)<=r[(19)])~=((0)~=0) then pc=pc+1 end
    -- PC 0112 FLAG=0x42 OP_215 [jump-target=140]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(139)
    -- PC 0113 FLAG=0x90 OP_150
    if ((0.0)<=r[(20)])~=((0)~=0) then pc=pc+1 end
    -- PC 0114 FLAG=0x82 OP_255 [jump-target=140]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(139)
    -- PC 0115 FLAG=0xC0 OP_002
    if (r[(19)]<r[(7)])~=((0)~=0) then pc=pc+1 end
    -- PC 0116 FLAG=0x82 OP_140 [jump-target=140]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(139)
    -- PC 0117 FLAG=0x40 OP_180
    if (r[(20)]<r[(6)])~=((0)~=0) then pc=pc+1 end
    -- PC 0118 FLAG=0x02 OP_140 [jump-target=140]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(139)
    -- PC 0119 FLAG=0x60 OP_136 [linear-fusion-payloads=2]
    local I=r[(5)];r[(21)+1]=I;r[(21)]=I[('isObstacle')]; -- 融合载荷：r[(21)]=r[(5)]; -- 融合载荷：r[(21)]=r[(5)]
    -- PC 0120 FLAG=0x00 OP_078 [linear-fusion-payloads=1]
    r[(23)]=r[(19)]; -- 融合载荷：r[(23)]=r[(19)]
    -- PC 0121 FLAG=0x40 OP_184
    r[(24)]=r[(20)]
    -- PC 0122 FLAG=0x40 OP_068
    r[(21)]=r[(21)](U(T,(21)+1,(24)))
    -- PC 0123 FLAG=0x20 OP_045
    if (r[(21)]==(0.0))~=((0)~=0) then pc=pc+1 end
    -- PC 0124 FLAG=0x42 OP_215 [jump-target=140]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(139)
    -- PC 0125 FLAG=0x40 OP_316
    r[(21)]=r[(19)]*r[(6)]
    -- PC 0126 FLAG=0xC0 OP_155
    r[(21)]=r[(21)]+r[(20)]
    -- PC 0127 FLAG=0xC0 OP_231
    r[(22)]=r[(8)][r[(21)]]
    -- PC 0128 FLAG=0x60 OP_279
    if (r[(22)]==(['unknown', 2]))~=((0)~=0) then pc=pc+1 end
    -- PC 0129 FLAG=0xC2 OP_215 [jump-target=140]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(139)
    -- PC 0130 FLAG=0xA0 OP_124
    r[(22)]=r[(12)]+(1.0)
    -- PC 0131 FLAG=0xC0 OP_294
    if (r[(19)]==r[(2)])~=((0)~=0) then pc=pc+1 end
    -- PC 0132 FLAG=0x02 OP_215 [jump-target=136]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(135)
    -- PC 0133 FLAG=0x00 OP_294
    if (r[(20)]==r[(3)])~=((0)~=0) then pc=pc+1 end
    -- PC 0134 FLAG=0x02 OP_215 [jump-target=136]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(135)
    -- PC 0135 FLAG=0x80 OP_220
    return U(T,(22),(22))
    -- PC 0136 FLAG=0x80 OP_174
    do local I=r[(21)];local F=r[(22)];r[(8)][I]=F end
    -- PC 0137 FLAG=0x40 OP_115
    r[(23)]=#r[(9)]
    -- PC 0138 FLAG=0x20 OP_124
    r[(23)]=r[(23)]+(1.0)
    -- PC 0139 FLAG=0x40 OP_368
    do local I=r[(23)];local F=r[(21)];r[(9)][I]=F end
    -- PC 0140 FLAG=0x02 OP_126 [loop-target=103]
    do local I=(15);local F=T[I+2];local U=T[I]+F;T[I]=U;local L=T[I+1];if (F>0 and U<=L) or (F<=0 and U>=L) then T[I+3]=U;pc=(102) end end
    -- PC 0141 FLAG=0x82 OP_140 [jump-target=81]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(80)
    -- PC 0142 FLAG=0x00 OP_125
    for I=(11),(11) do T[I]=nil end
    -- PC 0143 FLAG=0xC0 OP_220
    return U(T,(11),(11))
    -- PC 0144 FLAG=0x40 OP_001
    return
end
-- 原型入口：proto_Builtsetting_root_23

-- ============================================================================
-- 原型 root/24 | 候选名称：UseItemByIndex | 指令记录：55 | 子原型：0 | 可变参数：0
-- 字节范围：19639:20373
local function proto_UseItemByIndex_root_24(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 58.0
    -- K[1] = 'CHANGE_SETTING'
    -- K[2] = 2005.0
    -- K[3] = 57.0
    -- K[4] = '关闭屏蔽怪物'
    -- K[5] = '关闭游戏音乐'
    -- K[6] = 0.0
    -- K[7] = '开启人物简装'
    -- K[8] = 1002.0
    -- K[9] = '开启怪物简装'
    -- K[10] = '关闭高帧率'
    -- K[11] = 27.0
    -- K[12] = 1.0
    -- K[13] = 52.0
    -- K[14] = '关闭背景音乐'
    -- 指令语义：
    -- PC 0001 FLAG=0xD2 OP_168 [linear-fusion-payloads=1]
    r[(0)]=__ENV[('CHANGE_SETTING')]; -- 融合载荷：r[(0)]=('CHANGE_SETTING')
    -- PC 0002 FLAG=0xD2 OP_371
    r[(1)]=(27.0)
    -- PC 0003 FLAG=0x40 OP_090 [linear-fusion-payloads=1]
    r[(2)]={}; -- 融合载荷：r[(2)]=(1)
    -- PC 0004 FLAG=0xD2 OP_346
    r[(3)]=(0.0)
    -- PC 0005 FLAG=0x40 OP_153
    do local I=(1);if I==0 then I=math.max(0,(1)-(2)) end;local F=r[(2)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(2)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(2)]=O else for O=1,I do F[L+O]=T[(2)+O] end end;end
    -- PC 0006 FLAG=0x80 OP_358
    r[(0)](U(T,(0)+1,(2)))
    -- PC 0007 FLAG=0x80 OP_134 [linear-fusion-payloads=1]
    r[(0)]=up[(0)]; -- 融合载荷：r[(0)]=(0)
    -- PC 0008 FLAG=0x92 OP_371
    r[(1)]=('关闭背景音乐')
    -- PC 0009 FLAG=0xC0 OP_187
    r[(0)](U(T,(0)+1,(1)))
    -- PC 0010 FLAG=0x92 OP_168 [linear-fusion-payloads=1]
    r[(0)]=__ENV[('CHANGE_SETTING')]; -- 融合载荷：r[(0)]=('CHANGE_SETTING')
    -- PC 0011 FLAG=0xD2 OP_346
    r[(1)]=(52.0)
    -- PC 0012 FLAG=0xC0 OP_410
    r[(2)]={}
    -- PC 0013 FLAG=0x52 OP_346
    r[(3)]=(0.0)
    -- PC 0014 FLAG=0x00 OP_402
    do local I=(1);if I==0 then I=math.max(0,(1)-(2)) end;local F=r[(2)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(2)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(2)]=O else for O=1,I do F[L+O]=T[(2)+O] end end;end
    -- PC 0015 FLAG=0x00 OP_358
    r[(0)](U(T,(0)+1,(2)))
    -- PC 0016 FLAG=0x00 OP_130
    r[(0)]=up[(0)]
    -- PC 0017 FLAG=0xD2 OP_371
    r[(1)]=('关闭游戏音乐')
    -- PC 0018 FLAG=0xC0 OP_358
    r[(0)](U(T,(0)+1,(1)))
    -- PC 0019 FLAG=0x92 OP_168 [linear-fusion-payloads=1]
    r[(0)]=__ENV[('CHANGE_SETTING')]; -- 融合载荷：r[(0)]=('CHANGE_SETTING')
    -- PC 0020 FLAG=0xD2 OP_371
    r[(1)]=(1002.0)
    -- PC 0021 FLAG=0x00 OP_120
    r[(2)]={}
    -- PC 0022 FLAG=0x52 OP_346
    r[(3)]=(0.0)
    -- PC 0023 FLAG=0x80 OP_237
    do local I=(1);if I==0 then I=math.max(0,(1)-(2)) end;local F=r[(2)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(2)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(2)]=O else for O=1,I do F[L+O]=T[(2)+O] end end;end
    -- PC 0024 FLAG=0xC0 OP_187
    r[(0)](U(T,(0)+1,(2)))
    -- PC 0025 FLAG=0x00 OP_130
    r[(0)]=up[(0)]
    -- PC 0026 FLAG=0x52 OP_371
    r[(1)]=('关闭高帧率')
    -- PC 0027 FLAG=0xC0 OP_358
    r[(0)](U(T,(0)+1,(1)))
    -- PC 0028 FLAG=0x52 OP_137
    r[(0)]=__ENV[('CHANGE_SETTING')]
    -- PC 0029 FLAG=0x92 OP_040 [linear-fusion-payloads=2]
    r[(1)]=(57.0); -- 融合载荷：r[(1)]={}; -- 融合载荷：r[(1)]=(57.0)
    -- PC 0030 FLAG=0x00 OP_090 [linear-fusion-payloads=1]
    r[(2)]={}; -- 融合载荷：r[(2)]=(1)
    -- PC 0031 FLAG=0xD2 OP_346
    r[(3)]=(1.0)
    -- PC 0032 FLAG=0x80 OP_112
    do local I=(1);if I==0 then I=math.max(0,(1)-(2)) end;local F=r[(2)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(2)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(2)]=O else for O=1,I do F[L+O]=T[(2)+O] end end;end
    -- PC 0033 FLAG=0x80 OP_358
    r[(0)](U(T,(0)+1,(2)))
    -- PC 0034 FLAG=0xC0 OP_134 [linear-fusion-payloads=1]
    r[(0)]=up[(0)]; -- 融合载荷：r[(0)]=(0)
    -- PC 0035 FLAG=0x52 OP_346
    r[(1)]=('开启人物简装')
    -- PC 0036 FLAG=0x00 OP_187
    r[(0)](U(T,(0)+1,(1)))
    -- PC 0037 FLAG=0x52 OP_137
    r[(0)]=__ENV[('CHANGE_SETTING')]
    -- PC 0038 FLAG=0x92 OP_040 [linear-fusion-payloads=2]
    r[(1)]=(58.0); -- 融合载荷：r[(1)]={}; -- 融合载荷：r[(1)]=(58.0)
    -- PC 0039 FLAG=0x40 OP_090 [linear-fusion-payloads=1]
    r[(2)]={}; -- 融合载荷：r[(2)]=(1)
    -- PC 0040 FLAG=0x92 OP_346
    r[(3)]=(1.0)
    -- PC 0041 FLAG=0x80 OP_088
    do local I=(1);if I==0 then I=math.max(0,(1)-(2)) end;local F=r[(2)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(2)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(2)]=O else for O=1,I do F[L+O]=T[(2)+O] end end;end
    -- PC 0042 FLAG=0x00 OP_358
    r[(0)](U(T,(0)+1,(2)))
    -- PC 0043 FLAG=0x80 OP_130
    r[(0)]=up[(0)]
    -- PC 0044 FLAG=0xD2 OP_371
    r[(1)]=('开启怪物简装')
    -- PC 0045 FLAG=0x00 OP_358
    r[(0)](U(T,(0)+1,(1)))
    -- PC 0046 FLAG=0x52 OP_137
    r[(0)]=__ENV[('CHANGE_SETTING')]
    -- PC 0047 FLAG=0xD2 OP_346
    r[(1)]=(2005.0)
    -- PC 0048 FLAG=0x80 OP_105
    r[(2)]={}
    -- PC 0049 FLAG=0x12 OP_371
    r[(3)]=(0.0)
    -- PC 0050 FLAG=0x40 OP_112
    do local I=(1);if I==0 then I=math.max(0,(1)-(2)) end;local F=r[(2)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(2)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(2)]=O else for O=1,I do F[L+O]=T[(2)+O] end end;end
    -- PC 0051 FLAG=0xC0 OP_187
    r[(0)](U(T,(0)+1,(2)))
    -- PC 0052 FLAG=0x40 OP_130
    r[(0)]=up[(0)]
    -- PC 0053 FLAG=0x12 OP_371
    r[(1)]=('关闭屏蔽怪物')
    -- PC 0054 FLAG=0xC0 OP_187
    r[(0)](U(T,(0)+1,(1)))
    -- PC 0055 FLAG=0x40 OP_100
    return
end
-- 原型入口：proto_UseItemByIndex_root_24

-- ============================================================================
-- 原型 root/25 | 候选名称：DeathAutoBlacklist | 指令记录：33 | 子原型：0 | 可变参数：0
-- 字节范围：20373:20797
local function proto_DeathAutoBlacklist_root_25(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'GetMetaValue'
    -- K[1] = 'ITEM_COUNT'
    -- K[2] = 'ipairs'
    -- K[3] = 'tonumber'
    -- K[4] = 'ITEM_INDEX_BY_NAME'
    -- K[5] = 'SL'
    -- K[6] = 'UseItemByIndex'
    -- K[7] = 0.0
    -- 指令语义：
    -- PC 0001 FLAG=0x92 OP_095 [linear-fusion-payloads=1]
    r[(0)]=__ENV[('ipairs')]; -- 融合载荷：r[(0)]=up[('ipairs')]
    -- PC 0002 FLAG=0xC0 OP_130
    r[(1)]=up[(0)]
    -- PC 0003 FLAG=0x40 OP_233
    do local I={ r[(0)](U(T,(0)+1,(1))) };local F=0;for U=(0),(2) do F=F+1;T[U]=I[F] end end
    -- PC 0004 FLAG=0x42 OP_255 [jump-target=29]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(28)
    -- PC 0005 FLAG=0x92 OP_191 [linear-fusion-payloads=3]
    r[(5)]=__ENV[('SL')]; -- 融合载荷：local I=r[('SL')];r[(5)+1]=I;r[(5)]=I[(nil)]; -- 融合载荷：r[(5)]=('SL'); -- 融合载荷：r[(5)]=r[('SL')]
    -- PC 0006 FLAG=0x20 OP_186 [linear-fusion-payloads=2]
    local I=r[(5)];r[(5)+1]=I;r[(5)]=I[('GetMetaValue')]; -- 融合载荷：r[(5)]=(5); -- 融合载荷：r[(5)]=r[(5)]
    -- PC 0007 FLAG=0xD2 OP_346
    r[(7)]=('ITEM_INDEX_BY_NAME')
    -- PC 0008 FLAG=0xC0 OP_308
    r[(8)]=r[(4)]
    -- PC 0009 FLAG=0xC0 OP_068
    r[(5)]=r[(5)](U(T,(5)+1,(8)))
    -- PC 0010 FLAG=0x92 OP_137
    r[(6)]=__ENV[('tonumber')]
    -- PC 0011 FLAG=0x52 OP_191 [linear-fusion-payloads=3]
    r[(7)]=__ENV[('SL')]; -- 融合载荷：local I=r[('SL')];r[(7)+1]=I;r[(7)]=I[(nil)]; -- 融合载荷：r[(7)]=('SL'); -- 融合载荷：r[(7)]=r[('SL')]
    -- PC 0012 FLAG=0xA0 OP_186 [linear-fusion-payloads=2]
    local I=r[(7)];r[(7)+1]=I;r[(7)]=I[('GetMetaValue')]; -- 融合载荷：r[(7)]=(7); -- 融合载荷：r[(7)]=r[(7)]
    -- PC 0013 FLAG=0xD2 OP_286 [linear-fusion-payloads=1]
    r[(9)]=('ITEM_COUNT'); -- 融合载荷：r[(9)]=r[('ITEM_COUNT')]
    -- PC 0014 FLAG=0x00 OP_308
    r[(10)]=r[(4)]
    -- PC 0015 FLAG=0x40 OP_252
    do local I,F=E(r[(7)](U(T,(7)+1,(10))));(10)=F+(7)-1;local U=0;for L=(7),(10) do U=U+1;T[L]=I[U] end end
    -- PC 0016 FLAG=0x80 OP_223
    r[(6)]=r[(6)](U(T,(6)+1,(0)))
    -- PC 0017 FLAG=0x00 OP_342
    if (not not r[(6)])~=((1)~=0) then pc=pc+1 end
    -- PC 0018 FLAG=0x42 OP_140 [jump-target=20]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(19)
    -- PC 0019 FLAG=0x92 OP_371
    r[(6)]=(0.0)
    -- PC 0020 FLAG=0x40 OP_016
    if (not not r[(5)])~=((0)~=0) then pc=pc+1 end
    -- PC 0021 FLAG=0x42 OP_140 [jump-target=29]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(28)
    -- PC 0022 FLAG=0x50 OP_364
    if ((0.0)<r[(6)])~=((0)~=0) then pc=pc+1 end
    -- PC 0023 FLAG=0xC2 OP_140 [jump-target=29]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(28)
    -- PC 0024 FLAG=0x12 OP_300 [linear-fusion-payloads=2]
    r[(7)]=__ENV[('SL')]; -- 融合载荷：local I=r[('SL')];r[(7)+1]=I;r[(7)]=I[(nil)]; -- 融合载荷：r[(7)]=r[('SL')]
    -- PC 0025 FLAG=0xE0 OP_142 [linear-fusion-payloads=1]
    local I=r[(7)];r[(7)+1]=I;r[(7)]=I[('UseItemByIndex')]; -- 融合载荷：r[(7)]=r[(7)]
    -- PC 0026 FLAG=0x80 OP_184
    r[(9)]=r[(5)]
    -- PC 0027 FLAG=0x40 OP_358
    r[(7)](U(T,(7)+1,(9)))
    -- PC 0028 FLAG=0xC0 OP_220
    return U(T,(4),(4))
    -- PC 0029 FLAG=0x40 OP_339
    do local I,F=E(r[(0)](r[(0)+1],r[(0)+2]));for U=1,(2) do T[(0)+2+U]=I[U] end;if r[(0)+3]==nil then pc=pc+1 else r[(0)+2]=r[(0)+3] end end
    -- PC 0030 FLAG=0xC2 OP_140 [jump-target=5]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(4)
    -- PC 0031 FLAG=0xC0 OP_234
    for I=(0),(0) do T[I]=nil end
    -- PC 0032 FLAG=0xC0 OP_220
    return U(T,(0),(0))
    -- PC 0033 FLAG=0x80 OP_250
    return
end
-- 原型入口：proto_DeathAutoBlacklist_root_25

-- ============================================================================
-- 原型 root/26 | 候选名称：ResetGatherMonsterData | 指令记录：47 | 子原型：1 | 可变参数：0
-- 字节范围：20797:21597
local function proto_ResetGatherMonsterData_root_26(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 5.0
    -- K[1] = '被 %s 击杀，自动加入黑名单'
    -- K[2] = 'ScheduleOnce'
    -- K[3] = '本次死亡没记录到凶手，跳过自动拉黑'
    -- K[4] = 'lastAttacker'
    -- K[5] = ['unknown', 2]
    -- K[6] = ''
    -- K[7] = 1.0
    -- K[8] = 0.0
    -- K[9] = '自动拉黑：'
    -- K[10] = '凶手已在黑名单中：%s'
    -- K[11] = 'id'
    -- K[12] = 0.5
    -- K[13] = 'SL'
    -- K[14] = 'name'
    -- 指令语义：
    -- PC 0001 FLAG=0x80 OP_159 [linear-fusion-payloads=1]
    r[(0)]=up[(0)]; -- 融合载荷：r[(0)]=r[(0)][(0)]
    -- PC 0002 FLAG=0x20 OP_375
    r[(0)]=r[(0)][('lastAttacker')]
    -- PC 0003 FLAG=0x00 OP_089 [linear-fusion-payloads=1]
    r[(1)]=up[(0)]; -- 融合载荷：do local I=(0);local F=(0);r[(1)][I]=F end
    -- PC 0004 FLAG=0x70 OP_156
    do local I=('lastAttacker');local F=(['unknown', 2]);r[(1)][I]=F end
    -- PC 0005 FLAG=0xC0 OP_016
    if (not not r[(0)])~=((0)~=0) then pc=pc+1 end
    -- PC 0006 FLAG=0x42 OP_255 [jump-target=13]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(12)
    -- PC 0007 FLAG=0xE0 OP_032
    r[(1)]=r[(0)][('name')]
    -- PC 0008 FLAG=0xC0 OP_016
    if (not not r[(1)])~=((0)~=0) then pc=pc+1 end
    -- PC 0009 FLAG=0x02 OP_140 [jump-target=13]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(12)
    -- PC 0010 FLAG=0xE0 OP_032
    r[(1)]=r[(0)][('name')]
    -- PC 0011 FLAG=0xE0 OP_045
    if (r[(1)]==(''))~=((0)~=0) then pc=pc+1 end
    -- PC 0012 FLAG=0x82 OP_255 [jump-target=17]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(16)
    -- PC 0013 FLAG=0x80 OP_134 [linear-fusion-payloads=1]
    r[(1)]=up[(1)]; -- 融合载荷：r[(1)]=(1)
    -- PC 0014 FLAG=0x12 OP_371
    r[(2)]=('本次死亡没记录到凶手，跳过自动拉黑')
    -- PC 0015 FLAG=0x40 OP_358
    r[(1)](U(T,(1)+1,(2)))
    -- PC 0016 FLAG=0x40 OP_100
    return
    -- PC 0017 FLAG=0xC0 OP_130
    r[(1)]=up[(2)]
    -- PC 0018 FLAG=0x60 OP_053
    r[(2)]=r[(0)][('id')]
    -- PC 0019 FLAG=0x80 OP_068
    r[(1)]=r[(1)](U(T,(1)+1,(2)))
    -- PC 0020 FLAG=0x00 OP_016
    if (not not r[(1)])~=((0)~=0) then pc=pc+1 end
    -- PC 0021 FLAG=0x02 OP_140 [jump-target=27]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(26)
    -- PC 0022 FLAG=0x00 OP_134 [linear-fusion-payloads=1]
    r[(1)]=up[(1)]; -- 融合载荷：r[(1)]=(1)
    -- PC 0023 FLAG=0x12 OP_165 [linear-fusion-payloads=1]
    r[(2)]=('凶手已在黑名单中：%s'); -- 融合载荷：r[(2)]=r[('凶手已在黑名单中：%s')][(nil)]
    -- PC 0024 FLAG=0xA0 OP_375
    r[(3)]=r[(0)][('name')]
    -- PC 0025 FLAG=0x00 OP_358
    r[(1)](U(T,(1)+1,(3)))
    -- PC 0026 FLAG=0x80 OP_001
    return
    -- PC 0027 FLAG=0x80 OP_134 [linear-fusion-payloads=1]
    r[(1)]=up[(1)]; -- 融合载荷：r[(1)]=(1)
    -- PC 0028 FLAG=0x52 OP_165 [linear-fusion-payloads=1]
    r[(2)]=('被 %s 击杀，自动加入黑名单'); -- 融合载荷：r[(2)]=r[('被 %s 击杀，自动加入黑名单')][(nil)]
    -- PC 0029 FLAG=0x20 OP_053
    r[(3)]=r[(0)][('name')]
    -- PC 0030 FLAG=0x80 OP_187
    r[(1)](U(T,(1)+1,(3)))
    -- PC 0031 FLAG=0xC0 OP_130
    r[(1)]=up[(3)]
    -- PC 0032 FLAG=0x12 OP_091 [linear-fusion-payloads=2]
    r[(2)]=('自动拉黑：'); -- 融合载荷：r[(2)]=r[('自动拉黑：')][(nil)]; -- 融合载荷：do local I=r[(nil)];for F=(nil)-1,('自动拉黑：'),-1 do I=T[F]..I end;r[(2)]=I end
    -- PC 0033 FLAG=0x20 OP_097 [linear-fusion-payloads=1]
    r[(3)]=r[(0)][('name')]; -- 融合载荷：do local I=r[('name')];for F=('name')-1,(0),-1 do I=T[F]..I end;r[(3)]=I end
    -- PC 0034 FLAG=0xC0 OP_210
    do local I=r[(3)];for F=(3)-1,(2),-1 do I=T[F]..I end;r[(2)]=I end
    -- PC 0035 FLAG=0x80 OP_187
    r[(1)](U(T,(1)+1,(2)))
    -- PC 0036 FLAG=0x92 OP_061 [linear-fusion-payloads=2]
    r[(1)]=(0.0); -- 融合载荷：r[(1)]=(0.0); -- 融合载荷：r[(1)]=(0.0)
    -- PC 0037 FLAG=0x12 OP_282 [linear-fusion-payloads=1]
    r[(2)]=(5.0); -- 融合载荷：r[(2)]=(5.0)
    -- PC 0038 FLAG=0xD2 OP_346
    r[(3)]=(1.0)
    -- PC 0039 FLAG=0x02 OP_292 [jump-target=46]
    r[(1)]=r[(1)]-r[(1)+2];pc=(45)
    -- PC 0040 FLAG=0x52 OP_335 [linear-fusion-payloads=1]
    r[(5)]=__ENV[('SL')]; -- 融合载荷：local I=r[('SL')];r[(5)+1]=I;r[(5)]=I[(nil)]
    -- PC 0041 FLAG=0xE0 OP_121
    local I=r[(5)];r[(5)+1]=I;r[(5)]=I[('ScheduleOnce')]
    -- PC 0042 FLAG=0x00 OP_027 [linear-fusion-payloads=1, closure-child-index=0; captures=1; child-path=root/26/1]
    do local I=O[(0)];local F={};F[-1]=(1);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(1)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(7)]=M(I,U,S) end
    -- PC 0043 FLAG=0x00 OP_387
    r[(0)]=r[(0)]
    -- PC 0044 FLAG=0x50 OP_005
    r[(8)]=(0.5)*r[(4)]
    -- PC 0045 FLAG=0x80 OP_358
    r[(5)](U(T,(5)+1,(8)))
    -- PC 0046 FLAG=0x82 OP_126 [loop-target=40]
    do local I=(1);local F=T[I+2];local U=T[I]+F;T[I]=U;local L=T[I+1];if (F>0 and U<=L) or (F<=0 and U>=L) then T[I+3]=U;pc=(39) end end
    -- PC 0047 FLAG=0xC0 OP_055
    return
end
-- 原型入口：proto_ResetGatherMonsterData_root_26

-- ============================================================================
-- 原型 root/26/1 | 候选名称：Prototype_root_26_1 | 指令记录：6 | 子原型：0 | 可变参数：0
-- 字节范围：21483:21596
local function proto_Prototype_root_26_1_root_26_1(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'RequestAddBlacklistByName'
    -- K[1] = 'name'
    -- K[2] = 'SL'
    -- 指令语义：
    -- PC 0001 FLAG=0xD2 OP_137
    r[(0)]=__ENV[('SL')]
    -- PC 0002 FLAG=0xA0 OP_121
    local I=r[(0)];r[(0)+1]=I;r[(0)]=I[('RequestAddBlacklistByName')]
    -- PC 0003 FLAG=0x40 OP_159 [linear-fusion-payloads=1]
    r[(2)]=up[(0)]; -- 融合载荷：r[(2)]=r[(0)][(0)]
    -- PC 0004 FLAG=0x60 OP_375
    r[(2)]=r[(2)][('name')]
    -- PC 0005 FLAG=0x80 OP_358
    r[(0)](U(T,(0)+1,(2)))
    -- PC 0006 FLAG=0x80 OP_001
    return
end
-- 原型入口：proto_Prototype_root_26_1_root_26_1

-- ============================================================================
-- 原型 root/27 | 候选名称：StopGatherMonsters | 指令记录：20 | 子原型：0 | 可变参数：0
-- 字节范围：21597:21824
local function proto_StopGatherMonsters_root_27(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = '数据已重置'
    -- K[1] = 0.0
    -- K[2] = ''
    -- 指令语义：
    -- PC 0001 FLAG=0x40 OP_120
    r[(0)]={}
    -- PC 0002 FLAG=0x40 OP_114
    up[(0)]=r[(0)]
    -- PC 0003 FLAG=0x52 OP_371
    r[(0)]=(0.0)
    -- PC 0004 FLAG=0x80 OP_213 [linear-fusion-payloads=3]
    up[(1)]=r[(0)]; -- 融合载荷：r[(0)]=(1); -- 融合载荷：up[(1)]=r[(0)]; -- 融合载荷：r[(0)]=up[(1)]
    -- PC 0005 FLAG=0x92 OP_003 [linear-fusion-payloads=2]
    r[(0)]=(0.0); -- 融合载荷：up[(0.0)]=r[(0)]; -- 融合载荷：r[(0)]=up[(0.0)]
    -- PC 0006 FLAG=0xC0 OP_332 [linear-fusion-payloads=1]
    up[(2)]=r[(0)]; -- 融合载荷：r[(0)]=up[(2)]
    -- PC 0007 FLAG=0x00 OP_130
    r[(0)]=up[(3)]
    -- PC 0008 FLAG=0xC0 OP_187
    r[(0)](U(T,(0)+1,(0)))
    -- PC 0009 FLAG=0xC0 OP_338
    r[(0)]=(0)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0010 FLAG=0x40 OP_254 [linear-fusion-payloads=4]
    up[(4)]=r[(0)]; -- 融合载荷：r[(0)]=(4); -- 融合载荷：up[(4)]=r[(0)]; -- 融合载荷：for I=(0),(4) do T[I]=nil end; -- 融合载荷：up[(4)]=r[(0)]
    -- PC 0011 FLAG=0x92 OP_015 [linear-fusion-payloads=5]
    r[(0)]=(0.0); -- 融合载荷：up[(0.0)]=r[(0)]; -- 融合载荷：for I=(0),(0.0) do T[I]=nil end; -- 融合载荷：up[(0.0)]=r[(0)]; -- 融合载荷：r[(0)]=(0.0); -- 融合载荷：up[(0.0)]=r[(0)]
    -- PC 0012 FLAG=0x00 OP_067 [linear-fusion-payloads=6]
    up[(5)]=r[(0)]; -- 融合载荷：for I=(0),(5) do T[I]=nil end; -- 融合载荷：up[(5)]=r[(0)]; -- 融合载荷：r[(0)]=(5); -- 融合载荷：up[(5)]=r[(0)]; -- 融合载荷：r[(0)]=up[(5)]; -- 融合载荷：r[(0)]=(5)
    -- PC 0013 FLAG=0xC0 OP_125
    for I=(0),(0) do T[I]=nil end
    -- PC 0014 FLAG=0x00 OP_265 [linear-fusion-payloads=4]
    up[(6)]=r[(0)]; -- 融合载荷：r[(0)]=(6); -- 融合载荷：up[(6)]=r[(0)]; -- 融合载荷：r[(0)]=up[(6)]; -- 融合载荷：r[(0)]=(6)
    -- PC 0015 FLAG=0x92 OP_289 [linear-fusion-payloads=3]
    r[(0)]=(''); -- 融合载荷：up[('')]=r[(0)]; -- 融合载荷：r[(0)]=up[('')]; -- 融合载荷：r[(0)]=('')
    -- PC 0016 FLAG=0x40 OP_409 [linear-fusion-payloads=2]
    up[(7)]=r[(0)]; -- 融合载荷：r[(0)]=up[(7)]; -- 融合载荷：r[(0)]=(7)
    -- PC 0017 FLAG=0xC0 OP_134 [linear-fusion-payloads=1]
    r[(0)]=up[(8)]; -- 融合载荷：r[(0)]=(8)
    -- PC 0018 FLAG=0x52 OP_371
    r[(1)]=('数据已重置')
    -- PC 0019 FLAG=0x00 OP_187
    r[(0)](U(T,(0)+1,(1)))
    -- PC 0020 FLAG=0xC0 OP_001
    return
end
-- 原型入口：proto_StopGatherMonsters_root_27

-- ============================================================================
-- 原型 root/28 | 候选名称：FindMonsterCandidates | 指令记录：25 | 子原型：0 | 可变参数：0
-- 字节范围：21824:22136
local function proto_FindMonsterCandidates_root_28(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = '引怪功能已停止'
    -- K[1] = 'UnSchedule'
    -- K[2] = ['unknown', 2]
    -- K[3] = 'IDLE'
    -- K[4] = 'gatherTimer'
    -- K[5] = 'SL'
    -- 指令语义：
    -- PC 0001 FLAG=0x00 OP_338
    r[(0)]=(0)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0002 FLAG=0x80 OP_332 [linear-fusion-payloads=1]
    up[(0)]=r[(0)]; -- 融合载荷：r[(0)]=up[(0)]
    -- PC 0003 FLAG=0x00 OP_159 [linear-fusion-payloads=1]
    r[(0)]=up[(1)]; -- 融合载荷：r[(0)]=r[(1)][(0)]
    -- PC 0004 FLAG=0x20 OP_363
    r[(0)]=r[(0)][('gatherTimer')]
    -- PC 0005 FLAG=0xC0 OP_016
    if (not not r[(0)])~=((0)~=0) then pc=pc+1 end
    -- PC 0006 FLAG=0xC2 OP_215 [jump-target=14]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(13)
    -- PC 0007 FLAG=0x92 OP_335 [linear-fusion-payloads=1]
    r[(0)]=__ENV[('SL')]; -- 融合载荷：local I=r[('SL')];r[(0)+1]=I;r[(0)]=I[(nil)]
    -- PC 0008 FLAG=0xE0 OP_121
    local I=r[(0)];r[(0)+1]=I;r[(0)]=I[('UnSchedule')]
    -- PC 0009 FLAG=0x00 OP_159 [linear-fusion-payloads=1]
    r[(2)]=up[(1)]; -- 融合载荷：r[(2)]=r[(1)][(0)]
    -- PC 0010 FLAG=0xE0 OP_053
    r[(2)]=r[(2)][('gatherTimer')]
    -- PC 0011 FLAG=0xC0 OP_187
    r[(0)](U(T,(0)+1,(2)))
    -- PC 0012 FLAG=0xC0 OP_089 [linear-fusion-payloads=1]
    r[(0)]=up[(1)]; -- 融合载荷：do local I=(1);local F=(0);r[(0)][I]=F end
    -- PC 0013 FLAG=0x30 OP_146
    do local I=('gatherTimer');local F=(['unknown', 2]);r[(0)][I]=F end
    -- PC 0014 FLAG=0x00 OP_130
    r[(0)]=up[(2)]
    -- PC 0015 FLAG=0x40 OP_187
    r[(0)](U(T,(0)+1,(0)))
    -- PC 0016 FLAG=0xC0 OP_130
    r[(0)]=up[(3)]
    -- PC 0017 FLAG=0x40 OP_159 [linear-fusion-payloads=1]
    r[(1)]=up[(4)]; -- 融合载荷：r[(1)]=r[(4)][(0)]
    -- PC 0018 FLAG=0xE0 OP_032
    r[(1)]=r[(1)][('IDLE')]
    -- PC 0019 FLAG=0x40 OP_358
    r[(0)](U(T,(0)+1,(1)))
    -- PC 0020 FLAG=0xC0 OP_130
    r[(0)]=up[(5)]
    -- PC 0021 FLAG=0x80 OP_358
    r[(0)](U(T,(0)+1,(0)))
    -- PC 0022 FLAG=0x40 OP_134 [linear-fusion-payloads=1]
    r[(0)]=up[(6)]; -- 融合载荷：r[(0)]=(6)
    -- PC 0023 FLAG=0x92 OP_346
    r[(1)]=('引怪功能已停止')
    -- PC 0024 FLAG=0x80 OP_187
    r[(0)](U(T,(0)+1,(1)))
    -- PC 0025 FLAG=0x40 OP_250
    return
end
-- 原型入口：proto_FindMonsterCandidates_root_28

-- ============================================================================
-- 原型 root/29 | 候选名称：IsDie | 指令记录：102 | 子原型：1 | 可变参数：0
-- 字节范围：22136:23414
local function proto_IsDie_root_29(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'global'
    -- K[1] = 0.0
    -- K[2] = 'ipairs'
    -- K[3] = 'FindMonsterInCurrViewField'
    -- K[4] = 1.0
    -- K[5] = '未知怪物'
    -- K[6] = 'type'
    -- K[7] = 'SETTING_IDX_IGNORE_MONSTER'
    -- K[8] = 'SL'
    -- K[9] = 'insert'
    -- K[10] = 'GetName'
    -- K[11] = 'GET_SETTING'
    -- K[12] = 'table'
    -- K[13] = 'MMO'
    -- K[14] = 'sort'
    -- K[15] = '_distance'
    -- K[16] = 'GATHER_THRESHOLD'
    -- K[17] = 'pairs'
    -- K[18] = True
    -- 指令语义：
    -- PC 0001 FLAG=0x52 OP_335 [linear-fusion-payloads=1]
    r[(0)]=__ENV[('SL')]; -- 融合载荷：local I=r[('SL')];r[(0)+1]=I;r[(0)]=I[(nil)]
    -- PC 0002 FLAG=0xA0 OP_121
    local I=r[(0)];r[(0)+1]=I;r[(0)]=I[('FindMonsterInCurrViewField')]
    -- PC 0003 FLAG=0x00 OP_338
    r[(2)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0004 FLAG=0x00 OP_401
    r[(3)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0005 FLAG=0x40 OP_068
    r[(0)]=r[(0)](U(T,(0)+1,(3)))
    -- PC 0006 FLAG=0xC0 OP_016
    if (not not r[(0)])~=((0)~=0) then pc=pc+1 end
    -- PC 0007 FLAG=0x42 OP_140 [jump-target=11]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(10)
    -- PC 0008 FLAG=0xC0 OP_115
    r[(1)]=#r[(0)]
    -- PC 0009 FLAG=0x60 OP_279
    if (r[(1)]==(0.0))~=((0)~=0) then pc=pc+1 end
    -- PC 0010 FLAG=0x42 OP_255 [jump-target=13]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(12)
    -- PC 0011 FLAG=0x80 OP_105
    r[(1)]={}
    -- PC 0012 FLAG=0x00 OP_220
    return U(T,(1),(1))
    -- PC 0013 FLAG=0xC0 OP_077 [linear-fusion-payloads=1]
    r[(1)]={}; -- 融合载荷：r[(1)]=up[(0)]
    -- PC 0014 FLAG=0xC0 OP_130
    r[(2)]=up[(0)]
    -- PC 0015 FLAG=0x00 OP_098
    r[(2)]=r[(2)](U(T,(2)+1,(2)))
    -- PC 0016 FLAG=0x12 OP_376 [linear-fusion-payloads=3]
    r[(3)]=__ENV[('GET_SETTING')]; -- 融合载荷：r[(3)]=__ENV[('GET_SETTING')]; -- 融合载荷：r[(3)]=r[('GET_SETTING')][(nil)]; -- 融合载荷：r[(3)]=r[('GET_SETTING')][(nil)]
    -- PC 0017 FLAG=0xD2 OP_137
    r[(4)]=__ENV[('global')]
    -- PC 0018 FLAG=0x20 OP_375
    r[(4)]=r[(4)][('MMO')]
    -- PC 0019 FLAG=0x60 OP_053
    r[(4)]=r[(4)][('SETTING_IDX_IGNORE_MONSTER')]
    -- PC 0020 FLAG=0xC0 OP_098
    r[(3)]=r[(3)](U(T,(3)+1,(4)))
    -- PC 0021 FLAG=0xC0 OP_019 [linear-fusion-payloads=1]
    r[(4)]={}; -- 融合载荷：r[(4)]={}
    -- PC 0022 FLAG=0x40 OP_410
    r[(5)]={}
    -- PC 0023 FLAG=0x00 OP_016
    if (not not r[(3)])~=((0)~=0) then pc=pc+1 end
    -- PC 0024 FLAG=0x82 OP_215 [jump-target=47]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(46)
    -- PC 0025 FLAG=0xE0 OP_032
    r[(6)]=r[(3)][(1.0)]
    -- PC 0026 FLAG=0x40 OP_016
    if (not not r[(6)])~=((0)~=0) then pc=pc+1 end
    -- PC 0027 FLAG=0x82 OP_140 [jump-target=47]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(46)
    -- PC 0028 FLAG=0x92 OP_397 [linear-fusion-payloads=1]
    r[(6)]=__ENV[('type')]; -- 融合载荷：r[(6)]=r[('type')][(nil)]
    -- PC 0029 FLAG=0xE0 OP_032
    r[(7)]=r[(3)][(1.0)]
    -- PC 0030 FLAG=0x00 OP_068
    r[(6)]=r[(6)](U(T,(6)+1,(7)))
    -- PC 0031 FLAG=0xE0 OP_045
    if (r[(6)]==('table'))~=((0)~=0) then pc=pc+1 end
    -- PC 0032 FLAG=0x82 OP_255 [jump-target=47]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(46)
    -- PC 0033 FLAG=0x92 OP_397 [linear-fusion-payloads=1]
    r[(6)]=__ENV[('pairs')]; -- 融合载荷：r[(6)]=r[('pairs')][(nil)]
    -- PC 0034 FLAG=0x60 OP_032
    r[(7)]=r[(3)][(1.0)]
    -- PC 0035 FLAG=0xC0 OP_183
    do local I={ r[(6)](U(T,(6)+1,(7))) };local F=0;for U=(6),(8) do F=F+1;T[U]=I[F] end end
    -- PC 0036 FLAG=0x42 OP_255 [jump-target=45]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(44)
    -- PC 0037 FLAG=0xE0 OP_045
    if (r[(10)]==(1.0))~=((0)~=0) then pc=pc+1 end
    -- PC 0038 FLAG=0x82 OP_215 [jump-target=45]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(44)
    -- PC 0039 FLAG=0xE0 OP_109 [linear-fusion-payloads=4]
    do local I=r[(9)];local F=(true);r[(4)][I]=F end; -- 融合载荷：r[(4)]=__ENV[(9)]; -- 融合载荷：r[(4)]=r[(9)][(true)]; -- 融合载荷：r[(4)]=r[(9)]; -- 融合载荷：r[(4)]=r[(9)]
    -- PC 0040 FLAG=0x12 OP_010 [linear-fusion-payloads=3]
    r[(11)]=__ENV[('table')]; -- 融合载荷：r[(11)]=r[('table')][(nil)]; -- 融合载荷：r[(11)]=r[('table')]; -- 融合载荷：r[(11)]=r[('table')]
    -- PC 0041 FLAG=0xE0 OP_363
    r[(11)]=r[(11)][('insert')]
    -- PC 0042 FLAG=0x00 OP_078 [linear-fusion-payloads=1]
    r[(12)]=r[(5)]; -- 融合载荷：r[(12)]=r[(5)]
    -- PC 0043 FLAG=0x80 OP_308
    r[(13)]=r[(9)]
    -- PC 0044 FLAG=0x80 OP_358
    r[(11)](U(T,(11)+1,(13)))
    -- PC 0045 FLAG=0x00 OP_386
    do local I,F=E(r[(6)](r[(6)+1],r[(6)+2]));for U=1,(2) do T[(6)+2+U]=I[U] end;if r[(6)+3]==nil then pc=pc+1 else r[(6)+2]=r[(6)+3] end end
    -- PC 0046 FLAG=0x02 OP_255 [jump-target=37]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(36)
    -- PC 0047 FLAG=0x12 OP_071 [linear-fusion-payloads=1]
    r[(6)]=__ENV[('ipairs')]; -- 融合载荷：r[(6)]=r[('ipairs')]
    -- PC 0048 FLAG=0x00 OP_308
    r[(7)]=r[(0)]
    -- PC 0049 FLAG=0xC0 OP_183
    do local I={ r[(6)](U(T,(6)+1,(7))) };local F=0;for U=(6),(8) do F=F+1;T[U]=I[F] end end
    -- PC 0050 FLAG=0xC2 OP_140 [jump-target=77]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(76)
    -- PC 0051 FLAG=0xC0 OP_130
    r[(11)]=up[(1)]
    -- PC 0052 FLAG=0x40 OP_184
    r[(12)]=r[(10)]
    -- PC 0053 FLAG=0xC0 OP_098
    r[(11)]=r[(11)](U(T,(11)+1,(12)))
    -- PC 0054 FLAG=0x00 OP_016
    if (not not r[(11)])~=((0)~=0) then pc=pc+1 end
    -- PC 0055 FLAG=0x42 OP_215 [jump-target=77]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(76)
    -- PC 0056 FLAG=0x60 OP_033
    local I=r[(10)];r[(11)+1]=I;r[(11)]=I[('GetName')]
    -- PC 0057 FLAG=0x40 OP_098
    r[(11)]=r[(11)](U(T,(11)+1,(12)))
    -- PC 0058 FLAG=0xC0 OP_342
    if (not not r[(11)])~=((1)~=0) then pc=pc+1 end
    -- PC 0059 FLAG=0x82 OP_140 [jump-target=61]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(60)
    -- PC 0060 FLAG=0x92 OP_278 [linear-fusion-payloads=1]
    r[(11)]=('未知怪物'); -- 融合载荷：r[(11)]=r[('未知怪物')][r[(nil)]]
    -- PC 0061 FLAG=0x00 OP_231
    r[(12)]=r[(4)][r[(11)]]
    -- PC 0062 FLAG=0xC0 OP_342
    if (not not r[(12)])~=((1)~=0) then pc=pc+1 end
    -- PC 0063 FLAG=0x82 OP_255 [jump-target=77]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(76)
    -- PC 0064 FLAG=0x00 OP_130
    r[(12)]=up[(2)]
    -- PC 0065 FLAG=0x40 OP_308
    r[(13)]=r[(10)]
    -- PC 0066 FLAG=0x00 OP_098
    r[(12)]=r[(12)](U(T,(12)+1,(13)))
    -- PC 0067 FLAG=0x80 OP_348 [linear-fusion-payloads=2]
    r[(13)]=up[(3)]; -- 融合载荷：r[(13)]=r[(3)]; -- 融合载荷：r[(13)]=r[(3)]
    -- PC 0068 FLAG=0x80 OP_078 [linear-fusion-payloads=1]
    r[(14)]=r[(2)]; -- 融合载荷：r[(14)]=r[(2)]
    -- PC 0069 FLAG=0x00 OP_184
    r[(15)]=r[(12)]
    -- PC 0070 FLAG=0xC0 OP_098
    r[(13)]=r[(13)](U(T,(13)+1,(15)))
    -- PC 0071 FLAG=0x10 OP_268
    do local I=('_distance');local F=r[(13)];r[(10)][I]=F end
    -- PC 0072 FLAG=0x92 OP_137
    r[(14)]=__ENV[('table')]
    -- PC 0073 FLAG=0x60 OP_363
    r[(14)]=r[(14)][('insert')]
    -- PC 0074 FLAG=0x00 OP_078 [linear-fusion-payloads=1]
    r[(15)]=r[(1)]; -- 融合载荷：r[(15)]=r[(1)]
    -- PC 0075 FLAG=0xC0 OP_184
    r[(16)]=r[(10)]
    -- PC 0076 FLAG=0xC0 OP_187
    r[(14)](U(T,(14)+1,(16)))
    -- PC 0077 FLAG=0x40 OP_117
    do local I,F=E(r[(6)](r[(6)+1],r[(6)+2]));for U=1,(2) do T[(6)+2+U]=I[U] end;if r[(6)+3]==nil then pc=pc+1 else r[(6)+2]=r[(6)+3] end end
    -- PC 0078 FLAG=0x82 OP_215 [jump-target=51]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(50)
    -- PC 0079 FLAG=0x52 OP_307 [linear-fusion-payloads=2]
    r[(6)]=__ENV[('table')]; -- 融合载荷：r[(6)]=r[('table')][(nil)]; -- 融合载荷：r[(6)]=r[('table')]
    -- PC 0080 FLAG=0x60 OP_398 [linear-fusion-payloads=1]
    r[(6)]=r[(6)][('sort')]; -- 融合载荷：r[(6)]=r[(6)]
    -- PC 0081 FLAG=0xC0 OP_184
    r[(7)]=r[(1)]
    -- PC 0082 FLAG=0x80 OP_027 [closure-child-index=0; captures=0; child-path=root/29/1]
    do local I=O[(0)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(8)]=M(I,U,S) end
    -- PC 0083 FLAG=0x80 OP_358
    r[(6)](U(T,(6)+1,(8)))
    -- PC 0084 FLAG=0x40 OP_127 [linear-fusion-payloads=4]
    r[(6)]={}; -- 融合载荷：r[(6)]=up[(0)]; -- 融合载荷：r[(6)]=r[(0)][(0)]; -- 融合载荷：r[(6)]=__ENV[(0)]; -- 融合载荷：r[(6)]=r[(0)]
    -- PC 0085 FLAG=0x00 OP_130
    r[(7)]=up[(4)]
    -- PC 0086 FLAG=0xE0 OP_181 [linear-fusion-payloads=2]
    r[(7)]=r[(7)][('GATHER_THRESHOLD')]; -- 融合载荷：r[(7)]=__ENV[(7)]; -- 融合载荷：r[(7)]=r[(7)]
    -- PC 0087 FLAG=0xD2 OP_071 [linear-fusion-payloads=1]
    r[(8)]=__ENV[('ipairs')]; -- 融合载荷：r[(8)]=r[('ipairs')]
    -- PC 0088 FLAG=0xC0 OP_308
    r[(9)]=r[(1)]
    -- PC 0089 FLAG=0x80 OP_233
    do local I={ r[(8)](U(T,(8)+1,(9))) };local F=0;for U=(8),(10) do F=F+1;T[U]=I[F] end end
    -- PC 0090 FLAG=0x02 OP_215 [jump-target=99]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(98)
    -- PC 0091 FLAG=0x00 OP_180
    if (r[(7)]<r[(11)])~=((0)~=0) then pc=pc+1 end
    -- PC 0092 FLAG=0x82 OP_255 [jump-target=94]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(93)
    -- PC 0093 FLAG=0x82 OP_140 [jump-target=101]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(100)
    -- PC 0094 FLAG=0x92 OP_010 [linear-fusion-payloads=3]
    r[(13)]=__ENV[('table')]; -- 融合载荷：r[(13)]=r[('table')][(nil)]; -- 融合载荷：r[(13)]=r[('table')]; -- 融合载荷：r[(13)]=r[('table')]
    -- PC 0095 FLAG=0x60 OP_269 [linear-fusion-payloads=2]
    r[(13)]=r[(13)][('insert')]; -- 融合载荷：r[(13)]=r[(13)]; -- 融合载荷：r[(13)]=r[(13)]
    -- PC 0096 FLAG=0x00 OP_078 [linear-fusion-payloads=1]
    r[(14)]=r[(6)]; -- 融合载荷：r[(14)]=r[(6)]
    -- PC 0097 FLAG=0xC0 OP_184
    r[(15)]=r[(12)]
    -- PC 0098 FLAG=0x40 OP_187
    r[(13)](U(T,(13)+1,(15)))
    -- PC 0099 FLAG=0x40 OP_339
    do local I,F=E(r[(8)](r[(8)+1],r[(8)+2]));for U=1,(2) do T[(8)+2+U]=I[U] end;if r[(8)+3]==nil then pc=pc+1 else r[(8)+2]=r[(8)+3] end end
    -- PC 0100 FLAG=0x02 OP_255 [jump-target=91]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(90)
    -- PC 0101 FLAG=0x00 OP_220
    return U(T,(6),(6))
    -- PC 0102 FLAG=0x80 OP_055
    return
end
-- 原型入口：proto_IsDie_root_29

-- ============================================================================
-- 原型 root/29/1 | 候选名称：Prototype_root_29_1 | 指令记录：8 | 子原型：0 | 可变参数：2
-- 字节范围：23314:23413
local function proto_Prototype_root_29_1_root_29_1(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = '_distance'
    -- 指令语义：
    -- PC 0001 FLAG=0x60 OP_363
    r[(2)]=r[(0)][('_distance')]
    -- PC 0002 FLAG=0xA0 OP_032
    r[(3)]=r[(1)][('_distance')]
    -- PC 0003 FLAG=0x80 OP_180
    if (r[(2)]<r[(3)])~=((1)~=0) then pc=pc+1 end
    -- PC 0004 FLAG=0x82 OP_255 [jump-target=6]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(5)
    -- PC 0005 FLAG=0xC0 OP_082
    r[(2)]=(0)~=0;if (1)~=0 then pc=pc+1 end
    -- PC 0006 FLAG=0x40 OP_338
    r[(2)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0007 FLAG=0xC0 OP_220
    return U(T,(2),(2))
    -- PC 0008 FLAG=0xC0 OP_055
    return
end
-- 原型入口：proto_Prototype_root_29_1_root_29_1

-- ============================================================================
-- 原型 root/30 | 候选名称：GetMapName | 指令记录：7 | 子原型：0 | 可变参数：1
-- 字节范围：23414:23500
local function proto_GetMapName_root_30(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'IsDie'
    -- 指令语义：
    -- PC 0001 FLAG=0xC0 OP_247
    local I=r[(0)];if (not not I)==((0)~=0) then r[(1)]=I else pc=pc+1 end
    -- PC 0002 FLAG=0x02 OP_255 [jump-target=6]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(5)
    -- PC 0003 FLAG=0xE0 OP_121
    local I=r[(0)];r[(1)+1]=I;r[(1)]=I[('IsDie')]
    -- PC 0004 FLAG=0x00 OP_068
    r[(1)]=r[(1)](U(T,(1)+1,(2)))
    -- PC 0005 FLAG=0x40 OP_172
    r[(1)]=not r[(1)]
    -- PC 0006 FLAG=0x80 OP_220
    return U(T,(1),(1))
    -- PC 0007 FLAG=0xC0 OP_001
    return
end
-- 原型入口：proto_GetMapName_root_30

-- ============================================================================
-- 原型 root/31 | 候选名称：IsInWhitelistMap | 指令记录：9 | 子原型：0 | 可变参数：0
-- 字节范围：23500:23636
local function proto_IsInWhitelistMap_root_31(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'GetMetaValue'
    -- K[1] = 'MAP_NAME'
    -- K[2] = ''
    -- K[3] = 'SL'
    -- 指令语义：
    -- PC 0001 FLAG=0x92 OP_137
    r[(0)]=__ENV[('SL')]
    -- PC 0002 FLAG=0xE0 OP_297 [linear-fusion-payloads=1]
    local I=r[(0)];r[(0)+1]=I;r[(0)]=I[('GetMetaValue')]; -- 融合载荷：r[(0)]=(0)
    -- PC 0003 FLAG=0x92 OP_371
    r[(2)]=('MAP_NAME')
    -- PC 0004 FLAG=0xC0 OP_098
    r[(0)]=r[(0)](U(T,(0)+1,(2)))
    -- PC 0005 FLAG=0x40 OP_342
    if (not not r[(0)])~=((1)~=0) then pc=pc+1 end
    -- PC 0006 FLAG=0x02 OP_215 [jump-target=8]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(7)
    -- PC 0007 FLAG=0x12 OP_371
    r[(0)]=('')
    -- PC 0008 FLAG=0x00 OP_220
    return U(T,(0),(0))
    -- PC 0009 FLAG=0xC0 OP_100
    return
end
-- 原型入口：proto_IsInWhitelistMap_root_31

-- ============================================================================
-- 原型 root/32 | 候选名称：AnonymousHelper_32 | 指令记录：28 | 子原型：0 | 可变参数：0
-- 字节范围：23636:23977
local function proto_AnonymousHelper_32_root_32(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'MAP_NAME'
    -- K[1] = 'GetMetaValue'
    -- K[2] = '土城'
    -- K[3] = 'IN_SAFE_AREA'
    -- K[4] = 'ipairs'
    -- K[5] = 'SL'
    -- 指令语义：
    -- PC 0001 FLAG=0x12 OP_137
    r[(0)]=__ENV[('SL')]
    -- PC 0002 FLAG=0xA0 OP_033
    local I=r[(0)];r[(0)+1]=I;r[(0)]=I[('GetMetaValue')]
    -- PC 0003 FLAG=0x52 OP_346
    r[(2)]=('IN_SAFE_AREA')
    -- PC 0004 FLAG=0x80 OP_098
    r[(0)]=r[(0)](U(T,(0)+1,(2)))
    -- PC 0005 FLAG=0x80 OP_016
    if (not not r[(0)])~=((0)~=0) then pc=pc+1 end
    -- PC 0006 FLAG=0x82 OP_140 [jump-target=9]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(8)
    -- PC 0007 FLAG=0x80 OP_011
    r[(1)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0008 FLAG=0x40 OP_220
    return U(T,(1),(1))
    -- PC 0009 FLAG=0x92 OP_380 [linear-fusion-payloads=2]
    r[(1)]=__ENV[('SL')]; -- 融合载荷：local I=r[('SL')];r[(1)+1]=I;r[(1)]=I[(nil)]; -- 融合载荷：r[(1)]=('SL')
    -- PC 0010 FLAG=0xA0 OP_297 [linear-fusion-payloads=1]
    local I=r[(1)];r[(1)+1]=I;r[(1)]=I[('GetMetaValue')]; -- 融合载荷：r[(1)]=(1)
    -- PC 0011 FLAG=0x92 OP_371
    r[(3)]=('MAP_NAME')
    -- PC 0012 FLAG=0x80 OP_098
    r[(1)]=r[(1)](U(T,(1)+1,(3)))
    -- PC 0013 FLAG=0xC0 OP_090 [linear-fusion-payloads=1]
    r[(2)]={}; -- 融合载荷：r[(2)]=(1)
    -- PC 0014 FLAG=0x52 OP_346
    r[(3)]=('土城')
    -- PC 0015 FLAG=0x00 OP_112
    do local I=(1);if I==0 then I=math.max(0,(1)-(2)) end;local F=r[(2)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(2)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(2)]=O else for O=1,I do F[L+O]=T[(2)+O] end end;end
    -- PC 0016 FLAG=0x92 OP_071 [linear-fusion-payloads=1]
    r[(3)]=__ENV[('ipairs')]; -- 融合载荷：r[(3)]=r[('ipairs')]
    -- PC 0017 FLAG=0x80 OP_184
    r[(4)]=r[(2)]
    -- PC 0018 FLAG=0x80 OP_183
    do local I={ r[(3)](U(T,(3)+1,(4))) };local F=0;for U=(3),(5) do F=F+1;T[U]=I[F] end end
    -- PC 0019 FLAG=0x02 OP_255 [jump-target=24]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(23)
    -- PC 0020 FLAG=0x00 OP_099
    if (r[(1)]==r[(7)])~=((0)~=0) then pc=pc+1 end
    -- PC 0021 FLAG=0x82 OP_140 [jump-target=24]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(23)
    -- PC 0022 FLAG=0x40 OP_401
    r[(8)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0023 FLAG=0x00 OP_220
    return U(T,(8),(8))
    -- PC 0024 FLAG=0x40 OP_386
    do local I,F=E(r[(3)](r[(3)+1],r[(3)+2]));for U=1,(2) do T[(3)+2+U]=I[U] end;if r[(3)+3]==nil then pc=pc+1 else r[(3)+2]=r[(3)+3] end end
    -- PC 0025 FLAG=0x82 OP_255 [jump-target=20]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(19)
    -- PC 0026 FLAG=0x80 OP_011
    r[(3)]=(0)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0027 FLAG=0xC0 OP_220
    return U(T,(3),(3))
    -- PC 0028 FLAG=0xC0 OP_250
    return
end
-- 原型入口：proto_AnonymousHelper_32_root_32

-- ============================================================================
-- 原型 root/33 | 候选名称：AnonymousHelper_33 | 指令记录：6 | 子原型：0 | 可变参数：1
-- 字节范围：23977:24044
local function proto_AnonymousHelper_33_root_33(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- 指令语义：
    -- PC 0001 FLAG=0x40 OP_130
    r[(1)]=up[(0)]
    -- PC 0002 FLAG=0x40 OP_130
    r[(2)]=up[(1)]
    -- PC 0003 FLAG=0x40 OP_184
    r[(3)]=r[(0)]
    -- PC 0004 FLAG=0x00 OP_405
    return r[(1)](U(T,(1)+1,(3)))
    -- PC 0005 FLAG=0x40 OP_143
    return U(T,(1),(0))
    -- PC 0006 FLAG=0x40 OP_250
    return
end
-- 原型入口：proto_AnonymousHelper_33_root_33

-- ============================================================================
-- 原型 root/34 | 候选名称：Schedule | 指令记录：5 | 子原型：0 | 可变参数：0
-- 字节范围：24044:24102
local function proto_Schedule_root_34(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- 指令语义：
    -- PC 0001 FLAG=0x00 OP_004 [linear-fusion-payloads=1]
    r[(0)]=up[(0)]; -- 融合载荷：r[(0)]=up[(0)]
    -- PC 0002 FLAG=0x80 OP_130
    r[(1)]=up[(1)]
    -- PC 0003 FLAG=0x00 OP_405
    return r[(0)](U(T,(0)+1,(1)))
    -- PC 0004 FLAG=0x00 OP_143
    return U(T,(0),(0))
    -- PC 0005 FLAG=0xC0 OP_055
    return
end
-- 原型入口：proto_Schedule_root_34

-- ============================================================================
-- 原型 root/35 | 候选名称：SetTargetID | 指令记录：7 | 子原型：0 | 可变参数：2
-- 字节范围：24102:24198
local function proto_SetTargetID_root_35(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'SL'
    -- K[1] = 'Schedule'
    -- 指令语义：
    -- PC 0001 FLAG=0x12 OP_058 [linear-fusion-payloads=3]
    r[(2)]=__ENV[('SL')]; -- 融合载荷：local I=r[('SL')];r[(2)+1]=I;r[(2)]=I[(nil)]; -- 融合载荷：r[(2)]=r[('SL')]; -- 融合载荷：r[(2)]=r[('SL')]
    -- PC 0002 FLAG=0xA0 OP_136 [linear-fusion-payloads=2]
    local I=r[(2)];r[(2)+1]=I;r[(2)]=I[('Schedule')]; -- 融合载荷：r[(2)]=r[(2)]; -- 融合载荷：r[(2)]=r[(2)]
    -- PC 0003 FLAG=0x00 OP_308
    r[(4)]=r[(0)]
    -- PC 0004 FLAG=0x40 OP_184
    r[(5)]=r[(1)]
    -- PC 0005 FLAG=0xC0 OP_149
    return r[(2)](U(T,(2)+1,(5)))
    -- PC 0006 FLAG=0x00 OP_143
    return U(T,(2),(0))
    -- PC 0007 FLAG=0xC0 OP_055
    return
end
-- 原型入口：proto_SetTargetID_root_35

-- ============================================================================
-- 原型 root/36 | 候选名称：GetAvailableStoragePage | 指令记录：26 | 子原型：0 | 可变参数：1
-- 字节范围：24198:24573
local function proto_GetAvailableStoragePage_root_36(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'retrieveProxy'
    -- K[1] = 'Facade'
    -- K[2] = 'ProxyTable'
    -- K[3] = 'SELETE_TARGET_TYPE_FIND'
    -- K[4] = 'MMO'
    -- K[5] = 'PlayerInputProxy'
    -- K[6] = 'SetTargetID'
    -- K[7] = 'global'
    -- 指令语义：
    -- PC 0001 FLAG=0x92 OP_397 [linear-fusion-payloads=1]
    r[(1)]=__ENV[('global')]; -- 融合载荷：r[(1)]=r[('global')][(nil)]
    -- PC 0002 FLAG=0x60 OP_053
    r[(1)]=r[(1)][('Facade')]
    -- PC 0003 FLAG=0xC0 OP_342
    if (not not r[(1)])~=((1)~=0) then pc=pc+1 end
    -- PC 0004 FLAG=0xC2 OP_215 [jump-target=7]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(6)
    -- PC 0005 FLAG=0x00 OP_011
    r[(1)]=(0)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0006 FLAG=0xC0 OP_220
    return U(T,(1),(1))
    -- PC 0007 FLAG=0x52 OP_397 [linear-fusion-payloads=1]
    r[(1)]=__ENV[('global')]; -- 融合载荷：r[(1)]=r[('global')][(nil)]
    -- PC 0008 FLAG=0xA0 OP_260 [linear-fusion-payloads=4]
    r[(1)]=r[(1)][('Facade')]; -- 融合载荷：local I=r[(1)];r[(1)+1]=I;r[(1)]=I[('Facade')]; -- 融合载荷：r[(1)]=__ENV[(1)]; -- 融合载荷：r[(1)]=r[(1)][('Facade')]; -- 融合载荷：r[(1)]=r[(1)][('Facade')]
    -- PC 0009 FLAG=0xA0 OP_121
    local I=r[(1)];r[(1)+1]=I;r[(1)]=I[('retrieveProxy')]
    -- PC 0010 FLAG=0x92 OP_137
    r[(3)]=__ENV[('global')]
    -- PC 0011 FLAG=0xA0 OP_049 [linear-fusion-payloads=1]
    r[(3)]=r[(3)][('ProxyTable')]; -- 融合载荷：r[(3)]=r[(3)][('ProxyTable')]
    -- PC 0012 FLAG=0x60 OP_053
    r[(3)]=r[(3)][('PlayerInputProxy')]
    -- PC 0013 FLAG=0x40 OP_098
    r[(1)]=r[(1)](U(T,(1)+1,(3)))
    -- PC 0014 FLAG=0xC0 OP_342
    if (not not r[(1)])~=((1)~=0) then pc=pc+1 end
    -- PC 0015 FLAG=0x82 OP_140 [jump-target=18]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(17)
    -- PC 0016 FLAG=0x80 OP_401
    r[(2)]=(0)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0017 FLAG=0x80 OP_220
    return U(T,(2),(2))
    -- PC 0018 FLAG=0xA0 OP_329 [linear-fusion-payloads=4]
    local I=r[(1)];r[(2)+1]=I;r[(2)]=I[('SetTargetID')]; -- 融合载荷：r[(2)]=r[(1)]; -- 融合载荷：r[(2)]=__ENV[(1)]; -- 融合载荷：r[(2)]=r[(1)][('SetTargetID')]; -- 融合载荷：r[(2)]=r[(1)][('SetTargetID')]
    -- PC 0019 FLAG=0x40 OP_406 [linear-fusion-payloads=3]
    r[(4)]=r[(0)]; -- 融合载荷：r[(4)]=__ENV[(0)]; -- 融合载荷：r[(4)]=r[(0)][(0)]; -- 融合载荷：r[(4)]=r[(0)][(0)]
    -- PC 0020 FLAG=0x12 OP_198 [linear-fusion-payloads=2]
    r[(5)]=__ENV[('global')]; -- 融合载荷：r[(5)]=r[('global')][(nil)]; -- 融合载荷：r[(5)]=r[('global')][(nil)]
    -- PC 0021 FLAG=0x60 OP_049 [linear-fusion-payloads=1]
    r[(5)]=r[(5)][('MMO')]; -- 融合载荷：r[(5)]=r[(5)][('MMO')]
    -- PC 0022 FLAG=0xE0 OP_375
    r[(5)]=r[(5)][('SELETE_TARGET_TYPE_FIND')]
    -- PC 0023 FLAG=0x00 OP_187
    r[(2)](U(T,(2)+1,(5)))
    -- PC 0024 FLAG=0x00 OP_338
    r[(2)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0025 FLAG=0x40 OP_220
    return U(T,(2),(2))
    -- PC 0026 FLAG=0x40 OP_055
    return
end
-- 原型入口：proto_GetAvailableStoragePage_root_36

-- ============================================================================
-- 原型 root/37 | 候选名称：DestroyUI | 指令记录：51 | 子原型：0 | 可变参数：0
-- 字节范围：24573:25251
local function proto_DestroyUI_root_37(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'STORAGE_PER_PAGE_MAX'
    -- K[1] = 'GetOpenSize'
    -- K[2] = 'NPC_STORAGE_MAX_PAGE'
    -- K[3] = '仓库代理未初始化'
    -- K[4] = 'GetMaxPage'
    -- K[5] = 0.0
    -- K[6] = 'GUIDefine'
    -- K[7] = 'NPCStorageProxy'
    -- K[8] = 1.0
    -- K[9] = 'global'
    -- K[10] = 'GetStorageDataByPage'
    -- K[11] = 'MMO'
    -- 指令语义：
    -- PC 0001 FLAG=0xD2 OP_137
    r[(0)]=__ENV[('NPCStorageProxy')]
    -- PC 0002 FLAG=0x80 OP_342
    if (not not r[(0)])~=((1)~=0) then pc=pc+1 end
    -- PC 0003 FLAG=0x42 OP_140 [jump-target=9]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(8)
    -- PC 0004 FLAG=0xC0 OP_130
    r[(0)]=up[(0)]
    -- PC 0005 FLAG=0x12 OP_346
    r[(1)]=('仓库代理未初始化')
    -- PC 0006 FLAG=0x80 OP_187
    r[(0)](U(T,(0)+1,(1)))
    -- PC 0007 FLAG=0x40 OP_125
    for I=(0),(0) do T[I]=nil end
    -- PC 0008 FLAG=0xC0 OP_220
    return U(T,(0),(0))
    -- PC 0009 FLAG=0x92 OP_335 [linear-fusion-payloads=1]
    r[(0)]=__ENV[('NPCStorageProxy')]; -- 融合载荷：local I=r[('NPCStorageProxy')];r[(0)+1]=I;r[(0)]=I[(nil)]
    -- PC 0010 FLAG=0x20 OP_121
    local I=r[(0)];r[(0)+1]=I;r[(0)]=I[('GetMaxPage')]
    -- PC 0011 FLAG=0xC0 OP_068
    r[(0)]=r[(0)](U(T,(0)+1,(1)))
    -- PC 0012 FLAG=0x12 OP_101 [linear-fusion-payloads=2]
    r[(1)]=(1.0); -- 融合载荷：r[(1)]=r[(1.0)]; -- 融合载荷：r[(1)]=(1.0)
    -- PC 0013 FLAG=0x40 OP_288 [linear-fusion-payloads=1]
    r[(2)]=r[(0)]; -- 融合载荷：r[(2)]=(0)
    -- PC 0014 FLAG=0x12 OP_371
    r[(3)]=(1.0)
    -- PC 0015 FLAG=0x42 OP_292 [jump-target=48]
    r[(1)]=r[(1)]-r[(1)+2];pc=(47)
    -- PC 0016 FLAG=0xD2 OP_300 [linear-fusion-payloads=2]
    r[(5)]=__ENV[('NPCStorageProxy')]; -- 融合载荷：local I=r[('NPCStorageProxy')];r[(5)+1]=I;r[(5)]=I[(nil)]; -- 融合载荷：r[(5)]=r[('NPCStorageProxy')]
    -- PC 0017 FLAG=0x20 OP_121
    local I=r[(5)];r[(5)+1]=I;r[(5)]=I[('GetStorageDataByPage')]
    -- PC 0018 FLAG=0x40 OP_184
    r[(7)]=r[(4)]
    -- PC 0019 FLAG=0x40 OP_098
    r[(5)]=r[(5)](U(T,(5)+1,(7)))
    -- PC 0020 FLAG=0x80 OP_016
    if (not not r[(5)])~=((0)~=0) then pc=pc+1 end
    -- PC 0021 FLAG=0x82 OP_215 [jump-target=25]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(24)
    -- PC 0022 FLAG=0x00 OP_115
    r[(6)]=#r[(5)]
    -- PC 0023 FLAG=0x00 OP_342
    if (not not r[(6)])~=((1)~=0) then pc=pc+1 end
    -- PC 0024 FLAG=0xC2 OP_140 [jump-target=26]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(25)
    -- PC 0025 FLAG=0x12 OP_217 [linear-fusion-payloads=2]
    r[(6)]=(0.0); -- 融合载荷：r[(6)]=__ENV[(0.0)]; -- 融合载荷：r[(6)]=r[(0.0)][(nil)]
    -- PC 0026 FLAG=0x52 OP_397 [linear-fusion-payloads=1]
    r[(7)]=__ENV[('GUIDefine')]; -- 融合载荷：r[(7)]=r[('GUIDefine')][(nil)]
    -- PC 0027 FLAG=0xA0 OP_053
    r[(7)]=r[(7)][('STORAGE_PER_PAGE_MAX')]
    -- PC 0028 FLAG=0xC0 OP_342
    if (not not r[(7)])~=((1)~=0) then pc=pc+1 end
    -- PC 0029 FLAG=0xC2 OP_255 [jump-target=33]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(32)
    -- PC 0030 FLAG=0x52 OP_070 [linear-fusion-payloads=4]
    r[(7)]=__ENV[('global')]; -- 融合载荷：r[(7)]=r[('global')][(nil)]; -- 融合载荷：r[(7)]=r[('global')][(nil)]; -- 融合载荷：r[(7)]=__ENV[('global')]; -- 融合载荷：local I=r[('global')];r[(7)+1]=I;r[(7)]=I[(nil)]
    -- PC 0031 FLAG=0xE0 OP_053
    r[(7)]=r[(7)][('MMO')]
    -- PC 0032 FLAG=0x60 OP_064 [linear-fusion-payloads=2]
    r[(7)]=r[(7)][('NPC_STORAGE_MAX_PAGE')]; -- 融合载荷：r[(7)]=__ENV[(7)]; -- 融合载荷：local I=r[(7)];r[(7)+1]=I;r[(7)]=I[('NPC_STORAGE_MAX_PAGE')]
    -- PC 0033 FLAG=0x12 OP_137
    r[(8)]=__ENV[('NPCStorageProxy')]
    -- PC 0034 FLAG=0xE0 OP_121
    local I=r[(8)];r[(8)+1]=I;r[(8)]=I[('GetOpenSize')]
    -- PC 0035 FLAG=0x00 OP_098
    r[(8)]=r[(8)](U(T,(8)+1,(9)))
    -- PC 0036 FLAG=0x60 OP_347
    r[(9)]=r[(4)]-(1.0)
    -- PC 0037 FLAG=0x40 OP_263 [linear-fusion-payloads=1]
    r[(9)]=r[(9)]*r[(7)]; -- 融合载荷：r[(9)]=r[(9)]-r[(7)]
    -- PC 0038 FLAG=0x40 OP_340
    r[(8)]=r[(8)]-r[(9)]
    -- PC 0039 FLAG=0x00 OP_253
    if (r[(7)]<r[(8)])~=((0)~=0) then pc=pc+1 end
    -- PC 0040 FLAG=0xC2 OP_215 [jump-target=42]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(41)
    -- PC 0041 FLAG=0xC0 OP_308
    r[(8)]=r[(7)]
    -- PC 0042 FLAG=0xD0 OP_364
    if ((0.0)<r[(8)])~=((0)~=0) then pc=pc+1 end
    -- PC 0043 FLAG=0xC2 OP_140 [jump-target=48]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(47)
    -- PC 0044 FLAG=0x00 OP_340
    r[(9)]=r[(8)]-r[(6)]
    -- PC 0045 FLAG=0x10 OP_352
    if ((0.0)<r[(9)])~=((0)~=0) then pc=pc+1 end
    -- PC 0046 FLAG=0x02 OP_215 [jump-target=48]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(47)
    -- PC 0047 FLAG=0x40 OP_220
    return U(T,(4),(4))
    -- PC 0048 FLAG=0x02 OP_412 [loop-target=16]
    do local I=(1);local F=T[I+2];local U=T[I]+F;T[I]=U;local L=T[I+1];if (F>0 and U<=L) or (F<=0 and U>=L) then T[I+3]=U;pc=(15) end end
    -- PC 0049 FLAG=0x40 OP_248
    for I=(1),(1) do T[I]=nil end
    -- PC 0050 FLAG=0x00 OP_220
    return U(T,(1),(1))
    -- PC 0051 FLAG=0x80 OP_100
    return
end
-- 原型入口：proto_DestroyUI_root_37

-- ============================================================================
-- 原型 root/38 | 候选名称：GetOwnerID | 指令记录：31 | 子原型：0 | 可变参数：0
-- 字节范围：25251:25655
local function proto_GetOwnerID_root_38(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = ['unknown', 2]
    -- K[1] = 'UnSchedule'
    -- K[2] = 'isHidden'
    -- K[3] = 'GUI'
    -- K[4] = 'setVisible'
    -- K[5] = 'SL'
    -- K[6] = 'resWin'
    -- K[7] = 'resTimer'
    -- K[8] = 'Win_CloseAll'
    -- K[9] = False
    -- K[10] = 'pairs'
    -- 指令语义：
    -- PC 0001 FLAG=0x00 OP_130
    r[(0)]=up[(0)]
    -- PC 0002 FLAG=0xB0 OP_156
    do local I=('isHidden');local F=(false);r[(0)][I]=F end
    -- PC 0003 FLAG=0x00 OP_159 [linear-fusion-payloads=1]
    r[(0)]=up[(1)]; -- 融合载荷：r[(0)]=r[(1)][(0)]
    -- PC 0004 FLAG=0xE0 OP_053
    r[(0)]=r[(0)][('resTimer')]
    -- PC 0005 FLAG=0x80 OP_016
    if (not not r[(0)])~=((0)~=0) then pc=pc+1 end
    -- PC 0006 FLAG=0x42 OP_140 [jump-target=14]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(13)
    -- PC 0007 FLAG=0x92 OP_335 [linear-fusion-payloads=1]
    r[(0)]=__ENV[('SL')]; -- 融合载荷：local I=r[('SL')];r[(0)+1]=I;r[(0)]=I[(nil)]
    -- PC 0008 FLAG=0x20 OP_121
    local I=r[(0)];r[(0)+1]=I;r[(0)]=I[('UnSchedule')]
    -- PC 0009 FLAG=0x40 OP_130
    r[(2)]=up[(1)]
    -- PC 0010 FLAG=0x20 OP_363
    r[(2)]=r[(2)][('resTimer')]
    -- PC 0011 FLAG=0x00 OP_358
    r[(0)](U(T,(0)+1,(2)))
    -- PC 0012 FLAG=0x40 OP_130
    r[(0)]=up[(1)]
    -- PC 0013 FLAG=0xB0 OP_146
    do local I=('resTimer');local F=(['unknown', 2]);r[(0)][I]=F end
    -- PC 0014 FLAG=0x40 OP_315 [linear-fusion-payloads=2]
    r[(0)]=up[(0)]; -- 融合载荷：do local I=(0);local F=(0);r[(0)][I]=F end; -- 融合载荷：r[(0)]=__ENV[(0)]
    -- PC 0015 FLAG=0xB0 OP_146
    do local I=('resWin');local F=(['unknown', 2]);r[(0)][I]=F end
    -- PC 0016 FLAG=0x52 OP_335 [linear-fusion-payloads=1]
    r[(0)]=__ENV[('GUI')]; -- 融合载荷：local I=r[('GUI')];r[(0)+1]=I;r[(0)]=I[(nil)]
    -- PC 0017 FLAG=0xA0 OP_033
    local I=r[(0)];r[(0)+1]=I;r[(0)]=I[('Win_CloseAll')]
    -- PC 0018 FLAG=0x00 OP_358
    r[(0)](U(T,(0)+1,(1)))
    -- PC 0019 FLAG=0x52 OP_095 [linear-fusion-payloads=1]
    r[(0)]=__ENV[('pairs')]; -- 融合载荷：r[(0)]=up[('pairs')]
    -- PC 0020 FLAG=0x40 OP_130
    r[(1)]=up[(2)]
    -- PC 0021 FLAG=0x80 OP_359
    do local I={ r[(0)](U(T,(0)+1,(1))) };local F=0;for U=(0),(2) do F=F+1;T[U]=I[F] end end
    -- PC 0022 FLAG=0xC2 OP_140 [jump-target=29]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(28)
    -- PC 0023 FLAG=0x12 OP_137
    r[(5)]=__ENV[('GUI')]
    -- PC 0024 FLAG=0x60 OP_121
    local I=r[(5)];r[(5)+1]=I;r[(5)]=I[('setVisible')]
    -- PC 0025 FLAG=0x80 OP_028 [linear-fusion-payloads=1]
    r[(7)]=up[(2)]; -- 融合载荷：r[(7)]=r[(2)][r[(0)]]
    -- PC 0026 FLAG=0x80 OP_304
    r[(7)]=r[(7)][r[(3)]]
    -- PC 0027 FLAG=0x80 OP_338
    r[(8)]=(0)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0028 FLAG=0xC0 OP_187
    r[(5)](U(T,(5)+1,(8)))
    -- PC 0029 FLAG=0x80 OP_386
    do local I,F=E(r[(0)](r[(0)+1],r[(0)+2]));for U=1,(2) do T[(0)+2+U]=I[U] end;if r[(0)+3]==nil then pc=pc+1 else r[(0)+2]=r[(0)+3] end end
    -- PC 0030 FLAG=0x02 OP_215 [jump-target=23]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(22)
    -- PC 0031 FLAG=0x80 OP_055
    return
end
-- 原型入口：proto_GetOwnerID_root_38

-- ============================================================================
-- 原型 root/39 | 候选名称：GetMainPlayerID | 指令记录：31 | 子原型：0 | 可变参数：2
-- 字节范围：25655:26010
local function proto_GetMainPlayerID_root_39(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = -1.0
    -- K[1] = 'tostring'
    -- K[2] = 'GetOwnerID'
    -- K[3] = 'type'
    -- K[4] = ['unknown', 2]
    -- K[5] = ''
    -- K[6] = 'string'
    -- 指令语义：
    -- PC 0001 FLAG=0xA0 OP_121
    local I=r[(0)];r[(2)+1]=I;r[(2)]=I[('GetOwnerID')]
    -- PC 0002 FLAG=0x00 OP_098
    r[(2)]=r[(2)](U(T,(2)+1,(3)))
    -- PC 0003 FLAG=0xA0 OP_271
    if (r[(2)]==(['unknown', 2]))~=((1)~=0) then pc=pc+1 end
    -- PC 0004 FLAG=0x82 OP_215 [jump-target=9]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(8)
    -- PC 0005 FLAG=0x60 OP_279
    if (r[(2)]==(''))~=((1)~=0) then pc=pc+1 end
    -- PC 0006 FLAG=0x82 OP_255 [jump-target=9]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(8)
    -- PC 0007 FLAG=0xA0 OP_271
    if (r[(2)]==(-1.0))~=((0)~=0) then pc=pc+1 end
    -- PC 0008 FLAG=0x82 OP_255 [jump-target=12]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(11)
    -- PC 0009 FLAG=0x00 OP_338
    r[(3)]=(0)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0010 FLAG=0x80 OP_220
    return U(T,(3),(3))
    -- PC 0011 FLAG=0x42 OP_140 [jump-target=31]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(30)
    -- PC 0012 FLAG=0xD2 OP_071 [linear-fusion-payloads=1]
    r[(3)]=__ENV[('type')]; -- 融合载荷：r[(3)]=r[('type')]
    -- PC 0013 FLAG=0x80 OP_184
    r[(4)]=r[(2)]
    -- PC 0014 FLAG=0xC0 OP_098
    r[(3)]=r[(3)](U(T,(3)+1,(4)))
    -- PC 0015 FLAG=0xE0 OP_271
    if (r[(3)]==('string'))~=((0)~=0) then pc=pc+1 end
    -- PC 0016 FLAG=0x02 OP_255 [jump-target=26]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(25)
    -- PC 0017 FLAG=0x52 OP_071 [linear-fusion-payloads=1]
    r[(3)]=__ENV[('tostring')]; -- 融合载荷：r[(3)]=r[('tostring')]
    -- PC 0018 FLAG=0x00 OP_184
    r[(4)]=r[(1)]
    -- PC 0019 FLAG=0x00 OP_068
    r[(3)]=r[(3)](U(T,(3)+1,(4)))
    -- PC 0020 FLAG=0xC0 OP_099
    if (r[(2)]==r[(3)])~=((0)~=0) then pc=pc+1 end
    -- PC 0021 FLAG=0x42 OP_215 [jump-target=23]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(22)
    -- PC 0022 FLAG=0x80 OP_082
    r[(3)]=(0)~=0;if (1)~=0 then pc=pc+1 end
    -- PC 0023 FLAG=0x80 OP_401
    r[(3)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0024 FLAG=0x40 OP_220
    return U(T,(3),(3))
    -- PC 0025 FLAG=0x82 OP_215 [jump-target=31]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(30)
    -- PC 0026 FLAG=0xC0 OP_294
    if (r[(2)]==r[(1)])~=((0)~=0) then pc=pc+1 end
    -- PC 0027 FLAG=0x82 OP_215 [jump-target=29]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(28)
    -- PC 0028 FLAG=0xC0 OP_082
    r[(3)]=(0)~=0;if (1)~=0 then pc=pc+1 end
    -- PC 0029 FLAG=0x40 OP_401
    r[(3)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0030 FLAG=0x80 OP_220
    return U(T,(3),(3))
    -- PC 0031 FLAG=0x80 OP_001
    return
end
-- 原型入口：proto_GetMainPlayerID_root_39

-- ============================================================================
-- 原型 root/40 | 候选名称：ShowHideAllButtons | 指令记录：6 | 子原型：0 | 可变参数：0
-- 字节范围：26010:26133
local function proto_ShowHideAllButtons_root_40(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'gamePlayerController'
    -- K[1] = 'GetMainPlayerID'
    -- K[2] = 'global'
    -- 指令语义：
    -- PC 0001 FLAG=0x52 OP_309 [linear-fusion-payloads=2]
    r[(0)]=__ENV[('global')]; -- 融合载荷：r[(0)]=r[('global')][(nil)]; -- 融合载荷：local I=r[('global')];r[(0)+1]=I;r[(0)]=I[(nil)]
    -- PC 0002 FLAG=0xE0 OP_270 [linear-fusion-payloads=1]
    r[(0)]=r[(0)][('gamePlayerController')]; -- 融合载荷：local I=r[(0)];r[(0)+1]=I;r[(0)]=I[('gamePlayerController')]
    -- PC 0003 FLAG=0x20 OP_033
    local I=r[(0)];r[(0)+1]=I;r[(0)]=I[('GetMainPlayerID')]
    -- PC 0004 FLAG=0x80 OP_098
    r[(0)]=r[(0)](U(T,(0)+1,(1)))
    -- PC 0005 FLAG=0xC0 OP_220
    return U(T,(0),(0))
    -- PC 0006 FLAG=0x80 OP_100
    return
end
-- 原型入口：proto_ShowHideAllButtons_root_40

-- ============================================================================
-- 原型 root/41 | 候选名称：MoveItemToQuickUse | 指令记录：47 | 子原型：0 | 可变参数：0
-- 字节范围：26133:26669
local function proto_MoveItemToQuickUse_root_41(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'GUI'
    -- K[1] = 'pairs'
    -- K[2] = 'setVisible'
    -- K[3] = 'SL'
    -- K[4] = 'hidebut'
    -- K[5] = 'UnSchedule'
    -- K[6] = ['unknown', 2]
    -- K[7] = 'rewardTimer'
    -- K[8] = 'cruiseTimer'
    -- 指令语义：
    -- PC 0001 FLAG=0x40 OP_159 [linear-fusion-payloads=1]
    r[(0)]=up[(0)]; -- 融合载荷：r[(0)]=r[(0)][(0)]
    -- PC 0002 FLAG=0x20 OP_363
    r[(0)]=r[(0)][('rewardTimer')]
    -- PC 0003 FLAG=0x80 OP_016
    if (not not r[(0)])~=((0)~=0) then pc=pc+1 end
    -- PC 0004 FLAG=0xC2 OP_140 [jump-target=12]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(11)
    -- PC 0005 FLAG=0xD2 OP_335 [linear-fusion-payloads=1]
    r[(0)]=__ENV[('SL')]; -- 融合载荷：local I=r[('SL')];r[(0)+1]=I;r[(0)]=I[(nil)]
    -- PC 0006 FLAG=0xA0 OP_033
    local I=r[(0)];r[(0)+1]=I;r[(0)]=I[('UnSchedule')]
    -- PC 0007 FLAG=0xC0 OP_159 [linear-fusion-payloads=1]
    r[(2)]=up[(0)]; -- 融合载荷：r[(2)]=r[(0)][(0)]
    -- PC 0008 FLAG=0x60 OP_053
    r[(2)]=r[(2)][('rewardTimer')]
    -- PC 0009 FLAG=0x40 OP_358
    r[(0)](U(T,(0)+1,(2)))
    -- PC 0010 FLAG=0x80 OP_130
    r[(0)]=up[(0)]
    -- PC 0011 FLAG=0xB0 OP_146
    do local I=('rewardTimer');local F=(['unknown', 2]);r[(0)][I]=F end
    -- PC 0012 FLAG=0x80 OP_159 [linear-fusion-payloads=1]
    r[(0)]=up[(0)]; -- 融合载荷：r[(0)]=r[(0)][(0)]
    -- PC 0013 FLAG=0x20 OP_053
    r[(0)]=r[(0)][('cruiseTimer')]
    -- PC 0014 FLAG=0x00 OP_016
    if (not not r[(0)])~=((0)~=0) then pc=pc+1 end
    -- PC 0015 FLAG=0x02 OP_255 [jump-target=23]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(22)
    -- PC 0016 FLAG=0x92 OP_335 [linear-fusion-payloads=1]
    r[(0)]=__ENV[('SL')]; -- 融合载荷：local I=r[('SL')];r[(0)+1]=I;r[(0)]=I[(nil)]
    -- PC 0017 FLAG=0xA0 OP_238
    local I=r[(0)];r[(0)+1]=I;r[(0)]=I[('UnSchedule')]
    -- PC 0018 FLAG=0x40 OP_159 [linear-fusion-payloads=1]
    r[(2)]=up[(0)]; -- 融合载荷：r[(2)]=r[(0)][(0)]
    -- PC 0019 FLAG=0xE0 OP_363
    r[(2)]=r[(2)][('cruiseTimer')]
    -- PC 0020 FLAG=0xC0 OP_187
    r[(0)](U(T,(0)+1,(2)))
    -- PC 0021 FLAG=0xC0 OP_315 [linear-fusion-payloads=2]
    r[(0)]=up[(0)]; -- 融合载荷：do local I=(0);local F=(0);r[(0)][I]=F end; -- 融合载荷：r[(0)]=__ENV[(0)]
    -- PC 0022 FLAG=0x30 OP_301 [linear-fusion-payloads=1]
    do local I=('cruiseTimer');local F=(['unknown', 2]);r[(0)][I]=F end; -- 融合载荷：r[(0)]=__ENV[('cruiseTimer')]
    -- PC 0023 FLAG=0x92 OP_095 [linear-fusion-payloads=1]
    r[(0)]=__ENV[('pairs')]; -- 融合载荷：r[(0)]=up[('pairs')]
    -- PC 0024 FLAG=0x80 OP_130
    r[(1)]=up[(1)]
    -- PC 0025 FLAG=0x80 OP_233
    do local I={ r[(0)](U(T,(0)+1,(1))) };local F=0;for U=(0),(2) do F=F+1;T[U]=I[F] end end
    -- PC 0026 FLAG=0xC2 OP_215 [jump-target=33]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(32)
    -- PC 0027 FLAG=0x12 OP_335 [linear-fusion-payloads=1]
    r[(5)]=__ENV[('GUI')]; -- 融合载荷：local I=r[('GUI')];r[(5)+1]=I;r[(5)]=I[(nil)]
    -- PC 0028 FLAG=0xE0 OP_121
    local I=r[(5)];r[(5)+1]=I;r[(5)]=I[('setVisible')]
    -- PC 0029 FLAG=0x00 OP_028 [linear-fusion-payloads=1]
    r[(7)]=up[(1)]; -- 融合载荷：r[(7)]=r[(1)][r[(0)]]
    -- PC 0030 FLAG=0x40 OP_231
    r[(7)]=r[(7)][r[(3)]]
    -- PC 0031 FLAG=0x00 OP_401
    r[(8)]=(0)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0032 FLAG=0xC0 OP_187
    r[(5)](U(T,(5)+1,(8)))
    -- PC 0033 FLAG=0xC0 OP_117
    do local I,F=E(r[(0)](r[(0)+1],r[(0)+2]));for U=1,(2) do T[(0)+2+U]=I[U] end;if r[(0)+3]==nil then pc=pc+1 else r[(0)+2]=r[(0)+3] end end
    -- PC 0034 FLAG=0x82 OP_215 [jump-target=27]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(26)
    -- PC 0035 FLAG=0x80 OP_159 [linear-fusion-payloads=1]
    r[(0)]=up[(2)]; -- 融合载荷：r[(0)]=r[(2)][(0)]
    -- PC 0036 FLAG=0x60 OP_363
    r[(0)]=r[(0)][('hidebut')]
    -- PC 0037 FLAG=0x40 OP_016
    if (not not r[(0)])~=((0)~=0) then pc=pc+1 end
    -- PC 0038 FLAG=0x82 OP_140 [jump-target=47]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(46)
    -- PC 0039 FLAG=0xD2 OP_137
    r[(0)]=__ENV[('GUI')]
    -- PC 0040 FLAG=0x20 OP_121
    local I=r[(0)];r[(0)+1]=I;r[(0)]=I[('setVisible')]
    -- PC 0041 FLAG=0x80 OP_159 [linear-fusion-payloads=1]
    r[(2)]=up[(2)]; -- 融合载荷：r[(2)]=r[(2)][(0)]
    -- PC 0042 FLAG=0x60 OP_363
    r[(2)]=r[(2)][('hidebut')]
    -- PC 0043 FLAG=0xC0 OP_401
    r[(3)]=(0)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0044 FLAG=0x40 OP_187
    r[(0)](U(T,(0)+1,(3)))
    -- PC 0045 FLAG=0x40 OP_089 [linear-fusion-payloads=1]
    r[(0)]=up[(2)]; -- 融合载荷：do local I=(2);local F=(0);r[(0)][I]=F end
    -- PC 0046 FLAG=0x70 OP_146
    do local I=('hidebut');local F=(['unknown', 2]);r[(0)][I]=F end
    -- PC 0047 FLAG=0x80 OP_055
    return
end
-- 原型入口：proto_MoveItemToQuickUse_root_41

-- ============================================================================
-- 原型 root/42 | 候选名称：doInit_UI | 指令记录：133 | 子原型：0 | 可变参数：2
-- 字节范围：26669:28367
local function proto_doInit_UI_root_42(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = '快捷栏移动: %d → %d'
    -- K[1] = 'next'
    -- K[2] = 'QuickUseProxy'
    -- K[3] = 'SetQuickUsePosData'
    -- K[4] = 'GetQuickUseData'
    -- K[5] = 'GetQuickUseSize'
    -- K[6] = 'DelItemData'
    -- K[7] = '参数无效'
    -- K[8] = '物品已在目标位置'
    -- K[9] = 'addItemData'
    -- K[10] = 'Bag'
    -- K[11] = '物品不存在'
    -- K[12] = 'Index'
    -- K[13] = 'ProxyTable'
    -- K[14] = 'retrieveProxy'
    -- K[15] = 'Facade'
    -- K[16] = '目标位置超出范围'
    -- K[17] = 'string'
    -- K[18] = '已从背包移动到快捷栏位置%d'
    -- K[19] = 'format'
    -- K[20] = 'GetItemDataByItemIndex'
    -- K[21] = 'pairs'
    -- K[22] = 'global'
    -- K[23] = 'GetQucikUseDataByPos'
    -- K[24] = '快捷栏交换: %d ↔ %d'
    -- K[25] = 1.0
    -- 指令语义：
    -- PC 0001 FLAG=0x12 OP_179 [linear-fusion-payloads=5]
    r[(2)]=__ENV[('global')]; -- 融合载荷：r[(2)]=r[('global')][(nil)]; -- 融合载荷：local I=r[('global')];r[(2)+1]=I;r[(2)]=I[(nil)]; -- 融合载荷：r[(2)]=__ENV[('global')]; -- 融合载荷：r[(2)]=r[('global')][(nil)]; -- 融合载荷：r[(2)]=r[('global')][(nil)]
    -- PC 0002 FLAG=0x60 OP_260 [linear-fusion-payloads=4]
    r[(2)]=r[(2)][('Facade')]; -- 融合载荷：local I=r[(2)];r[(2)+1]=I;r[(2)]=I[('Facade')]; -- 融合载荷：r[(2)]=__ENV[(2)]; -- 融合载荷：r[(2)]=r[(2)][('Facade')]; -- 融合载荷：r[(2)]=r[(2)][('Facade')]
    -- PC 0003 FLAG=0xE0 OP_121
    local I=r[(2)];r[(2)+1]=I;r[(2)]=I[('retrieveProxy')]
    -- PC 0004 FLAG=0xD2 OP_198 [linear-fusion-payloads=2]
    r[(4)]=__ENV[('global')]; -- 融合载荷：r[(4)]=r[('global')][(nil)]; -- 融合载荷：r[(4)]=r[('global')][(nil)]
    -- PC 0005 FLAG=0xA0 OP_375
    r[(4)]=r[(4)][('ProxyTable')]
    -- PC 0006 FLAG=0x20 OP_053
    r[(4)]=r[(4)][('pcuickUseProxy')]
    -- PC 0007 FLAG=0x40 OP_098
    r[(2)]=r[(2)](U(T,(2)+1,(4)))
    -- PC 0008 FLAG=0x12 OP_179 [linear-fusion-payloads=5]
    r[(3)]=__ENV[('global')]; -- 融合载荷：r[(3)]=r[('global')][(nil)]; -- 融合载荷：local I=r[('global')];r[(3)+1]=I;r[(3)]=I[(nil)]; -- 融合载荷：r[(3)]=__ENV[('global')]; -- 融合载荷：r[(3)]=r[('global')][(nil)]; -- 融合载荷：r[(3)]=r[('global')][(nil)]
    -- PC 0009 FLAG=0x60 OP_032
    r[(3)]=r[(3)][('Facade')]
    -- PC 0010 FLAG=0xE0 OP_121
    local I=r[(3)];r[(3)+1]=I;r[(3)]=I[('retrieveProxy')]
    -- PC 0011 FLAG=0x52 OP_198 [linear-fusion-payloads=2]
    r[(5)]=__ENV[('global')]; -- 融合载荷：r[(5)]=r[('global')][(nil)]; -- 融合载荷：r[(5)]=r[('global')][(nil)]
    -- PC 0012 FLAG=0x60 OP_049 [linear-fusion-payloads=1]
    r[(5)]=r[(5)][('ProxyTable')]; -- 融合载荷：r[(5)]=r[(5)][('ProxyTable')]
    -- PC 0013 FLAG=0xE0 OP_053
    r[(5)]=r[(5)][('Bag')]
    -- PC 0014 FLAG=0xC0 OP_068
    r[(3)]=r[(3)](U(T,(3)+1,(5)))
    -- PC 0015 FLAG=0x40 OP_016
    if (not not r[(0)])~=((0)~=0) then pc=pc+1 end
    -- PC 0016 FLAG=0x42 OP_255 [jump-target=19]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(18)
    -- PC 0017 FLAG=0x00 OP_342
    if (not not r[(1)])~=((1)~=0) then pc=pc+1 end
    -- PC 0018 FLAG=0x82 OP_255 [jump-target=22]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(21)
    -- PC 0019 FLAG=0xC0 OP_401
    r[(4)]=(0)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0020 FLAG=0x52 OP_371
    r[(5)]=('参数无效')
    -- PC 0021 FLAG=0xC0 OP_220
    return U(T,(4),(5))
    -- PC 0022 FLAG=0xA0 OP_033
    local I=r[(2)];r[(4)+1]=I;r[(4)]=I[('GetpcuickUseSize')]
    -- PC 0023 FLAG=0xC0 OP_098
    r[(4)]=r[(4)](U(T,(4)+1,(5)))
    -- PC 0024 FLAG=0x20 OP_043
    if (r[(1)]<(1.0))~=((1)~=0) then pc=pc+1 end
    -- PC 0025 FLAG=0x82 OP_140 [jump-target=28]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(27)
    -- PC 0026 FLAG=0x00 OP_002
    if (r[(4)]<r[(1)])~=((0)~=0) then pc=pc+1 end
    -- PC 0027 FLAG=0xC2 OP_215 [jump-target=31]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(30)
    -- PC 0028 FLAG=0x40 OP_401
    r[(5)]=(0)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0029 FLAG=0xD2 OP_346
    r[(6)]=('目标位置超出范围')
    -- PC 0030 FLAG=0xC0 OP_220
    return U(T,(5),(6))
    -- PC 0031 FLAG=0xE0 OP_121
    local I=r[(2)];r[(5)+1]=I;r[(5)]=I[('GetpcuickUseData')]
    -- PC 0032 FLAG=0x40 OP_068
    r[(5)]=r[(5)](U(T,(5)+1,(6)))
    -- PC 0033 FLAG=0x92 OP_071 [linear-fusion-payloads=1]
    r[(6)]=__ENV[('pairs')]; -- 融合载荷：r[(6)]=r[('pairs')]
    -- PC 0034 FLAG=0x80 OP_184
    r[(7)]=r[(5)]
    -- PC 0035 FLAG=0x00 OP_359
    do local I={ r[(6)](U(T,(6)+1,(7))) };local F=0;for U=(6),(8) do F=F+1;T[U]=I[F] end end
    -- PC 0036 FLAG=0x42 OP_140 [jump-target=89]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(88)
    -- PC 0037 FLAG=0x40 OP_016
    if (not not r[(10)])~=((0)~=0) then pc=pc+1 end
    -- PC 0038 FLAG=0xC2 OP_140 [jump-target=89]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(88)
    -- PC 0039 FLAG=0x20 OP_032
    r[(11)]=r[(10)][('Index')]
    -- PC 0040 FLAG=0x40 OP_294
    if (r[(11)]==r[(0)])~=((0)~=0) then pc=pc+1 end
    -- PC 0041 FLAG=0xC2 OP_255 [jump-target=89]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(88)
    -- PC 0042 FLAG=0x40 OP_099
    if (r[(9)]==r[(1)])~=((0)~=0) then pc=pc+1 end
    -- PC 0043 FLAG=0x42 OP_140 [jump-target=47]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(46)
    -- PC 0044 FLAG=0x80 OP_338
    r[(11)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0045 FLAG=0x52 OP_371
    r[(12)]=('物品已在目标位置')
    -- PC 0046 FLAG=0xC0 OP_220
    return U(T,(11),(12))
    -- PC 0047 FLAG=0xE0 OP_142 [linear-fusion-payloads=1]
    local I=r[(2)];r[(11)+1]=I;r[(11)]=I[('GetpcucikUseDataByPos')]; -- 融合载荷：r[(11)]=r[(2)]
    -- PC 0048 FLAG=0x40 OP_184
    r[(13)]=r[(1)]
    -- PC 0049 FLAG=0xC0 OP_068
    r[(11)]=r[(11)](U(T,(11)+1,(13)))
    -- PC 0050 FLAG=0xE0 OP_121
    local I=r[(2)];r[(12)+1]=I;r[(12)]=I[('SetpcuickUsePosData')]
    -- PC 0051 FLAG=0xC0 OP_078 [linear-fusion-payloads=1]
    r[(14)]=r[(9)]; -- 融合载荷：r[(14)]=r[(9)]
    -- PC 0052 FLAG=0x80 OP_308
    r[(15)]=r[(10)]
    -- PC 0053 FLAG=0x00 OP_011
    r[(16)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0054 FLAG=0x80 OP_358
    r[(12)](U(T,(12)+1,(16)))
    -- PC 0055 FLAG=0xC0 OP_016
    if (not not r[(11)])~=((0)~=0) then pc=pc+1 end
    -- PC 0056 FLAG=0x82 OP_255 [jump-target=76]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(75)
    -- PC 0057 FLAG=0xA0 OP_136 [linear-fusion-payloads=2]
    local I=r[(2)];r[(12)+1]=I;r[(12)]=I[('SetpcuickUsePosData')]; -- 融合载荷：r[(12)]=r[(2)]; -- 融合载荷：r[(12)]=r[(2)]
    -- PC 0058 FLAG=0x00 OP_078 [linear-fusion-payloads=1]
    r[(14)]=r[(1)]; -- 融合载荷：r[(14)]=r[(1)]
    -- PC 0059 FLAG=0xC0 OP_308
    r[(15)]=r[(10)]
    -- PC 0060 FLAG=0x40 OP_011
    r[(16)]=(0)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0061 FLAG=0x00 OP_358
    r[(12)](U(T,(12)+1,(16)))
    -- PC 0062 FLAG=0x20 OP_136 [linear-fusion-payloads=2]
    local I=r[(2)];r[(12)+1]=I;r[(12)]=I[('SetpcuickUsePosData')]; -- 融合载荷：r[(12)]=r[(2)]; -- 融合载荷：r[(12)]=r[(2)]
    -- PC 0063 FLAG=0x80 OP_078 [linear-fusion-payloads=1]
    r[(14)]=r[(9)]; -- 融合载荷：r[(14)]=r[(9)]
    -- PC 0064 FLAG=0x80 OP_308
    r[(15)]=r[(11)]
    -- PC 0065 FLAG=0x40 OP_011
    r[(16)]=(0)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0066 FLAG=0x80 OP_358
    r[(12)](U(T,(12)+1,(16)))
    -- PC 0067 FLAG=0x00 OP_401
    r[(12)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0068 FLAG=0x52 OP_110 [linear-fusion-payloads=2]
    r[(13)]=__ENV[('string')]; -- 融合载荷：r[(13)]=r[('string')][(nil)]; -- 融合载荷：r[(13)]=('string')
    -- PC 0069 FLAG=0x20 OP_363
    r[(13)]=r[(13)][('format')]
    -- PC 0070 FLAG=0x12 OP_059 [linear-fusion-payloads=2]
    r[(14)]=('快捷栏交换: %d ↔ %d'); -- 融合载荷：r[(14)]=r[('快捷栏交换: %d ↔ %d')]; -- 融合载荷：r[(14)]=r[('快捷栏交换: %d ↔ %d')]
    -- PC 0071 FLAG=0xC0 OP_184
    r[(15)]=r[(9)]
    -- PC 0072 FLAG=0x40 OP_184
    r[(16)]=r[(1)]
    -- PC 0073 FLAG=0x00 OP_252
    do local I,F=E(r[(13)](U(T,(13)+1,(16))));(16)=F+(13)-1;local U=0;for L=(13),(16) do U=U+1;T[L]=I[U] end end
    -- PC 0074 FLAG=0x80 OP_143
    return U(T,(12),(0))
    -- PC 0075 FLAG=0x02 OP_140 [jump-target=89]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(88)
    -- PC 0076 FLAG=0xA0 OP_136 [linear-fusion-payloads=2]
    local I=r[(2)];r[(12)+1]=I;r[(12)]=I[('SetpcuickUsePosData')]; -- 融合载荷：r[(12)]=r[(2)]; -- 融合载荷：r[(12)]=r[(2)]
    -- PC 0077 FLAG=0x00 OP_078 [linear-fusion-payloads=1]
    r[(14)]=r[(1)]; -- 融合载荷：r[(14)]=r[(1)]
    -- PC 0078 FLAG=0x00 OP_308
    r[(15)]=r[(10)]
    -- PC 0079 FLAG=0x80 OP_338
    r[(16)]=(0)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0080 FLAG=0x80 OP_358
    r[(12)](U(T,(12)+1,(16)))
    -- PC 0081 FLAG=0x40 OP_011
    r[(12)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0082 FLAG=0x92 OP_137
    r[(13)]=__ENV[('string')]
    -- PC 0083 FLAG=0x20 OP_053
    r[(13)]=r[(13)][('format')]
    -- PC 0084 FLAG=0x12 OP_346
    r[(14)]=('快捷栏移动: %d → %d')
    -- PC 0085 FLAG=0x00 OP_078 [linear-fusion-payloads=1]
    r[(15)]=r[(9)]; -- 融合载荷：r[(15)]=r[(9)]
    -- PC 0086 FLAG=0xC0 OP_308
    r[(16)]=r[(1)]
    -- PC 0087 FLAG=0xC0 OP_392
    do local I,F=E(r[(13)](U(T,(13)+1,(16))));(16)=F+(13)-1;local U=0;for L=(13),(16) do U=U+1;T[L]=I[U] end end
    -- PC 0088 FLAG=0xC0 OP_143
    return U(T,(12),(0))
    -- PC 0089 FLAG=0x80 OP_117
    do local I,F=E(r[(6)](r[(6)+1],r[(6)+2]));for U=1,(2) do T[(6)+2+U]=I[U] end;if r[(6)+3]==nil then pc=pc+1 else r[(6)+2]=r[(6)+3] end end
    -- PC 0090 FLAG=0xC2 OP_140 [jump-target=37]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(36)
    -- PC 0091 FLAG=0x20 OP_142 [linear-fusion-payloads=1]
    local I=r[(3)];r[(6)+1]=I;r[(6)]=I[('GetItemDataByItemIndex')]; -- 融合载荷：r[(6)]=r[(3)]
    -- PC 0092 FLAG=0x00 OP_184
    r[(8)]=r[(0)]
    -- PC 0093 FLAG=0x80 OP_068
    r[(6)]=r[(6)](U(T,(6)+1,(8)))
    -- PC 0094 FLAG=0x00 OP_016
    if (not not r[(6)])~=((0)~=0) then pc=pc+1 end
    -- PC 0095 FLAG=0xC2 OP_215 [jump-target=101]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(100)
    -- PC 0096 FLAG=0x12 OP_071 [linear-fusion-payloads=1]
    r[(7)]=__ENV[('next')]; -- 融合载荷：r[(7)]=r[('next')]
    -- PC 0097 FLAG=0x40 OP_184
    r[(8)]=r[(6)]
    -- PC 0098 FLAG=0x80 OP_098
    r[(7)]=r[(7)](U(T,(7)+1,(8)))
    -- PC 0099 FLAG=0xC0 OP_342
    if (not not r[(7)])~=((1)~=0) then pc=pc+1 end
    -- PC 0100 FLAG=0x42 OP_140 [jump-target=104]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(103)
    -- PC 0101 FLAG=0x80 OP_011
    r[(7)]=(0)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0102 FLAG=0x52 OP_371
    r[(8)]=('物品不存在')
    -- PC 0103 FLAG=0x80 OP_220
    return U(T,(7),(8))
    -- PC 0104 FLAG=0xA0 OP_142 [linear-fusion-payloads=1]
    local I=r[(2)];r[(7)+1]=I;r[(7)]=I[('GetpcucikUseDataByPos')]; -- 融合载荷：r[(7)]=r[(2)]
    -- PC 0105 FLAG=0xC0 OP_184
    r[(9)]=r[(1)]
    -- PC 0106 FLAG=0xC0 OP_098
    r[(7)]=r[(7)](U(T,(7)+1,(9)))
    -- PC 0107 FLAG=0x80 OP_016
    if (not not r[(7)])~=((0)~=0) then pc=pc+1 end
    -- PC 0108 FLAG=0x82 OP_255 [jump-target=117]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(116)
    -- PC 0109 FLAG=0xA0 OP_142 [linear-fusion-payloads=1]
    local I=r[(2)];r[(8)+1]=I;r[(8)]=I[('SetpcuickUsePosData')]; -- 融合载荷：r[(8)]=r[(2)]
    -- PC 0110 FLAG=0x40 OP_184
    r[(10)]=r[(1)]
    -- PC 0111 FLAG=0xC0 OP_184
    r[(11)]=r[(7)]
    -- PC 0112 FLAG=0xC0 OP_338
    r[(12)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0113 FLAG=0x00 OP_187
    r[(8)](U(T,(8)+1,(12)))
    -- PC 0114 FLAG=0x60 OP_033
    local I=r[(3)];r[(8)+1]=I;r[(8)]=I[('addItemData')]
    -- PC 0115 FLAG=0x00 OP_308
    r[(10)]=r[(7)]
    -- PC 0116 FLAG=0xC0 OP_187
    r[(8)](U(T,(8)+1,(10)))
    -- PC 0117 FLAG=0x20 OP_270 [linear-fusion-payloads=1]
    r[(8)]=r[(6)][(1.0)]; -- 融合载荷：local I=r[(6)];r[(8)+1]=I;r[(8)]=I[(1.0)]
    -- PC 0118 FLAG=0xE0 OP_238
    local I=r[(3)];r[(9)+1]=I;r[(9)]=I[('DelItemData')]
    -- PC 0119 FLAG=0xC0 OP_308
    r[(11)]=r[(8)]
    -- PC 0120 FLAG=0xC0 OP_358
    r[(9)](U(T,(9)+1,(11)))
    -- PC 0121 FLAG=0x20 OP_136 [linear-fusion-payloads=2]
    local I=r[(2)];r[(9)+1]=I;r[(9)]=I[('SetpcuickUsePosData')]; -- 融合载荷：r[(9)]=r[(2)]; -- 融合载荷：r[(9)]=r[(2)]
    -- PC 0122 FLAG=0xC0 OP_078 [linear-fusion-payloads=1]
    r[(11)]=r[(1)]; -- 融合载荷：r[(11)]=r[(1)]
    -- PC 0123 FLAG=0x00 OP_308
    r[(12)]=r[(8)]
    -- PC 0124 FLAG=0x80 OP_401
    r[(13)]=(0)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0125 FLAG=0x80 OP_187
    r[(9)](U(T,(9)+1,(13)))
    -- PC 0126 FLAG=0xC0 OP_338
    r[(9)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0127 FLAG=0x52 OP_110 [linear-fusion-payloads=2]
    r[(10)]=__ENV[('string')]; -- 融合载荷：r[(10)]=r[('string')][(nil)]; -- 融合载荷：r[(10)]=('string')
    -- PC 0128 FLAG=0xE0 OP_363
    r[(10)]=r[(10)][('format')]
    -- PC 0129 FLAG=0x12 OP_286 [linear-fusion-payloads=1]
    r[(11)]=('已从背包移动到快捷栏位置%d'); -- 融合载荷：r[(11)]=r[('已从背包移动到快捷栏位置%d')]
    -- PC 0130 FLAG=0x80 OP_308
    r[(12)]=r[(1)]
    -- PC 0131 FLAG=0x80 OP_392
    do local I,F=E(r[(10)](U(T,(10)+1,(12))));(12)=F+(10)-1;local U=0;for L=(10),(12) do U=U+1;T[L]=I[U] end end
    -- PC 0132 FLAG=0x40 OP_143
    return U(T,(9),(0))
    -- PC 0133 FLAG=0x40 OP_100
    return
end
-- 原型入口：proto_doInit_UI_root_42

-- ============================================================================
-- 原型 root/43 | 候选名称：GetOwnerDescription | 指令记录：419 | 子原型：23 | 可变参数：0
-- 字节范围：28367:52718
local function proto_GetOwnerDescription_root_43(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'addOnClickEvent'
    -- K[1] = 'pcall'
    -- K[2] = 'Button_setTitleFontSize'
    -- K[3] = 'RequestStorageData'
    -- K[4] = 'ScheduleOnce'
    -- K[5] = 'takebut'
    -- K[6] = 'res/public/kaiti2.ttf'
    -- K[7] = '声望卷'
    -- K[8] = 'SL'
    -- K[9] = '%Y-%m-%d %H:%M:%S'
    -- K[10] = 'Builtsetting'
    -- K[11] = 'slot'
    -- K[12] = '开拉怪'
    -- K[13] = 18.0
    -- K[14] = 'retrieveProxy'
    -- K[15] = 'cruiseTimer'
    -- K[16] = ['unknown', 2]
    -- K[17] = 0.1
    -- K[18] = 'toggle'
    -- K[19] = '恶魔令牌'
    -- K[20] = '灵符'
    -- K[21] = 'MainProperty'
    -- K[22] = '转生水晶'
    -- K[23] = '绑定灵符'
    -- K[24] = 'Button_Create'
    -- K[25] = 'res/public/fuzhu_btn.png'
    -- K[26] = 'MoneyProxy'
    -- K[27] = 80.0
    -- K[28] = 'Button_setTitleFontName'
    -- K[29] = '绑定元宝'
    -- K[30] = '快速小退'
    -- K[31] = '随机传送石'
    -- K[32] = '永久随机石'
    -- K[33] = '免战回城石'
    -- K[34] = 'GetMoneyCountById'
    -- K[35] = '大陆传送石'
    -- K[36] = 'rewardbut'
    -- K[37] = '关黑名单'
    -- K[38] = 'shiqubut'
    -- K[39] = '关拉怪'
    -- K[40] = 'clearblacklistbut'
    -- K[41] = 'NPCStorageProxy'
    -- K[42] = '插件初始化完成'
    -- K[43] = 'getWorldPosition'
    -- K[44] = 4.0
    -- K[45] = 'time'
    -- K[46] = 'width'
    -- K[47] = '清距离值'
    -- K[48] = '开拾取'
    -- K[49] = '关丢物品'
    -- K[50] = 1.0
    -- K[51] = 'getContentSize'
    -- K[52] = 'Button_setTitleText'
    -- K[53] = 'storagebut'
    -- K[54] = '血龙宝珠'
    -- K[55] = 10.0
    -- K[56] = 'UnSchedule'
    -- K[57] = '资源统计'
    -- K[58] = 'Panel_mini_chat'
    -- K[59] = '盟重传送石'
    -- K[60] = 'date'
    -- K[61] = '_ui'
    -- K[62] = 'GetMoneyIdByName'
    -- K[63] = 2.0
    -- K[64] = 'hidebut'
    -- K[65] = 'xiaotuibut'
    -- K[66] = 'os'
    -- K[67] = '洗髓丹'
    -- K[68] = '--'
    -- K[69] = 'ProxyTable'
    -- K[70] = 'Facade'
    -- K[71] = 'initTimeStr'
    -- K[72] = '隐 藏'
    -- K[73] = 40.0
    -- K[74] = 'cleardistancebut'
    -- K[75] = '开黑名单'
    -- K[76] = 'key'
    -- K[77] = 'ipairs'
    -- K[78] = 'blacklistbut'
    -- K[79] = '关奖励'
    -- K[80] = 'GUI'
    -- K[81] = 'moneybut'
    -- K[82] = 'diuqibut'
    -- K[83] = 'clearmonsterbut'
    -- K[84] = 'initTime'
    -- K[85] = 'initSnapshot'
    -- K[86] = 'Schedule'
    -- K[87] = 'yinguaibut'
    -- K[88] = 'name'
    -- K[89] = '盟重回城石'
    -- K[90] = 3.0
    -- K[91] = '关拾取'
    -- K[92] = 'names'
    -- K[93] = 'x'
    -- K[94] = 'Attach_UITop'
    -- K[95] = '清黑名单'
    -- K[96] = '元宝'
    -- K[97] = '开奖励'
    -- K[98] = '清怪物值'
    -- K[99] = 'y'
    -- K[100] = '永久回城石'
    -- K[101] = 'global'
    -- K[102] = '悟道茶'
    -- K[103] = 0.0
    -- K[104] = '开丢物品'
    -- 指令语义：
    -- PC 0001 FLAG=0x40 OP_134 [linear-fusion-payloads=1]
    r[(0)]=up[(0)]; -- 融合载荷：r[(0)]=(0)
    -- PC 0002 FLAG=0x52 OP_371
    r[(1)]=('插件初始化完成')
    -- PC 0003 FLAG=0x00 OP_187
    r[(0)](U(T,(0)+1,(1)))
    -- PC 0004 FLAG=0x80 OP_090 [linear-fusion-payloads=1]
    r[(0)]={}; -- 融合载荷：r[(0)]=(4)
    -- PC 0005 FLAG=0x52 OP_226 [linear-fusion-payloads=3]
    r[(1)]=('元宝'); -- 融合载荷：r[(1)]=('元宝'); -- 融合载荷：r[(1)]=('元宝'); -- 融合载荷：r[(1)]=('元宝')
    -- PC 0006 FLAG=0x12 OP_061 [linear-fusion-payloads=2]
    r[(2)]=('绑定元宝'); -- 融合载荷：r[(2)]=('绑定元宝'); -- 融合载荷：r[(2)]=('绑定元宝')
    -- PC 0007 FLAG=0x52 OP_282 [linear-fusion-payloads=1]
    r[(3)]=('灵符'); -- 融合载荷：r[(3)]=('灵符')
    -- PC 0008 FLAG=0x92 OP_371
    r[(4)]=('绑定灵符')
    -- PC 0009 FLAG=0x00 OP_237
    do local I=(4);if I==0 then I=math.max(0,(4)-(0)) end;local F=r[(0)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(0)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(0)]=O else for O=1,I do F[L+O]=T[(0)+O] end end;end
    -- PC 0010 FLAG=0x80 OP_090 [linear-fusion-payloads=1]
    r[(1)]={}; -- 融合载荷：r[(1)]=(6)
    -- PC 0011 FLAG=0x52 OP_371
    r[(2)]=('声望卷')
    -- PC 0012 FLAG=0x92 OP_346
    r[(3)]=('悟道茶')
    -- PC 0013 FLAG=0x52 OP_346
    r[(4)]=('洗髓丹')
    -- PC 0014 FLAG=0x52 OP_061 [linear-fusion-payloads=2]
    r[(5)]=('转生水晶'); -- 融合载荷：r[(5)]=('转生水晶'); -- 融合载荷：r[(5)]=('转生水晶')
    -- PC 0015 FLAG=0x92 OP_371
    r[(6)]=('恶魔令牌')
    -- PC 0016 FLAG=0x12 OP_346
    r[(7)]=('血龙宝珠')
    -- PC 0017 FLAG=0x00 OP_402
    do local I=(6);if I==0 then I=math.max(0,(6)-(1)) end;local F=r[(1)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(1)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(1)]=O else for O=1,I do F[L+O]=T[(1)+O] end end;end
    -- PC 0018 FLAG=0xC0 OP_027 [closure-child-index=0; captures=0; child-path=root/43/1]
    do local I=O[(0)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(2)]=M(I,U,S) end
    -- PC 0019 FLAG=0x40 OP_130
    r[(3)]=up[(1)]
    -- PC 0020 FLAG=0xB0 OP_146
    do local I=('initTime');local F=(0.0);r[(3)][I]=F end
    -- PC 0021 FLAG=0x00 OP_130
    r[(3)]=up[(1)]
    -- PC 0022 FLAG=0x30 OP_301 [linear-fusion-payloads=1]
    do local I=('initTimeStr');local F=('--');r[(3)][I]=F end; -- 融合载荷：r[(3)]=__ENV[('initTimeStr')]
    -- PC 0023 FLAG=0x92 OP_137
    r[(3)]=__ENV[('os')]
    -- PC 0024 FLAG=0x40 OP_016
    if (not not r[(3)])~=((0)~=0) then pc=pc+1 end
    -- PC 0025 FLAG=0x82 OP_255 [jump-target=56]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(55)
    -- PC 0026 FLAG=0x92 OP_397 [linear-fusion-payloads=1]
    r[(3)]=__ENV[('os')]; -- 融合载荷：r[(3)]=r[('os')][(nil)]
    -- PC 0027 FLAG=0xE0 OP_053
    r[(3)]=r[(3)][('time')]
    -- PC 0028 FLAG=0x80 OP_016
    if (not not r[(3)])~=((0)~=0) then pc=pc+1 end
    -- PC 0029 FLAG=0x42 OP_255 [jump-target=56]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(55)
    -- PC 0030 FLAG=0x12 OP_397 [linear-fusion-payloads=1]
    r[(3)]=__ENV[('os')]; -- 融合载荷：r[(3)]=r[('os')][(nil)]
    -- PC 0031 FLAG=0x60 OP_363
    r[(3)]=r[(3)][('date')]
    -- PC 0032 FLAG=0x80 OP_016
    if (not not r[(3)])~=((0)~=0) then pc=pc+1 end
    -- PC 0033 FLAG=0x02 OP_140 [jump-target=56]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(55)
    -- PC 0034 FLAG=0x92 OP_137
    r[(3)]=__ENV[('pcall')]
    -- PC 0035 FLAG=0xD2 OP_397 [linear-fusion-payloads=1]
    r[(4)]=__ENV[('os')]; -- 融合载荷：r[(4)]=r[('os')][(nil)]
    -- PC 0036 FLAG=0xA0 OP_375
    r[(4)]=r[(4)][('time')]
    -- PC 0037 FLAG=0xC0 OP_183
    do local I={ r[(3)](U(T,(3)+1,(4))) };local F=0;for U=(3),(4) do F=F+1;T[U]=I[F] end end
    -- PC 0038 FLAG=0x00 OP_016
    if (not not r[(3)])~=((0)~=0) then pc=pc+1 end
    -- PC 0039 FLAG=0x02 OP_255 [jump-target=56]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(55)
    -- PC 0040 FLAG=0x00 OP_016
    if (not not r[(4)])~=((0)~=0) then pc=pc+1 end
    -- PC 0041 FLAG=0x02 OP_255 [jump-target=56]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(55)
    -- PC 0042 FLAG=0xC0 OP_130
    r[(5)]=up[(1)]
    -- PC 0043 FLAG=0x50 OP_268
    do local I=('initTime');local F=r[(4)];r[(5)][I]=F end
    -- PC 0044 FLAG=0x52 OP_137
    r[(5)]=__ENV[('pcall')]
    -- PC 0045 FLAG=0xD2 OP_110 [linear-fusion-payloads=2]
    r[(6)]=__ENV[('os')]; -- 融合载荷：r[(6)]=r[('os')][(nil)]; -- 融合载荷：r[(6)]=('os')
    -- PC 0046 FLAG=0x20 OP_363
    r[(6)]=r[(6)][('date')]
    -- PC 0047 FLAG=0xD2 OP_286 [linear-fusion-payloads=1]
    r[(7)]=('%Y-%m-%d %H:%M:%S'); -- 融合载荷：r[(7)]=r[('%Y-%m-%d %H:%M:%S')]
    -- PC 0048 FLAG=0xC0 OP_184
    r[(8)]=r[(4)]
    -- PC 0049 FLAG=0x00 OP_359
    do local I={ r[(5)](U(T,(5)+1,(8))) };local F=0;for U=(5),(6) do F=F+1;T[U]=I[F] end end
    -- PC 0050 FLAG=0x40 OP_016
    if (not not r[(5)])~=((0)~=0) then pc=pc+1 end
    -- PC 0051 FLAG=0x42 OP_215 [jump-target=56]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(55)
    -- PC 0052 FLAG=0x80 OP_016
    if (not not r[(6)])~=((0)~=0) then pc=pc+1 end
    -- PC 0053 FLAG=0x42 OP_215 [jump-target=56]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(55)
    -- PC 0054 FLAG=0x80 OP_130
    r[(7)]=up[(1)]
    -- PC 0055 FLAG=0xD0 OP_268
    do local I=('initTimeStr');local F=r[(6)];r[(7)][I]=F end
    -- PC 0056 FLAG=0x80 OP_130
    r[(3)]=up[(1)]
    -- PC 0057 FLAG=0x40 OP_105
    r[(4)]={}
    -- PC 0058 FLAG=0x90 OP_355
    do local I=('initSnapshot');local F=r[(4)];r[(3)][I]=F end
    -- PC 0059 FLAG=0x52 OP_179 [linear-fusion-payloads=5]
    r[(3)]=__ENV[('global')]; -- 融合载荷：r[(3)]=r[('global')][(nil)]; -- 融合载荷：local I=r[('global')];r[(3)+1]=I;r[(3)]=I[(nil)]; -- 融合载荷：r[(3)]=__ENV[('global')]; -- 融合载荷：r[(3)]=r[('global')][(nil)]; -- 融合载荷：r[(3)]=r[('global')][(nil)]
    -- PC 0060 FLAG=0xE0 OP_260 [linear-fusion-payloads=4]
    r[(3)]=r[(3)][('Facade')]; -- 融合载荷：local I=r[(3)];r[(3)+1]=I;r[(3)]=I[('Facade')]; -- 融合载荷：r[(3)]=__ENV[(3)]; -- 融合载荷：r[(3)]=r[(3)][('Facade')]; -- 融合载荷：r[(3)]=r[(3)][('Facade')]
    -- PC 0061 FLAG=0x20 OP_201 [linear-fusion-payloads=3]
    local I=r[(3)];r[(3)+1]=I;r[(3)]=I[('retrieveProxy')]; -- 融合载荷：r[(3)]=__ENV[(3)]; -- 融合载荷：r[(3)]=r[(3)][('retrieveProxy')]; -- 融合载荷：r[(3)]=r[(3)][('retrieveProxy')]
    -- PC 0062 FLAG=0xD2 OP_198 [linear-fusion-payloads=2]
    r[(5)]=__ENV[('global')]; -- 融合载荷：r[(5)]=r[('global')][(nil)]; -- 融合载荷：r[(5)]=r[('global')][(nil)]
    -- PC 0063 FLAG=0xA0 OP_049 [linear-fusion-payloads=1]
    r[(5)]=r[(5)][('ProxyTable')]; -- 融合载荷：r[(5)]=r[(5)][('ProxyTable')]
    -- PC 0064 FLAG=0x60 OP_053
    r[(5)]=r[(5)][('MoneyProxy')]
    -- PC 0065 FLAG=0x00 OP_068
    r[(3)]=r[(3)](U(T,(3)+1,(5)))
    -- PC 0066 FLAG=0x40 OP_016
    if (not not r[(3)])~=((0)~=0) then pc=pc+1 end
    -- PC 0067 FLAG=0x82 OP_215 [jump-target=88]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(87)
    -- PC 0068 FLAG=0x12 OP_071 [linear-fusion-payloads=1]
    r[(4)]=__ENV[('ipairs')]; -- 融合载荷：r[(4)]=r[('ipairs')]
    -- PC 0069 FLAG=0xC0 OP_184
    r[(5)]=r[(0)]
    -- PC 0070 FLAG=0x40 OP_359
    do local I={ r[(4)](U(T,(4)+1,(5))) };local F=0;for U=(4),(6) do F=F+1;T[U]=I[F] end end
    -- PC 0071 FLAG=0xC2 OP_215 [jump-target=86]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(85)
    -- PC 0072 FLAG=0xE0 OP_142 [linear-fusion-payloads=1]
    local I=r[(3)];r[(9)+1]=I;r[(9)]=I[('GetMoneyIdByName')]; -- 融合载荷：r[(9)]=r[(3)]
    -- PC 0073 FLAG=0x40 OP_308
    r[(11)]=r[(8)]
    -- PC 0074 FLAG=0x80 OP_098
    r[(9)]=r[(9)](U(T,(9)+1,(11)))
    -- PC 0075 FLAG=0x80 OP_016
    if (not not r[(9)])~=((0)~=0) then pc=pc+1 end
    -- PC 0076 FLAG=0x82 OP_255 [jump-target=86]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(85)
    -- PC 0077 FLAG=0x80 OP_159 [linear-fusion-payloads=1]
    r[(10)]=up[(1)]; -- 融合载荷：r[(10)]=r[(1)][(0)]
    -- PC 0078 FLAG=0x60 OP_270 [linear-fusion-payloads=1]
    r[(10)]=r[(10)][('initSnapshot')]; -- 融合载荷：local I=r[(10)];r[(10)+1]=I;r[(10)]=I[('initSnapshot')]
    -- PC 0079 FLAG=0xA0 OP_238
    local I=r[(3)];r[(11)+1]=I;r[(11)]=I[('GetMoneyCountById')]
    -- PC 0080 FLAG=0xC0 OP_308
    r[(13)]=r[(9)]
    -- PC 0081 FLAG=0x40 OP_098
    r[(11)]=r[(11)](U(T,(11)+1,(13)))
    -- PC 0082 FLAG=0xC0 OP_342
    if (not not r[(11)])~=((1)~=0) then pc=pc+1 end
    -- PC 0083 FLAG=0x82 OP_140 [jump-target=85]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(84)
    -- PC 0084 FLAG=0x52 OP_346
    r[(11)]=(0.0)
    -- PC 0085 FLAG=0x40 OP_327
    do local I=r[(8)];local F=r[(11)];r[(10)][I]=F end
    -- PC 0086 FLAG=0x00 OP_117
    do local I,F=E(r[(4)](r[(4)+1],r[(4)+2]));for U=1,(2) do T[(4)+2+U]=I[U] end;if r[(4)+3]==nil then pc=pc+1 else r[(4)+2]=r[(4)+3] end end
    -- PC 0087 FLAG=0x02 OP_255 [jump-target=72]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(71)
    -- PC 0088 FLAG=0x52 OP_071 [linear-fusion-payloads=1]
    r[(4)]=__ENV[('ipairs')]; -- 融合载荷：r[(4)]=r[('ipairs')]
    -- PC 0089 FLAG=0xC0 OP_184
    r[(5)]=r[(1)]
    -- PC 0090 FLAG=0x00 OP_359
    do local I={ r[(4)](U(T,(4)+1,(5))) };local F=0;for U=(4),(6) do F=F+1;T[U]=I[F] end end
    -- PC 0091 FLAG=0x42 OP_140 [jump-target=98]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(97)
    -- PC 0092 FLAG=0x00 OP_159 [linear-fusion-payloads=1]
    r[(9)]=up[(1)]; -- 融合载荷：r[(9)]=r[(1)][(0)]
    -- PC 0093 FLAG=0xA0 OP_032
    r[(9)]=r[(9)][('initSnapshot')]
    -- PC 0094 FLAG=0x80 OP_078 [linear-fusion-payloads=1]
    r[(10)]=r[(2)]; -- 融合载荷：r[(10)]=r[(2)]
    -- PC 0095 FLAG=0x00 OP_184
    r[(11)]=r[(8)]
    -- PC 0096 FLAG=0x40 OP_098
    r[(10)]=r[(10)](U(T,(10)+1,(11)))
    -- PC 0097 FLAG=0xC0 OP_327
    do local I=r[(8)];local F=r[(10)];r[(9)][I]=F end
    -- PC 0098 FLAG=0xC0 OP_386
    do local I,F=E(r[(4)](r[(4)+1],r[(4)+2]));for U=1,(2) do T[(4)+2+U]=I[U] end;if r[(4)+3]==nil then pc=pc+1 else r[(4)+2]=r[(4)+3] end end
    -- PC 0099 FLAG=0x82 OP_255 [jump-target=92]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(91)
    -- PC 0100 FLAG=0x92 OP_137
    r[(4)]=__ENV[('Builtsetting')]
    -- PC 0101 FLAG=0xC0 OP_187
    r[(4)](U(T,(4)+1,(4)))
    -- PC 0102 FLAG=0x00 OP_019 [linear-fusion-payloads=1]
    r[(4)]={}; -- 融合载荷：r[(4)]={}
    -- PC 0103 FLAG=0x80 OP_105
    r[(5)]={}
    -- PC 0104 FLAG=0x70 OP_146
    do local I=('slot');local F=(1.0);r[(5)][I]=F end
    -- PC 0105 FLAG=0x80 OP_090 [linear-fusion-payloads=1]
    r[(6)]={}; -- 融合载荷：r[(6)]=(3)
    -- PC 0106 FLAG=0x92 OP_061 [linear-fusion-payloads=2]
    r[(7)]=('永久回城石'); -- 融合载荷：r[(7)]=('永久回城石'); -- 融合载荷：r[(7)]=('永久回城石')
    -- PC 0107 FLAG=0xD2 OP_282 [linear-fusion-payloads=1]
    r[(8)]=('盟重回城石'); -- 融合载荷：r[(8)]=('盟重回城石')
    -- PC 0108 FLAG=0x12 OP_346
    r[(9)]=('盟重传送石')
    -- PC 0109 FLAG=0x40 OP_237
    do local I=(3);if I==0 then I=math.max(0,(3)-(6)) end;local F=r[(6)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(6)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(6)]=O else for O=1,I do F[L+O]=T[(6)+O] end end;end
    -- PC 0110 FLAG=0x10 OP_355
    do local I=('names');local F=r[(6)];r[(5)][I]=F end
    -- PC 0111 FLAG=0x80 OP_410
    r[(6)]={}
    -- PC 0112 FLAG=0x70 OP_146
    do local I=('slot');local F=(2.0);r[(6)][I]=F end
    -- PC 0113 FLAG=0x00 OP_120
    r[(7)]={}
    -- PC 0114 FLAG=0x92 OP_282 [linear-fusion-payloads=1]
    r[(8)]=('永久随机石'); -- 融合载荷：r[(8)]=('永久随机石')
    -- PC 0115 FLAG=0xD2 OP_371
    r[(9)]=('随机传送石')
    -- PC 0116 FLAG=0xC0 OP_402
    do local I=(2);if I==0 then I=math.max(0,(2)-(7)) end;local F=r[(7)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(7)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(7)]=O else for O=1,I do F[L+O]=T[(7)+O] end end;end
    -- PC 0117 FLAG=0x10 OP_355
    do local I=('names');local F=r[(7)];r[(6)][I]=F end
    -- PC 0118 FLAG=0xC0 OP_410
    r[(7)]={}
    -- PC 0119 FLAG=0x30 OP_156
    do local I=('slot');local F=(3.0);r[(7)][I]=F end
    -- PC 0120 FLAG=0x40 OP_410
    r[(8)]={}
    -- PC 0121 FLAG=0x92 OP_346
    r[(9)]=('大陆传送石')
    -- PC 0122 FLAG=0x40 OP_153
    do local I=(1);if I==0 then I=math.max(0,(1)-(8)) end;local F=r[(8)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(8)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(8)]=O else for O=1,I do F[L+O]=T[(8)+O] end end;end
    -- PC 0123 FLAG=0x10 OP_268
    do local I=('names');local F=r[(8)];r[(7)][I]=F end
    -- PC 0124 FLAG=0x40 OP_120
    r[(8)]={}
    -- PC 0125 FLAG=0xB0 OP_156
    do local I=('slot');local F=(4.0);r[(8)][I]=F end
    -- PC 0126 FLAG=0x40 OP_120
    r[(9)]={}
    -- PC 0127 FLAG=0x92 OP_371
    r[(10)]=('免战回城石')
    -- PC 0128 FLAG=0x80 OP_088
    do local I=(1);if I==0 then I=math.max(0,(1)-(9)) end;local F=r[(9)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(9)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(9)]=O else for O=1,I do F[L+O]=T[(9)+O] end end;end
    -- PC 0129 FLAG=0x50 OP_355
    do local I=('names');local F=r[(9)];r[(8)][I]=F end
    -- PC 0130 FLAG=0x40 OP_088
    do local I=(4);if I==0 then I=math.max(0,(4)-(4)) end;local F=r[(4)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(4)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(4)]=O else for O=1,I do F[L+O]=T[(4)+O] end end;end
    -- PC 0131 FLAG=0xD2 OP_071 [linear-fusion-payloads=1]
    r[(5)]=__ENV[('ipairs')]; -- 融合载荷：r[(5)]=r[('ipairs')]
    -- PC 0132 FLAG=0x00 OP_184
    r[(6)]=r[(4)]
    -- PC 0133 FLAG=0xC0 OP_233
    do local I={ r[(5)](U(T,(5)+1,(6))) };local F=0;for U=(5),(7) do F=F+1;T[U]=I[F] end end
    -- PC 0134 FLAG=0x02 OP_140 [jump-target=143]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(142)
    -- PC 0135 FLAG=0x92 OP_335 [linear-fusion-payloads=1]
    r[(10)]=__ENV[('SL')]; -- 融合载荷：local I=r[('SL')];r[(10)+1]=I;r[(10)]=I[(nil)]
    -- PC 0136 FLAG=0xA0 OP_121
    local I=r[(10)];r[(10)+1]=I;r[(10)]=I[('ScheduleOnce')]
    -- PC 0137 FLAG=0x40 OP_154 [linear-fusion-payloads=2, closure-child-index=16; captures=2; child-path=root/43/17]
    do local I=O[(16)];local F={};F[-1]=(2);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(2)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(12)]=M(I,U,S) end
    -- PC 0138 FLAG=0xC0 OP_387
    r[(0)]=r[(9)]
    -- PC 0139 FLAG=0x00 OP_325
    r[(0)]=up[(0)]
    -- PC 0140 FLAG=0xE0 OP_024
    r[(13)]=r[(8)]*(0.1)
    -- PC 0141 FLAG=0x00 OP_187
    r[(10)](U(T,(10)+1,(13)))
    -- PC 0142 FLAG=0x80 OP_262
    do local I=(8);local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (0)=K[2];if Z==T and I<=(0) then F[(0)]=Z[(0)];K[1]=F end end end end end
    -- PC 0143 FLAG=0x40 OP_339
    do local I,F=E(r[(5)](r[(5)+1],r[(5)+2]));for U=1,(2) do T[(5)+2+U]=I[U] end;if r[(5)+3]==nil then pc=pc+1 else r[(5)+2]=r[(5)+3] end end
    -- PC 0144 FLAG=0x82 OP_140 [jump-target=135]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(134)
    -- PC 0145 FLAG=0xC0 OP_234
    for I=(5),(5) do T[I]=nil end
    -- PC 0146 FLAG=0xC0 OP_159 [linear-fusion-payloads=1]
    r[(6)]=up[(2)]; -- 融合载荷：r[(6)]=r[(2)][(0)]
    -- PC 0147 FLAG=0xE0 OP_363
    r[(6)]=r[(6)][('cruiseTimer')]
    -- PC 0148 FLAG=0x40 OP_016
    if (not not r[(6)])~=((0)~=0) then pc=pc+1 end
    -- PC 0149 FLAG=0x02 OP_140 [jump-target=157]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(156)
    -- PC 0150 FLAG=0x52 OP_335 [linear-fusion-payloads=1]
    r[(6)]=__ENV[('SL')]; -- 融合载荷：local I=r[('SL')];r[(6)+1]=I;r[(6)]=I[(nil)]
    -- PC 0151 FLAG=0xA0 OP_238
    local I=r[(6)];r[(6)+1]=I;r[(6)]=I[('UnSchedule')]
    -- PC 0152 FLAG=0x00 OP_130
    r[(8)]=up[(2)]
    -- PC 0153 FLAG=0xE0 OP_363
    r[(8)]=r[(8)][('cruiseTimer')]
    -- PC 0154 FLAG=0x80 OP_358
    r[(6)](U(T,(6)+1,(8)))
    -- PC 0155 FLAG=0x80 OP_089 [linear-fusion-payloads=1]
    r[(6)]=up[(2)]; -- 融合载荷：do local I=(2);local F=(0);r[(6)][I]=F end
    -- PC 0156 FLAG=0xB0 OP_146
    do local I=('cruiseTimer');local F=(['unknown', 2]);r[(6)][I]=F end
    -- PC 0157 FLAG=0x80 OP_130
    r[(6)]=up[(2)]
    -- PC 0158 FLAG=0x12 OP_335 [linear-fusion-payloads=1]
    r[(7)]=__ENV[('SL')]; -- 融合载荷：local I=r[('SL')];r[(7)+1]=I;r[(7)]=I[(nil)]
    -- PC 0159 FLAG=0x20 OP_121
    local I=r[(7)];r[(7)+1]=I;r[(7)]=I[('Schedule')]
    -- PC 0160 FLAG=0x40 OP_027 [linear-fusion-payloads=3, closure-child-index=12; captures=3; child-path=root/43/13]
    do local I=O[(12)];local F={};F[-1]=(3);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(3)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(9)]=M(I,U,S) end
    -- PC 0161 FLAG=0xC0 OP_387
    r[(0)]=r[(5)]
    -- PC 0162 FLAG=0x00 OP_325
    r[(0)]=up[(3)]
    -- PC 0163 FLAG=0x80 OP_325
    r[(0)]=up[(0)]
    -- PC 0164 FLAG=0x12 OP_346
    r[(10)]=(1.0)
    -- PC 0165 FLAG=0x80 OP_098
    r[(7)]=r[(7)](U(T,(7)+1,(10)))
    -- PC 0166 FLAG=0x50 OP_268
    do local I=('cruiseTimer');local F=r[(7)];r[(6)][I]=F end
    -- PC 0167 FLAG=0x52 OP_309 [linear-fusion-payloads=2]
    r[(6)]=__ENV[('global')]; -- 融合载荷：r[(6)]=r[('global')][(nil)]; -- 融合载荷：local I=r[('global')];r[(6)+1]=I;r[(6)]=I[(nil)]
    -- PC 0168 FLAG=0x20 OP_260 [linear-fusion-payloads=4]
    r[(6)]=r[(6)][('Facade')]; -- 融合载荷：local I=r[(6)];r[(6)+1]=I;r[(6)]=I[('Facade')]; -- 融合载荷：r[(6)]=__ENV[(6)]; -- 融合载荷：r[(6)]=r[(6)][('Facade')]; -- 融合载荷：r[(6)]=r[(6)][('Facade')]
    -- PC 0169 FLAG=0x20 OP_201 [linear-fusion-payloads=3]
    local I=r[(6)];r[(6)+1]=I;r[(6)]=I[('retrieveProxy')]; -- 融合载荷：r[(6)]=__ENV[(6)]; -- 融合载荷：r[(6)]=r[(6)][('retrieveProxy')]; -- 融合载荷：r[(6)]=r[(6)][('retrieveProxy')]
    -- PC 0170 FLAG=0x52 OP_137
    r[(8)]=__ENV[('global')]
    -- PC 0171 FLAG=0x60 OP_049 [linear-fusion-payloads=1]
    r[(8)]=r[(8)][('ProxyTable')]; -- 融合载荷：r[(8)]=r[(8)][('ProxyTable')]
    -- PC 0172 FLAG=0xA0 OP_053
    r[(8)]=r[(8)][('NPCStorageProxy')]
    -- PC 0173 FLAG=0xC0 OP_098
    r[(6)]=r[(6)](U(T,(6)+1,(8)))
    -- PC 0174 FLAG=0x12 OP_182
    __ENV[('NPCStorageProxy')]=r[(6)]
    -- PC 0175 FLAG=0x12 OP_137
    r[(6)]=__ENV[('NPCStorageProxy')]
    -- PC 0176 FLAG=0x80 OP_016
    if (not not r[(6)])~=((0)~=0) then pc=pc+1 end
    -- PC 0177 FLAG=0x02 OP_255 [jump-target=181]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(180)
    -- PC 0178 FLAG=0x12 OP_335 [linear-fusion-payloads=1]
    r[(6)]=__ENV[('NPCStorageProxy')]; -- 融合载荷：local I=r[('NPCStorageProxy')];r[(6)+1]=I;r[(6)]=I[(nil)]
    -- PC 0179 FLAG=0xE0 OP_033
    local I=r[(6)];r[(6)+1]=I;r[(6)]=I[('RequestStorageData')]
    -- PC 0180 FLAG=0xC0 OP_358
    r[(6)](U(T,(6)+1,(7)))
    -- PC 0181 FLAG=0x12 OP_335 [linear-fusion-payloads=1]
    r[(6)]=__ENV[('GUI')]; -- 融合载荷：local I=r[('GUI')];r[(6)+1]=I;r[(6)]=I[(nil)]
    -- PC 0182 FLAG=0xE0 OP_033
    local I=r[(6)];r[(6)+1]=I;r[(6)]=I[('Attach_UITop')]
    -- PC 0183 FLAG=0x00 OP_068
    r[(6)]=r[(6)](U(T,(6)+1,(7)))
    -- PC 0184 FLAG=0x12 OP_137
    r[(7)]=__ENV[('MainProperty')]
    -- PC 0185 FLAG=0x20 OP_049 [linear-fusion-payloads=1]
    r[(7)]=r[(7)][('_ui')]; -- 融合载荷：r[(7)]=r[(7)][('_ui')]
    -- PC 0186 FLAG=0x20 OP_270 [linear-fusion-payloads=1]
    r[(7)]=r[(7)][('Panel_mini_chat')]; -- 融合载荷：local I=r[(7)];r[(7)+1]=I;r[(7)]=I[('Panel_mini_chat')]
    -- PC 0187 FLAG=0x60 OP_121
    local I=r[(7)];r[(8)+1]=I;r[(8)]=I[('getWorldPosition')]
    -- PC 0188 FLAG=0x80 OP_098
    r[(8)]=r[(8)](U(T,(8)+1,(9)))
    -- PC 0189 FLAG=0xE0 OP_238
    local I=r[(7)];r[(9)+1]=I;r[(9)]=I[('getContentSize')]
    -- PC 0190 FLAG=0x00 OP_098
    r[(9)]=r[(9)](U(T,(9)+1,(10)))
    -- PC 0191 FLAG=0x20 OP_049 [linear-fusion-payloads=1]
    r[(10)]=r[(8)][('x')]; -- 融合载荷：r[(10)]=r[(8)][('x')]
    -- PC 0192 FLAG=0xA0 OP_375
    r[(11)]=r[(9)][('width')]
    -- PC 0193 FLAG=0x00 OP_189
    r[(10)]=r[(10)]+r[(11)]
    -- PC 0194 FLAG=0xE0 OP_363
    r[(11)]=r[(8)][('y')]
    -- PC 0195 FLAG=0x40 OP_019 [linear-fusion-payloads=1]
    r[(12)]={}; -- 融合载荷：r[(12)]={}
    -- PC 0196 FLAG=0xC0 OP_410
    r[(13)]={}
    -- PC 0197 FLAG=0xB0 OP_156
    do local I=('key');local F=('yinguaibut');r[(13)][I]=F end
    -- PC 0198 FLAG=0xB0 OP_146
    do local I=('name');local F=('开拉怪');r[(13)][I]=F end
    -- PC 0199 FLAG=0xF0 OP_146
    do local I=('toggle');local F=('关拉怪');r[(13)][I]=F end
    -- PC 0200 FLAG=0xC0 OP_120
    r[(14)]={}
    -- PC 0201 FLAG=0xF0 OP_156
    do local I=('key');local F=('blacklistbut');r[(14)][I]=F end
    -- PC 0202 FLAG=0x30 OP_156
    do local I=('name');local F=('开黑名单');r[(14)][I]=F end
    -- PC 0203 FLAG=0xF0 OP_146
    do local I=('toggle');local F=('关黑名单');r[(14)][I]=F end
    -- PC 0204 FLAG=0x80 OP_410
    r[(15)]={}
    -- PC 0205 FLAG=0x70 OP_156
    do local I=('key');local F=('clearblacklistbut');r[(15)][I]=F end
    -- PC 0206 FLAG=0xF0 OP_146
    do local I=('name');local F=('清黑名单');r[(15)][I]=F end
    -- PC 0207 FLAG=0x40 OP_105
    r[(16)]={}
    -- PC 0208 FLAG=0x70 OP_146
    do local I=('key');local F=('moneybut');r[(16)][I]=F end
    -- PC 0209 FLAG=0xF0 OP_146
    do local I=('name');local F=('资源统计');r[(16)][I]=F end
    -- PC 0210 FLAG=0x80 OP_153
    do local I=(4);if I==0 then I=math.max(0,(4)-(12)) end;local F=r[(12)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(12)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(12)]=O else for O=1,I do F[L+O]=T[(12)+O] end end;end
    -- PC 0211 FLAG=0x40 OP_105
    r[(13)]={}
    -- PC 0212 FLAG=0x00 OP_120
    r[(14)]={}
    -- PC 0213 FLAG=0x30 OP_156
    do local I=('key');local F=('shiqubut');r[(14)][I]=F end
    -- PC 0214 FLAG=0x70 OP_146
    do local I=('name');local F=('开拾取');r[(14)][I]=F end
    -- PC 0215 FLAG=0xF0 OP_146
    do local I=('toggle');local F=('关拾取');r[(14)][I]=F end
    -- PC 0216 FLAG=0x00 OP_105
    r[(15)]={}
    -- PC 0217 FLAG=0x30 OP_156
    do local I=('key');local F=('diuqibut');r[(15)][I]=F end
    -- PC 0218 FLAG=0x70 OP_156
    do local I=('name');local F=('开丢物品');r[(15)][I]=F end
    -- PC 0219 FLAG=0x30 OP_146
    do local I=('toggle');local F=('关丢物品');r[(15)][I]=F end
    -- PC 0220 FLAG=0x00 OP_410
    r[(16)]={}
    -- PC 0221 FLAG=0x30 OP_156
    do local I=('key');local F=('xiaotuibut');r[(16)][I]=F end
    -- PC 0222 FLAG=0x30 OP_156
    do local I=('name');local F=('快速小退');r[(16)][I]=F end
    -- PC 0223 FLAG=0x40 OP_088
    do local I=(3);if I==0 then I=math.max(0,(3)-(13)) end;local F=r[(13)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(13)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(13)]=O else for O=1,I do F[L+O]=T[(13)+O] end end;end
    -- PC 0224 FLAG=0x40 OP_410
    r[(14)]={}
    -- PC 0225 FLAG=0xC0 OP_105
    r[(15)]={}
    -- PC 0226 FLAG=0x70 OP_146
    do local I=('key');local F=('clearmonsterbut');r[(15)][I]=F end
    -- PC 0227 FLAG=0x70 OP_156
    do local I=('name');local F=('清怪物值');r[(15)][I]=F end
    -- PC 0228 FLAG=0x80 OP_105
    r[(16)]={}
    -- PC 0229 FLAG=0x70 OP_146
    do local I=('key');local F=('cleardistancebut');r[(16)][I]=F end
    -- PC 0230 FLAG=0x30 OP_156
    do local I=('name');local F=('清距离值');r[(16)][I]=F end
    -- PC 0231 FLAG=0x40 OP_105
    r[(17)]={}
    -- PC 0232 FLAG=0xB0 OP_146
    do local I=('key');local F=('rewardbut');r[(17)][I]=F end
    -- PC 0233 FLAG=0x30 OP_146
    do local I=('name');local F=('开奖励');r[(17)][I]=F end
    -- PC 0234 FLAG=0x30 OP_156
    do local I=('toggle');local F=('关奖励');r[(17)][I]=F end
    -- PC 0235 FLAG=0x40 OP_088
    do local I=(3);if I==0 then I=math.max(0,(3)-(14)) end;local F=r[(14)];local L=((1)-1)*50;if L==0 then local N={};for O=1,I do N[O]=T[(14)+O] end;local O={U(N,1,I)};for K,Z in pairs(F) do if type(K)~="number" or K<1 or K%1~=0 or K>I then O[K]=Z end end;r[(14)]=O else for O=1,I do F[L+O]=T[(14)+O] end end;end
    -- PC 0236 FLAG=0x00 OP_027 [linear-fusion-payloads=2, closure-child-index=5; captures=2; child-path=root/43/6]
    do local I=O[(5)];local F={};F[-1]=(2);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(2)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(15)]=M(I,U,S) end
    -- PC 0237 FLAG=0x80 OP_387
    r[(0)]=r[(12)]
    -- PC 0238 FLAG=0xC0 OP_325
    r[(0)]=up[(4)]
    -- PC 0239 FLAG=0xC0 OP_154 [linear-fusion-payloads=5, closure-child-index=17; captures=5; child-path=root/43/18]
    do local I=O[(17)];local F={};F[-1]=(5);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(5)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(16)]=M(I,U,S) end
    -- PC 0240 FLAG=0xC0 OP_325
    r[(0)]=up[(5)]
    -- PC 0241 FLAG=0x00 OP_325
    r[(0)]=up[(6)]
    -- PC 0242 FLAG=0x80 OP_325
    r[(0)]=up[(2)]
    -- PC 0243 FLAG=0x80 OP_325
    r[(0)]=up[(7)]
    -- PC 0244 FLAG=0x40 OP_325
    r[(0)]=up[(0)]
    -- PC 0245 FLAG=0x80 OP_154 [linear-fusion-payloads=2, closure-child-index=7; captures=2; child-path=root/43/8]
    do local I=O[(7)];local F={};F[-1]=(2);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(2)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(17)]=M(I,U,S) end
    -- PC 0246 FLAG=0x00 OP_325
    r[(0)]=up[(8)]
    -- PC 0247 FLAG=0x40 OP_325
    r[(0)]=up[(9)]
    -- PC 0248 FLAG=0x80 OP_154 [linear-fusion-payloads=1, closure-child-index=22; captures=1; child-path=root/43/23]
    do local I=O[(22)];local F={};F[-1]=(1);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(1)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(18)]=M(I,U,S) end
    -- PC 0249 FLAG=0x40 OP_325
    r[(0)]=up[(0)]
    -- PC 0250 FLAG=0xC0 OP_027 [linear-fusion-payloads=8, closure-child-index=11; captures=8; child-path=root/43/12]
    do local I=O[(11)];local F={};F[-1]=(8);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(8)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(19)]=M(I,U,S) end
    -- PC 0251 FLAG=0xC0 OP_387
    r[(0)]=r[(18)]
    -- PC 0252 FLAG=0xC0 OP_325
    r[(0)]=up[(10)]
    -- PC 0253 FLAG=0x80 OP_325
    r[(0)]=up[(11)]
    -- PC 0254 FLAG=0x00 OP_325
    r[(0)]=up[(0)]
    -- PC 0255 FLAG=0xC0 OP_325
    r[(0)]=up[(12)]
    -- PC 0256 FLAG=0x40 OP_325
    r[(0)]=up[(13)]
    -- PC 0257 FLAG=0x80 OP_387
    r[(0)]=r[(16)]
    -- PC 0258 FLAG=0x80 OP_387
    r[(0)]=r[(15)]
    -- PC 0259 FLAG=0xC0 OP_027 [linear-fusion-payloads=8, closure-child-index=14; captures=8; child-path=root/43/15]
    do local I=O[(14)];local F={};F[-1]=(8);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(8)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(20)]=M(I,U,S) end
    -- PC 0260 FLAG=0x00 OP_387
    r[(0)]=r[(18)]
    -- PC 0261 FLAG=0x00 OP_325
    r[(0)]=up[(14)]
    -- PC 0262 FLAG=0x80 OP_325
    r[(0)]=up[(11)]
    -- PC 0263 FLAG=0x80 OP_325
    r[(0)]=up[(0)]
    -- PC 0264 FLAG=0x80 OP_325
    r[(0)]=up[(12)]
    -- PC 0265 FLAG=0x80 OP_325
    r[(0)]=up[(15)]
    -- PC 0266 FLAG=0xC0 OP_387
    r[(0)]=r[(17)]
    -- PC 0267 FLAG=0x00 OP_387
    r[(0)]=r[(15)]
    -- PC 0268 FLAG=0x80 OP_120
    r[(21)]={}
    -- PC 0269 FLAG=0x00 OP_154 [linear-fusion-payloads=6, closure-child-index=6; captures=6; child-path=root/43/7]
    do local I=O[(6)];local F={};F[-1]=(6);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(6)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(22)]=M(I,U,S) end
    -- PC 0270 FLAG=0x80 OP_325
    r[(0)]=up[(2)]
    -- PC 0271 FLAG=0x40 OP_325
    r[(0)]=up[(11)]
    -- PC 0272 FLAG=0x80 OP_325
    r[(0)]=up[(9)]
    -- PC 0273 FLAG=0xC0 OP_325
    r[(0)]=up[(0)]
    -- PC 0274 FLAG=0x40 OP_387
    r[(0)]=r[(20)]
    -- PC 0275 FLAG=0x40 OP_387
    r[(0)]=r[(17)]
    -- PC 0276 FLAG=0x90 OP_268
    do local I=('yinguaibut');local F=r[(22)];r[(21)][I]=F end
    -- PC 0277 FLAG=0x40 OP_154 [linear-fusion-payloads=4, closure-child-index=2; captures=4; child-path=root/43/3]
    do local I=O[(2)];local F={};F[-1]=(4);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(4)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(22)]=M(I,U,S) end
    -- PC 0278 FLAG=0x40 OP_325
    r[(0)]=up[(16)]
    -- PC 0279 FLAG=0x40 OP_325
    r[(0)]=up[(15)]
    -- PC 0280 FLAG=0xC0 OP_325
    r[(0)]=up[(11)]
    -- PC 0281 FLAG=0x80 OP_325
    r[(0)]=up[(0)]
    -- PC 0282 FLAG=0x50 OP_268
    do local I=('clearmonsterbut');local F=r[(22)];r[(21)][I]=F end
    -- PC 0283 FLAG=0xC0 OP_027 [linear-fusion-payloads=4, closure-child-index=20; captures=4; child-path=root/43/21]
    do local I=O[(20)];local F={};F[-1]=(4);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(4)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(22)]=M(I,U,S) end
    -- PC 0284 FLAG=0x40 OP_325
    r[(0)]=up[(16)]
    -- PC 0285 FLAG=0x40 OP_325
    r[(0)]=up[(13)]
    -- PC 0286 FLAG=0x80 OP_325
    r[(0)]=up[(11)]
    -- PC 0287 FLAG=0xC0 OP_325
    r[(0)]=up[(0)]
    -- PC 0288 FLAG=0x10 OP_268
    do local I=('cleardistancebut');local F=r[(22)];r[(21)][I]=F end
    -- PC 0289 FLAG=0x00 OP_027 [linear-fusion-payloads=5, closure-child-index=1; captures=5; child-path=root/43/2]
    do local I=O[(1)];local F={};F[-1]=(5);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(5)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(22)]=M(I,U,S) end
    -- PC 0290 FLAG=0x40 OP_325
    r[(0)]=up[(2)]
    -- PC 0291 FLAG=0x40 OP_325
    r[(0)]=up[(0)]
    -- PC 0292 FLAG=0x80 OP_325
    r[(0)]=up[(17)]
    -- PC 0293 FLAG=0x40 OP_325
    r[(0)]=up[(18)]
    -- PC 0294 FLAG=0x40 OP_325
    r[(0)]=up[(19)]
    -- PC 0295 FLAG=0x10 OP_355
    do local I=('rewardbut');local F=r[(22)];r[(21)][I]=F end
    -- PC 0296 FLAG=0x00 OP_027 [linear-fusion-payloads=1, closure-child-index=13; captures=1; child-path=root/43/14]
    do local I=O[(13)];local F={};F[-1]=(1);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(1)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(22)]=M(I,U,S) end
    -- PC 0297 FLAG=0x00 OP_325
    r[(0)]=up[(0)]
    -- PC 0298 FLAG=0xD0 OP_268
    do local I=('clearblacklistbut');local F=r[(22)];r[(21)][I]=F end
    -- PC 0299 FLAG=0x80 OP_027 [linear-fusion-payloads=6, closure-child-index=18; captures=6; child-path=root/43/19]
    do local I=O[(18)];local F={};F[-1]=(6);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(6)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(22)]=M(I,U,S) end
    -- PC 0300 FLAG=0x40 OP_325
    r[(0)]=up[(2)]
    -- PC 0301 FLAG=0x80 OP_325
    r[(0)]=up[(0)]
    -- PC 0302 FLAG=0x80 OP_325
    r[(0)]=up[(1)]
    -- PC 0303 FLAG=0x40 OP_325
    r[(0)]=up[(6)]
    -- PC 0304 FLAG=0xC0 OP_387
    r[(0)]=r[(19)]
    -- PC 0305 FLAG=0x40 OP_387
    r[(0)]=r[(16)]
    -- PC 0306 FLAG=0xD0 OP_268
    do local I=('blacklistbut');local F=r[(22)];r[(21)][I]=F end
    -- PC 0307 FLAG=0x00 OP_027 [linear-fusion-payloads=4, closure-child-index=8; captures=4; child-path=root/43/9]
    do local I=O[(8)];local F={};F[-1]=(4);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(4)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(22)]=M(I,U,S) end
    -- PC 0308 FLAG=0x80 OP_325
    r[(0)]=up[(2)]
    -- PC 0309 FLAG=0x00 OP_325
    r[(0)]=up[(0)]
    -- PC 0310 FLAG=0x80 OP_325
    r[(0)]=up[(1)]
    -- PC 0311 FLAG=0x40 OP_325
    r[(0)]=up[(7)]
    -- PC 0312 FLAG=0x50 OP_355
    do local I=('storagebut');local F=r[(22)];r[(21)][I]=F end
    -- PC 0313 FLAG=0xC0 OP_027 [linear-fusion-payloads=4, closure-child-index=19; captures=4; child-path=root/43/20]
    do local I=O[(19)];local F={};F[-1]=(4);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(4)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(22)]=M(I,U,S) end
    -- PC 0314 FLAG=0x40 OP_325
    r[(0)]=up[(2)]
    -- PC 0315 FLAG=0x40 OP_325
    r[(0)]=up[(0)]
    -- PC 0316 FLAG=0x40 OP_325
    r[(0)]=up[(1)]
    -- PC 0317 FLAG=0x80 OP_325
    r[(0)]=up[(7)]
    -- PC 0318 FLAG=0xD0 OP_268
    do local I=('takebut');local F=r[(22)];r[(21)][I]=F end
    -- PC 0319 FLAG=0xC0 OP_154 [linear-fusion-payloads=3, closure-child-index=10; captures=3; child-path=root/43/11]
    do local I=O[(10)];local F={};F[-1]=(3);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(3)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(22)]=M(I,U,S) end
    -- PC 0320 FLAG=0x00 OP_325
    r[(0)]=up[(2)]
    -- PC 0321 FLAG=0x80 OP_325
    r[(0)]=up[(0)]
    -- PC 0322 FLAG=0x80 OP_325
    r[(0)]=up[(7)]
    -- PC 0323 FLAG=0x50 OP_268
    do local I=('shiqubut');local F=r[(22)];r[(21)][I]=F end
    -- PC 0324 FLAG=0xC0 OP_027 [linear-fusion-payloads=4, closure-child-index=21; captures=4; child-path=root/43/22]
    do local I=O[(21)];local F={};F[-1]=(4);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(4)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(22)]=M(I,U,S) end
    -- PC 0325 FLAG=0xC0 OP_325
    r[(0)]=up[(2)]
    -- PC 0326 FLAG=0x00 OP_325
    r[(0)]=up[(0)]
    -- PC 0327 FLAG=0xC0 OP_325
    r[(0)]=up[(1)]
    -- PC 0328 FLAG=0x40 OP_325
    r[(0)]=up[(7)]
    -- PC 0329 FLAG=0xD0 OP_355
    do local I=('diuqibut');local F=r[(22)];r[(21)][I]=F end
    -- PC 0330 FLAG=0xC0 OP_154 [linear-fusion-payloads=4, closure-child-index=3; captures=4; child-path=root/43/4]
    do local I=O[(3)];local F={};F[-1]=(4);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(4)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(22)]=M(I,U,S) end
    -- PC 0331 FLAG=0xC0 OP_325
    r[(0)]=up[(3)]
    -- PC 0332 FLAG=0xC0 OP_325
    r[(0)]=up[(0)]
    -- PC 0333 FLAG=0x40 OP_325
    r[(0)]=up[(2)]
    -- PC 0334 FLAG=0xC0 OP_325
    r[(0)]=up[(1)]
    -- PC 0335 FLAG=0xD0 OP_355
    do local I=('moneybut');local F=r[(22)];r[(21)][I]=F end
    -- PC 0336 FLAG=0x80 OP_154 [closure-child-index=4; captures=0; child-path=root/43/5]
    do local I=O[(4)];local F={};F[-1]=(0);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(0)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(22)]=M(I,U,S) end
    -- PC 0337 FLAG=0x90 OP_268
    do local I=('xiaotuibut');local F=r[(22)];r[(21)][I]=F end
    -- PC 0338 FLAG=0xA0 OP_347
    r[(22)]=r[(10)]-(10.0)
    -- PC 0339 FLAG=0xE0 OP_124
    r[(23)]=r[(11)]+(1.0)
    -- PC 0340 FLAG=0x80 OP_027 [linear-fusion-payloads=5, closure-child-index=9; captures=5; child-path=root/43/10]
    do local I=O[(9)];local F={};F[-1]=(5);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(5)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(24)]=M(I,U,S) end
    -- PC 0341 FLAG=0x00 OP_387
    r[(0)]=r[(6)]
    -- PC 0342 FLAG=0x00 OP_387
    r[(0)]=r[(22)]
    -- PC 0343 FLAG=0x00 OP_387
    r[(0)]=r[(23)]
    -- PC 0344 FLAG=0xC0 OP_325
    r[(0)]=up[(4)]
    -- PC 0345 FLAG=0x80 OP_387
    r[(0)]=r[(21)]
    -- PC 0346 FLAG=0xD2 OP_071 [linear-fusion-payloads=1]
    r[(25)]=__ENV[('ipairs')]; -- 融合载荷：r[(25)]=r[('ipairs')]
    -- PC 0347 FLAG=0x40 OP_184
    r[(26)]=r[(12)]
    -- PC 0348 FLAG=0x40 OP_183
    do local I={ r[(25)](U(T,(25)+1,(26))) };local F=0;for U=(25),(27) do F=F+1;T[U]=I[F] end end
    -- PC 0349 FLAG=0x02 OP_215 [jump-target=355]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(354)
    -- PC 0350 FLAG=0x40 OP_385 [linear-fusion-payloads=2]
    r[(30)]=r[(24)]; -- 融合载荷：r[(30)]=r[(24)]; -- 融合载荷：r[(30)]=r[(24)]
    -- PC 0351 FLAG=0x40 OP_078 [linear-fusion-payloads=1]
    r[(31)]=r[(29)]; -- 融合载荷：r[(31)]=r[(29)]
    -- PC 0352 FLAG=0xC0 OP_288 [linear-fusion-payloads=1]
    r[(32)]=r[(28)]; -- 融合载荷：r[(32)]=(28)
    -- PC 0353 FLAG=0x12 OP_346
    r[(33)]=(40.0)
    -- PC 0354 FLAG=0x00 OP_187
    r[(30)](U(T,(30)+1,(33)))
    -- PC 0355 FLAG=0x80 OP_339
    do local I,F=E(r[(25)](r[(25)+1],r[(25)+2]));for U=1,(2) do T[(25)+2+U]=I[U] end;if r[(25)+3]==nil then pc=pc+1 else r[(25)+2]=r[(25)+3] end end
    -- PC 0356 FLAG=0x42 OP_255 [jump-target=350]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(349)
    -- PC 0357 FLAG=0x12 OP_071 [linear-fusion-payloads=1]
    r[(25)]=__ENV[('ipairs')]; -- 融合载荷：r[(25)]=r[('ipairs')]
    -- PC 0358 FLAG=0xC0 OP_184
    r[(26)]=r[(13)]
    -- PC 0359 FLAG=0xC0 OP_183
    do local I={ r[(25)](U(T,(25)+1,(26))) };local F=0;for U=(25),(27) do F=F+1;T[U]=I[F] end end
    -- PC 0360 FLAG=0xC2 OP_215 [jump-target=366]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(365)
    -- PC 0361 FLAG=0xC0 OP_308
    r[(30)]=r[(24)]
    -- PC 0362 FLAG=0x00 OP_078 [linear-fusion-payloads=1]
    r[(31)]=r[(29)]; -- 融合载荷：r[(31)]=r[(29)]
    -- PC 0363 FLAG=0x80 OP_308
    r[(32)]=r[(28)]
    -- PC 0364 FLAG=0x92 OP_371
    r[(33)]=(0.0)
    -- PC 0365 FLAG=0x40 OP_358
    r[(30)](U(T,(30)+1,(33)))
    -- PC 0366 FLAG=0x40 OP_117
    do local I,F=E(r[(25)](r[(25)+1],r[(25)+2]));for U=1,(2) do T[(25)+2+U]=I[U] end;if r[(25)+3]==nil then pc=pc+1 else r[(25)+2]=r[(25)+3] end end
    -- PC 0367 FLAG=0x02 OP_255 [jump-target=361]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(360)
    -- PC 0368 FLAG=0x52 OP_071 [linear-fusion-payloads=1]
    r[(25)]=__ENV[('ipairs')]; -- 融合载荷：r[(25)]=r[('ipairs')]
    -- PC 0369 FLAG=0x00 OP_308
    r[(26)]=r[(14)]
    -- PC 0370 FLAG=0x00 OP_359
    do local I={ r[(25)](U(T,(25)+1,(26))) };local F=0;for U=(25),(27) do F=F+1;T[U]=I[F] end end
    -- PC 0371 FLAG=0x02 OP_140 [jump-target=377]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(376)
    -- PC 0372 FLAG=0x80 OP_184
    r[(30)]=r[(24)]
    -- PC 0373 FLAG=0xC0 OP_078 [linear-fusion-payloads=1]
    r[(31)]=r[(29)]; -- 融合载荷：r[(31)]=r[(29)]
    -- PC 0374 FLAG=0xC0 OP_288 [linear-fusion-payloads=1]
    r[(32)]=r[(28)]; -- 融合载荷：r[(32)]=(28)
    -- PC 0375 FLAG=0x52 OP_371
    r[(33)]=(80.0)
    -- PC 0376 FLAG=0x80 OP_187
    r[(30)](U(T,(30)+1,(33)))
    -- PC 0377 FLAG=0xC0 OP_386
    do local I,F=E(r[(25)](r[(25)+1],r[(25)+2]));for U=1,(2) do T[(25)+2+U]=I[U] end;if r[(25)+3]==nil then pc=pc+1 else r[(25)+2]=r[(25)+3] end end
    -- PC 0378 FLAG=0xC2 OP_140 [jump-target=372]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(371)
    -- PC 0379 FLAG=0x00 OP_130
    r[(25)]=up[(3)]
    -- PC 0380 FLAG=0x12 OP_287 [linear-fusion-payloads=3]
    r[(26)]=__ENV[('GUI')]; -- 融合载荷：local I=r[('GUI')];r[(26)+1]=I;r[(26)]=I[(nil)]; -- 融合载荷：r[(26)]=r[('GUI')]; -- 融合载荷：r[(26)]=('GUI')
    -- PC 0381 FLAG=0x20 OP_238
    local I=r[(26)];r[(26)+1]=I;r[(26)]=I[('Button_Create')]
    -- PC 0382 FLAG=0xC0 OP_323 [linear-fusion-payloads=2]
    r[(28)]=r[(6)]; -- 融合载荷：r[(28)]=(6); -- 融合载荷：r[(28)]=(6)
    -- PC 0383 FLAG=0xD2 OP_226 [linear-fusion-payloads=3]
    r[(29)]=('hidebut'); -- 融合载荷：r[(29)]=('hidebut'); -- 融合载荷：r[(29)]=('hidebut'); -- 融合载荷：r[(29)]=('hidebut')
    -- PC 0384 FLAG=0x52 OP_061 [linear-fusion-payloads=2]
    r[(30)]=(0.0); -- 融合载荷：r[(30)]=(0.0); -- 融合载荷：r[(30)]=(0.0)
    -- PC 0385 FLAG=0xD2 OP_282 [linear-fusion-payloads=1]
    r[(31)]=(0.0); -- 融合载荷：r[(31)]=(0.0)
    -- PC 0386 FLAG=0x12 OP_371
    r[(32)]=('res/public/fuzhu_btn.png')
    -- PC 0387 FLAG=0x40 OP_068
    r[(26)]=r[(26)](U(T,(26)+1,(32)))
    -- PC 0388 FLAG=0x50 OP_268
    do local I=('hidebut');local F=r[(26)];r[(25)][I]=F end
    -- PC 0389 FLAG=0x80 OP_159 [linear-fusion-payloads=1]
    r[(25)]=up[(3)]; -- 融合载荷：r[(25)]=r[(3)][(0)]
    -- PC 0390 FLAG=0x20 OP_375
    r[(25)]=r[(25)][('hidebut')]
    -- PC 0391 FLAG=0x00 OP_016
    if (not not r[(25)])~=((0)~=0) then pc=pc+1 end
    -- PC 0392 FLAG=0xC2 OP_215 [jump-target=411]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(410)
    -- PC 0393 FLAG=0xD2 OP_335 [linear-fusion-payloads=1]
    r[(25)]=__ENV[('GUI')]; -- 融合载荷：local I=r[('GUI')];r[(25)+1]=I;r[(25)]=I[(nil)]
    -- PC 0394 FLAG=0x60 OP_033
    local I=r[(25)];r[(25)+1]=I;r[(25)]=I[('Button_setTitleText')]
    -- PC 0395 FLAG=0x40 OP_159 [linear-fusion-payloads=1]
    r[(27)]=up[(3)]; -- 融合载荷：r[(27)]=r[(3)][(0)]
    -- PC 0396 FLAG=0x20 OP_363
    r[(27)]=r[(27)][('hidebut')]
    -- PC 0397 FLAG=0x92 OP_346
    r[(28)]=('隐 藏')
    -- PC 0398 FLAG=0x80 OP_187
    r[(25)](U(T,(25)+1,(28)))
    -- PC 0399 FLAG=0xD2 OP_335 [linear-fusion-payloads=1]
    r[(25)]=__ENV[('GUI')]; -- 融合载荷：local I=r[('GUI')];r[(25)+1]=I;r[(25)]=I[(nil)]
    -- PC 0400 FLAG=0x60 OP_033
    local I=r[(25)];r[(25)+1]=I;r[(25)]=I[('Button_setTitleFontSize')]
    -- PC 0401 FLAG=0x80 OP_159 [linear-fusion-payloads=1]
    r[(27)]=up[(3)]; -- 融合载荷：r[(27)]=r[(3)][(0)]
    -- PC 0402 FLAG=0xE0 OP_032
    r[(27)]=r[(27)][('hidebut')]
    -- PC 0403 FLAG=0xD2 OP_371
    r[(28)]=(18.0)
    -- PC 0404 FLAG=0xC0 OP_358
    r[(25)](U(T,(25)+1,(28)))
    -- PC 0405 FLAG=0x92 OP_137
    r[(25)]=__ENV[('GUI')]
    -- PC 0406 FLAG=0x20 OP_033
    local I=r[(25)];r[(25)+1]=I;r[(25)]=I[('Button_setTitleFontName')]
    -- PC 0407 FLAG=0x00 OP_130
    r[(27)]=up[(3)]
    -- PC 0408 FLAG=0x20 OP_363
    r[(27)]=r[(27)][('hidebut')]
    -- PC 0409 FLAG=0xD2 OP_346
    r[(28)]=('res/public/kaiti2.ttf')
    -- PC 0410 FLAG=0xC0 OP_358
    r[(25)](U(T,(25)+1,(28)))
    -- PC 0411 FLAG=0xD2 OP_335 [linear-fusion-payloads=1]
    r[(25)]=__ENV[('GUI')]; -- 融合载荷：local I=r[('GUI')];r[(25)+1]=I;r[(25)]=I[(nil)]
    -- PC 0412 FLAG=0xA0 OP_238
    local I=r[(25)];r[(25)+1]=I;r[(25)]=I[('addOnClickEvent')]
    -- PC 0413 FLAG=0x00 OP_130
    r[(27)]=up[(3)]
    -- PC 0414 FLAG=0x60 OP_032
    r[(27)]=r[(27)][('hidebut')]
    -- PC 0415 FLAG=0x40 OP_154 [linear-fusion-payloads=2, closure-child-index=15; captures=2; child-path=root/43/16]
    do local I=O[(15)];local F={};F[-1]=(2);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(2)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(28)]=M(I,U,S) end
    -- PC 0416 FLAG=0x00 OP_325
    r[(0)]=up[(3)]
    -- PC 0417 FLAG=0x00 OP_325
    r[(0)]=up[(0)]
    -- PC 0418 FLAG=0x80 OP_187
    r[(25)](U(T,(25)+1,(28)))
    -- PC 0419 FLAG=0xC0 OP_250
    return
end
-- 原型入口：proto_GetOwnerDescription_root_43

-- ============================================================================
-- 原型 root/43/1 | 候选名称：Prototype_root_43_1 | 指令记录：46 | 子原型：0 | 可变参数：1
-- 字节范围：33721:34285
local function proto_Prototype_root_43_1_root_43_1(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'find'
    -- K[1] = 'Name'
    -- K[2] = 'GetMetaValue'
    -- K[3] = 1.0
    -- K[4] = 'BAG_DATA'
    -- K[5] = 'string'
    -- K[6] = 'MakeIndex'
    -- K[7] = 'ITEM_IS_BIND'
    -- K[8] = 'SL'
    -- K[9] = 'pairs'
    -- K[10] = 'OverLap'
    -- K[11] = 0.0
    -- 指令语义：
    -- PC 0001 FLAG=0x92 OP_380 [linear-fusion-payloads=2]
    r[(1)]=__ENV[('SL')]; -- 融合载荷：local I=r[('SL')];r[(1)+1]=I;r[(1)]=I[(nil)]; -- 融合载荷：r[(1)]=('SL')
    -- PC 0002 FLAG=0x20 OP_238
    local I=r[(1)];r[(1)+1]=I;r[(1)]=I[('GetMetaValue')]
    -- PC 0003 FLAG=0x92 OP_371
    r[(3)]=('BAG_DATA')
    -- PC 0004 FLAG=0x80 OP_098
    r[(1)]=r[(1)](U(T,(1)+1,(3)))
    -- PC 0005 FLAG=0xC0 OP_342
    if (not not r[(1)])~=((1)~=0) then pc=pc+1 end
    -- PC 0006 FLAG=0x82 OP_255 [jump-target=9]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(8)
    -- PC 0007 FLAG=0xD2 OP_346
    r[(2)]=(0.0)
    -- PC 0008 FLAG=0x00 OP_220
    return U(T,(2),(2))
    -- PC 0009 FLAG=0x12 OP_346
    r[(2)]=(0.0)
    -- PC 0010 FLAG=0xD2 OP_137
    r[(3)]=__ENV[('pairs')]
    -- PC 0011 FLAG=0x80 OP_184
    r[(4)]=r[(1)]
    -- PC 0012 FLAG=0x80 OP_233
    do local I={ r[(3)](U(T,(3)+1,(4))) };local F=0;for U=(3),(5) do F=F+1;T[U]=I[F] end end
    -- PC 0013 FLAG=0x42 OP_215 [jump-target=43]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(42)
    -- PC 0014 FLAG=0xC0 OP_016
    if (not not r[(7)])~=((0)~=0) then pc=pc+1 end
    -- PC 0015 FLAG=0x42 OP_255 [jump-target=43]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(42)
    -- PC 0016 FLAG=0xE0 OP_363
    r[(8)]=r[(7)][('Name')]
    -- PC 0017 FLAG=0x80 OP_016
    if (not not r[(8)])~=((0)~=0) then pc=pc+1 end
    -- PC 0018 FLAG=0x42 OP_140 [jump-target=43]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(42)
    -- PC 0019 FLAG=0x20 OP_053
    r[(8)]=r[(7)][('MakeIndex')]
    -- PC 0020 FLAG=0x00 OP_016
    if (not not r[(8)])~=((0)~=0) then pc=pc+1 end
    -- PC 0021 FLAG=0x42 OP_140 [jump-target=43]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(42)
    -- PC 0022 FLAG=0x12 OP_296 [linear-fusion-payloads=3]
    r[(8)]=__ENV[('string')]; -- 融合载荷：r[(8)]=r[('string')][(nil)]; -- 融合载荷：r[(8)]=r[('string')][(nil)]; -- 融合载荷：r[(8)]=r[('string')]
    -- PC 0023 FLAG=0x60 OP_389 [linear-fusion-payloads=2]
    r[(8)]=r[(8)][('find')]; -- 融合载荷：r[(8)]=r[(8)][('find')]; -- 融合载荷：r[(8)]=r[(8)]
    -- PC 0024 FLAG=0x20 OP_176 [linear-fusion-payloads=2]
    r[(9)]=r[(7)][('Name')]; -- 融合载荷：r[(9)]=r[(7)]; -- 融合载荷：r[(9)]=(7)
    -- PC 0025 FLAG=0x40 OP_288 [linear-fusion-payloads=1]
    r[(10)]=r[(0)]; -- 融合载荷：r[(10)]=(0)
    -- PC 0026 FLAG=0x52 OP_371
    r[(11)]=(1.0)
    -- PC 0027 FLAG=0xC0 OP_401
    r[(12)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0028 FLAG=0x00 OP_098
    r[(8)]=r[(8)](U(T,(8)+1,(12)))
    -- PC 0029 FLAG=0xC0 OP_016
    if (not not r[(8)])~=((0)~=0) then pc=pc+1 end
    -- PC 0030 FLAG=0x42 OP_140 [jump-target=43]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(42)
    -- PC 0031 FLAG=0xD2 OP_191 [linear-fusion-payloads=3]
    r[(8)]=__ENV[('SL')]; -- 融合载荷：local I=r[('SL')];r[(8)+1]=I;r[(8)]=I[(nil)]; -- 融合载荷：r[(8)]=('SL'); -- 融合载荷：r[(8)]=r[('SL')]
    -- PC 0032 FLAG=0x20 OP_186 [linear-fusion-payloads=2]
    local I=r[(8)];r[(8)+1]=I;r[(8)]=I[('GetMetaValue')]; -- 融合载荷：r[(8)]=(8); -- 融合载荷：r[(8)]=r[(8)]
    -- PC 0033 FLAG=0xD2 OP_286 [linear-fusion-payloads=1]
    r[(10)]=('ITEM_IS_BIND'); -- 融合载荷：r[(10)]=r[('ITEM_IS_BIND')]
    -- PC 0034 FLAG=0xC0 OP_184
    r[(11)]=r[(7)]
    -- PC 0035 FLAG=0x40 OP_098
    r[(8)]=r[(8)](U(T,(8)+1,(11)))
    -- PC 0036 FLAG=0x80 OP_342
    if (not not r[(8)])~=((1)~=0) then pc=pc+1 end
    -- PC 0037 FLAG=0x42 OP_140 [jump-target=43]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(42)
    -- PC 0038 FLAG=0x20 OP_363
    r[(9)]=r[(7)][('OverLap')]
    -- PC 0039 FLAG=0x40 OP_342
    if (not not r[(9)])~=((1)~=0) then pc=pc+1 end
    -- PC 0040 FLAG=0x82 OP_140 [jump-target=42]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(41)
    -- PC 0041 FLAG=0xD2 OP_346
    r[(9)]=(1.0)
    -- PC 0042 FLAG=0x80 OP_189
    r[(2)]=r[(2)]+r[(9)]
    -- PC 0043 FLAG=0xC0 OP_386
    do local I,F=E(r[(3)](r[(3)+1],r[(3)+2]));for U=1,(2) do T[(3)+2+U]=I[U] end;if r[(3)+3]==nil then pc=pc+1 else r[(3)+2]=r[(3)+3] end end
    -- PC 0044 FLAG=0x42 OP_255 [jump-target=14]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(13)
    -- PC 0045 FLAG=0x40 OP_220
    return U(T,(2),(2))
    -- PC 0046 FLAG=0x00 OP_250
    return
end
-- 原型入口：proto_Prototype_root_43_1_root_43_1

-- ============================================================================
-- 原型 root/43/2 | 候选名称：Prototype_root_43_2 | 指令记录：33 | 子原型：1 | 可变参数：0
-- 字节范围：34285:34964
local function proto_Prototype_root_43_2_root_43_2(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 'SL'
    -- K[1] = ['unknown', 2]
    -- K[2] = '开启奖励功能'
    -- K[3] = 'UnSchedule'
    -- K[4] = 'rewardTimer'
    -- K[5] = 'Schedule'
    -- K[6] = 0.0
    -- K[7] = '关闭奖励功能'
    -- 指令语义：
    -- PC 0001 FLAG=0x00 OP_159 [linear-fusion-payloads=1]
    r[(0)]=up[(0)]; -- 融合载荷：r[(0)]=r[(0)][(0)]
    -- PC 0002 FLAG=0x20 OP_375
    r[(0)]=r[(0)][('rewardTimer')]
    -- PC 0003 FLAG=0x80 OP_016
    if (not not r[(0)])~=((0)~=0) then pc=pc+1 end
    -- PC 0004 FLAG=0x42 OP_215 [jump-target=17]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(16)
    -- PC 0005 FLAG=0x80 OP_134 [linear-fusion-payloads=1]
    r[(0)]=up[(1)]; -- 融合载荷：r[(0)]=(1)
    -- PC 0006 FLAG=0x12 OP_371
    r[(1)]=('关闭奖励功能')
    -- PC 0007 FLAG=0x80 OP_187
    r[(0)](U(T,(0)+1,(1)))
    -- PC 0008 FLAG=0x52 OP_137
    r[(0)]=__ENV[('SL')]
    -- PC 0009 FLAG=0xE0 OP_238
    local I=r[(0)];r[(0)+1]=I;r[(0)]=I[('UnSchedule')]
    -- PC 0010 FLAG=0x40 OP_130
    r[(2)]=up[(0)]
    -- PC 0011 FLAG=0xA0 OP_363
    r[(2)]=r[(2)][('rewardTimer')]
    -- PC 0012 FLAG=0x40 OP_358
    r[(0)](U(T,(0)+1,(2)))
    -- PC 0013 FLAG=0xC0 OP_089 [linear-fusion-payloads=1]
    r[(0)]=up[(0)]; -- 融合载荷：do local I=(0);local F=(0);r[(0)][I]=F end
    -- PC 0014 FLAG=0xB0 OP_146
    do local I=('rewardTimer');local F=(['unknown', 2]);r[(0)][I]=F end
    -- PC 0015 FLAG=0x40 OP_338
    r[(0)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0016 FLAG=0xC0 OP_220
    return U(T,(0),(0))
    -- PC 0017 FLAG=0x00 OP_130
    r[(0)]=up[(1)]
    -- PC 0018 FLAG=0x52 OP_346
    r[(1)]=('开启奖励功能')
    -- PC 0019 FLAG=0xC0 OP_358
    r[(0)](U(T,(0)+1,(1)))
    -- PC 0020 FLAG=0x52 OP_346
    r[(0)]=(0.0)
    -- PC 0021 FLAG=0x80 OP_130
    r[(1)]=up[(0)]
    -- PC 0022 FLAG=0x12 OP_335 [linear-fusion-payloads=1]
    r[(2)]=__ENV[('SL')]; -- 融合载荷：local I=r[('SL')];r[(2)+1]=I;r[(2)]=I[(nil)]
    -- PC 0023 FLAG=0xA0 OP_033
    local I=r[(2)];r[(2)+1]=I;r[(2)]=I[('Schedule')]
    -- PC 0024 FLAG=0xC0 OP_027 [linear-fusion-payloads=3, closure-child-index=0; captures=3; child-path=root/43/2/1]
    do local I=O[(0)];local F={};F[-1]=(3);local U=K({}, {__index=function(_,L)local N=F[L];return N[1][N[2]] end,__newindex=function(_,L,N)local I=F[L];I[1][I[2]]=N end});for L=0,(3)-1 do pc=pc+1;local N=Y[pc];if N[1]==387 then F[L]={T,N[3]} else F[L]={D,N[3]} end;H[#H+1]=F end;r[(4)]=M(I,U,S) end
    -- PC 0025 FLAG=0x40 OP_387
    r[(0)]=r[(0)]
    -- PC 0026 FLAG=0xC0 OP_325
    r[(0)]=up[(2)]
    -- PC 0027 FLAG=0x80 OP_325
    r[(0)]=up[(3)]
    -- PC 0028 FLAG=0x80 OP_130
    r[(5)]=up[(4)]
    -- PC 0029 FLAG=0x40 OP_098
    r[(2)]=r[(2)](U(T,(2)+1,(5)))
    -- PC 0030 FLAG=0x10 OP_355
    do local I=('rewardTimer');local F=r[(2)];r[(1)][I]=F end
    -- PC 0031 FLAG=0x40 OP_401
    r[(1)]=(1)~=0;if (0)~=0 then pc=pc+1 end
    -- PC 0032 FLAG=0x80 OP_220
    return U(T,(1),(1))
    -- PC 0033 FLAG=0x80 OP_001
    return
end
-- 原型入口：proto_Prototype_root_43_2_root_43_2

-- ============================================================================
-- 原型 root/43/2/1 | 候选名称：Prototype_root_43_2_1 | 指令记录：22 | 子原型：0 | 可变参数：0
-- 字节范围：34701:34963
local function proto_Prototype_root_43_2_1_root_43_2_1(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = 2.0
    -- K[1] = 1.0
    -- K[2] = 9002.0
    -- K[3] = 3.0
    -- K[4] = 'LuaSendMsg'
    -- 指令语义：
    -- PC 0001 FLAG=0x80 OP_130
    r[(0)]=up[(0)]
    -- PC 0002 FLAG=0xA0 OP_124
    r[(0)]=r[(0)]+(1.0)
    -- PC 0003 FLAG=0xC0 OP_114
    up[(0)]=r[(0)]
    -- PC 0004 FLAG=0xC0 OP_130
    r[(0)]=up[(0)]
    -- PC 0005 FLAG=0xA0 OP_347
    r[(0)]=r[(0)]-(1.0)
    -- PC 0006 FLAG=0x80 OP_130
    r[(1)]=up[(1)]
    -- PC 0007 FLAG=0x80 OP_280
    r[(0)]=r[(0)]%r[(1)]
    -- PC 0008 FLAG=0x00 OP_130
    r[(1)]=up[(2)]
    -- PC 0009 FLAG=0x60 OP_124
    r[(2)]=r[(0)]+(1.0)
    -- PC 0010 FLAG=0x80 OP_231
    r[(1)]=r[(1)][r[(2)]]
    -- PC 0011 FLAG=0x00 OP_016
    if (not not r[(1)])~=((0)~=0) then pc=pc+1 end
    -- PC 0012 FLAG=0x02 OP_255 [jump-target=22]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(21)
    -- PC 0013 FLAG=0xD2 OP_168 [linear-fusion-payloads=1]
    r[(2)]=__ENV[('LuaSendMsg')]; -- 融合载荷：r[(2)]=('LuaSendMsg')
    -- PC 0014 FLAG=0xD2 OP_165 [linear-fusion-payloads=1]
    r[(3)]=(9002.0); -- 融合载荷：r[(3)]=r[(9002.0)][(nil)]
    -- PC 0015 FLAG=0x60 OP_025 [linear-fusion-payloads=2]
    r[(4)]=r[(1)][(1.0)]; -- 融合载荷：r[(4)]=(1); -- 融合载荷：r[(4)]=(1)
    -- PC 0016 FLAG=0x92 OP_061 [linear-fusion-payloads=2]
    r[(5)]=(1.0); -- 融合载荷：r[(5)]=(1.0); -- 融合载荷：r[(5)]=(1.0)
    -- PC 0017 FLAG=0x12 OP_282 [linear-fusion-payloads=1]
    r[(6)]=(2.0); -- 融合载荷：r[(6)]=(2.0)
    -- PC 0018 FLAG=0x12 OP_371
    r[(7)]=(3.0)
    -- PC 0019 FLAG=0x60 OP_049 [linear-fusion-payloads=1]
    r[(8)]=r[(1)][(2.0)]; -- 融合载荷：r[(8)]=r[(1)][(2.0)]
    -- PC 0020 FLAG=0x60 OP_032
    r[(9)]=r[(1)][(3.0)]
    -- PC 0021 FLAG=0x00 OP_358
    r[(2)](U(T,(2)+1,(9)))
    -- PC 0022 FLAG=0x00 OP_100
    return
end
-- 原型入口：proto_Prototype_root_43_2_1_root_43_2_1

-- ============================================================================
-- 原型 root/43/3 | 候选名称：Prototype_root_43_3 | 指令记录：21 | 子原型：0 | 可变参数：0
-- 字节范围：34964:35292
local function proto_Prototype_root_43_3_root_43_3(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = '已清空怪物阈值'
    -- K[1] = '已清空怪物阈值存档：%s'
    -- K[2] = '清空怪物阈值失败'
    -- K[3] = '清空怪物阈值失败：%s'
    -- 指令语义：
    -- PC 0001 FLAG=0x00 OP_004 [linear-fusion-payloads=1]
    r[(0)]=up[(0)]; -- 融合载荷：r[(0)]=up[(0)]
    -- PC 0002 FLAG=0x80 OP_130
    r[(1)]=up[(1)]
    -- PC 0003 FLAG=0x00 OP_233
    do local I={ r[(0)](U(T,(0)+1,(1))) };local F=0;for U=(0),(1) do F=F+1;T[U]=I[F] end end
    -- PC 0004 FLAG=0x40 OP_016
    if (not not r[(0)])~=((0)~=0) then pc=pc+1 end
    -- PC 0005 FLAG=0xC2 OP_140 [jump-target=14]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(13)
    -- PC 0006 FLAG=0x80 OP_134 [linear-fusion-payloads=1]
    r[(2)]=up[(2)]; -- 融合载荷：r[(2)]=(2)
    -- PC 0007 FLAG=0x92 OP_371
    r[(3)]=('已清空怪物阈值')
    -- PC 0008 FLAG=0x40 OP_187
    r[(2)](U(T,(2)+1,(3)))
    -- PC 0009 FLAG=0xC0 OP_134 [linear-fusion-payloads=1]
    r[(2)]=up[(3)]; -- 融合载荷：r[(2)]=(3)
    -- PC 0010 FLAG=0xD2 OP_286 [linear-fusion-payloads=1]
    r[(3)]=('已清空怪物阈值存档：%s'); -- 融合载荷：r[(3)]=r[('已清空怪物阈值存档：%s')]
    -- PC 0011 FLAG=0x00 OP_184
    r[(4)]=r[(1)]
    -- PC 0012 FLAG=0x00 OP_187
    r[(2)](U(T,(2)+1,(4)))
    -- PC 0013 FLAG=0xC2 OP_140 [jump-target=21]
    if (0)>0 then do local I=(0)-1;local F={};for U=1,#H do local L=H[U];local N=L[-1] or 0;for O=0,N-1 do local K=L[O];if K then local Z=K[1];local (nil)=K[2];if Z==T and I<=(nil) then F[(nil)]=Z[(nil)];K[1]=F end end end end end end;pc=(20)
    -- PC 0014 FLAG=0xC0 OP_134 [linear-fusion-payloads=1]
    r[(2)]=up[(2)]; -- 融合载荷：r[(2)]=(2)
    -- PC 0015 FLAG=0x92 OP_346
    r[(3)]=('清空怪物阈值失败')
    -- PC 0016 FLAG=0x80 OP_358
    r[(2)](U(T,(2)+1,(3)))
    -- PC 0017 FLAG=0x00 OP_134 [linear-fusion-payloads=1]
    r[(2)]=up[(3)]; -- 融合载荷：r[(2)]=(3)
    -- PC 0018 FLAG=0x52 OP_286 [linear-fusion-payloads=1]
    r[(3)]=('清空怪物阈值失败：%s'); -- 融合载荷：r[(3)]=r[('清空怪物阈值失败：%s')]
    -- PC 0019 FLAG=0x40 OP_184
    r[(4)]=r[(1)]
    -- PC 0020 FLAG=0xC0 OP_358
    r[(2)](U(T,(2)+1,(4)))
    -- PC 0021 FLAG=0x40 OP_100
    return
end
-- 原型入口：proto_Prototype_root_43_3_root_43_3

-- ============================================================================
-- 原型 root/43/4 | 候选名称：Prototype_root_43_4 | 指令记录：320 | 子原型：5 | 可变参数：0
-- 字节范围：35292:43248
local function proto_Prototype_root_43_4_root_43_4(...)
    local r, up, pc = {}, {}, 1
    local T, H = nil, {} -- TODO: VM 闭包/栈环境，需结合解释器调用约定还原
    local __args = {...}
    -- 常量池：
    -- K[0] = '#FFFF00'
    -- K[1] = 'durTimeText'
    -- K[2] = 2.0
    -- K[3] = 'noteText'
    -- K[4] = 'global'
    -- K[5] = 'money'
    -- K[6] = '--'
    -- K[7] = 'initTimeCell'
    -- K[8] = '元宝'
    -- K[9] = 'Schedule'
    -- K[10] = 'titleText'
    -- K[11] = 'Win_IsNotNull'
    -- K[12] = '#00FF00'
    -- K[13] = '#FF0000'
    -- K[14] = '当前时间:--'
    -- K[15] = '绑定灵符'
    -- K[16] = 999.0
    -- K[17] = 255.0
    -- K[18] = '（括号内数量为非绑定资源的收益）'
    -- K[19] = '声望卷'
    -- K[20] = '历时:--'
    -- K[21] = 'ProxyTable'
    -- K[22] = 'noteCell'
    -- K[23] = 'Layout_Create'
    -- K[24] = 'screenW'
    -- K[25] = 'SL'
    -- K[26] = 'Text_Create'
    -- K[27] = 'curTimeCell'
    -- K[28] = ['unknown', 2]
    -- K[29] = 'UnSchedule'
    -- K[30] = 'resWin'
    -- K[31] = '血龙宝珠'
    -- K[32] = 'Facade'
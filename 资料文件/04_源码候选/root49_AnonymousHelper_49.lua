-- root.children[49] / legacy root/50 / AnonymousHelper_49
-- 5条指令；捕获ReadNumericConfig闭包与固定文件名；无显式参数。

local function make_AnonymousHelper_49(readNumericConfig, fileName)
    return function AnonymousHelper_49()
        return readNumericConfig(fileName)
    end
end

-- 返回ReadNumericConfig的全部返回值，不做转换或吞掉nil。
-- 根模块在root PC304创建，PC305/PC306依序捕获读取函数和文件名。

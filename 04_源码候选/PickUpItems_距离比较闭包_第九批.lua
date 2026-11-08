-- PickUpItems short comparator closures.
-- Parent: root.children[21] / legacy root/22 / PickUpItems.
-- Static reconstruction only; no runtime validation.

-- root.children[21].children[0] / legacy root/22/1
-- 19 physical instructions, vararg; compares kIdx first and dist on ties.
local function Nested_dist(a, b)
    if a.kIdx ~= b.kIdx then
        return a.kIdx < b.kIdx
    end
    return a.dist < b.dist
end

-- root.children[21].children[1] / legacy root/22/2
-- 8 physical instructions, vararg; compares dist only.
local function Nested_dist_2(a, b)
    return a.dist < b.dist
end

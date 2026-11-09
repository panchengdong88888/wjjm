-- root.children[50].children[1] / legacy root/51/2
-- Reconstruction label: Nested_Anonymous_2
-- 27 physical VM instructions; 4 captured values; no child prototypes.
-- Status: first-pass ordinary Lua draft. Static-complete status not asserted;
-- runtime behavior has not been validated.
--
-- Capture mapping (StorageItems parent, PC54-PC58):
--   UP[0] = maxPage
--   UP[1] = pageCapacity
--   UP[2] = openSize
--   UP[3] = storedPageData (per-page occupied item counts)
--
-- The local function name below is descriptive only; the original identifier
-- was not recovered.

local function make_FindAvailableStoragePage(
    maxPage,
    pageCapacity,
    openSize,
    storedPageData
)
    return function()
        -- Search pages in ascending order and return the first page that has
        -- room for another stored item.
        for page = 1, maxPage do
            local pageLimit = pageCapacity

            -- The final page may be smaller than the ordinary page capacity.
            if page == maxPage then
                pageLimit = math.min(
                    pageCapacity,
                    openSize - (maxPage - 1) * pageCapacity
                )
            end

            local currentCount = storedPageData[page]
            if currentCount < pageLimit then
                return page
            end
        end

        return nil
    end
end

-- Evidence / limits:
-- * Parent root/51 PC54 creates this closure with four captures; PC55-PC58
--   copy parent R1/R2/R3/R4 into capture slots 0..3.
-- * Existing StorageItems review maps those captures to
--   maxPage/pageCapacity/openSize/storedPageData and confirms the final-page
--   capacity expression above.
-- * Parent code prepares storedPageData[page] as a per-page count (zero when
--   no stored-page record exists), so this helper compares the count directly.
-- * This is readable reconstruction, not recovered author formatting or
--   original local names. No host runtime test has been performed.

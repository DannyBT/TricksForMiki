-- Only for rogues
local _,_,classIndex = UnitClass("player")
if classIndex ~= 4 then return end

local addonName = "TricksForMiki" -- Schlag
local listener = CreateFrame("FRAME", "TricksForMikiListener")

listener:RegisterEvent("PLAYER_ENTERING_WORLD")
--listener:RegisterEvent("PLAYER_ROLES_ASSIGNED")
listener:RegisterEvent("GROUP_ROSTER_UPDATE")

local tank

listener:SetScript("OnEvent", function(self, event,...)
    if not IsInGroup() or (InCombatLockdown() == 1) then return end

    local macroName = addonName
    local printHeader = "|TInterface\\Icons\\ability_rogue_tricksofthetrade:0:0:0:0|t " .. WrapTextInColorCode("TricksForMiki", "fffef367")
    local spellName = GetSpellInfo(57934) or "Tricks of the Trade"
    local body = string.format("#showtooltip\n/use [@mouseover, exists, help][] %s", spellName)
    
    -- Create macro if not exists
    if GetMacroIndexByName(macroName) == 0 then
        -- Check if there is space
        local numGlobal, numPerChar = GetNumMacros()
        if numPerChar < 18 then           
            CreateMacro(
                macroName,
                "INV_MISC_QUESTIONMARK",
                body,
                1
            )
            print(printHeader, ": Macro created")
        else
            print(printHeader, ": Not enough space to create macro")
        end
    end    
    -- Looking for tank name
    local newTank
    for i = 1, GetNumGroupMembers() do
        local unit = IsInRaid() and ("raid" .. i) or ("party" .. i)
        if UnitGroupRolesAssigned(unit) == "TANK" then
            newTank = unit
            break
        end
    end
    
    if newTank and not (tank == newTank) then
        tank = newTank
        -- Edit macro
        local tankName = GetUnitName(tank, true)
        local _,_,_,color = GetClassColor(select(2,UnitClass(tank)))

        body = string.format("#showtooltip\n/use [@mouseover, exists, help][@%s][] %s", tankName, spellName)
        EditMacro(
            macroName,
            nil,
            nil,
            body,
            1,
            1
        )
        print(printHeader, ": Macro updated with", WrapTextInColorCode(tankName, color), "as target")
    end
end)
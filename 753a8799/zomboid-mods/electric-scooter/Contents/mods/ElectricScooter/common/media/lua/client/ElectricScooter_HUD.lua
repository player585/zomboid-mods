-- ============================================================
--  ElectricScooter_HUD.lua
--  CLIENT-SIDE: Draws a battery charge indicator on screen
--  when the player is riding the electric scooter.
-- ============================================================

require "ElectricScooter_Core"

local HUD = {}
HUD.visible     = false
HUD.charge      = 100
HUD.x           = 20
HUD.y           = 200
HUD.width       = 120
HUD.height      = 18
HUD.padding     = 4

-- Poll vehicle state every player update
local function onPlayerUpdate(player)
    if not player then return end
    local vehicle = player:getVehicle()
    if vehicle and ElectricScooter.isElectricScooter(vehicle) then
        HUD.visible = true
        local batteryPart = vehicle:getPartById("Battery")
        if batteryPart then
            HUD.charge = batteryPart:getCondition()
        else
            HUD.charge = 0
        end
    else
        HUD.visible = false
    end
end

-- Draw the HUD element
local function onPreUIDraw()
    if not HUD.visible then return end

    local ui    = UIManager.getUI()
    local sw    = getCore():getScreenWidth()
    local sh    = getCore():getScreenHeight()
    local drawX = HUD.x
    local drawY = sh - 150   -- bottom-left area above inventory bar

    local pct   = math.max(0, math.min(100, HUD.charge)) / 100
    local fillW = math.floor((HUD.width - HUD.padding * 2) * pct)

    -- Background bar
    UIManager.DrawTextureScaled(nil, drawX, drawY, HUD.width, HUD.height, 1, 0.1, 0.1, 0.1, 0.8)

    -- Charge fill: green > yellow > red based on level
    local r, g, b
    if pct > 0.5 then
        r, g, b = 0.2, 0.9, 0.3
    elseif pct > 0.25 then
        r, g, b = 0.9, 0.7, 0.1
    else
        r, g, b = 0.9, 0.1, 0.1
    end
    UIManager.DrawTextureScaled(nil, drawX + HUD.padding, drawY + HUD.padding, fillW, HUD.height - HUD.padding * 2, 1, r, g, b, 1)

    -- Label
    local label = string.format("⚡ %.0f%%", HUD.charge)
    getDebugDrawing():DrawTextLeft(drawX + HUD.width + 6, drawY + 2, label, 1, 1, 1, 1)
end

Events.OnPlayerUpdate.Add(onPlayerUpdate)
Events.OnPreUIDraw.Add(onPreUIDraw)

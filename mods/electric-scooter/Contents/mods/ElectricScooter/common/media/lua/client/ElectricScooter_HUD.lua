-- ============================================================
--  ElectricScooter_HUD.lua
--  CLIENT-SIDE: Battery charge indicator drawn on screen
--  while the player is riding the electric scooter.
--
--  Implementation notes:
--    * Uses ISUIElement so we get a real drawRect / drawText API.
--    * Mounts on UIManager.AddUI() and toggles visibility based on
--      whether the player is in our scooter.
--    * Polled via OnPlayerUpdate (NOT OnPreUIDraw — that event
--      does not exist in PZ).
-- ============================================================

require "ElectricScooter_Core"
require "ISUI/ISUIElement"

ElectricScooterHUD = ISUIElement:derive("ElectricScooterHUD")

function ElectricScooterHUD:initialise()
    ISUIElement.initialise(self)
    self.charge = 100
end

function ElectricScooterHUD:prerender()
    -- Background pill
    self:drawRect(0, 0, self.width, self.height, 0.85, 0.08, 0.08, 0.08)
    self:drawRectBorder(0, 0, self.width, self.height, 0.9, 0.6, 0.6, 0.6)

    -- Charge fill
    local pct   = math.max(0, math.min(100, self.charge)) / 100
    local fillW = math.floor((self.width - 8) * pct)

    local r, g, b
    if pct > 0.5 then
        r, g, b = 0.20, 0.90, 0.30
    elseif pct > 0.25 then
        r, g, b = 0.95, 0.75, 0.10
    else
        r, g, b = 0.95, 0.15, 0.15
    end
    self:drawRect(4, 4, fillW, self.height - 8, 1, r, g, b)

    -- Label
    local label = string.format("BATTERY  %.0f%%", self.charge)
    self:drawText(label, self.width + 8, 2, 1, 1, 1, 1, UIFont.Small)
end

function ElectricScooterHUD:render()
    -- Currently nothing additional in render; prerender handles draw.
end

-- ---------- Singleton management ----------

local instance = nil

local function ensureCreated()
    if instance then return instance end
    local sw = getCore():getScreenWidth()
    local sh = getCore():getScreenHeight()
    instance = ElectricScooterHUD:new(20, sh - 160, 140, 22)
    instance:initialise()
    instance:instantiate()
    instance:setVisible(false)
    instance:addToUIManager()
    return instance
end

-- Bulletproof safeChargeRead: wraps every nilable in pcall so a
-- missing API method (e.g. getUsedDelta vs getDelta vs getCondition)
-- never throws and never trips PZ's "Break On Error" debugger.
local function safeChargeRead(item)
    if not item then return 0 end
    local ok, val
    -- Try the modern (B42) API first.
    if item.getUsedDelta then
        ok, val = pcall(function() return item:getUsedDelta() end)
        if ok and type(val) == "number" then return val * 100 end
    end
    -- Fall back to B41 API name.
    if item.getDelta then
        ok, val = pcall(function() return item:getDelta() end)
        if ok and type(val) == "number" then return val * 100 end
    end
    -- Last resort: durability/condition based estimate.
    if item.getCondition then
        ok, val = pcall(function() return item:getCondition() end)
        if ok and type(val) == "number" then return val end
    end
    return 0
end

local function onPlayerUpdate(player)
    if not player then return end
    if not getCore or not getCore() then return end -- UI not yet ready

    local hud = ensureCreated()
    if not hud then return end

    -- Wrap the entire vehicle/part lookup in pcall so a nil chain never
    -- trips the lua debugger when entering/exiting the scooter.
    local ok, err = pcall(function()
        local vehicle = player.getVehicle and player:getVehicle() or nil
        if vehicle and ElectricScooter and ElectricScooter.isElectricScooter
           and ElectricScooter.isElectricScooter(vehicle) then
            local batteryPart = vehicle.getPartById and vehicle:getPartById("Battery") or nil
            local item = batteryPart and batteryPart.getInventoryItem
                         and batteryPart:getInventoryItem() or nil
            hud.charge = safeChargeRead(item)
            if not hud:isVisible() then hud:setVisible(true) end
        else
            if hud:isVisible() then hud:setVisible(false) end
        end
    end)
    -- Silently swallow any error - never want HUD code to halt the player.
end

Events.OnPlayerUpdate.Add(onPlayerUpdate)

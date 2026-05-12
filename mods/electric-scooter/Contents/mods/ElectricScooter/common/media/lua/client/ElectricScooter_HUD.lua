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

local function onPlayerUpdate(player)
    if not player then return end
    if not getCore or not getCore() then return end -- UI not yet ready

    local hud = ensureCreated()
    if not hud then return end

    local vehicle = player.getVehicle and player:getVehicle() or nil

    if vehicle and ElectricScooter.isElectricScooter(vehicle) then
        local batteryPart = vehicle:getPartById("Battery")
        local item = batteryPart and batteryPart:getInventoryItem()
        -- B42 batteries use usedDelta (0..1), display as percent
        if item then
            hud.charge = item:getUsedDelta() * 100
        else
            hud.charge = 0
        end
        if not hud:isVisible() then hud:setVisible(true) end
    else
        if hud:isVisible() then hud:setVisible(false) end
    end
end

Events.OnPlayerUpdate.Add(onPlayerUpdate)

-- ============================================================
--  ElectricScooter_Keyless.lua
--  CLIENT-SIDE:
--    Real e-scooters use a power button, not a key. We:
--      1. Force setKeysInIgnition(true) every tick
--      2. Inject a "Power On" / "Power Off" radial menu option
--         that bypasses the vanilla key check and starts the
--         engine directly via engineDoStarting()
--      3. Also auto-power-on when the player enters
-- ============================================================

require "ElectricScooter_Core"

ElectricScooter.Keyless = ElectricScooter.Keyless or {}

local function isElectricScooter(vehicle)
    if not vehicle then return false end
    local ok, script = pcall(function() return vehicle:getScript() end)
    if not ok or not script then return false end
    local name = script:getName()
    return name == "ElectricScooter"
end

-- ------------------------------------------------------------
-- Force the vehicle into a "key-present" state
-- ------------------------------------------------------------
local function forceKeyless(vehicle)
    if not vehicle then return end
    pcall(function()
        if vehicle:getKeyId() == 0 then
            vehicle:setKeyId(ZombRand(2147483647) + 1)
        end
    end)
    pcall(function() vehicle:setKeysInIgnition(true) end)
    pcall(function() vehicle:setHotwired(true) end)
    pcall(function() vehicle:setHotwiredBroken(false) end)
end

-- ------------------------------------------------------------
-- Direct engine start, bypassing key UI
-- ------------------------------------------------------------
local function powerOn(player)
    if not player then return end
    local v = player:getVehicle()
    if not isElectricScooter(v) then return end
    forceKeyless(v)
    pcall(function() v:engineDoStarting() end)
    pcall(function() v:setEngineRunning(true) end)
    player:Say("*scooter powered on*")
end

local function powerOff(player)
    if not player then return end
    local v = player:getVehicle()
    if not isElectricScooter(v) then return end
    pcall(function() v:setEngineRunning(false) end)
    pcall(function() v:shutOff() end)
    player:Say("*scooter powered off*")
end

ElectricScooter.Keyless.powerOn  = powerOn
ElectricScooter.Keyless.powerOff = powerOff

-- ------------------------------------------------------------
-- Inject "Power On / Off" into the vehicle radial menu (V key)
-- ------------------------------------------------------------
local function addPowerOptions(menu, player, vehicle)
    if not isElectricScooter(vehicle) then return end
    if vehicle:isEngineRunning() then
        menu:addSlice(getText("IGUI_VehiclePowerOff") or "Power Off",
                      getTexture("media/ui/vehicles/vehicle_shutoff.png"),
                      function() powerOff(player) end)
    else
        menu:addSlice(getText("IGUI_VehiclePowerOn") or "Power On",
                      getTexture("media/ui/vehicles/vehicle_start.png"),
                      function() powerOn(player) end)
    end
end

-- Hook into the radial menu fill event if it exists
if Events.OnFillVehicleRadialMenu then
    Events.OnFillVehicleRadialMenu.Add(addPowerOptions)
end

-- ------------------------------------------------------------
-- Also inject into the right-click world context menu when
-- standing in a scooter
-- ------------------------------------------------------------
local function onFillWorldContextMenu(player, context, worldobjects, test)
    local pl = getSpecificPlayer(player)
    if not pl then return end
    local v = pl:getVehicle()
    if not isElectricScooter(v) then return end
    if v:isEngineRunning() then
        context:addOption("Power Off Scooter", nil, function() powerOff(pl) end)
    else
        context:addOption("Power On Scooter", nil, function() powerOn(pl) end)
    end
end
Events.OnFillWorldObjectContextMenu.Add(onFillWorldContextMenu)

-- ------------------------------------------------------------
-- Per-tick re-assert + cleanup
-- ------------------------------------------------------------
local function onPlayerUpdate(player)
    if not player then return end
    local v = player:getVehicle()
    if isElectricScooter(v) then forceKeyless(v) end
end

local function onEnterVehicle(player)
    if not player then return end
    local v = player:getVehicle()
    if isElectricScooter(v) then forceKeyless(v) end
end

local function onGameStart()
    local p = getPlayer()
    if p and isElectricScooter(p:getVehicle()) then
        forceKeyless(p:getVehicle())
    end
end

Events.OnEnterVehicle.Add(onEnterVehicle)
Events.OnPlayerUpdate.Add(onPlayerUpdate)
Events.OnGameStart.Add(onGameStart)

if getDebug() then
    print("[ElectricScooter] Keyless v3 (force flags + Power On/Off menu) loaded")
end

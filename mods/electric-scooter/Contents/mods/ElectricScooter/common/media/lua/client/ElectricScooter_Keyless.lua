-- ============================================================
--  ElectricScooter_Keyless.lua
--  CLIENT-SIDE:
--    Real e-scooters don't use keys — they use a power button.
--    We emulate that by telling PZ a key is permanently "in
--    the ignition" for any ElectricScooter.
--
--    Strategy (revised, no inventory key needed):
--      - On OnEnterVehicle: if the vehicle is an ElectricScooter,
--        call setKeysInIgnition(true). The vanilla start logic
--        checks this flag before complaining about missing keys.
--      - Also assign a keyId if missing (some code paths read it).
--      - Every tick while in a scooter, re-assert the flag in case
--        vanilla code clears it.
--      - Clean up any orphan CarKey items our older build dropped
--        in the player's inventory.
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
-- Set the "keys in ignition" flag and ensure keyId exists
-- ------------------------------------------------------------
local function enableKeyless(vehicle)
    if not vehicle then return end

    -- Ensure vehicle has a keyId (some checks short-circuit on 0)
    local ok1, id = pcall(function() return vehicle:getKeyId() end)
    if ok1 and id == 0 then
        pcall(function() vehicle:setKeyId(ZombRand(2147483647) + 1) end)
    end

    -- Tell the game a key is already in the ignition
    pcall(function() vehicle:setKeysInIgnition(true) end)
end

-- ------------------------------------------------------------
-- Remove any leftover phantom CarKey from the previous build
-- ------------------------------------------------------------
local function cleanupOrphanKeys(player)
    if not player then return end
    local inv = player:getInventory()
    if not inv then return end
    local items = inv:getItems()
    local toRemove = {}
    for i = 0, items:size() - 1 do
        local it = items:get(i)
        if it and it.getName and it:getName() == "Scooter Fob" then
            table.insert(toRemove, it)
        end
    end
    for _, it in ipairs(toRemove) do
        pcall(function() inv:Remove(it) end)
    end
end

-- ------------------------------------------------------------
-- Hooks
-- ------------------------------------------------------------
local function onEnterVehicle(player)
    if not player then return end
    cleanupOrphanKeys(player)
    local vehicle = player:getVehicle()
    if isElectricScooter(vehicle) then
        enableKeyless(vehicle)
    end
end

-- Re-assert each tick so vanilla can't undo us
local function onPlayerUpdate(player)
    if not player then return end
    local vehicle = player:getVehicle()
    if isElectricScooter(vehicle) then
        -- only call if currently false to avoid spam
        local ok, on = pcall(function() return vehicle:isKeysInIgnition() end)
        if ok and not on then
            pcall(function() vehicle:setKeysInIgnition(true) end)
        end
    end
end

local function onGameStart()
    local p = getPlayer()
    if p then
        cleanupOrphanKeys(p)
        if isElectricScooter(p:getVehicle()) then
            enableKeyless(p:getVehicle())
        end
    end
end

Events.OnEnterVehicle.Add(onEnterVehicle)
Events.OnPlayerUpdate.Add(onPlayerUpdate)
Events.OnGameStart.Add(onGameStart)

if getDebug() then
    print("[ElectricScooter] Keyless start (setKeysInIgnition mode) loaded")
end

-- ============================================================
--  ElectricScooter_Keyless.lua
--  CLIENT-SIDE:
--    Real e-scooters don't use keys — they use a power button or
--    NFC fob. We emulate that by auto-binding a phantom key to
--    any ElectricScooter the moment a player enters it.
--
--    Strategy:
--      1. When a player enters a vehicle, check if it's an
--         ElectricScooter (by script name).
--      2. If so, assign a random keyId to the vehicle if it
--         doesn't have one.
--      3. Spawn a hidden "ScooterFob" key in the player's
--         inventory bound to that ID — OR, simpler, just tell
--         the vehicle the player has the key by setting the
--         key state directly.
--
--    PZ checks key presence via `vehicle:getKeyId()` vs the
--    player's inventory. Easier: override the start logic by
--    calling `vehicle:setKeysInIgnition(true)` and giving the
--    player a matching CarKey on entry. The key is auto-removed
--    when they exit so it doesn't clutter inventory.
-- ============================================================

require "ElectricScooter_Core"

ElectricScooter.Keyless = ElectricScooter.Keyless or {}

-- Track keys we spawned so we can clean them up on exit
local spawnedKeys = {}

local function isElectricScooter(vehicle)
    if not vehicle then return false end
    local script = vehicle:getScript()
    if not script then return false end
    local name = script:getName()
    return name == "ElectricScooter"
end

-- ------------------------------------------------------------
-- Bind a phantom fob when entering the scooter
-- ------------------------------------------------------------
local function onEnterVehicle(player)
    if not player then return end
    local vehicle = player:getVehicle()
    if not vehicle or not isElectricScooter(vehicle) then return end

    -- Ensure vehicle has a keyId
    local id = vehicle:getKeyId()
    if id == 0 then
        id = ZombRand(2147483647) + 1
        vehicle:setKeyId(id)
    end

    -- Check if player already has a matching key
    local inv = player:getInventory()
    local items = inv:getItems()
    for i = 0, items:size() - 1 do
        local it = items:get(i)
        if it and it.getKeyId and it:getKeyId() == id then
            -- Already has matching key, nothing to do
            return
        end
    end

    -- Spawn a phantom fob and bind it
    local fob = InventoryItemFactory.CreateItem("Base.CarKey")
    if not fob then return end
    fob:setKeyId(id)
    fob:setName("Scooter Fob")
    inv:AddItem(fob)

    -- Remember it so we can remove it on exit
    spawnedKeys[player:getUsername() or "local"] = fob
end

-- ------------------------------------------------------------
-- Remove phantom fob when exiting
-- ------------------------------------------------------------
local function onExitVehicle(player)
    if not player then return end
    local key = "local"
    if player.getUsername then
        key = player:getUsername() or "local"
    end
    local fob = spawnedKeys[key]
    if fob then
        local inv = player:getInventory()
        if inv and inv:contains(fob) then
            inv:Remove(fob)
        end
        spawnedKeys[key] = nil
    end
end

-- ------------------------------------------------------------
-- Hook B42 events. OnEnterVehicle / OnExitVehicle fire after
-- the player is fully seated / has left.
-- ------------------------------------------------------------
Events.OnEnterVehicle.Add(onEnterVehicle)
Events.OnExitVehicle.Add(onExitVehicle)

-- Also handle the edge case where the mod is loaded with a
-- player already in a scooter (save reload):
local function onGameStart()
    local p = getPlayer()
    if p and p:getVehicle() and isElectricScooter(p:getVehicle()) then
        onEnterVehicle(p)
    end
end
Events.OnGameStart.Add(onGameStart)

if getDebug() then
    print("[ElectricScooter] Keyless start system loaded")
end

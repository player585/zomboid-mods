-- ============================================================
--  ElectricScooter_Engine.lua
--  SERVER-SIDE (also runs in single-player):
--    Provides the two per-part update callbacks referenced by
--    vehicle_electricscooter.txt:
--
--      ElectricScooter.Update.Battery  (drains battery while moving)
--      ElectricScooter.Update.Engine   (locks fuel at max, kills engine
--                                       if battery dies)
--
--  Build 42 invokes these from the vehicle scripts' lua{} blocks via
--    lua { update = ElectricScooter.Update.Battery }
--  ...so there is NO Events.OnVehicleUpdated subscription. (That event
--  does not exist in B42 — the equivalent is the script-driven hooks.)
-- ============================================================

require "ElectricScooter_Core"

ElectricScooter.Update = ElectricScooter.Update or {}

-- ------------------------------------------------------------
-- helper: nearby-players notification
-- ------------------------------------------------------------
local function notifyNearbyPlayers(vehicle, msg)
    local vx, vy, vz = vehicle:getX(), vehicle:getY(), vehicle:getZ()
    local players = IsoPlayer.players
    if not players then return end
    for i = 0, players:size() - 1 do
        local pl = players:get(i)
        if pl then
            local dx = pl:getX() - vx
            local dy = pl:getY() - vy
            local dz = pl:getZ() - vz
            if (dx*dx + dy*dy + dz*dz) < 100 then -- within ~10 tiles
                pl:Say(msg)
            end
        end
    end
end

-- ------------------------------------------------------------
-- ElectricScooter.Update.Battery
-- Called by the engine for the Battery part every game-tick batch.
-- elapsedMinutes is how many in-game minutes passed since the last
-- call (typically 1 minute when the player is nearby).
-- ------------------------------------------------------------
function ElectricScooter.Update.Battery(vehicle, part, elapsedMinutes)
    if not vehicle or not part then return end

    -- Only drain while the engine is running
    if not vehicle:isEngineRunning() then return end

    local item = part:getInventoryItem()
    if not item then return end

    local current = item:getUsedDelta()  -- 0..1, vanilla "battery charge"
    if current <= 0 then return end

    -- Drain proportional to elapsed minutes
    local drain = ElectricScooter.BATTERY_DRAIN_RATE * (elapsedMinutes or 1)
    local newCharge = math.max(0, current - drain)
    item:setUsedDelta(newCharge)

    -- Out of juice -> cut engine
    if newCharge <= (ElectricScooter.MIN_BATTERY_TO_RUN / 100) then
        vehicle:setEngineRunning(false)
        notifyNearbyPlayers(vehicle, "*scooter battery dead*")
    end
end

-- ------------------------------------------------------------
-- ElectricScooter.Update.Engine
-- Called by the engine for the Engine part. We use it to keep
-- the (inherited from SmallCar) gas tank topped off so the
-- vanilla fuel system never decides we are out of gas.
-- ------------------------------------------------------------
function ElectricScooter.Update.Engine(vehicle, part, elapsedMinutes)
    if not vehicle then return end

    -- Lock fuel at max so vanilla "out of gas" never fires
    local fuelMax = vehicle:getFuelMax() or 0
    if fuelMax > 0 and vehicle:getFuel() < fuelMax then
        vehicle:setFuel(fuelMax)
    end
end

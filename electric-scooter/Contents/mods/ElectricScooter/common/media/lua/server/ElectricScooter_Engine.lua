-- ============================================================
--  ElectricScooter_Engine.lua
--  SERVER-SIDE (also runs in singleplayer):
--    * Drains battery while the engine runs.
--    * Locks the fuel system so vanilla "out of gas" never fires.
--    * Cuts the engine when battery dips below MIN_BATTERY_TO_RUN.
-- ============================================================

require "ElectricScooter_Core"

local function notifyNearbyPlayers(vehicle, msg)
    -- IsoGridSquare has no getPlayers(); enumerate IsoPlayer.players instead
    -- and filter by distance to the vehicle.
    local vx, vy, vz = vehicle:getX(), vehicle:getY(), vehicle:getZ()
    local players = IsoPlayer.players  -- ArrayList<IsoPlayer>
    if not players then return end

    for i = 0, players:size() - 1 do
        local pl = players:get(i)
        if pl then
            local dx = pl:getX() - vx
            local dy = pl:getY() - vy
            local dz = pl:getZ() - vz
            local distSq = dx * dx + dy * dy + dz * dz
            if distSq < 100 then -- within ~10 tiles
                pl:Say(msg)
            end
        end
    end
end

local function onVehicleUpdated(vehicle)
    if not ElectricScooter.isElectricScooter(vehicle) then return end

    -- Lock fuel at max so the vanilla fuel system doesn't kill the engine
    local fuelMax = vehicle:getFuelMax()
    if vehicle:getFuel() < fuelMax then
        vehicle:setFuel(fuelMax)
    end

    -- Only drain battery when the engine is running
    if not vehicle:isEngineRunning() then return end

    local batteryPart = vehicle:getPartById("Battery")
    if not batteryPart then return end

    local current = batteryPart:getCondition()

    if current <= ElectricScooter.MIN_BATTERY_TO_RUN then
        vehicle:setEngineRunning(false)
        notifyNearbyPlayers(vehicle, "*scooter battery dead*")
        return
    end

    -- Drain
    local newCondition = current - ElectricScooter.BATTERY_DRAIN_RATE
    batteryPart:setCondition(math.max(0, newCondition))
end

Events.OnVehicleUpdated.Add(onVehicleUpdated)

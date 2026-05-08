-- ============================================================
--  ElectricScooter_Engine.lua
--  SERVER-SIDE: Battery drain logic
--  Fires every vehicle update tick on the server.
--  Multiplayer safe — server is authoritative over battery state.
-- ============================================================

require "ElectricScooter_Core"

local function onVehicleUpdated(vehicle)
    -- Bail early if not our scooter
    if not ElectricScooter.isElectricScooter(vehicle) then return end

    -- Lock out the fuel system — electric vehicle uses no gas
    -- This prevents the vanilla "engine off due to no fuel" logic
    local fuelMax = vehicle:getFuelMax()
    if vehicle:getFuel() < fuelMax then
        vehicle:setFuel(fuelMax)
    end

    -- Only drain battery when the engine is actually running
    if not vehicle:isEngineRunning() then return end

    local batteryPart = vehicle:getPartById("Battery")
    if not batteryPart then return end

    local currentCondition = batteryPart:getCondition()

    -- Kill the engine if battery is too dead
    if currentCondition <= ElectricScooter.MIN_BATTERY_TO_RUN then
        vehicle:setEngineRunning(false)
        -- Notify any nearby players via chat (optional feedback)
        local x = vehicle:getX()
        local y = vehicle:getY()
        local z = vehicle:getZ()
        local square = getCell():getGridSquare(x, y, z)
        if square then
            local players = square:getPlayers()
            if players then
                for i = 0, players:size() - 1 do
                    local pl = players:get(i)
                    if pl then
                        pl:Say("*scooter battery dead*")
                    end
                end
            end
        end
        return
    end

    -- Drain the battery
    local newCondition = currentCondition - ElectricScooter.BATTERY_DRAIN_RATE
    batteryPart:setCondition(math.max(0, newCondition))
end

Events.OnVehicleUpdated.Add(onVehicleUpdated)

-- ============================================================
--  ElectricScooter_Core.lua
--  Shared logic: constants and utility functions
--  Runs on BOTH client and server
-- ============================================================

ElectricScooter = {}
ElectricScooter.VEHICLE_SCRIPT = "Base.ElectricScooter"

-- Battery drain per engine update tick.
-- Lower = slower drain. 0.0002 ≈ full charge lasts ~1 in-game day of driving.
ElectricScooter.BATTERY_DRAIN_RATE = 0.0002

-- Minimum battery condition before the scooter dies (0–100)
ElectricScooter.MIN_BATTERY_TO_RUN  = 5

function ElectricScooter.isElectricScooter(vehicle)
    if not vehicle then return false end
    local script = vehicle:getScriptName()
    return script == ElectricScooter.VEHICLE_SCRIPT
end

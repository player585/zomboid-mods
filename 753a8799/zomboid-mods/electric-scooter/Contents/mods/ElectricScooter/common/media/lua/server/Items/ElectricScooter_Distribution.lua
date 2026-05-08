-- ============================================================
--  ElectricScooter_Distribution.lua
--  SERVER-SIDE: Registers the scooter in vehicle spawn tables.
--  Spawns in suburban zones, parking lots, and good-condition
--  vehicle pools. Weighted low to keep it a rare find.
-- ============================================================

require "ElectricScooter_Core"

local function registerVehicleDistribution()
    if not VehicleDistributions then return end

    -- Spawn in good-condition pool (rare)
    if VehicleDistributions["GoodCondition"] then
        table.insert(VehicleDistributions["GoodCondition"]["vehicles"],
            { vehicle = ElectricScooter.VEHICLE_SCRIPT, weight = 4 }
        )
    end

    -- Spawn in bad-condition pool (slightly more common — beat up)
    if VehicleDistributions["BadCondition"] then
        table.insert(VehicleDistributions["BadCondition"]["vehicles"],
            { vehicle = ElectricScooter.VEHICLE_SCRIPT, weight = 7 }
        )
    end

    -- Spawn in suburb zone pools
    if VehicleDistributions["SuburbsParking"] then
        table.insert(VehicleDistributions["SuburbsParking"]["vehicles"],
            { vehicle = ElectricScooter.VEHICLE_SCRIPT, weight = 10 }
        )
    end

    -- Spawn in general parking
    if VehicleDistributions["Parking"] then
        table.insert(VehicleDistributions["Parking"]["vehicles"],
            { vehicle = ElectricScooter.VEHICLE_SCRIPT, weight = 6 }
        )
    end
end

-- Hook into game start after all distributions are loaded
Events.OnGameStart.Add(registerVehicleDistribution)

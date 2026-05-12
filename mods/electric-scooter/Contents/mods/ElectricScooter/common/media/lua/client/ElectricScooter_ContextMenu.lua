-- ============================================================
--  ElectricScooter_ContextMenu.lua
--  CLIENT-SIDE: Adds "Check Battery" to right-click context
--  menu when player interacts with the Electric Scooter.
-- ============================================================

require "ElectricScooter_Core"

local function onFillWorldObjectContextMenu(player, context, worldobjects, test)
    if test then return true end

    for _, obj in ipairs(worldobjects) do
        -- IsoVehicle check
        if obj.getVehicle and obj:getVehicle() then
            local vehicle = obj:getVehicle()
            if ElectricScooter.isElectricScooter(vehicle) then

                context:addOption("Check Battery", vehicle, function(v)
                    local batteryPart = v:getPartById("Battery")
                    local item = batteryPart and batteryPart:getInventoryItem()
                    local charge = (item and item:getUsedDelta() * 100) or 0
                    local msg

                    if charge > 75 then
                        msg = string.format("Battery is strong. Charge: %.0f%%", charge)
                    elseif charge > 40 then
                        msg = string.format("Battery getting low. Charge: %.0f%%", charge)
                    elseif charge > ElectricScooter.MIN_BATTERY_TO_RUN then
                        msg = string.format("Battery critical! Charge: %.0f%%", charge)
                    else
                        msg = "Battery is dead. Need to swap it."
                    end

                    getPlayer():Say(msg)
                end)

            end
        end
    end
end

Events.OnFillWorldObjectContextMenu.Add(onFillWorldObjectContextMenu)

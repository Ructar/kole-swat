isGrappling = false
grappleRope = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isGrappling then
            local Player = PlayerPedId()
            if grappleRope and GetEntityHealth(isGrappling, false) > 0 then
                local PlayerPosition = GetEntityCoords(Player, false)

                if not IsEntityPlayingAnim(Player, Config.Animations["Rappel"].Dictionary, Config.Animations["Rappel"].Animation, 0) then
                    TaskPlayAnim(Player, Config.Animations["Rappel"].Dictionary, Config.Animations["Rappel"].Animation, 0.0, 0.0, 1.0, -1, 49, 0, 0, 0)
                end
                if CanPedRagdoll(Player) then
                    SetPedCanRagdoll(Player, false)
                else
                    if IsControlPressed(1, Config.Keys["Up"]) then
                        StopRopeUnwindingFront(grappleRope)
                        StartRopeWinding(grappleRope)
                    end
                    if IsControlPressed(1, Config.Keys["Down"]) then
                        StopRopeWinding(grappleRope)
                        StartRopeUnwindingFront(grappleRope)
                    end
                    if IsControlPressed(1, Config.Keys["Left"]) then
                        ApplyForceToEntityCenterOfMass(Player, 0, 0.0, -0.5, 0.0, false, true, true, false)
                    end
                    if IsControlPressed(1, Config.Keys["Right"]) then
                        ApplyForceToEntityCenterOfMass(Player, 0, 0.0, 0.5, 0.0, false, true, true, false)
                    end
                end
            else
                DetachEntityFromRope(grappleRope, Player)
            end
        end
    end
end)

RegisterNetEvent("SWAT:CreateRope")
AddEventHandler("SWAT:CreateRope", function()
    local Player = PlayerPedId()
    local PlayerPosition = GetEntityCoords(Player, false)
    local Height = GetGroundZFromCoord(Hitcoord.x, Hitcoord.y, Hitcoord.z, PlayerPosition.z)
    local Distance = #(PlayerPosition - Hitcoord)
    local Angle = math.sin(Height / Distance)
    if Angle > 80 and Angle < 95 then
        grappleRope = AddRope(Hitcoord.x, Hitcoord.y, Hitcoord.z, 0.0, 0.0, 0.0, Distance - 1, 2, Distance, 0, 1, false, false, true, false, true, false)
        AttachRopeToEntity(grappleRope, Player, 0.0, 0.0, 0.0, false)
        while not HasAnimDictLoaded(Config.Animations["Start"].Dictionary) do
            Citizen.Wait(0)
        end
        TaskPlayAnim(Player, Config.Animations["Start"].Dictionary, Config.Animations["Start"].Animation, 0.0, 0.0, 1.0, 3, 49, 0, 0, 0)
        Citizen.Wait(3000)
        isGrappling = true
    end
end)


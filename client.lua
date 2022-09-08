

QBCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

-- Code

local cooldown = 0
local ispriority = false
local ishold = false


RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true

    QBCore.Functions.TriggerCallback('Uc-scoreboard:server:GetConfig', function(config)
        Config.IllegalActions = config
    end)
end)

local scoreboardOpen = false

local PlayerOptin = {}

DrawText3D = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

GetClosestPlayer = function()
    local closestPlayers = QBCore.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(GetPlayerPed(-1))

    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end

	return closestPlayer, closestDistance
end

GetPlayers = function()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            table.insert(players, player)
        end
    end
    return players
end

GetPlayersFromCoords = function(coords, distance)
    local players = GetPlayers()
    local closePlayers = {}

    if coords == nil then
		coords = GetEntityCoords(GetPlayerPed(-1))
    end
    if distance == nil then
        distance = 5.0
    end
    for _, player in pairs(players) do
		local target = GetPlayerPed(player)
		local targetCoords = GetEntityCoords(target)
		local targetdistance = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)
		if targetdistance <= distance then
			table.insert(closePlayers, player)
		end
    end
    
    return closePlayers
end


Citizen.CreateThread(function()
    while true do
        if IsControlJustPressed(0, Config.OpenKey) then
            if not scoreboardOpen then
                QBCore.Functions.TriggerCallback('Uc-scoreboard:server:GetPlayersArrays', function(playerList)
                    QBCore.Functions.TriggerCallback('Uc-scoreboard:server:GetActivity', function(cops, ambulance)
                        PlayerOptin = playerList
                        Config.CurrentCops = cops
    
                        SendNUIMessage({
                            action = "open",
                            players = GetCurrentPlayers(),
                            maxPlayers = Config.MaxPlayers,
                            requiredCops = Config.IllegalActions,
                            currentCops = Config.CurrentCops,
                            currentAmbulance = ambulance,
                            ogtal3b = FFTlayTime(),
                            col = cooldown,
                        })
                        scoreboardOpen = true
                    end)
                end)
            end
        end

        if IsControlJustReleased(0, Config.OpenKey) then
            if scoreboardOpen then
                SendNUIMessage({
                    action = "close",
                })
                scoreboardOpen = false
            end
        end

        if scoreboardOpen then
            for _, player in pairs(GetPlayersFromCoords(GetEntityCoords(GetPlayerPed(-1)), 10.0)) do
                local PlayerId = GetPlayerServerId(player)
                local PlayerPed = GetPlayerPed(player)
                local PlayerName = GetPlayerName(player)
                local PlayerCoords = GetEntityCoords(PlayerPed)

                DrawText3D(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 1.0, '~b~ID~w~ [ '..PlayerId..' ]')
            end
        end

        Citizen.Wait(3)
    end
end)

function GetCurrentPlayers()
    local TotalPlayers = 0

    for _, player in ipairs(GetActivePlayers()) do
        TotalPlayers = TotalPlayers + 1
    end

    return TotalPlayers
end


local Totalm = 0

local Totalh = 0

local Totalt = 0


Citizen.CreateThread(function()
  
    while true do
       
        Citizen.Wait(60000)
        -- Citizen.Wait(100)

        if Totalm < 61 then 

        Totalm = Totalm + 1

        else 
            Totalm = 0 
            Totalh = Totalh + 1
        end 
      
        


    end 
end)


RegisterNetEvent('Uc-scoreboard:client:SetActivityBusy')
AddEventHandler('Uc-scoreboard:client:SetActivityBusy', function(activity, busy)
    Config.IllegalActions[activity].busy = busy
end)

function FFTlayTime()
 

  
    
    Totalt = ""..Totalh.." : "..Totalm.." Time ⏱ "

    return Totalt
    
end







RegisterNetEvent('UpdateCooldown')
AddEventHandler('UpdateCooldown', function(newCooldown)
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
     TriggerEvent('chatMessage', "شرطة لوس سانتوس", "error", "تم تفعيل اولوية المدينة ويمنع منعاً باتاً مزاولة اي عمل إجرامي الى حين الانتهاء")
    cooldown = newCooldown
end)

RegisterNetEvent('UpdatePriority')
AddEventHandler('UpdatePriority', function(newispriority)
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)

    ispriority = newispriority
end)

RegisterNetEvent('UpdateHold')
AddEventHandler('UpdateHold', function(newishold)
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)

    ishold = newishold
end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)
-- 		if ishold == true then
-- 			DrawText2("FOR ~c~LIFE | ~w~Priority Cooldown: ~c~Priorities Are On Hold")
-- 		elseif ispriority == false then
-- 			DrawText2("FOR ~c~LIFE | ~w~Priority Cooldown: ~c~".. cooldown .." ~w~Mins")
-- 		elseif ispriority == true then
-- 			DrawText2("FOR ~c~LIFE | ~w~Priority Cooldown: ~c~Priority In Progress")
-- 		end
-- 	end
-- end)

RegisterNetEvent('police:PlaySound')
AddEventHandler('police:PlaySound', function()
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
end)

    function DrawText2(text)
        local fontId = RegisterFontId('Arb')
        SetTextFont(fontId)
        SetTextProportional(3)
        SetTextScale(0.1, 0.25)
        SetTextDropshadow(1, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(0.840, 0.950)
    end


QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

QBCore.Functions.CreateCallback('Uc-scoreboard:server:GetActivity', function(source, cb)
    local PoliceCount = 0
    local AmbulanceCount = 0
    
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                PoliceCount = PoliceCount + 1
            end

            if ((Player.PlayerData.job.name == "ambulance" or Player.PlayerData.job.name == "doctor") and Player.PlayerData.job.onduty) then
                AmbulanceCount = AmbulanceCount + 1
            end
        end
    end

    cb(PoliceCount, AmbulanceCount)
end)



QBCore.Functions.CreateCallback('Uc-scoreboard:server:GetConfig', function(source, cb)
    cb(Config.IllegalActions)
end)

QBCore.Functions.CreateCallback('Uc-scoreboard:server:GetPlayersArrays', function(source, cb)
    local players = {}
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            players[Player.PlayerData.source] = {}
            players[Player.PlayerData.source].permission = QBCore.Functions.IsOptin(Player.PlayerData.source)
        end
    end
    cb(players)
end)

RegisterServerEvent('Uc-scoreboard:server:SetActivityBusy')
AddEventHandler('Uc-scoreboard:server:SetActivityBusy', function(activity, bool)
    Config.IllegalActions[activity].busy = bool
    TriggerClientEvent('Uc-scoreboard:client:SetActivityBusy', -1, activity, bool)
end)



-- Config
timermax = 31 -- In minutes. Must be one bigger than the max timer you want (Eg if you want 20 it must be 21)

-- Do not touch
cooldown = 0
ispriority = false
ishold = false

RegisterNetEvent('isPriority')
AddEventHandler('isPriority', function()
	ispriority = true
	Citizen.Wait(1)
	TriggerClientEvent('UpdatePriority', -1, ispriority)
	TriggerClientEvent('chatMessage', -1, "WARNING", {255, 0, 0}, "^1A priority call is in progress. Please do not interfere, otherwise you will be ^1kicked. ^7All calls are on ^3hold ^7until this one concludes.")
end)

RegisterNetEvent('isOnHold')
AddEventHandler('isOnHold', function()
	ishold = true
	Citizen.Wait(1)
	TriggerClientEvent('UpdateHold', -1, ishold)
end)

RegisterNetEvent("cooldownt")
AddEventHandler("cooldownt", function()
	if ispriority == true then
		ispriority = false
		TriggerClientEvent('UpdatePriority', -1, ispriority)
	end
	Citizen.Wait(1)
	if ishold == true then
		ishold = false
		TriggerClientEvent('UpdateHold', -1, ishold)
	end
	Citizen.Wait(1)
	if cooldown == 0 then
		cooldown = 0
		cooldown = cooldown + timermax
		TriggerClientEvent('chatMessage', -1, "WARNING", {255, 0, 0}, "^1A priority call was just conducted. ^3All civilians must wait 20 minutes before conducting another one. ^7Failure to abide by this rule will lead to you being ^1kicked.")
		while cooldown > 0 do
			cooldown = cooldown - 1
			TriggerClientEvent('UpdateCooldown', -1, cooldown)
			Citizen.Wait(60000)
		end
	elseif cooldown ~= 0 then
		CancelEvent()
	end
end)

QBCore.Commands.Add("priority", "لتفعيل الاولويه", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "police2" or Player.PlayerData.job.name == "polic3" or Player.PlayerData.job.name == "police4" or Player.PlayerData.job.name == "police5" or Player.PlayerData.job.name == "police6" then
	TriggerEvent("cooldownt")
	    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "هاذا الامر لخدمات الطوارئ فقط")
    end
end)

QBCore.Commands.Add("cancepriority", "لالغاء الاولويه", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "police2" or Player.PlayerData.job.name == "polic3" or Player.PlayerData.job.name == "police4" or Player.PlayerData.job.name == "police5" or Player.PlayerData.job.name == "police6" then
	TriggerEvent("cancelcooldown")
	    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "هاذا الامر لخدمات الطوارئ فقط")
    end
end)

QBCore.Commands.Add("inprogress", "الابلاغ ان هناك اولويه اتيه", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "police2" or Player.PlayerData.job.name == "polic3" or Player.PlayerData.job.name == "police4" or Player.PlayerData.job.name == "police5" or Player.PlayerData.job.name == "police6" then
	TriggerEvent('isPriority')
	    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "هاذا الامر لخدمات الطوارئ فقط")
    end
end)

QBCore.Commands.Add("onhold", "لتعليق الاولويه", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "police2" or Player.PlayerData.job.name == "polic3" or Player.PlayerData.job.name == "police4" or Player.PlayerData.job.name == "police5" or Player.PlayerData.job.name == "police6" then
	TriggerEvent('isOnHold')
	    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "هاذا الامر لخدمات الطوارئ فقط")
    end
end)


RegisterNetEvent("cancelcooldown")
AddEventHandler("cancelcooldown", function()
	Citizen.Wait(1)
	while cooldown > 0 do
		cooldown = cooldown - 1
		TriggerClientEvent('UpdateCooldown', -1, cooldown)
		Citizen.Wait(100)
	end
	
end)
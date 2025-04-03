ESX = exports['es_extended']:getSharedObject()
NTDOTJSX = GetCurrentResourceName()
local IS_CARRY = false
local IS_DEAD = false -- WAIT USE

RegisterCommand('openmenu', function()
	OpenESXMenu()
end, false)

RegisterKeyMapping('openmenu', 'Open ESX Menu', 'keyboard', 'F9')

function OpenESXMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'action_menu', {
		title = 'ESX Menu',
		align = 'top-right',
		elements = Config.MenuElements
	}, function(data, menu)
		local PLAYER, DISTANCE = ESX.Game.GetClosestPlayer()
		local TARGETID = GetPlayerServerId(PLAYER)
		if data.current.value == 'carry_dead' then
			CarryDeadPlayer(PLAYER, DISTANCE, TARGETID)
		elseif data.current.value == 'carry_emote' then
			CarryEmote(PLAYER, DISTANCE)
		end
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

function CarryDeadPlayer(PLAYER, DISTANCE, TARGETID)
	if PLAYER ~= -1 and DISTANCE <= 3.0 then
		if CARRYDEAD[GetPlayerServerId(tonumber(PLAYER))] == true then
			IS_CARRY = not IS_CARRY
			if IS_CARRY then
				LoadAnimationDictionary("missfinale_c2mcs_1")
				TaskPlayAnim(PlayerPedId(), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 8.0, 8.0, -1, 49, 0, false,
					false, false)
				Anim = "fin_c2_mcs_1_camman"
				DictAnim = "missfinale_c2mcs_1"
			else
				IS_CARRY = false
				Wait(250)
				StopAnimTask(PlayerPedId(), DictAnim, Anim, 3.0)
			end

			if IS_CARRY then
				TriggerServerEvent("ADDTABLE:PLAYERDEAD", GetPlayerServerId(PLAYER))
				TriggerServerEvent(NTDOTJSX .. ':DROP_PLAYER', GetPlayerServerId(tonumber(PLAYER)), true)
				TriggerServerEvent(NTDOTJSX .. ':LYFTER', GetPlayerServerId(PLAYER), IS_CARRY, "Carry")
				MyCarryPeople = GetPlayerServerId(PLAYER)
				return
			end
		else
			if IsEntityDead(GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(tonumber(PLAYER))))) == 1 then
				IS_CARRY = not IS_CARRY
				if IS_CARRY then
					LoadAnimationDictionary("missfinale_c2mcs_1")
					TaskPlayAnim(PlayerPedId(), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 8.0, 8.0, -1, 49, 0, false,
						false, false)
					Anim = "fin_c2_mcs_1_camman"
					DictAnim = "missfinale_c2mcs_1"
				else
					IS_CARRY = false
					Wait(250)
					StopAnimTask(PlayerPedId(), DictAnim, Anim, 3.0)
				end

				if IS_CARRY then
					TriggerServerEvent("ADDTABLE:PLAYERDEAD", GetPlayerServerId(PLAYER))
					if CARRYDEAD[GetPlayerServerId(tonumber(PLAYER))] then
						TriggerServerEvent(NTDOTJSX .. ':DROP_PLAYER', MyCarryPeople, true)
					end
					TriggerServerEvent(NTDOTJSX .. ':LYFTER', GetPlayerServerId(PLAYER), IS_CARRY, "Carry")
					MyCarryPeople = GetPlayerServerId(PLAYER)
					return
				end
			end
		end
	else
		print('NO PLAYER NEARBY')
	end

	if IS_CARRY == true then
		IS_CARRY = false
		Wait(250)
		StopAnimTask(PlayerPedId(), DictAnim, Anim, 3.0)
	end
end

function CarryEmote(PLAYER, DISTANCE)
	if PLAYER ~= -1 and DISTANCE <= 3.0 then
		print('CARRY EMOTE !!')
	else
		print("NO PLAYER NEARBY")
	end
end

CARRYDEAD = {}
RegisterNetEvent('ADDTABLE:PLAYERDEAD')
AddEventHandler('ADDTABLE:PLAYERDEAD', function(TARGET)
	CARRYDEAD[TARGET] = true
end)

RegisterNetEvent('ADDTABLE:RemoveDead')
AddEventHandler('ADDTABLE:RemoveDead', function(TARGET)
	CARRYDEAD[TARGET] = nil
end)
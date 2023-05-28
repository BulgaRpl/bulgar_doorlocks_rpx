local RPX = exports['rpx-core']:GetObject()

local DoorInfo	= {}

RegisterServerEvent('bulgar_doorlocks_rpx:Load')
AddEventHandler('bulgar_doorlocks_rpx:Load', function()
	for k, v in pairs(DoorInfo) do
		TriggerClientEvent('bulgar_doorlocks_rpx:setState', -1, v.doorID, v.state)
	end
end)

RegisterServerEvent('bulgar_doorlocks_rpx:updatedoorsv')
AddEventHandler('bulgar_doorlocks_rpx:updatedoorsv', function(source, doorID, cb)
    local _source = source

	local Character = RPX.GetPlayer(_source)
	local job = Character.job.name
	
	if not IsAuthorized(job, Config.DoorList[doorID]) then
		lib.notify(_source, {title = "No Key!", type = "error"})
		return
	else 
		TriggerClientEvent('bulgar_doorlocks_rpx:changedoor', _source, doorID)
	end
end)

RegisterServerEvent('bulgar_doorlocks_rpx:updateState')
AddEventHandler('bulgar_doorlocks_rpx:updateState', function(doorID, state, cb)
    local _source = source
	
	local Character = RPX.GetPlayer(_source)
	local job = Character.job.name
	
	if type(doorID) ~= 'number' then
		return
	end

	if not IsAuthorized(job, Config.DoorList[doorID]) then
		return
	end
	
	DoorInfo[doorID] = {
		doorID = doorID,
		state = state
	}

	TriggerClientEvent('bulgar_doorlocks_rpx:setState', -1, doorID, state)
end)

function IsAuthorized(jobName, doorID)
	for _,job in pairs(doorID.authorizedJobs) do
		if job == jobName then
			return true
		end
	end
	return false
end
local ADDON_NAME = "SuppressErrors"
local ADDON_VERSION = "1.0"
local ADDON_AUTHOR = "Tom Cumbow"

local SV





local function HandleLuaErrorEvent()

	if SV.luaError >= 1 then

		--unregister original handler
		EVENT_MANAGER:UnregisterForEvent("ErrorFrame", EVENT_LUA_ERROR)

		local seenBugs = {}

		--create a new event handler
		local function OnLuaError(_, errString)

			-- Display a notification
			if SV.luaError == 1 then

				local LNTF = LibNotifications
				local provider = LNTF:CreateProvider()

				local function RemoveNotification(data)
					table.remove(provider.notifications, data.notificationId)
					provider:UpdateNotifications()
				end

				if not seenBugs[errString] then

					local msg = {
						dataType						= NOTIFICATIONS_REQUEST_DATA,
						secsSinceRequest			= ZO_NormalizeSecondsSince(0),
						message						= GetString(NOTYOU_LUAERR_MESSAGE),
						note							= errString,
						heading						= GetString(NOTYOU_LUAERR_HEADING),
						texture						= "/esoui/art/miscellaneous/eso_icon_warning.dds",
						shortDisplayText			= GetString(NOTYOU_LUAERR_SHORT),
						controlsOwnSounds			= true,
						keyboardAcceptCallback	= function(data)
							ZO_ERROR_FRAME:OnUIError(errString)
							RemoveNotification(data)
						end,
						keybaordDeclineCallback	= RemoveNotification,
						gamepadAcceptCallback	= function(data)
							ZO_ERROR_FRAME:OnUIError(errString)
							RemoveNotification(data)
						end,
						gamepadDeclineCallback	= RemoveNotification,
						data							= {errString = errString},
					}

					table.insert(provider.notifications, msg)
					provider:UpdateNotifications()
					seenBugs[errString] = true

				end
			elseif SV.luaError == 2 then
				if not seenBugs[errString] then
					d(errString)
					seenBugs[errString] = true
				end
			end
		end

		EVENT_MANAGER:RegisterForEvent("LUA_ERROR", EVENT_LUA_ERROR, OnLuaError)

	end

end

local function OnAddonLoaded(event, name)
	if name == ADDON_NAME then
		EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, event)


		--set hooks
		HandleLuaErrorEvent()

	end
end

EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, OnAddonLoaded)

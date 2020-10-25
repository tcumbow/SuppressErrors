local ADDON_NAME = "SuppressErrors"
local ADDON_VERSION = "1.0"
local ADDON_AUTHOR = "Tom Cumbow"

local SV




local function HandleLuaErrorEvent()

	EVENT_MANAGER:UnregisterForEvent("ErrorFrame", EVENT_LUA_ERROR)

end

local function OnAddonLoaded(event, name)
	if name == ADDON_NAME then
		EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, event)


		--set hooks
		HandleLuaErrorEvent()

	end
end

EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, OnAddonLoaded)

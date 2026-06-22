local Console = {}

local Commands = {}
local Logger
local Roles = require(script.Shared.Roles)

function Console:RegisterCommand(name, func, role, description)
	Commands[string.lower(name)] = {
		Callback = func,
		Role = role or "Player",
		Description = description or "No description provided."
	}
end

function Console:SetLogger(logger)
	Logger = logger
end

function Console:Log(message)
	if typeof(Logger) == "table" and Logger.Log then
		Logger:Log(message)
	end
end

function Console:GetCommands()
	return Commands
end

function Console:GetCommand(name)
	return Commands[string.lower(name)]
end

function Console:ClearLogs()
	if typeof(Logger) == "table" and Logger.Clear then
		Logger:Clear()
	end
end

function Console:Execute(player, input)
	local args = string.split(input, " ")
	local commandName = string.lower(table.remove(args, 1) or "")

	if commandName == "" then
		self:Log("[ERROR] No command entered")
		return
	end

	local commandData = Commands[commandName]

	if not commandData then
		self:Log("[ERROR] Unknown command")
		return
	end

	local requiredRole = commandData.Role
	local playerRole = Roles:GetPlayerRole(player)

	if requiredRole and requiredRole ~= "Player" then
		if playerRole ~= requiredRole then
			self:Log("[ERROR] You need " .. requiredRole .. " to use this command")
			return
		end
	end

	local success, err = pcall(function()
		commandData.Callback(player, self, table.unpack(args))
	end)

	if success then
		if commandName ~= "help" and commandName ~= "clear" then
			self:Log("[EXECUTED] " .. commandName .. " executed successfully")
		end
	else
		self:Log("[ERROR] " .. tostring(err))
	end
end

return Console

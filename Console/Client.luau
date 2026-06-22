local Client = {}

local Core
local UI

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Roles = require(game.ReplicatedStorage.Console.Console.Shared.Roles)

local initialized = false

local function getMainFrame()
	return UI and UI:FindFirstChild("MainFrame")
end

function Client:Init()
	if initialized then return end
	initialized = true

	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local interface = game.ReplicatedStorage.Console.Console.Interface
	local guiTemplate = interface:WaitForChild("ConsoleGui")

	local gui = playerGui:FindFirstChild("ConsoleGui")

	if not gui then
		gui = guiTemplate:Clone()
		gui.Name = "ConsoleGui"
		gui.Parent = playerGui
	end

	UI = gui

	if not UI:IsDescendantOf(playerGui) then
		UI.Parent = playerGui
	end

	local mainFrame = getMainFrame()
	if mainFrame then
		mainFrame.Visible = false
	end

	local f3Debounce = false

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode ~= Enum.KeyCode.F3 then return end

		if not Roles:CanOpenConsole(player) then return end
		if f3Debounce then return end

		f3Debounce = true

		local mf = getMainFrame()
		if mf then
			mf.Visible = not mf.Visible
		end

		task.delay(0.15, function()
			f3Debounce = false
		end)
	end)

	Core = require(game.ReplicatedStorage.Console.Console)

	local function load(folder)
		for _, module in ipairs(folder:GetChildren()) do
			if module:IsA("ModuleScript") then
				local cmd = require(module)

				if cmd and cmd.Name and cmd.Run then
					Core:RegisterCommand(cmd.Name, cmd.Run, cmd.Role, cmd.Description)
				end
			end
		end
	end

	local commandsFolder = game.ReplicatedStorage.Console.Console.Commands

	load(commandsFolder.BaseCommands)
	load(commandsFolder.CustomCommands)

	Core:SetLogger({
		Log = function(_, message)
			self:CreateLog(message)
		end,
		Clear = function()
			self:ClearLogs()
		end
	})
end

function Client:GetMatchingCommand(text)
	local input = string.lower(text)

	for name, data in pairs(Core:GetCommands()) do
		if string.sub(name, 1, #input) == input then
			return name, data
		end
	end

	return nil
end

function Client:Run(input)
	local player = Players.LocalPlayer
	Core:Execute(player, input)
end

function Client:CreateLog(data)
	local scroll = UI.MainFrame.HomeFrame:WaitForChild("LogsScrollingFrame")
	local template = scroll:WaitForChild("LogLabel")

	local log = template:Clone()
	log.Visible = true
	log.Name = "LogLabel"
	log.Parent = scroll

	local text = typeof(data) == "table" and data.Text or data

	local tag, rest = text:match("^(%[.-%])%s*(.*)$")

	if tag == "[ERROR]" then
		log.RichText = true
		log.Text = string.format('<font color="rgb(177,0,0)">%s</font> %s', tag, rest)

	elseif tag == "[EXECUTED]" then
		log.RichText = true
		log.Text = string.format('<font color="rgb(0,181,0)">%s</font> %s', tag, rest)

	else
		log.Text = text
	end

	if typeof(data) == "table" and data.Type == "Help" then
		log.Size = UDim2.new(log.Size.X.Scale, log.Size.X.Offset, 0, 100)
	end
end

function Client:ClearLogs()
	local scroll = UI.MainFrame.HomeFrame:WaitForChild("LogsScrollingFrame")
	local template = scroll:WaitForChild("LogLabel")

	for _, child in ipairs(scroll:GetChildren()) do
		if child:IsA("TextLabel") and child.Name == "LogLabel" and child ~= template then
			child:Destroy()
		end
	end
end

return Client
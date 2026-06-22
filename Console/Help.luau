return {
	Name = "help",
	Description = "Lists all available commands.",
	Role = "Player",

	Run = function(player, console)
		local Commands = console:GetCommands()

		local lines = {}

		for name, data in pairs(Commands) do
			table.insert(lines, name .. " (" .. (data.Role or "Player") .. ")")
		end

		console:Log("[EXECUTED] help executed successfully")

		console:Log({
			Type = "Help",
			Text = table.concat(lines, "\n")
		})
	end
}
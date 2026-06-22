return {
	Name = "clear",
	Description = "Clears all logs from the console.",
	Role = "Player",

	Run = function(player, console)
		console:ClearLogs()
	end
}
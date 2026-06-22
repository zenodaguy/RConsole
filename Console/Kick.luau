local Players = game:GetService("Players")

return {
	Name = "kick",
	Description = "Kicks a player from the server.",
	Role = "Admin",

	Run = function(player, console, target, ...)
		if not target or target == "" then
			error("Usage: kick <username/userid> [message]")
		end

		local targetPlayer

		for _, plr in ipairs(Players:GetPlayers()) do
			if string.lower(plr.Name) == string.lower(target) then
				targetPlayer = plr
				break
			end
		end

		if not targetPlayer then
			local userId = tonumber(target)

			if userId then
				for _, plr in ipairs(Players:GetPlayers()) do
					if plr.UserId == userId then
						targetPlayer = plr
						break
					end
				end
			end
		end

		if not targetPlayer then
			error("Player not found")
		end

		local message = table.concat({...}, " ")

		if message == "" then
			message = "Kicked by " .. player.Name
		end

		targetPlayer:Kick(message)
	end
}
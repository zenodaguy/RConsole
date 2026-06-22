local Players = game:GetService("Players")

return {
	Name = "kill",
	Description = "Kills the player entered.",
	Role = "Admin",

	Run = function(player, args)
		local targetName = args[1]

		if not targetName then
			local character = player.Character
			if character and character:FindFirstChild("Humanoid") then
				character.Humanoid.Health = 0
			end
			return
		end

		local function findPlayer(name)
			name = string.lower(name)

			for _, plr in ipairs(Players:GetPlayers()) do
				if string.lower(plr.Name):sub(1, #name) == name then
					return plr
				end
			end

			return nil
		end

		local target = findPlayer(targetName)

		if target and target.Character and target.Character:FindFirstChild("Humanoid") then
			target.Character.Humanoid.Health = 0
		end
	end
}
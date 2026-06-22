local BaseRoles = require(script.BaseRoles)
local CustomRoles = require(script.CustomRoles)

local Roles = {}

Roles.List = {}

for roleName, data in pairs(BaseRoles.List) do
	Roles.List[roleName] = data
end

for roleName, data in pairs(CustomRoles.List) do
	Roles.List[roleName] = data
end

function Roles:GetPlayerRole(player)
	for roleName, data in pairs(self.List) do
		for _, id in ipairs(data.Users) do
			if player.UserId == id then
				return roleName
			end
		end
	end

	return "Player"
end

function Roles:IsAdmin(player)
	return self:GetPlayerRole(player) == "Admin"
end

function Roles:CanOpenConsole(player)
	local role = self:GetPlayerRole(player)

	if role == "Player" then
		return false
	end

	local roleData = self.List[role]

	if not roleData then
		return false
	end

	return roleData.CanOpenConsole == true
end

function Roles:HasRole(player, roleName)
	local currentRole = self:GetPlayerRole(player)

	if currentRole == roleName then
		return true
	end

	if currentRole == "Admin" then
		return true
	end

	return false
end

return Roles
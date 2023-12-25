local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local EnvironmentSettings = {}

function EnvironmentSettings:IsMultiplayer()
	if RunService:IsClient() then
		while ReplicatedStorage:GetAttribute("MultiplayerMode") == nil do
			RunService.Heartbeat:Wait()
		end
	end

	return ReplicatedStorage:GetAttribute("MultiplayerMode")
end

function EnvironmentSettings:SetMultiplayerMode(bool: boolean)
	if RunService:IsClient() then return end
	ReplicatedStorage:SetAttribute("MultiplayerMode", bool)
end

return EnvironmentSettings
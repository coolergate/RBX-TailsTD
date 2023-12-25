local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local MainService = {Client = {}}


function MainService:Start()
	
end


function MainService:Init()
	-- -------------------- Remove interfaces from startergui ------------------- --
	for _, inst in StarterGui:GetChildren() do
		if not inst:IsA("ScreenGui") then
			warn("Invalid instance in StarterGui (not a ScreenGui):", inst)
			continue
		end

		inst.Parent = self.Shared.EnvironmentFoldersModule:GetReplicatedFolder("interface", ReplicatedStorage)
	end

	-- debug purposes
	self.Shared.EnvironmentSettings:SetMultiplayerMode(false)
end


return MainService
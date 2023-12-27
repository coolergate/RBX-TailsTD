local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local MainService = {
	Client = {}
}

function MainService.Client:JoinQueue(user: Player, queueid: string)
	local testqueue = MainService.Services.LobbyService:CreateQueue()

	testqueue.AddPlayer(user)
	testqueue.Teleport()
end

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
	
	-- ---------------------- Creating and managing servers --------------------- --
	self.Shared.EnvironmentSettings:SetMultiplayerMode(if game.PrivateServerId ~= "" then true else false)
	
end


return MainService
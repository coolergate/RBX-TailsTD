local Players = game:GetService("Players")

type gameplrdata = {
	cash: number
}

local PlayerService = {
	Client = {},
	LoggedPlayers = {} :: {[number]: gameplrdata},
}


function PlayerService:Start()
	
end

function PlayerService:HandlePlayer(user: Player)
	if self.LoggedPlayers[user] then return end

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = user

	local cash = Instance.new("NumberValue")
	cash.Name = "Cash"
	cash.Value = 1_000 -- temporary
	cash.Parent = leaderstats

	self.LoggedPlayers[user] = {
		cash = cash.Value,
	}
end

function PlayerService:Init()
	Players.PlayerAdded:Connect(function(player)
		self:HandlePlayer(player)
	end)
	for _, user in Players:GetPlayers() do
		self:HandlePlayer(user)
	end
end


return PlayerService
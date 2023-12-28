local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

type QueueRoom = {
	id: string;
	players: {Player};
	max_players: number;
	kill_time: number;
	selected_map: string;
}

local GameplayService = {}
GameplayService = {
	Client = {
		Server = {} :: typeof(GameplayService)
	},
	ActiveQueues = {} :: {[string]: QueueRoom}
}

function GetCurrentTime() 
	return DateTime.now().UnixTimestampMillis / 1000
end

function GameplayService.Client:JoinQueue(player: Player, roomid: string)
	if typeof(roomid) ~= "string" then return end

	local room = self.Server.ActiveQueues[roomid]
	if not room or #room.players == room.max_players then return end

	table.insert(room.players, player)

	if #room.players == room.max_players then
		room.kill_time = GetCurrentTime() + 5
		print("teleporting in 5 seconds...")
	end
end

function GameplayService.Client:CurrentLeaveQueue(player: Player)
	for _, room in pairs(self.Server.ActiveQueues) do
		local index =  table.find(room.players, player)
		if not index then continue end

		table.remove(room.players, index)
	end
end

function GameplayService.Client:GetQueues()
	return table.clone(self.Server.ActiveQueues)
end

function GameplayService:Start()
	if game.PrivateServerId == "" then
		coroutine.wrap(function()
			while (game) do
				for index, queue in pairs(self.ActiveQueues) do
					local currentTime = GetCurrentTime()
					if currentTime > queue.kill_time then

						if #queue.players > 0 then
							local code = TeleportService:ReserveServer(game.PlaceId)
							TeleportService:TeleportToPrivateServer(game.PlaceId, code, queue.players)
						end

						-- delete queue and create another one in its place
						table.clear(queue)
						self.ActiveQueues[index] = nil
						self:CreateQueue()
					end
				end

				RunService.Heartbeat:Wait()
			end
		end)()
		
		for _ = 1, 4 do
			self:CreateQueue()
		end
	end
end

function GameplayService:CreateQueue()
	local queue: QueueRoom = {
		id = HttpService:GenerateGUID(false),
		players = {},
		max_players = 1,
		kill_time = GetCurrentTime() + 12,
		selected_map = math.random(1, #ReplicatedStorage:WaitForChild("Maps"):GetChildren()) or "",
	}

	self.ActiveQueues[queue.id] = queue
end


function GameplayService:Init()
	
end


return GameplayService
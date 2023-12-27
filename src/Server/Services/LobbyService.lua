local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local LobbyService = {Client = {}}
local active_queues = {} :: {[string]: Lobby}

type Lobby = {
	lobbyid: string;
	players: {Player};
	players_ready: {[number]: Player};
	time_created: number;
	time_maxplayers: number;
	max_players: number;
}

function LobbyService:CreateQueue()
	local lobby: Lobby = {
		lobbyid = HttpService:GenerateGUID(false);
		players = {};
		players_ready = {};
		time_created = time();
		time_maxplayers = 5;
		max_players = 4;
	}

	active_queues[lobby.lobbyid] = lobby

	local function AddPlayer(player: Player)
		table.insert(lobby.players, player)
	end

	local function RemovePlayer(player: Player)
		local index = table.find(lobby.players, player)
		if not index then return end

		table.remove(lobby.players, index)
	end

	local function Cancel()
		for _, player in lobby.players do
			RemovePlayer(player)
		end

		active_queues[lobby.lobbyid] = nil
	end

	local function Teleport()
		local code = TeleportService:ReserveServer(game.PlaceId)

		TeleportService:TeleportToPrivateServer(game.PlaceId, code, lobby.players)
	end

	return {
		lobby = lobby;
		AddPlayer = AddPlayer;
		RemovePlayer = RemovePlayer;
		Teleport = Teleport;
		Cancel = Cancel;
	}
end

function LobbyService:Start()
	
end


function LobbyService:Init()
	
end


return LobbyService
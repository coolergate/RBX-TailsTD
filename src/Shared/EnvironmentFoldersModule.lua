local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local defaultfolders = {}

local EnvironmentFoldersModule = {
	defaultfolders = defaultfolders
}

function EnvironmentFoldersModule:Update()
	if RunService:IsClient() then
		for _, inst in CollectionService:GetTagged("ServerLocalFolder") do
			inst:Destroy()
		end
	end
end

function EnvironmentFoldersModule:GetReplicatedFolder(name: string, target: Instance)
	self:Update()

	if RunService:IsClient() then
		local inst = target:FindFirstChild(name) :: Folder
		if not inst or not inst:IsA("Folder") then
			inst = target:WaitForChild(name .. "_folder") :: Folder
		end
		return inst
	end

	local inst = target:FindFirstChild(name) :: Folder or target:FindFirstChild(name .. "_folder")
	if not inst or not inst:IsA("Folder") then
		inst = Instance.new("Folder")
		inst.Name = name .. "_folder"
		inst.Parent = target
	end
	
	return inst;
end

function EnvironmentFoldersModule:GetLocalFolder(name: string, target: Instance)
	self:Update()

	local targetkeyword = if RunService:IsClient() then "_clfolder" else "_svfolder"
	local inst = target:FindFirstChild(name) :: Folder or target:FindFirstChild(name .. targetkeyword) :: Folder
	
	if RunService:IsClient() and table.find(inst:GetTags(), "ServerLocalFolder") then
		inst:Destroy()
		inst = nil
	end

	if not inst or not inst:IsA("Folder") then
		inst = Instance.new("Folder")
		inst.Name = name .. targetkeyword
		inst.Parent = target
		inst:AddTag(if RunService:IsClient() then "ClientLocalFolder" else "ServerLocalFolder")
	end

	return inst
end


return EnvironmentFoldersModule
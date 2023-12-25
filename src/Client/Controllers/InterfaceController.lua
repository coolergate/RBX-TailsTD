local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local InterfaceController = {}

function InterfaceController:Start()
	local player = Players.LocalPlayer
	local playergui = player:WaitForChild("PlayerGui") :: PlayerGui
	local leaderstats = player:WaitForChild("leaderstats") :: Folder

	-- ---------------------------- Clone interfaces ---------------------------- --
	local content = self.Shared.EnvironmentFoldersModule:GetReplicatedFolder("interface", ReplicatedStorage):GetChildren() :: {[string]: Instance}
	for _, inst in content do
		if not inst:IsA("ScreenGui") then continue end
		
		local clone = inst:Clone() :: ScreenGui
		clone.Enabled = true
		clone.IgnoreGuiInset = true
		clone.ResetOnSpawn = false
		clone.Parent = playergui
	end

	-- ------------------------------- Default HUD ------------------------------ --
	local InterfaceHud = playergui:WaitForChild("Interface") :: ScreenGui

	-- ----------------------------- Shop interface ----------------------------- --
	if not self.Shared.EnvironmentSettings:IsMultiplayer() then
		local shopgui = playergui:WaitForChild("Shop") :: ScreenGui
		local shopwindow = shopgui.Window :: Frame
		local shop_closebtn = shopwindow.CloseButton :: TextButton
		local shopcontent = shopwindow.Content :: ScrollingFrame
		local proximityPrompt: ProximityPrompt
		
		shop_closebtn.Activated:Connect(function(inputObject, clickCount)
			shopgui.Enabled = false
			proximityPrompt.Enabled = true
		end)
		
		local shop_prefab = shopcontent.Prefab :: ShopPrefabContent
		shop_prefab.Visible = false

		type ShopPrefabContent = Frame & {
			BuyButton: TextButton;
			Image: ImageLabel;
			Name: TextLabel;
			Price: TextLabel;
		}

		-- -------------------------- Shop proximity prompt ------------------------- --
		local part = self.Shared.EnvironmentFoldersModule:GetReplicatedFolder("Objects", workspace):WaitForChild("ShopPart") :: Part

		proximityPrompt = Instance.new("ProximityPrompt")
		proximityPrompt.Name = "ProximityPrompt"
		proximityPrompt.Parent = part
		proximityPrompt.ActionText = "Open"
		proximityPrompt.GamepadKeyCode = Enum.KeyCode.ButtonY
		proximityPrompt.MaxActivationDistance = 8
		proximityPrompt.ObjectText = "Tower shop"
		proximityPrompt.RequiresLineOfSight = false

		proximityPrompt.Triggered:Connect(function()
			proximityPrompt.Enabled = false
			shopgui.Enabled = true
		end)
	end
	
	-- ----------------------------- TRINGs counter ----------------------------- --
	local cashcount = leaderstats:WaitForChild("Cash") :: NumberValue
	do
		local viewport = InterfaceHud.ViewportFrame :: ViewportFrame
		local ringstext = viewport.Rings :: TextLabel

		local camera = Instance.new("Camera")
		camera.Parent = viewport
		camera.FieldOfView = 1
		camera.CFrame = CFrame.new(0, 0, 70);

		local mesh = self.Shared.EnvironmentFoldersModule:GetReplicatedFolder("Models", ReplicatedStorage):WaitForChild("TRING"):Clone() :: MeshPart
		mesh.Parent = viewport

		viewport.CurrentCamera = camera

		local step = 0
		local rotation = 0
		RunService.RenderStepped:Connect(function(deltaTime)
			ringstext.Text = cashcount.Value

			step += deltaTime;
			if step < 1 / 30 then return end ;
			step = 0;

			rotation += 10;
			mesh.CFrame = CFrame.new() * CFrame.Angles(0, math.rad(rotation), 0) * CFrame.Angles(math.rad(180), 0, math.rad(90));
		end)
	end
end

function InterfaceController:Init()
	
end


return InterfaceController
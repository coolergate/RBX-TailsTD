local Players = game:GetService("Players")

local CharacterController = {}

function CharacterController:ResetCharacter()
	local player = Players.LocalPlayer
	local character = player.Character

	if not character then return end
	character:WaitForChild("Humanoid"):TakeDamage(character:WaitForChild("Humanoid").Health + 1)
end

function CharacterController:Start()
	local player = Players.LocalPlayer

	local animation_walk = Instance.new("Animation");
	animation_walk.Parent = workspace
	animation_walk.AnimationId = "rbxassetid://15753138656"

	local animation_jump = Instance.new("Animation");
	animation_jump.Parent = workspace
	animation_jump.AnimationId = "rbxassetid://15753222668"

	local animation_idle = Instance.new("Animation");
	animation_idle.Parent = workspace
	animation_idle.AnimationId = "rbxassetid://15753213933"

	local function HandleCharacter()
		local char = player.Character or player.CharacterAdded:Wait()
		local humanoid = char:WaitForChild("Humanoid") :: Humanoid
		local animator = humanoid:WaitForChild("Animator") :: Animator

		local walk, jump, idle = animator:LoadAnimation(animation_walk), animator:LoadAnimation(animation_jump), animator:LoadAnimation(animation_idle)
		walk.Priority = Enum.AnimationPriority.Action
		jump.Priority = Enum.AnimationPriority.Action2
		idle.Priority = Enum.AnimationPriority.Action

		walk.Looped = true
		idle.Looped = true

		humanoid.Jumping:Connect(function(active)
			if active then jump:Play() end
		end)
		humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
			local movement = humanoid.MoveDirection
			if movement.Magnitude > 0 then
				if not walk.IsPlaying then walk:Play() end
			else
				walk:Stop()
				idle:Play()
			end
		end)

		task.wait(1)
		idle:Play()
	end
	HandleCharacter()

	player.CharacterAdded:Connect(HandleCharacter)
end

function CharacterController:Init()
end


return CharacterController
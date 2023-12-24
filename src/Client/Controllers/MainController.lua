local Players = game:GetService("Players")

local MainController = {}


function MainController:Start()
	local player = Players.LocalPlayer

	-- --------------------------- Play shop animation -------------------------- --
	do
		local shopchar = self.Shared.EnvironmentFoldersModule:GetReplicatedFolder("Objects", workspace):WaitForChild("ShopCharacter") :: Model
		local shopchar_animator = shopchar:WaitForChild("Humanoid"):WaitForChild("Animator") :: Animator

		local shopchar_animation = Instance.new("Animation");
		shopchar_animation.AnimationId = "rbxassetid://15591537556";
		shopchar_animation.Parent = workspace

		local loaded_animation = shopchar_animator.LoadAnimation(shopchar_animation);
		loaded_animation.Priority = Enum.AnimationPriority.Action4;
		loaded_animation.Looped = true;
		loaded_animation:Play();
	end
end


function MainController:Init()
	
end


return MainController
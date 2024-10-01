local TweenService = game:GetService("TweenService")
local Teams = game:GetService("Teams")

local PlayerCrusher = {}
PlayerCrusher.__index = PlayerCrusher

function PlayerCrusher.new(crusherPart: Part, cooldown: IntValue, offset: IntValue, crushSpeed: IntValue, goalPart: Part)
	local self = setmetatable({}, PlayerCrusher)
	self.crusherPart = crusherPart
	self.cooldown = cooldown	
	self.offset = offset
	self.crushSpeed = crushSpeed
	self.startCFrame = crusherPart.CFrame
	self.endCFrame = goalPart.CFrame
	
	self.button = self.crusherPart.Parent:FindFirstChild("Button").Value
	self.originalButtonColor = Color3.fromRGB(255, 115, 0)
	self.cooldownButtonColor = Color3.fromRGB(31, 14, 0)
	self.buttonCooldown = 3
	
	self.crusherPart.Parent:FindFirstChild("Killbrick").Touched:Connect(function(part)
		
		if part:IsA("BasePart") and part.Parent:FindFirstChild("Humanoid")  then
			part.Parent:FindFirstChild("Humanoid").Health = 0
		end
		
	end)
	
	self.button.ProximityPrompt.Triggered:Connect(function(player)
		
		if self.button.Color ~= self.cooldownButtonColor and player.Team == Teams["Bosses"] then
			self.button.Color = self.cooldownButtonColor
			self.button.ProximityPrompt.Enabled = false
			self:Crush()
		end
		
	end)
	
	
	return self
end

function PlayerCrusher:Crush()
	
	local tweenInfo = TweenInfo.new(self.crushSpeed / 4, Enum.EasingStyle.Quart, Enum.EasingDirection.In, 0, false)
	local startGoal = {}
	startGoal.CFrame = self.endCFrame
	local startTween = TweenService:Create(self.crusherPart, tweenInfo, startGoal)
	
	startTween:Play()
	
	startTween.Completed:Connect(function()
		self:UnCrush()
	end)
	
	if self.crusherPart.Parent:FindFirstChild("Killbrick") then
		local killbrick = self.crusherPart.Parent:FindFirstChild("Killbrick")
		
		killbrick.Touched:Connect(function(part)
			if part.Name == "CrusherGoal" and killbrick:FindFirstChild("Sound") and killbrick.Sound.Playing ~= true then
				killbrick.Sound.Playing = true
			end
		end)
	end
	
end

function PlayerCrusher:UnCrush()
	if self.crusherPart.Parent:FindFirstChild("Killbrick") then
		local killbrick = self.crusherPart.Parent:FindFirstChild("Killbrick")

		if killbrick:FindFirstChild("Sound") and killbrick.Sound.Playing ~= true then
			killbrick.Sound.Playing = true
		end
	end
	
	
	local tweenInfo = TweenInfo.new(self.crushSpeed / 4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, 0, false, self.cooldown / 4)
	local endGoal = {}
	endGoal.CFrame = self.startCFrame
	local endTween = TweenService:Create(self.crusherPart, tweenInfo, endGoal)
	
	endTween:Play()
	
	endTween.Completed:Connect(function()
		local routine = coroutine.create(function() 
			wait(self.buttonCooldown)
			self.button.Color = self.originalButtonColor
			self.button.ProximityPrompt.Enabled = true
		end)
		
		coroutine.resume(routine)
	end)

end

return PlayerCrusher

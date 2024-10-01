local TweenService = game:GetService("TweenService")

local Crusher = {}
Crusher.__index = Crusher

function Crusher.new(crusherPart: Part, cooldown: IntValue, offset: IntValue, crushSpeed: IntValue, goalPart: Part)
	local self = setmetatable({}, Crusher)
	self.crusherPart = crusherPart
	self.cooldown = cooldown	
	self.offset = offset
	self.crushSpeed = crushSpeed
	self.startCFrame = crusherPart.CFrame
	self.endCFrame = goalPart.CFrame
	
	self.crusherPart.Parent:FindFirstChild("Killbrick").Touched:Connect(function(part)
		if part:IsA("BasePart") and part.Parent:FindFirstChild("Humanoid")  then
			part.Parent:FindFirstChild("Humanoid").Health = 0
		end
	end)
	
	self:Crush()
	
	return self
end

function Crusher:Crush()
	
	local tweenInfo = TweenInfo.new(self.crushSpeed / 4, Enum.EasingStyle.Quart, Enum.EasingDirection.In, 0, false, self.cooldown + math.random(0, 2))
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

function Crusher:UnCrush()
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
		self:Crush()
	end)
end

return Crusher

local TweenService = game:GetService("TweenService")

local Gear = {}
Gear.__index = Gear

function Gear.new(gearPart: MeshPart, cooldown: IntValue, rotateSpeed: IntValue, variation: string)
	local self = setmetatable({}, Gear)
	self.gearPart = gearPart
	self.cooldown = cooldown
	self.rotateSpeed = rotateSpeed
	self.variation = variation
	
	self:Rotate()
	
	return self
end

function Gear:Rotate()
	local tween
	
	if self.variation == "Normal" then
		
		local tweenInfo = TweenInfo.new(self.rotateSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, self.cooldown)
		local startGoal = {}
		startGoal.CFrame = self.gearPart.CFrame * CFrame.Angles(0, math.rad(90), 0)
		tween = TweenService:Create(self.gearPart, tweenInfo, startGoal)
		
	elseif self.variation == "Random" then
		
		local tweenInfo = TweenInfo.new(self.rotateSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, self.cooldown)
		local startGoal = {}
		startGoal.CFrame = self.gearPart.CFrame * CFrame.Angles(0,math.rad( (math.random(0, 1) * 180 - 90) ), 0)
		tween = TweenService:Create(self.gearPart, tweenInfo, startGoal)

	elseif self.variation == "Constant" then
		
		local tweenInfo = TweenInfo.new(self.rotateSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, false, self.cooldown)
		local startGoal = {}
		startGoal.CFrame = self.gearPart.CFrame * CFrame.Angles(0, math.rad(180), 0)
		tween = TweenService:Create(self.gearPart, tweenInfo, startGoal)
		
		tween:Play()
		return
		
	end
	
	tween:Play()

	tween.Completed:Connect(function()
		self:Rotate()
	end)
	
end

return Gear
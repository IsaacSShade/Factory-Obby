local TweenService = game:GetService("TweenService")

local Conveyer = {}
Conveyer.__index = Conveyer

RotatingConveyerList = {}
local rotatingConveyersStarting = false


-- Rotates around the Y axis
local function rotateConveyer(conveyerObject)
	if not conveyerObject.conveyerModel:FindFirstChild("rotateDebounce") then
		local debounce = Instance.new("BoolValue")
		debounce.Parent = conveyerObject.conveyerModel
		debounce.Name = "rotateDebounce"
		
		local animateTime = 1
		local velocity = conveyerObject.conveyerModel.PrimaryPart.AssemblyLinearVelocity

		local startTweenInfo = TweenInfo.new(animateTime, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		local startGoal = {}
		startGoal.CFrame = (conveyerObject.conveyerModel.PrimaryPart.CFrame - Vector3.new(0, 2, 0)) * CFrame.Angles(0, math.rad(45), 0)
		startGoal.AssemblyLinearVelocity = Vector3.new((velocity.X * math.cos(math.rad(-45))) - (velocity.Z * math.sin(math.rad(-45))), 0, (velocity.X * math.sin(math.rad(-45))) + (velocity.Z * math.cos(math.rad(-45))))

		local startTween = TweenService:Create(conveyerObject.conveyerModel.PrimaryPart, startTweenInfo, startGoal)

		startTween:Play()
		wait(animateTime)

		velocity = conveyerObject.conveyerModel.PrimaryPart.AssemblyLinearVelocity

		local endTweenInfo = TweenInfo.new(animateTime, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		local endGoal = {}
		endGoal.CFrame = (conveyerObject.conveyerModel.PrimaryPart.CFrame + Vector3.new(0, 2, 0)) * CFrame.Angles(0, math.rad(45), 0)
		endGoal.AssemblyLinearVelocity = Vector3.new((velocity.X * math.cos(math.rad(-45))) - (velocity.Z * math.sin(math.rad(-45))), 0, (velocity.X * math.sin(math.rad(-45))) + (velocity.Z * math.cos(math.rad(-45))))

		local endTween = TweenService:Create(conveyerObject.conveyerModel.PrimaryPart, endTweenInfo, endGoal)

		endTween:Play()
		wait(animateTime)
		
		debounce:Destroy()
	end
	
end

local function rotateConveyerLoop()
	
	-- Starting it off pretty random
	for i = 0, 5, 1 do
		wait(2.1)

		for j = 0, 60, 1 do
			local routine = coroutine.create(function()
				rotateConveyer(RotatingConveyerList[math.random(1, #RotatingConveyerList)])
			end)
			coroutine.resume(routine)
			i += 1
		end
	end
	
	
	while true do
		--wait(math.random(1, 3))
		wait(0.5)
		
		local routine = coroutine.create(function()
			rotateConveyer(RotatingConveyerList[math.random(1, #RotatingConveyerList)])
		end)
		coroutine.resume(routine)
	end
end

function Conveyer.new(conveyerModel, speed)
	local self = setmetatable({}, Conveyer)
	self.conveyerModel = conveyerModel
	self.speed = speed
	
	self:AnimateTexture()
	
	if conveyerModel.Parent.Name == "RotatingConveyers" then
		table.insert(RotatingConveyerList, self)
		
		if rotatingConveyersStarting == false then
			rotatingConveyersStarting = true
			
			local routine = coroutine.create(function()
				rotateConveyerLoop()
				
			end)
			coroutine.resume(routine)
		end
	end
	
	return self
end

function Conveyer:AnimateTexture()
	
	for i, texture in pairs(self.conveyerModel:GetDescendants()) do
		if texture:IsA("Texture") then
			local tweenInfo = TweenInfo.new((100 / self.speed), Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, false)
			local tweenGoal = {}
			
			if texture.Face == Enum.NormalId.Front or texture.Face == Enum.NormalId.Top then
				tweenGoal.OffsetStudsV = -100
			elseif texture.Face == Enum.NormalId.Back or texture.Face == Enum.NormalId.Bottom then
				tweenGoal.OffsetStudsV = 100
			end
			
			local tween = TweenService:Create(texture, tweenInfo, tweenGoal)
			tween:Play()
				
		end
	end
end

function Conveyer:ChangeSpeed(speed)
	self.conveyerModel.Belt.AssemblyLinearVelocity = self.conveyerModel.Belt.AssemblyLinearVelocity.Unit * speed
	self.speed = speed
end

return Conveyer

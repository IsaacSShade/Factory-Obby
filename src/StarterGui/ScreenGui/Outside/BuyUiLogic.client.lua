local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local Teams = game:GetService("Teams")

local outsideFrame = script.Parent
local insideFrame = outsideFrame.Inside
local player = game.Players.LocalPlayer

local buyCeoId = 887465925
local buySkipStageId = 1902403068

local debounce = false
local buttonAnimationDebounce = false

local function moveGUI()
	if debounce  then
		return
	else
		debounce = true
		
		local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
		local goal = {}
		
		if outsideFrame.Arrow.Rotation == 0 then
			outsideFrame.Arrow.Rotation = 180
			goal.AnchorPoint = Vector2.new(0, outsideFrame.AnchorPoint.Y)
		elseif outsideFrame.Arrow.Rotation == 180 then
			outsideFrame.Arrow.Rotation = 0
			goal.AnchorPoint = Vector2.new(0.75, outsideFrame.AnchorPoint.Y)
		end
		
		local slideTween = TweenService:Create(outsideFrame, tweenInfo, goal)
		slideTween:Play()
		
		slideTween.Completed:Connect(function()
			debounce = false
		end)
		
	end
end

local function pressingEffect(button)
	if not buttonAnimationDebounce then
		buttonAnimationDebounce = true
		
		local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, true)
		local goal = {}
		goal.ImageColor3 = Color3.fromRGB(138, 138, 138)

		local pressTween = TweenService:Create(button, tweenInfo, goal)
		pressTween:Play()
		
		pressTween.Completed:Connect(function()
			buttonAnimationDebounce = false
		end)
	end
end

local function promptGamepassPurchase(passId)
	MarketplaceService:PromptGamePassPurchase(player, passId)
end

local function promptProductPurchase(productId)
	MarketplaceService:PromptProductPurchase(player, productId)
end

outsideFrame.Arrow.Activated:Connect(function()
	pressingEffect(outsideFrame.Arrow)
	moveGUI()
end)
insideFrame.SkipStage.Activated:Connect(function()
	pressingEffect(insideFrame.SkipStage)
	
	if player.Team == Teams["Plumbers - Stage 4"] or player.Team == Teams["On Fire - Stage 5"] or player.Team == Teams["Bosses"] then
		game.Workspace.Sounds.Splat.Playing = true
		return
	end
	
	--romptProductPurchase(buySkipStageId)
end)

insideFrame.CEO.Activated:Connect(function()
	pressingEffect(insideFrame.CEO)
	
	promptGamepassPurchase(buyCeoId)
end)

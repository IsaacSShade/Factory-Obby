BoxSpawner = require(game.ServerScriptService:WaitForChild("BoxSpawner", true))
Conveyer = require(game.ServerScriptService:WaitForChild("Conveyer", true))
Crusher = require(game.ServerScriptService:WaitForChild("Crusher", true))
PlayerCrusher = require(game.ServerScriptService:FindFirstChild("PlayerCrusher", true))
Gear = require(game.ServerScriptService:WaitForChild("Gear", true))

local STAGE_1_TEAM_NAME = "New Hires - Stage 1"
local STAGE_2_TEAM_NAME = "Haulers - Stage 2"
local STAGE_3_TEAM_NAME = "Mechanics - Stage 3"
local STAGE_4_TEAM_NAME = "Plumbers - Stage 4"
local STAGE_5_TEAM_NAME = "On Fire - Stage 5"
local WINNING_TEAM_NAME = "Bosses"
	
local Teams = game:GetService("Teams")

local function handleCrusherNames(crusherModel)
	
	if crusherModel.Name == "Crusher" then
		Crusher.new(crusherModel.PrimaryPart, 1, 0, 4, crusherModel:FindFirstChild("CrusherGoal"))
	elseif crusherModel.Name == "PlayerCrusher" then
		PlayerCrusher.new(crusherModel.PrimaryPart, 2, 4, 4, crusherModel:FindFirstChild("CrusherGoal"))
	end
	
end

local function handleSpawnerNames(spawnerModel)
	local cooldownTime = 4
	
	if spawnerModel.Name == "SmallShadow" and spawnerModel:FindFirstChild("BoxSpawner") then
		BoxSpawner.new(spawnerModel.BoxSpawner, "Small")
	elseif spawnerModel.Name == "MediumShadow" and spawnerModel:FindFirstChild("BoxSpawner") then
		BoxSpawner.new(spawnerModel.BoxSpawner, "Medium")
	elseif spawnerModel.Name == "LargeShadow" and spawnerModel:FindFirstChild("BoxSpawner") then
		BoxSpawner.new(spawnerModel.BoxSpawner, "Large")
	end
	
end

local function handleGearNames(gearModel)

	if gearModel.Name == "Gear" then
		Gear.new(gearModel.PrimaryPart, 1, 5, "Normal")
	elseif gearModel.Name == "RandomGear" then
		Gear.new(gearModel.PrimaryPart, 1, 5, "Random")
	elseif gearModel.Name == "ConstantGear" then
		Gear.new(gearModel.PrimaryPart, 0, 20, "Constant")
	end

end

local function startMachinery()
	for i, model in pairs( game.Workspace:GetDescendants() ) do
		if model:IsA("Model") then
			
			handleCrusherNames(model)
			handleSpawnerNames(model)
			handleGearNames(model)
			
			if model.Name == "Conveyer" then
				local speed = model.PrimaryPart.AssemblyLinearVelocity.Magnitude
				Conveyer.new(model, speed)
			end
			
		end
	end
end

local function initializeTeams()
	local stage1 = Instance.new("Team", Teams)
	stage1.Name = STAGE_1_TEAM_NAME
	stage1.TeamColor = BrickColor.new("Light orange brown")
	stage1.AutoAssignable = true
	
	local stage2 = Instance.new("Team", Teams)
	stage2.Name = STAGE_2_TEAM_NAME
	stage2.TeamColor = BrickColor.new("Grey")
	stage2.AutoAssignable = false
	
	local stage3 = Instance.new("Team", Teams)
	stage3.Name = STAGE_3_TEAM_NAME
	stage3.TeamColor = BrickColor.new("Dark green")
	stage3.AutoAssignable = false
	
	local stage4 = Instance.new("Team", Teams)
	stage4.Name = STAGE_4_TEAM_NAME
	stage4.TeamColor = BrickColor.new("Bright bluish green")
	stage4.AutoAssignable = false
	
	local stage5 = Instance.new("Team", Teams)
	stage5.Name = STAGE_5_TEAM_NAME
	stage5.TeamColor = BrickColor.new("Bright red")
	stage5.AutoAssignable = false
	
	local finished = Instance.new("Team", Teams)
	finished.Name = WINNING_TEAM_NAME
	finished.TeamColor = BrickColor.new("Black")
	finished.AutoAssignable = false
end

local function debugTeamChanger(name, teamName)
	game.Players:FindFirstChild(name).Team = game:getService("Teams")[teamName]
end

startMachinery()
initializeTeams()

game.Players.PlayerAdded:Connect(function(player)
	if player.Name == "IsaacShadowShade1" or player.Name == "kiwixlc" or player.Name == "Xfileguy123" then
		debugTeamChanger(player.Name, STAGE_4_TEAM_NAME)
	end
end)

local BoxSpawner = {}
BoxSpawner.__index = BoxSpawner

-- Small size is 8x8
-- Medium size is 16x16
-- Large size is 32x32

local spawningStarted = false
local intervalWaitTime = 1.2
local boxFolder = game.ReplicatedStorage.Boxes
local smallSpawners = {}
local mediumSpawners = {}
local largeSpawners = {}

local function BoxDestructionTimer(box)
	wait(60)
	if box ~= nil then
		box:Destroy()
	end
end

local function SpawnBoxes(spawnerTable, size)
	local sizeFolder = boxFolder:FindFirstChild(size)
	
	for i, spawner in pairs (spawnerTable) do
		local box = sizeFolder:GetChildren()[math.random(1, #sizeFolder:GetChildren())]:Clone()
		box.Parent = game.Workspace
		box.PrimaryPart:PivotTo(spawner.CFrame)
		
		local routine = coroutine.create(function()
			BoxDestructionTimer(box)
		end)
		coroutine.resume(routine)
	end
end

local function StartSpawningLoop()
	
	while true do
		wait(intervalWaitTime)
		SpawnBoxes(smallSpawners, "Small")
		SpawnBoxes(mediumSpawners, "Medium")
		SpawnBoxes(largeSpawners, "Large")
		
		wait(intervalWaitTime)
		SpawnBoxes(smallSpawners, "Small")
		
		wait(intervalWaitTime)
		SpawnBoxes(smallSpawners, "Small")
		SpawnBoxes(mediumSpawners, "Medium")
		
		wait(intervalWaitTime)
		SpawnBoxes(smallSpawners, "Small")
		
		wait(intervalWaitTime)
		SpawnBoxes(smallSpawners, "Small")
		SpawnBoxes(mediumSpawners, "Medium")
		
		wait(intervalWaitTime)
		SpawnBoxes(smallSpawners, "Small")

		wait(intervalWaitTime)
		SpawnBoxes(smallSpawners, "Small")
		SpawnBoxes(mediumSpawners, "Medium")

		wait(intervalWaitTime)
		SpawnBoxes(smallSpawners, "Small")
		
	end
end

function BoxSpawner.new(spawnerPart: Part, size: string, cooldown: int)
	local self = setmetatable({}, BoxSpawner)
	self.spawnerPart = spawnerPart
	self.size = size
	self.cooldown = cooldown
	
	if spawningStarted == false then
		spawningStarted = true
		
		local routine = coroutine.create(function()
			StartSpawningLoop()
		end)
		coroutine.resume(routine)
	end
	
	self:ActivateSpawner()
	
	return self
end

function BoxSpawner:ActivateSpawner() 
	if self.size == "Small" then
		table.insert(smallSpawners, self.spawnerPart)
	elseif self.size == "Medium" then
		table.insert(mediumSpawners, self.spawnerPart)
	elseif self.size == "Large" then
		table.insert(largeSpawners, self.spawnerPart)
	end
end

return BoxSpawner


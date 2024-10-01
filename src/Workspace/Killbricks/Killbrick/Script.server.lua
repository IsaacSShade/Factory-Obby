local function burnPart(part)
	--debounce
	local deb = Instance.new("BoolValue",part)
	deb.Name = "deb"

	--remove character velocity to prevent splatter
	part.AssemblyLinearVelocity = Vector3.new(0,0,0)
	part.AssemblyLinearVelocity = Vector3.new(0,0,0)

	--kill player, change color, play death sound
	part.Color = Color3.new(0,0,0)
	local sound = script.Sound:Clone()
	sound.Parent = part
	sound:Destroy()
end

script.Parent.Touched:Connect(function(part)
	
	if part and part.Parent and not part:FindFirstChild("deb") then
		
		if part:IsA("BasePart") and part.Parent:FindFirstChild("Humanoid") then
			burnPart(part)

			--kill player, change color, play death sound
			part.Parent.Humanoid.Health = part.Parent.Humanoid.Health - part.Parent.Humanoid.Health

			--remove shirt/pants to look more charred
			if part.Parent:FindFirstChild("Shirt") then part.Parent:FindFirstChild("Shirt"):Destroy() end
			if part.Parent:FindFirstChild("Pants") then part.Parent:FindFirstChild("Pants"):Destroy() end
			if part.Parent:FindFirstChild("TShirt") then part.Parent:FindFirstChild("TShirt"):Destroy() end
		end

		if part:IsA("BasePart") and part.Parent:IsA("Model") and game.ReplicatedStorage.Boxes:FindFirstChild(part.Parent.Name, true) and not part:FindFirstChild("deb") then
			local boxModel = part.Parent
			
			burnPart(part)
			wait(2)
			part:Destroy()
			
			if #boxModel:GetChildren() == 0 then
				boxModel:Destroy()
			end
		end
	end
	
end)
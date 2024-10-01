script.Parent.Touched:Connect(function(part)
	if part:IsA("BasePart") and part.Parent:FindFirstChild("Humanoid") and not part:FindFirstChild("deb") then
		game.Players:GetPlayerFromCharacter(part.Parent).Team = game:getService("Teams")["Plumbers - Stage 4"]
	end
end)
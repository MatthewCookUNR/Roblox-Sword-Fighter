game.Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	local matts = Instance.new("IntValue")
	matts.Name = "Matts"
	matts.Value = 0
	matts.Parent = leaderstats
	
	player.CharacterAdded:Connect(function(character)
		character.Humanoid.WalkSpeed = 16
		character.Humanoid.Died:Connect(function()
			--Whenevever someone dies, this runs
			if character:FindFirstChild("GameTag") then
				character.GameTag:Destroy()
			end
			
			player.LoadCharacter()
		end)
	end)
end)
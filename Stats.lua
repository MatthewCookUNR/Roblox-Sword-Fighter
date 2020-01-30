local dataStores = game:getService("DataStoreService"):GetDataStore("MattsDataStore")

local defaultCash = 0

local playersLeft = 0

--Event fires when player connects
game.Players.PlayerAdded:Connect(function(player)
	
	playersLeft = playersLeft + 1
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
	
	--Data Store
	
	local playerData
	
	pcall(function()
		playerData = dataStores:GetAsync(player.UserId.."-Matts") -- 1376-Matts
	end)
	--If player data is not null(exists)
	if playerData ~= nil then
		--Player has saved data, load it in
		matts.Value = playerData
	else
		--New Player
		matts.Value = defaultCash
	end
end)

local bindableEvent = Instance.new("BindableEvent")

--Event fires when player leaves the game
game.Players.PlayerRemoving:Connect(function(player)
	--Saves data for player
	pcall(function()
		dataStores:SetAsync(player.UserId.."-Matts", player.leaderstats.Matts.Value)
		print("Saved")
		playersLeft = playersLeft - 1
		bindableEvent:Fire()
	end)
end)

--Event fires upon game shutdown
game:BindToClose(function()
	while playersLeft > 0 do
		--Forces server to wait till there are no more players
		bindableEvent.Event:Wait()
	end
end)
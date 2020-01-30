-- Declare Variables Here
local ReplicatedStorage = game:GetService("ReplicatedStorage") --Replicated to player (seen by all and server). Ex: StatusVal for GUI(Intermission)

local ServerStorage = game:GetService("ServerStorage") --Server storage is for server only

local MapsFolder = ServerStorage:WaitForChild("Maps") -- Variable for Game Map

local Status = ReplicatedStorage:WaitForChild("Status") -- Variable for game status

local GameLength = 50

local reward = 50

-- Game Loop
while true do
	Status.Value = "Waiting for enough players"
	
	repeat wait() until game.Players.NumPlayers >= 2 -- Waits till ther are 2 or more players
	
	Status.Value = "Intermission"
	
	wait(10)
	
	--Check to see if there are enough players
	
	local playerTable = {}
	for i, player in pairs(game.Players:getPlayers()) do -- loops through all current players
		if player then -- if player is there
			table.insert(playerTable, player) -- Add each player to playerTable
		end
	end
	
	wait(2)
	
	--There are enough players, get map ready
	Status.Value = "Get ready to play!"	
	
	local AvailableMaps = MapsFolder:GetChildren()
	local ChosenMap = AvailableMaps[math.random(1, #AvailableMaps)]
	
	Status.Value = ChosenMap.Name.." Chosen" -- the ".." concatenates the two strings
	
	local ClonedMap = ChosenMap:Clone()
	ClonedMap.Parent = game.Workspace
	
	-- Teleport player to map
	
	local SpawnPoints = ClonedMap:FindFirstChild("SpawnPoints1")
	
	if not SpawnPoints then
		print("SpawnPoints not found")
	end
	
	local AvailableSpawnPoints = SpawnPoints:GetChildren() --Returns a table
	
	--pairs is a function that makes it loop over all elements of table
	for i, player in pairs(playerTable) do
		if player then
			character = player.Character
			if character then
				--Teleport
				--"HumanoidRootPart" is common between all Roblox body types
				--Vector3 addition makes the player 10 above spawn (x, y, z)
				character:FindFirstChild("HumanoidRootPart").CFrame = AvailableSpawnPoints[1].CFrame + Vector3.new(0,10,0)
				table.remove(AvailableSpawnPoints, 1)
				
				--Give player sword
				local Sword = ServerStorage.Sword:Clone()
				Sword.Parent = player.Backpack
				
				--Set Game Tag
				local GameTag = Instance.new("BoolValue")
				GameTag.Name = "GameTag"
				GameTag.Parent = player.Character
				
			else
				--No Character
				if not player then
					table.remove(playerTable, i) --Remove from table of active players
				end
			end
		end
	end
	
	--Game Loop Script (Who Left, Crown Winner, Out of Time)
	
	-- i = 50 (start at), 0 (breaking point), -1 (incrementing by)
	for i = GameLength, 0, -1 do
		for j, player in pairs(playerTable) do
			if player then
				character = player.Character
				if not character then
					--Left the game
					table.remove(playerTable, j)
				else
					if character:FindFirstChild("GameTag") then
						-- They are still alive
						print(player.Name.." is still in the game!")
					else
						--They are dead
						table.remove(playerTable, j)
					end					
				end
			else
				--Failed, not player
				table.remove(playerTable, j)
				print(player.Name.." has been removed!")
			end
		end
		
		Status.Value = "There are "..i.." seconds remaining, and "..#playerTable.." players left"
		
		if #playerTable == 1 then
			--Last person standing
			Status.Value = "The winner is "..playerTable[1].Name
			playerTable[1].leaderstats.Matts.Value = playerTable[1].leaderstats.Matts.Value + reward
			break --Break out of loop since game is over
		elseif #playerTable == 0 then
			Status.Value = "Nobody won!"
			break
		elseif i == 0 then
			Status.Value = "Time's Up"
		end
		
		--One Second Game Time Elapsed
		wait(1)
	end
	
	print("Game Over")
	
	--End of Game Cleanup (Delete GameTag, swords)
	for i, player in pairs(game.Players:getPlayers()) do
		character = player.Character
		if not character then
			--Ignore
		else
			--Delete GameTag at end of game
			if character:FindFirstChild("GameTag") then
				character.GameTag:Destroy()
			end
			--Destory sword in backpack at end of game
			if player.Backpack:FindFirstChild("Sword") then
				player.Backpack.Sword:Destroy()
			end
			--Destory sword in player's hand at end of game
			if character:FindFirstChild("Sword") then
				character.Sword:Destroy()
			end
		player:LoadCharacter()
		end
	end
	ClonedMap:Destroy()
	
	wait(2)
	
	Status.Value = "Game Ended"
end
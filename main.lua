local arcane = RegisterMod("Aracne Items", 1)


--animation stuff
arcane.COSTUME_ARCANE_AMULET = Isaac.GetCostumeIdByPath("gfx/characters/arcane_glow.anm2")
arcane.COSTUME_ARCANE_CLOAK = Isaac.GetCostumeIdByPath("gfx/characters/arcane_cloak.anm2")

--variable declarations
local game = Game()
local player
local room
local level
local resAllowed = true
local modItems = {
	AMULET = Isaac.GetItemIdByName("Arcane Amulet"),
	CLOAK = Isaac.GetItemIdByName("Arcane Cloak")
}

local hasItems = {
	Amulet = false,
	Cloak = false
}

-----------------------------------

function arcane:onUpdate(player, room)
	game = Game()
	player = game:GetPlayer(0)
	room = game:GetRoom()
	level = game:GetLevel()
	
	if  not hasItems.Amulet and player:HasCollectible(modItems.AMULET) then
		player:AddNullCostume(arcane.COSTUME_ARCANE_AMULET)
		hasItems.Amulet = true
	end
  
	if not hasItems.Cloak and player:HasCollectible(modItems.CLOAK) then
		player:AddNullCostume(arcane.COSTUME_ARCANE_CLOAK)
		hasItems.Cloak = true
	end
	if player:IsDead() and player:HasCollectible(modItems.AMULET) and resAllowed and room:GetType() == RoomType.ROOM_BOSS then
		player:Revive()
		--TODO: Go back one room, pop up text and hold up item
		game:ChangeRoom(level:GetPreviousRoomIndex())
		if player:GetMaxHearts() == 0 then
			player:AddSoulHearts(6) --in case no red hearts
		else  
			player:AddHearts(player:GetMaxHearts())
		end
		
	--resAllowed = false;
	end
	end

-------------------------------------
	
	function arcane:onCache(player,myCacheFlag)-- update stats and flying
	if myCacheFlag == CacheFlag.CACHE_FLYING then
		if player:HasCollectible(modItems.CLOAK) then
			player.CanFly = true
			hasItems.CLOAK = true
		end
	end
	if myCacheFlag == CacheFlag.CACHE_DAMAGE then
		if player:HasCollectible(modItems.AMULET) then
			player.Damage = 1.01*(player.Damage + 0.69)
			--hasItems.Amulet = true
		end
	end
end

----------------------------------------

--[[function arcane:onNewLevel() --Check if final floors(hopefully)
	game = Game()
	level = Game():GetLevel()
	if level >= LevelStage.STAGE6 then
		resAllowed = true
	end
end
]]--


arcane:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, arcane.onUpdate)
arcane:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, arcane.Init)
arcane:AddCallback(ModCallbacks.MC_POST_UPDATE, arcane.onUpdate, EntityType.ENTITY_PLAYER)
arcane:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, arcane.onCache)
arcane:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, arcane.onNewLevel)

--arcane:AddCallback(ModCallbacks.MC_POST_UPDATE, arcane.onFirstFrame)
--arcane:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, arcane.onDamage,EntityType.ENTITY_PLAYER)



#define SERVER_ONLY
CBlob@ SpawnPlayer(CPlayer@ p, Vec2f pos, u8 team)
{
	print("TODO: spawn player: " + p.getUsername() + " at (" + pos.x + "," + pos.y + ")");

	CBlob@ blob = server_CreateBlob("knight", team, pos);
	blob.server_SetPlayer(p);
	
	return blob;
}
int spawnTime = 10 * 2;
int gameovertimer = 10;
u32 limit = 11;
void onTick(CRules@ this)
{
	u8 StartTeam;
	CPlayer@[] players = collectPlayers(this);
	for (uint i = 0; i < players.length; i++)
	{
		if (i == 0){
			StartTeam = players[0].getBlob().getTeamNum();
		}
		if (StartTeam != players[i].getBlob().getTeamNum()){
			break;
		}
		if(i == players.length)
		{
			LoadNextMap();
		}
	}
}
void onInit(CRules@ this)
{
	onRestart(this);
}
void onRestart(CRules@ this)
{
	this.SetCurrentState(GAME);
}

void onNewPlayerJoin(CRules@ this, CPlayer@ player)
{
	player.server_setTeamNum(255);
	//player.set_s16("spawn time", spawnTime);
	//player.Sync("spawn time", true);
}
void onPlayerRequestTeamChange(CRules@ this, CPlayer@ player, u8 newteam)
{
	if (newteam != this.getSpectatorTeamNum())
		newteam = 0;

	KillOwnedBlob(player);
	player.server_setTeamNum(newteam);
}
void onPlayerLeave(CRules@ this, CPlayer@ player)
{
	KillOwnedBlob(player);
}

void onPlayerDie( CRules@ this, CPlayer@ victim, CPlayer@ attacker, u8 customData )
{		
	if (victim !is null )
	{
		victim.set_s16("spawn time", spawnTime);
		//victim.Sync("spawn time", true);
	}
}

/////////////////////////////////////////
//helper functions

Random _edgeRandom();
Vec2f randomEdgePosition()
{
	const s32 edgeVariation = 4; //range that you can spawn in of the edge, in tiles

	CMap@ map = getMap();
	s32 x = 1;
	if (_edgeRandom.NextRanged(2) == 0)
	{
		x = (map.tilemapwidth - 2);
		x -= _edgeRandom.NextRanged(edgeVariation);
	}
	else
	{
		x += _edgeRandom.NextRanged(edgeVariation);
	}
	s32 y = map.getLandYAtX(x) - 2;
	return Vec2f((x + 0.5f) * map.tilesize, (y + 0.5f) * map.tilesize);
}

//collect players actually playing the game
//aka not spectators
CPlayer@[] collectPlayers(CRules@ this)
{
	CPlayer@[] players;
	for (uint i = 0; i < getPlayersCount(); i++)
	{
		CPlayer@ p = getPlayer(i);
		if (p.getTeamNum() != this.getSpectatorTeamNum())
		{
			players.push_back(p);
		}
	}
	return players;
}

//get players that need a respawn (dont have a blob)
CPlayer@[] filterNeedRespawn(CPlayer@[] players)
{
	CPlayer@[] filtered;
	for (uint i = 0; i < players.length; i++)
	{
		CPlayer@ p = players[i];
		if (p.getBlob() is null)
		{
			filtered.push_back(p);
		}
	}
	return filtered;
}

//do the respawns for a set of players that need it
void DoRespawns(CPlayer@[] players)
{
	for (uint i = 0; i < players.length; i++)
	{
		CPlayer@ player = players[i];
		
		Vec2f[] teleports;
		CMap@ map = getMap();
		map.getMarkers("blue main spawn", teleports );
			
		Vec2f respawnPos = teleports[i];
		CBlob@ playerBlob = SpawnPlayer(player, respawnPos, i);
		
		
	}
}

bool SetMaterials(CBlob@ blob, const string &in name, const int quantity)
{
	CInventory@ inv = blob.getInventory();

	//already got them?
	if (inv.isInInventory(name, quantity))
		return false;

	//otherwise...
	inv.server_RemoveItems(name, quantity); //shred any old ones

	CBlob@ mat = server_CreateBlob(name);
	if (mat !is null)
	{
		mat.Tag("do not set materials");
		mat.server_SetQuantity(quantity);
		if (!blob.server_PutInInventory(mat))
		{
			mat.setPosition(blob.getPosition());
		}
	}

	return true;
}

void GiveSpawnResources(CBlob@ blob)
{
	if (blob.getName() == "builder")
	{
		SetMaterials(blob, "mat_wood", 100);
		SetMaterials(blob, "mat_stone", 30);
	}
	else if (blob.getName() == "assassin")
	{
		SetMaterials(blob, "mat_arrows", 30);
	}
	else if (blob.getName() == "knight")
	{
	}
}

//kill the blob if they have one (on switching team, or leaving)
void KillOwnedBlob(CPlayer@ player)
{
	CBlob@ blob = player.getBlob();
	if (blob !is null)
	{
		blob.server_Die();
	}
}



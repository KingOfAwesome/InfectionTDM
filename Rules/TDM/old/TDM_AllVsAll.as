#define SERVER_ONLY

int lastTeam = 1000;

void onBlobCreated(CRules@ this, CBlob@ blob)
{
	if (blob.hasTag("player"))
	{
		string name = blob.getName();

		lastTeam -= 1;
		blob.server_setTeamNum(lastTeam);

		CMap@ map = getMap();
		f32 mapMiddle = map.tilemapwidth * 8 / 2;

		Vec2f[] spawns;
		array<Vec2f> spawnsLeft, spawnsRight;
		map.getMarkers("blue main spawn", spawns);

		for (int i = 0; i < spawns.length; i++)
		{
			if (spawns[i].x < mapMiddle )
				spawnsLeft.insertLast(spawns[i]);
			else
				spawnsRight.insertLast(spawns[i]);
		}

		if (name == "knight")
		{
			int rndSpawn = XORRandom(spawnsLeft.length);
			blob.setPosition(spawnsLeft[rndSpawn] - Vec2f(0,8));
		}
		else
		{
			int rndSpawn = XORRandom(spawnsRight.length);
			blob.setPosition(spawnsRight[rndSpawn] - Vec2f(0,8));
		}
	}
}

void onRestart(CRules@ this)
{
	lastTeam = 1000;
}
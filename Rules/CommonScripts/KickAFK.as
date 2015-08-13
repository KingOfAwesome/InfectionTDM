// kicks players that dont move for a given time
// by norill

const int checkIntervalSeconds = 5 * 60;
const int kickWarnSeconds = 10;
Vec2f[] playersPos;
KickInfo@[] kickTimers;

// void onInit(CRules@ this){
// this.getCurrentScript().tickFrequency = getTicksASecond() * checkIntervalSeconds;
// }

class KickInfo
{
	CPlayer@ player;
	uint time;
	Vec2f pos;

	KickInfo() {}
};

void onTick(CRules@ this)
{
	if (getGameTime() % getTicksASecond() == 0)
	{
		for (uint i = 0; i < kickTimers.length; i++)
		{
			if (kickTimers[i].time + getTicksASecond() * kickWarnSeconds <= getGameTime())
			{
				if (kickTimers[i].player is getLocalPlayer() &&
				        !getNet().isServer()) //dont afk kick on local server
				{
					client_AddToChat("You were kicked for being AFK too long.", SColor(255, 240, 50, 0));
					getNet().DisconnectClient(); //politely disconnect if we can
				}

				if (getNet().isServer())
				{
					KickPlayer(kickTimers[i].player);
				}

				kickTimers.removeAt(i--);
			}
			else
			{
				CBlob@ blob = kickTimers[i].player.getBlob();
				if (blob is null || blob.getPosition() != kickTimers[i].pos)
				{
					if (kickTimers[i].player is getLocalPlayer() && !getNet().isServer())
					{
						client_AddToChat("AFK Kick avoided.", SColor(255, 20, 120, 0));
					}

					kickTimers.removeAt(i--);
				}
			}
		}
	}

	if (getGameTime() % (getTicksASecond() * checkIntervalSeconds) != 0) return;

	int count = getPlayerCount();
	playersPos.resize(count);
	for (uint i = 0; i < count; i++)
	{
		CBlob@ blob = getPlayer(i).getBlob();
		if (blob !is null && !getPlayer(i).isBot())
		{
			if (playersPos[i] == blob.getPosition())
			{
				warnAFK(getPlayer(i));
			}
			playersPos[i] = blob.getPosition();
		}
		else
		{
			playersPos[i] = Vec2f(0, 0);
		}
	}
}

void warnAFK(CPlayer@ player)
{
	if (player is getLocalPlayer() && !getNet().isServer())
	{
		client_AddToChat("Seems like you are currently away from your keyboard.", SColor(255, 255, 100, 32));
		client_AddToChat("Move around or you will be kicked in 10 seconds!", SColor(255, 255, 100, 32));
	}

	KickInfo info;
	@info.player = player;
	info.time = getGameTime();
	info.pos = player.getBlob().getPosition();
	kickTimers.push_back(info);
}
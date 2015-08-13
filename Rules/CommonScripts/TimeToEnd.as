//Rules timer!

// Requires game_end_time set originally

void onInit(CRules@ this)
{
	if (!this.exists("no timer"))
		this.set_bool("no timer", false);
	if (!this.exists("game_end_time"))
		this.set_u32("game_end_time", 0);
}

void onTick(CRules@ this)
{
	if (!getNet().isServer() || !this.isMatchRunning() || this.get_bool("no timer"))
	{
		return;
	}

	u32 gameEndTime = this.get_u32("game_end_time");

	if (gameEndTime == 0) return; //-------------------- early out if no time.

	if (getGameTime() > gameEndTime)
	{
		bool hasWinner = false;
		s8 teamWonNumber = -1;

		if (this.exists("team_wins_on_end"))
		{
			teamWonNumber = this.get_s8("team_wins_on_end");
		}

		if (teamWonNumber >= 0)
		{
			//ends the game and sets the winning team
			this.SetTeamWon(teamWonNumber);
			CTeam@ teamWon = this.getTeam(teamWonNumber);

			if (teamWon !is null)
			{
				hasWinner = true;
				this.SetGlobalMessage("Time is up!\n" + teamWon.getName() + " wins the game!");
			}
		}

		if (!hasWinner)
		{
			this.SetGlobalMessage("Time is up!\nIt's a tie!");
		}

		//GAME OVER
		this.SetCurrentState(3);
	}
}

void onRender(CRules@ this)
{
	if (!this.isMatchRunning()) return;

	u32 gameEndTime = this.get_u32("game_end_time");
	u32 currentTime = getGameTime();

	if (gameEndTime > 0 && gameEndTime > currentTime)
	{
		s32 timeToEnd = s32(gameEndTime - currentTime) / 30;

		s32 secondsToEnd = timeToEnd % 60;
		s32 MinutesToEnd = timeToEnd / 60;
		drawRulesFont("Time left: " + ((MinutesToEnd < 10) ? "0" + MinutesToEnd : "" + MinutesToEnd) + ":" + ((secondsToEnd < 10) ? "0" + secondsToEnd : "" + secondsToEnd),
		              SColor(255, 255, 255, 255), Vec2f(10, 140), Vec2f(getScreenWidth() - 20, 180), true, false);
	}
}

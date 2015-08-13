#define CLIENT_ONLY

f32 zoomTarget = 1.0f;
int ticksToScroll = 0;

bool justClicked = false;
CPlayer@ targetPlayer;

void Spectator(CRules@ this)
{
	//setup initial variables
	CCamera@ camera = getCamera();
	CControls@ controls = getControls();

	if (camera is null || controls is null)
		return;

	//Zoom in and out using mouse wheel
	if (ticksToScroll <= 0)
	{
		if (controls.mouseScrollUp)
		{
			ticksToScroll = 7;
			if (zoomTarget < 1.0f)
				zoomTarget = 1.0f;
			else
				zoomTarget = 2.0f;

		}
		else if (controls.mouseScrollDown)
		{
			ticksToScroll = 7;
			if (zoomTarget > 1.0f)
				zoomTarget = 1.0f;
			else
				zoomTarget = 0.5f;

		}

	}
	else
	{
		ticksToScroll--;
	}

	Vec2f pos = camera.getPosition();

	if (Maths::Abs(camera.targetDistance - zoomTarget) > 0.001f)
	{
		camera.targetDistance = (camera.targetDistance * 3 + zoomTarget) / 4;
	}
	else
	{
		camera.targetDistance = zoomTarget;
	}

	f32 camSpeed = 15.0f / zoomTarget;

	//Move the camera using the action movement keys
	if (controls.ActionKeyPressed(AK_MOVE_LEFT))
	{
		pos.x -= camSpeed;
		@targetPlayer = null;
	}
	if (controls.ActionKeyPressed(AK_MOVE_RIGHT))
	{
		pos.x += camSpeed;
		@targetPlayer = null;
	}
	if (controls.ActionKeyPressed(AK_MOVE_UP))
	{
		pos.y -= camSpeed;
		@targetPlayer = null;
	}
	if (controls.ActionKeyPressed(AK_MOVE_DOWN))
	{
		pos.y += camSpeed;
		@targetPlayer = null;
	}

	//Click on players to track them or set camera to mousePos
	Vec2f mousePos = controls.getMouseWorldPos();
	if (controls.isKeyJustPressed(KEY_LBUTTON))
	{
		CBlob@[] players;
		@targetPlayer = null;
		getBlobsByTag("player", @players);
		for (uint i = 0; i < players.length; i++)
		{
			CBlob@ blob = players[i];
			Vec2f bpos = blob.getPosition();
			if (blob.getName() == "migrant") // screw migrants
				continue;

			if (Maths::Pow(mousePos.x - bpos.x, 2) + Maths::Pow(mousePos.y - bpos.y, 2) <= Maths::Pow(blob.getRadius() * 2, 2) && camera.getTarget() !is blob)
			{
				//print("set player to track: " + (blob.getPlayer() is null ? "null" : blob.getPlayer().getUsername()));
				@targetPlayer = blob.getPlayer();
				camera.setTarget(blob);
				camera.setPosition(blob.getPosition());
				return;
			}
		}
	}
	else if (controls.isKeyPressed(KEY_LBUTTON) && camera.getTarget() is null) //classic-like held mouse moving
	{
		pos += (mousePos - pos) / 8;
	}

	if (targetPlayer !is null)
	{
		if (camera.getTarget() !is targetPlayer.getBlob())
		{
			camera.setTarget(targetPlayer.getBlob());
		}
	}
	else
	{
		camera.setTarget(null);
	}

	if (camera.getTarget() !is null) // mystery code
	{
		camera.mousecamstyle = 1;
		camera.mouseFactor = 0.5f;
		return;
	}

	//Don't go to far off the map boundaries
	CMap@ map = getMap();
	if (map !is null)
	{
		f32 borderMarginX = map.tilesize * 2 / zoomTarget;
		f32 borderMarginY = map.tilesize * 2 / zoomTarget;

		if (pos.x < borderMarginX)
		{
			pos.x = borderMarginX;
		}
		if (pos.y < borderMarginY)
		{
			pos.y = borderMarginY;
		}
		if (pos.x > map.tilesize * map.tilemapwidth - borderMarginX)
		{
			pos.x = map.tilesize * map.tilemapwidth - borderMarginX;
		}
		if (pos.y > map.tilesize * map.tilemapheight - borderMarginY)
		{
			pos.y = map.tilesize * map.tilemapheight - borderMarginY;
		}
	}

	camera.setPosition(pos);

}

#include "Default/DefaultGUI.as"
#include "Default/DefaultLoaders.as"

void onInit(CRules@ this)
{
	LoadDefaultMapLoaders();
	LoadDefaultGUI();

	sv_gravity = 9.81f;
	particles_gravity.y = 0.25f;
	v_camera_ints = true;
	sv_visiblity_scale = 1.25f;
	cc_halign = 2;
	cc_valign = 2;

	s_effects = false;

	sv_max_localplayers = 1;

	//smooth shader
	Driver@ driver = getDriver();

	driver.AddShader("hq2x", 1.0f);
	driver.SetShader("hq2x", true);
}
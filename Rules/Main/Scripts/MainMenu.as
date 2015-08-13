#define ALWAYS_ONRELOAD
#include "MainMenuCommon.as"
#include "Login.as"

void onInit(CRules@ this)
{
	printf("onInit");
	setGameState( GameState::game );
	Engine::ShowLoginWindow();
	onReload(this);
}

void onReload(CRules@ this)
{
	printf("onReload");
	//_backCallback( null, null );
	
	UI::Group@ g = UI::AddGroup("titlescreen", Vec2f(0,0), Vec2f(1.0,1.0));
	g.proxy.renderFunc = RenderTitleBackgound;
}

void onShowMenu(CRules@ this)
{
	printf("onShowMenu ");
	_backCallback( null, null );
}

void OnCloseMenu(CRules@ this)
{
	printf("OnCloseMenu");
	_backCallback( null, null );
	// if (!Engine::isAuthenticated()){ 
	// 	Engine::ShowLoginWindow(); 
	// }
}

void OnAuthenticationFail(CRules@ this)
{
	print("AUTH FAILED");
}

void OnAuthenticationSuccess(CRules@ this )
{
	print("AUTH SUCCESS");
	_backCallback( null, null );
}

void OnOffline(CRules@ this)
{
	print("AUTH OFFLINE");
	_backCallback( null, null );
}                                                             
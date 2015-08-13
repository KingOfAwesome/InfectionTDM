// #include "UI.as"
// #include "UILabel.as"
// #include "UIButton.as"
// #include "UICommonUpdates.as"

// int _dialogCount = 0;

// namespace UI
// {
// 	namespace Dialog
// 	{
// 		Control@ Add( const string &in caption )
// 	    {
// 	    	Data@ data = UI::getData();

// 	   		// save current selection
// 	   		Group@ oldGroup = data.activeGroup;

// 	    	Group@ group = UI::AddGroup("dialog#"+_dialogCount++, Vec2f(0.3f,0.45), Vec2f(0.7,0.55));
// 	    	group.modal = true;
// 			UI::Grid( 1, 2 );
// 			Control@ control = UI::Label::Add( caption, 2.0f );
// 			Control@ ok = UI::Button::Add( "OK", Select, "", 2.0f );
// 			@control.proxy = AddProxy( data, RenderBackground, NoTransitionUpdate, group, ok, 1.0f );

// 	    	ok.vars.set( "activeGroup", oldGroup );

// 	    	UI::SetSelection(-1);

// 	   		return ok;
// 	    }

// 		void Select( UI::Group@ group, UI::Control@ control )
// 		{
// 			Group@ oldGroup;
// 			control.vars.get( "activeGroup", @oldGroup );
// 			UI::Clear( group.name );
// 			@group.data.activeGroup = UI::getGroup( group.data, oldGroup.name ); // we get by name because somehow pointer changes (Angelscript WTF!?)
// 		}

// 		void RenderBackground( Proxy@ proxy )
// 		{
// 			GUI::DrawRectangle( Vec2f_zero, proxy.data.screenSize, color_black );
// 		}
// 	}
// }
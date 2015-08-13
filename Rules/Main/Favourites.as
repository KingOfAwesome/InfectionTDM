
bool isFavourite(APIServer@ s){
	Favourites::doInit();
	
	return Favourites::favourites.exists(s.serverIPv4Address+" "+s.serverIPv6Address+" "+s.serverPort);
}

void setFavourite(APIServer@ s, bool value){
	Favourites::doInit();

	string key = s.serverIPv4Address+" "+s.serverIPv6Address+" "+s.serverPort;
	if (value) {
		Favourites::favourites.set(key, uint8(0));
	} else {
		Favourites::favourites.delete(key);
	}

	ConfigFile cfg;
	cfg.addArray_string("favourites", Favourites::favourites.getKeys());
	cfg.saveFile("Favourites.cfg");
}

bool toggleFavourite(APIServer@ s){
	bool value = !isFavourite(s);
	setFavourite(s, value);
	return value;
}

namespace Favourites
{
	bool init = false;
	dictionary favourites;

	void doInit(){
		if (init) return;

		string[] strings;
		ConfigFile cfg;

		if (!cfg.loadFile("../Cache/Favourites.cfg")) {
			cfg.addArray_string("favourites", strings);
			cfg.saveFile("Favourites.cfg");
		}

		if(!cfg.readIntoArray_string(strings, "favourites")){ //borked file?
			cfg.addArray_string("favourites", strings);
			cfg.saveFile("Favourites.cfg");
		}

		for (int i = 0; i < strings.length; ++i)
		{
			favourites.set(strings[i], uint8(0));
			// print(strings[i]);
		}

		init = true;
	}
}
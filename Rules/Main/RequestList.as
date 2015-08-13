
funcdef void CALLBACK();

void onTick( CRules@ this )
{
	CScriptedBrowser@ b = getBrowser();
	APIServer@[] servers;
	b.getServersList(servers);

	if (servers.length == 0) return;

	CALLBACK@ cb;
	this.get("OnRequestList", @cb);
	cb();
	this.RemoveScript("RequestList");
}

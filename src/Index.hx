import haxe.web.Dispatch;
import neko.Web.*;

class Index
{
	static var init = false;
	static var serverData:ServerData;
	static var api:Dispatchers.ApiDispatch;
	
	public static function main():Void
	{
		cacheModule(main);
		
		if(!init)
			setup();
		
		var uri = getURI().substring("/repo".length);
		
		try
		{
			Dispatch.run(uri, getParams(), api);
		}
		catch(ex:Dynamic)
		{
			neko.Lib.println("Invalid url");
		}
	}
	
	public static function setup():Void
	{
		init = true;
		serverData = new ServerData();
		api = new Dispatchers.ApiDispatch();
	}
}
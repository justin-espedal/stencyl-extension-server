import thx.semver.Version;
import thx.semver.Version.*;

class Json
{
	static function replacer(key:Dynamic, value:Dynamic):Dynamic
	{
		if(key == "number")
		{
			return (value : Version).toString();
		}
		
		if(key == "requires")
		{
			return (value : Version.StencylVersion).toString();
		}
		
		return value;
	}

	public static function stringify(obj:Dynamic):String
	{
		return haxe.Json.stringify(obj, replacer);
	}
	
	public static function parse(s:String):Dynamic
	{
		return haxe.Json.parse(s);
	}
}
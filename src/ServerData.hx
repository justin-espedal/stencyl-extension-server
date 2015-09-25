import neko.Lib.*;
import sys.io.File;

class ServerData
{
	public static var contentDir = "/home/justin/extension-repo/content";
	
	public static var apiVersions = { "versions": ["v1"] };
	
	public static var engineExtensionList:Array<String> = Json.parse(File.getContent(contentDir + "/engine/extensions")).extensions;
	public static var toolsetExtensionList:Array<String> = Json.parse(File.getContent(contentDir + "/toolset/extensions")).extensions;
	
	public static var engineExtensions = new Map<String, Extension>();
	public static var toolsetExtensions = new Map<String, Extension>();
	
	public function new()
	{
		//println("REBUILDING<br>");
		
		for(ext in engineExtensionList)
		{
			engineExtensions.set(ext, createExtension("engine", ext));
		}
		for(ext in toolsetExtensionList)
		{
			toolsetExtensions.set(ext, createExtension("toolset", ext));
		}
	}
	
	static function createVersion(v:Dynamic):Version
	{
		return new Version(v.version, v.changes, v.requires);
	}
	
	public static function createExtension(type:String, name:String):Extension
	{
		var e:Extension = new Extension(type, name);
		e.versions = Json.parse(File.getContent(contentDir + '/$type/$name/versions')).versions.map(createVersion);
		return e;
	}
	
	public static function getExtension(type:String, name:String):Extension
	{
		switch(type)
		{
			case "engine":
				return engineExtensions.get(name);
			case "toolset":
				return toolsetExtensions.get(name);
		}
		
		return null;
	}
	
	public static function getExtensions(type:String):Array<String>
	{
		switch(type)
		{
			case "engine":
				return engineExtensionList;
			case "toolset":
				return toolsetExtensionList;
		}
		
		return [];
	}
}
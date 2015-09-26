import cmd.Cmd;
import cmd.Cmd.*;

import haxe.web.Dispatch;
import neko.Lib.*;

import Version.StencylVersion;

import Json.*;

class ApiDispatch
{
	var versionDispatch:VersionDispatch;
	
	public function new()
	{
		versionDispatch = new VersionDispatch();
	}
	
	function doDefault(msg:String)
	{
		println("mod_neko<br>");
	}
	
	function doAccess()
	{
		var obj = ServerData.apiVersions;
		println(stringify(obj));
	}
	
	function doV1(d:Dispatch)
	{
		d.dispatch(versionDispatch);
	}
}

class VersionDispatch
{
	var extensionTypeDispatch:ExtensionTypeDispatch;
	
	public function new()
	{
		extensionTypeDispatch = new ExtensionTypeDispatch();
	}
	
	function doEngine(d:Dispatch)
	{
		extensionTypeDispatch.type = "engine";
		d.dispatch(extensionTypeDispatch);
	}
	
	function doToolset(d:Dispatch)
	{
		extensionTypeDispatch.type = "toolset";
		d.dispatch(extensionTypeDispatch);
	}
}

class ExtensionTypeDispatch
{
	public var type:String = "";
	
	var extensionDispatch:ExtensionDispatch;
	
	public function new()
	{
		extensionDispatch = new ExtensionDispatch();
	}
	
	function doDefault(extensionID:String, d:Dispatch)
	{
		extensionDispatch.extension = {"type":type, "name":extensionID};
		d.dispatch(extensionDispatch);
	}
	
	function doList()
	{
		Stencylrm.listExtensions(["toolset", "-json"]);
		//cmd("srm", ["list", type, "-json"]);
		//var obj = { "extensions": ServerData.getExtensions(type) };
		//println(stringify(obj));
	}
}

class ExtensionDispatch
{
	public var extension:Extension;
	public var versionListDispatch:VersionListDispatch;
	
	public function new()
	{
		versionListDispatch = new VersionListDispatch();
	}
	
	function doLatest(withStencylVersion:String)
	{
		Stencylrm.listVersions([extension.type, extension.name, "-l", "-json"]);
		/*
		var latest = null;
		var stencylVersion:StencylVersion = withStencylVersion;
		
		for(version in extension.versions)
		{
			if((version.requires:Int) > (stencylVersion:Int))
				break;
			
			latest = version;
		}
		
		println(stringify(latest));
		*/
	}
	
	function doVersions(d:Dispatch)
	{
		versionListDispatch.extension = extension;
		d.dispatch(versionListDispatch);
	}
	
	function doGet(version:String)
	{
		neko.Web.redirect('http://www.polydes.com/get/${extension.type}/${extension.name}/$version.zip');
	}
}

class VersionListDispatch
{
	public var extension:Extension;
	
	public function new()
	{
		
	}
	
	function doDefault()
	{
		Stencylrm.listVersions([extension.type, extension.name, "-json"]);
		//var obj = { "versions": extension.versions };
		//println(stringify(obj));
	}
	
	function doFrom(fromVersion:String)
	{
		Stencylrm.listVersions([extension.type, extension.name, "-f", fromVersion, "-json"]);
		/*
		var latest = null;
		var list = [];
		var fromSem:thx.semver.Version = fromVersion;
		
		for(version in extension.versions)
		{
			if(version.number <= fromVersion)
				continue;
			
			list.push(version);
		}
		
		var obj = { "versions": list };
		println(stringify(obj));
		*/
	}
}

/*
Have a "repository" string in attributes. ExtensionManager can send it data to check if an update is available.

Extension-Repo: http://some-site.com/stencyl-extensions/

/access/
/{api version}/{extension type}/list/ -> see extensions for type
/{api version}/{extension type}/{id}/latest/{stencyl-version} -> get info for latest version of extension
/{api version}/{extension type}/{id}/versions/ -> get info for all versions of extension
/{api version}/{extension type}/{id}/versions/from/{version}
/{api version}/{extension type}/{id}/get/xxx.zip
/get/type/id/v.zip
*/

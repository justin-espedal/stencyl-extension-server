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
		Stencylrm.listExtensions([type, "-json"]);
	}
}

class ExtensionDispatch
{
	public var extension:Extension;
	
	public function new()
	{
	}
	
	function doVersions(args:{stencyl:Null<String>, dep:Null<String>, latest:Null<Bool>, format:Null<String>, from:Null<String>})
	{
		var passArgs = [extension.type, extension.name];
		if(args.stencyl != null)
		{
			passArgs.push("-s");
			passArgs.push(args.stencyl);
		}
		if(args.dep != null)
		{
			passArgs.push("-d");
			passArgs.push(args.dep);
		}
		if(args.latest != null && args.latest)
			passArgs.push("-l");
		if(args.format != null)
			passArgs.push('-${args.format}');
		if(args.from != null)
		{
			passArgs.push("-f");
			passArgs.push(args.from);
		}
		Stencylrm.listVersions(passArgs);
	}
	
	function doGet(object:String)
	{
		var realPath = Stencylrm.getPathString(extension.type, extension.name, object);
		var redirectPrefix = 'http://www.polydes.com/get/';
		var redirectPath = redirectPrefix + realPath.substring(realPath.indexOf(extension.type));
		neko.Web.redirect(redirectPath);
		//'http://www.polydes.com/get/${extension.type}/${extension.name}/$version.zip';
	}
}

/*
/access/
/{api version}/{extension type}/list/ -> see extensions for type
/{api version}/{extension type}/{id}/versions?latest=true&format=json&stencyl={b8670} -> get info for latest version of extension
/{api version}/{extension type}/{id}/versions?format=json -> get info for all versions of extension
/{api version}/{extension type}/{id}/versions?format=json&from={1.6.0}
/{api version}/{extension type}/{id}/get/{1.0.0}
*/

class Version
{
	public function new(number:String, changes:String, requires:String)
	{
		//trace('$number, $changes, $requires<br>');
		
		this.number = number;
		this.changes = changes;
		this.requires = requires;
	}
	
	public var number:thx.semver.Version;
	public var changes:String;
	public var requires:StencylVersion;
}

abstract StencylVersion(Int) from Int to Int
{
	public inline function new(i:Int)
	{
		this = i;
	}

	@:from
	static public function fromString(s:String)
	{
		return new StencylVersion(Std.parseInt(s.substring(1)));
	}

	@:to
	public function toString()
	{
		return "b" + (this:Int);
	}
}
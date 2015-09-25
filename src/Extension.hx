class Extension
{
	public var type:String;
	public var name:String;
	public var versions:Array<Version>;
	
	public function new(type:String, name:String)
	{
		this.type = type;
		this.name = name;
	}
}
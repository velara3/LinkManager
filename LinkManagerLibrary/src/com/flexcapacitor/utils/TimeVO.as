package com.flexcapacitor.utils
{
	public class TimeVO
	{
		// we use String for the properties
		// the sole purpose for this decision is to allow us to 
		// display and bind to text fields and so we can use leading zeros
		public var time:String = "";
		public var hours:int = 0;
		public var minutes:int = 0;
		public var seconds:int = 0;
		public var milliseconds:int = 0;
		public var ampm:String = "";
		public var militaryTime:Boolean = false;
		public var date:Date = new Date();
		
		public function TimeVO()
		{
			//TODO: implement function
			date = new Date();
		}

	}
}
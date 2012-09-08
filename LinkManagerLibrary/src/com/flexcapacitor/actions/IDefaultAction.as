









package com.flexcapacitor.actions {
	
	
	public interface IDefaultAction {
		
		// determines where this action is run,
		// before user actions, after user actions or never
		function set occurs(value:String):void;
		function get occurs():String;
			
	}
}
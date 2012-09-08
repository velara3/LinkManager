/**
 * A class that calls a function a specified number of seconds later. 
 * 
 * This class should use another class that extends the Timer class with the params it needs or
 * it should dispatch a custom event that has the properties we need on it. 
 * 
 * This class doesnt support repeatCount of the Timer class. 
 * 
 * */

package com.flexcapacitor.utils
{
	import flash.utils.Timer;
	import mx.collections.ArrayCollection;
	import flash.events.TimerEvent;
	import flash.events.Event;

	public class CallLater
	{
		
		private static var instance:CallLater;
		private static var created:Boolean;
		public var time:int = 1000;
		public var frames:int = 0;
		private var _array:Array = new Array();
		public var timers:ArrayCollection = new ArrayCollection(_array);
		
		/**
		 * Constructor - Singleton
		 */
		public function CallLater()
		{
			if ( !created )
			{
				throw new Error("CallLater Class cannot be instantiated");
			}
		}
		
		/**
		 * Returns the one single instance of this class
		 */
		public static function getInstance():CallLater
		{
			if (instance == null)
			{
				created = true;
				instance = new CallLater();
				created = false;
			}
			
			return instance;
		}
		
		public static function call(functionName:Function, milliseconds:int = 500, repeatCount:int = 0, ...args):void {
			var cl:CallLater = getInstance();
			var newTimer:Timer = new Timer(milliseconds, repeatCount);
			newTimer.delay = milliseconds;
			newTimer.repeatCount = repeatCount;
	        newTimer.addEventListener(TimerEvent.TIMER_COMPLETE, cl.timerComplete);
	        newTimer.addEventListener(TimerEvent.TIMER, cl.timerComplete);
	  		cl.timers.addItem({timer:newTimer,functionName:functionName,milliseconds:milliseconds,args:args});
	  		newTimer.start();
	  		newTimer.repeatCount = cl.timers.length - 1;
			
		}
		
		// todo: implement callLaterTimer
		public static function callLater(functionName:Function, milliseconds:int = 500, ...args):void {
			var cl:CallLater = getInstance();
			var newTimer:Timer = new Timer(milliseconds, 0);
			newTimer.delay = milliseconds;
			newTimer.repeatCount = 0;
	        newTimer.addEventListener(TimerEvent.TIMER_COMPLETE, cl.timerComplete);
	        newTimer.addEventListener(TimerEvent.TIMER, cl.timerComplete);
	  		cl.timers.addItem({timer:newTimer,functionName:functionName,milliseconds:milliseconds,args:args});
	  		newTimer.start();
			newTimer.repeatCount = cl.timers.length - 1;
			
		}
		
		public function timerComplete(event:TimerEvent):void {
			//trace("timer complete");
			var timer:Timer = event.currentTarget as Timer;
			var timerObj:Object = timers.getItemAt(timer.repeatCount);
			timer.stop();
			if (timerObj.args.length > 0) { 
				timerObj.functionName(timerObj.args);
			}
			else {
				timerObj.functionName();
			}
		}
	}
}

import flash.utils.Timer;	

internal class CallLaterTimer {
	public var timer:Timer;
	public var delay:int;
	public var repeatCount:int;
	public var functionName:Function;
	public var args:Array;
	
	public function CallLaterTimer(milliseconds:int):void {
		timer = new Timer(milliseconds);
	}
}
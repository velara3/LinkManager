




package com.flexcapacitor.actions {
	
	import com.flexcapacitor.utils.ClassUtils;
	
	import mx.core.UIComponent;
	
	
	/** 
	 *  
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="callFunction", type="flash.events.Event")]

	public class Trace extends Action {
		
		public function Trace(message:String = "") {
			super();
		}
		
		private var _target:Object;
		
		[Inspectable(category="General")]
		/**
		 *  Component with text property. Optional.
		 */
		public function set target(object:Object):void {
			_target = object;
		}
		
		/**
		 *  @private
		 */
		public function get target():Object {
			return _target;
		}

		private var _message:String = "";
		
		[Inspectable(category="General")]
		/**
		 *  Component with text property. Optional.
		 */
		public function set message(value:String):void {
			_message = value;
		}
		
		/**
		 *  @private
		 */
		public function get message():String {
			return _message;
		}
	    
	    override public function apply(parent:UIComponent = null):void{
	        
	        if (target!=null && target.hasOwnProperty("text")) {
	        	target.text += ClassUtils.staticInstance.getClassName(this) + ": " + message + "\n";
	        }
	        else {
	        	trace(ClassUtils.staticInstance.getClassName(this) + ": " + message);
	        }
		}

	}
}
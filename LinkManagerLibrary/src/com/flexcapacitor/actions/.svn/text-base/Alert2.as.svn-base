




package com.flexcapacitor.actions {
	
	import flash.display.Sprite;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	
	
	/** 
	 *  
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="callFunction", type="flash.events.Event")]
	
	public class Alert2 extends Interaction {
		
		public function Alert2(message:String = "") {
			super();
		}
		
		private var _target:Object;
		
		[Inspectable(category="General")]
		/**
		 *  Component to show Alert over. Optional.
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
		 *  Message to display. Optional.
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
		
		private var _title:String = "";
		
		/**
		 *  Title to display. Optional.
		 */
		[Inspectable(category="General")]
		public function set title(value:String):void {
			_title = value;
		}
		
		/**
		 *  @private
		 */
		public function get title():String {
			return _title;
		}
		
		/**
		 * Shows an alert with the message provided
		 * */
		override public function apply(parent:UIComponent = null):void{
			
			
			// NOTE! this is not allowing more than one alert
			if (target!=null) {
				//target.text += ClassUtils.staticInstance.getClassName(this) + ": " + message + "\n";
				mx.controls.Alert.show(message, title, 4, Sprite(target));
			}
			else {
				//trace(ClassUtils.staticInstance.getClassName(this) + ": " + message);
				mx.controls.Alert.show(message, title, 4, Sprite(application));
			}
		}
		
	}
}
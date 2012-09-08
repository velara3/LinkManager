




package com.flexcapacitor.actions {
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.core.UIComponent;
	
	
	/** 
	 *  
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="callFunction", type="flash.events.Event")]
	
	public class Show extends Action {
		
		public var request:URLRequest = new URLRequest();
		
		public function Show() {
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
		
		private var _includeInLayout:Boolean = true;
		
		public function get includeInLayout():Boolean {
			return _includeInLayout;
		}
		
		public function set includeInLayout(value:Boolean):void {
			_includeInLayout = value;
		}

		
		override public function apply(parent:UIComponent = null):void {
			
			if (target!=null && target.hasOwnProperty("visible")) {
				if (includeInLayout && target.hasOwnProperty("includeInLayout")) {
					target.includeInLayout = true;
				}
				target.visible = true;
				
			}
			
		}
		
	}
}





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
	
	public class Hide extends Action {
		
		public var request:URLRequest = new URLRequest();
		
		public function Hide() {
			super();
		}
		
		private var _target:Object;
		
		[Inspectable(category="General")]
		/**
		 *  Component with text property. Optional.
		 */
		[Bindable]
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
		
		private var _remove:Boolean = false;

		public function get remove():Boolean {
			return _remove;
		}

		public function set remove(value:Boolean):void {
			_remove = value;
		}
		
		
		override public function apply(parent:UIComponent = null):void {
			
			if (target!=null && target.hasOwnProperty("visible")) {
				if (!includeInLayout && target.hasOwnProperty("includeInLayout")) {
					target.includeInLayout = false;
				}
				target.visible = false;
				
				if (target.hasOwnProperty("parent") && remove) {
					Object(target).parent.removeChild(target);
				}
			}
			
		}
		
	}
}
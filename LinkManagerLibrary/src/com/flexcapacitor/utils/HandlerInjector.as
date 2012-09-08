


/**
 * Adds event handlers en masse. 
 * */
package com.flexcapacitor.utils {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	import mx.core.MXMLObjectAdapter;
	import mx.events.FlexEvent;

	public class HandlerInjector extends MXMLObjectAdapter {


		public function HandlerInjector() {

		}
		
		[ArrayElementType("flash.display.DisplayObject")]
		private var _targets:Array;
		
		public function get targets():Array {
			return _targets;
		}
		
		public function set targets(value:Array):void {
			_targets = value;
			addHandlers();
		}
		
		private var _event:String;
		
		public function get event():String {
			return _event;
		}
		
		public function set event(value:String):void {
			_event = value;
			_events = new Array(value);
			addHandlers();
		}
		
		private var _target:DisplayObject;
		
		public function get target():DisplayObject {
			return _target;
		}
		
		public function set target(value:DisplayObject):void {
			_target = value;
			_targets = new Array(value);
			addHandlers();
		}
		
		[ArrayElementType("String")]
		private var _events:Array;
		
		public function get events():Array {
			return _events;
		}
		
		public function set events(value:Array):void {
			_events = value;
			addHandlers();
		}

		override public function initialized(document:Object, id:String):void {
			addHandlers();
		}
		
		/**
		 * Adds handlers to the targets
		 * Note: Adding an event listener more than once does not add another handler
		 * */
		private function addHandlers():void {
			
			for each (var target:DisplayObject in _targets) {
				
				for each (var text:String in events) {
					trace("adding " + text + " handler to " + Object(target).id);
					target.addEventListener(text, _handler, false, 0, true);
				}
			} 
		}
		
		/**
		 * Handler to handle the event specified
		 * */
		private var _handler:Function;
		public function set handler(value:Function):void {
			_handler = value;
		}
		public function get handler():Function {
			return _handler;
		}
	}
}
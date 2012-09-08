




package com.flexcapacitor.proxy {
	import com.flexcapacitor.managers.LinkManager;
	import com.flexcapacitor.vo.LinkInfo;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;
	import mx.utils.URLUtil;

	use namespace flash_proxy;
	
	[Bindable("propertyChange")]
	dynamic public class ParametersProxy extends Proxy implements IEventDispatcher {
		protected var strings:Object;
		protected var eventDispatcher:EventDispatcher;
		public var linkManager:LinkManager;

		public function ParametersProxy() {
			strings = {};
			eventDispatcher = new EventDispatcher(this);
		}
		
		flash_proxy override function getProperty(name:*):* {
			linkManager = LinkManager.getInstance();

			if (strings.hasOwnProperty(name)) {
				return strings[name];
			}
			
			return linkManager.defaultProxyValue;
		}
		
		flash_proxy override function setProperty(name:*, value:*):void {
			var oldValue:* = strings[name];
			strings[name] = value;
			var kind:String = PropertyChangeEventKind.UPDATE;
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false, kind, name, oldValue, value, this));
		}
		
		flash_proxy override function callProperty(method:*, ...args):* {
			return;
		}
		
		// we call this to dispatch change events to any bindings
		public function update(parametersObject:Object = null):void {
			linkManager = LinkManager.getInstance();
			var fragment:String;
			var linkInfo:LinkInfo;
			
			if (parametersObject==null) {
				fragment = linkManager.getFragment();
				linkInfo = linkManager.getLinkInfo(fragment);
				parametersObject = linkInfo.parametersObject;
			}
			
			// erase unused properties
			for (var property:String in strings) {
				if (parametersObject.hasOwnProperty(property)) {
					continue;
				}
				else {
					this[property] = "";
				}
			}
			
			// set new properties
			for (var parameterName:String in parametersObject) {
				if (parameterName!=null) {
					this[parameterName] = parametersObject[parameterName];
				}
			}
			
		}

		public function hasEventListener(type:String):Boolean {
			return eventDispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean {
			return eventDispatcher.willTrigger(type);
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0.0, useWeakReference:Boolean=false):void {
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean {
			return eventDispatcher.dispatchEvent(event);
		}
	}
}



/*

EXAMPLE OF DYNAMIC BINDABLE PROPERTY CLASS


package com.flexcapacitor.proxy {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;
	use namespace flash_proxy;
	
	[Bindable("propertyChange")]
	dynamic public class ParametersProxy extends Proxy implements IEventDispatcher {
		protected var strings:Object;
		protected var eventDispatcher:EventDispatcher;
		
		public function ParametersProxy() {
			strings = {};
			eventDispatcher = new EventDispatcher(this);
		}
		
		flash_proxy override function getProperty(name:*):* {
			return strings[name] || name;
		}
		
		flash_proxy override function setProperty(name:*, value:*):void {
			var oldValue:* = strings[name];
			strings[name] = value;
			var kind:String = PropertyChangeEventKind.UPDATE;
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false, kind, name, oldValue, value, this));
		}
		
		public function hasEventListener(type:String):Boolean {
			return eventDispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean {
			return eventDispatcher.willTrigger(type);
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0.0, useWeakReference:Boolean=false):void {
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean {
			return eventDispatcher.dispatchEvent(event);
		}
	}
}*/
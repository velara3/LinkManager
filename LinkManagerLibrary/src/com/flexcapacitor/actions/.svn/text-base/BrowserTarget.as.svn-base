




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
	
	public class BrowserTarget extends Action {
		
		public var request:URLRequest = new URLRequest();
		
		public function BrowserTarget(url:String = "") {
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
		
		private var _url:String = "";
		
		[Inspectable(category="General")]
		/**
		 *  Component with text property. Optional.
		 */
		public function set url(value:String):void {
			_url = value;
		}
		
		/**
		 *  @private
		 */
		public function get url():String {
			return _url;
		}
		
		override public function apply(parent:UIComponent = null):void{
			var hyperlink:String = linkInfo.hyperlink;
			var target:String = linkInfo.hyperlinkTarget;
			
			if (target==linkManager.BROWSER_HYPERLINK) {
				request = new URLRequest(hyperlink);
				navigateToURL(request);
				handler.exitActions = true;
			}
			
		}
		
	}
}
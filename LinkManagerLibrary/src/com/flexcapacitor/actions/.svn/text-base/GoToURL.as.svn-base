




package com.flexcapacitor.actions {
		
	import com.flexcapacitor.managers.LinkManager;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.core.UIComponent;
	
	
	/** 
	 *  
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="callFunction", type="flash.events.Event")]
	
	public class GoToURL extends Action {
		
		public var request:URLRequest = new URLRequest();

		public function GoToURL(url:String = "") {
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
		
		override public function apply(parent:UIComponent = null):void {
			var hyperlink:String = linkInfo.hyperlink;
			var hyperlinkTarget:String = linkInfo.hyperlinkTarget;
			var linkManager:LinkManager = LinkManager.getInstance();
			
			if (hyperlink.indexOf("http://")!=-1 || hyperlink.indexOf("https://")!=-1 ) {
				
				if (hyperlinkTarget=="" ||
					hyperlinkTarget==linkManager.SELF_HYPERLINK ||
					hyperlinkTarget==linkManager.BLANK_HYPERLINK) {
					request = new URLRequest(hyperlink);
					navigateToURL(request, hyperlinkTarget);
					handler.exitActions = true;
				}
				else if (hyperlinkTarget.indexOf("browser:")==0) {
					var windowName:String = hyperlinkTarget;
					request = new URLRequest(hyperlink);
					navigateToURL(request, hyperlinkTarget);
					handler.exitActions = true;
				}
			}

		}
		
	}
}
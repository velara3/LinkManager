




package com.flexcapacitor.actions {
	
	import com.flexcapacitor.utils.ClassUtils;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.core.UIComponent;
	
	
	/** 
	 *  
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="callFunction", type="flash.events.Event")]
	
	public class DownloadTarget extends Action {
		
		public var request:URLRequest; 

		public function DownloadTarget(message:String = "") {
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
		
		
		override public function apply(parent:UIComponent = null):void{
			
			if (linkInfo.hyperlinkTarget==linkManager.DOWNLOAD_HYPERLINK) {
				request = new URLRequest(linkInfo.hyperlink);
				if (linkManager.useBrowserDownloadDialog) {
					navigateToURL(request);
				}
				else {
					try {
						linkManager.fileReference.download(request);
					}
					catch (event:Event) {
						trace("Link Manager: Download Target - Couldn't download the file." + event.toString());
					}
				}
				
				handler.exitActions = true;
				
			}
		}
	}
}





package com.flexcapacitor.actions {
	
	import com.flexcapacitor.managers.AnchorManager;
	import com.flexcapacitor.managers.LinkManager;
	import com.flexcapacitor.utils.ArrayUtils;
	import com.flexcapacitor.vo.HistoryInfo;
	import com.flexcapacitor.vo.LinkInfo;
	
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.utils.ArrayUtil;
	
	/** 
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="callFunction", type="flash.events.Event")]
	
	public class ScrollToPosition extends Action implements IDefaultAction {
		
		
		public function ScrollToPosition() {
			
		}
		
		private var _value:String;
		
		[Inspectable(category="General")]
		public function set value(value:String):void {
			// if it's an object convert it to a string
			_value = value as String;
		}
		
		/**
		 *  @private
		 */
		public function get value():String {
			return _value;
		}
		
		public var currentFrameIndex:int = 0;
		
		// how many frames to apply the scroll to position for. default is 5
		public var applyDurationInFrames:int = 5;
		
		// current vertical scroll bar position
		public var verticalScrollBarPosition:int = 0;
		
		public var anchorManager:AnchorManager = AnchorManager.getInstance();
		
		override public function apply(parent:UIComponent = null):void {
			anchorManager = AnchorManager.getInstance();
			linkManager = LinkManager.getInstance();
			
			anchorManager.useBrowserScrollBars = linkManager.useBrowserScrollbars;
			
			if (linkManager.contentLoadingItems.length>0) {
				
				// we always scroll to the top before going to an anchor
				// for now dont scroll to top when using browser scroll bars
				// we may have to do that before state or url fragment change
				if (handler.scrollToTop && !anchorManager.useBrowserScrollBars) {
					anchorManager.scrollToTop();
				}
				
				linkManager.addEventListener(linkManager.CONTENT_UPDATE_COMPLETE, contentUpdateComplete, false, 0, true);
			}
			else {
				contentUpdateComplete();
			}
		}
		
		public function contentUpdateComplete(event:Event = null):void {
			anchorManager = AnchorManager.getInstance();
			linkManager = LinkManager.getInstance();
			
			anchorManager.useBrowserScrollBars = linkManager.useBrowserScrollbars;
			
			currentFrameIndex = 0;
			
			// scroll to anchor
			if (linkInfo.hasAnchor && !linkInfo.browserURLChangeEvent) {
				// scroll to an anchor or id or vertical position
				//anchorManager.scrollToAnchor(linkInfo.anchorName);
				// this is ugly - 
				//setTimeout(anchorManager.scrollToAnchor, 100, linkInfo.anchorName);
				setTimeout(anchorManager.scrollToAnchor, 1000, linkInfo.anchorName);
				//setTimeout(anchorManager.scrollToAnchor, 2000, linkInfo.anchorName);
				setTimeout(anchorManager.scrollToAnchor, 3000, linkInfo.anchorName);
				setTimeout(anchorManager.scrollToAnchor, 3300, linkInfo.anchorName);
			}
			
			// restore the previous vertical position
			//else if (linkInfo.browserURLChangeEvent) {
			else {
				
				// we always scroll to the top before going to an anchor
				if (handler.scrollToTop && !anchorManager.useBrowserScrollBars) {
					anchorManager.scrollToTop();
				}
				
				if (linkInfo.determinedFragment=="") {
					linkInfo.determinedFragment = linkManager.determineFragment(linkInfo);
				}
				
				var itemIndex:int = ArrayUtils.getItemIndexByProperty(linkManager.history, "fragment", linkInfo.determinedFragment);
				
				if (itemIndex!=-1) {
					var item:HistoryInfo = HistoryInfo(linkManager.history.getItemAt(itemIndex));
					var verticalPosition:int = item.verticalPosition;

					// let's try and get the stage to be sized before we scroll to the anchor
					application.invalidateDisplayList();
					application.validateNow();
					
					var height:int = application.stage.height;
					if (verticalPosition>height) {
						//trace("Link Manager: Scroll position is greater than current app height");
					}
					
					verticalScrollBarPosition = verticalPosition;
					
					// we could or should run this for a few frames
					anchorManager.scrollToPosition(verticalScrollBarPosition);
				}
				
			}
			linkManager.removeEventListener(linkManager.CONTENT_UPDATE_COMPLETE, contentUpdateComplete);
		}
		
		public function setScrollPosition(verticalScrollBarPosition:int = 0):void {
			anchorManager = AnchorManager.getInstance();
			
			// we should run this for a few frames
			anchorManager.scrollToPosition(verticalScrollBarPosition);
		}
		
	}
	
}
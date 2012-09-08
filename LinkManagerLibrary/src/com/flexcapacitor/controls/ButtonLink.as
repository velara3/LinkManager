



package com.flexcapacitor.controls {

	import com.flexcapacitor.managers.AnchorManager;
	import com.flexcapacitor.managers.LinkManager;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Button;

	public class ButtonLink extends Button implements IHyperlink {
		
		public function ButtonLink() {
			super();
			
	        anchorManager.addItem(this);
		}
		
		/** 
		 * used to inform search engines if this link should be followed
		 * */
		public function set follow(value:Boolean):void {
			_follow = value;
		}
		public function get follow():Boolean {
			return _follow;
		}
		private var _follow:Boolean = true;
		
		private var _pageTitle:String = "";
		
		/**
		 * Used to set the page title
		 * */
		[Bindable]
		[Inspectable(category="General")]
		public function set pageTitle(value:String):void {
			_pageTitle = value;
		}
		
		public function get pageTitle():String {
			return _pageTitle;
		}
		
		public var anchorManager:AnchorManager = AnchorManager.getInstance();
		
		private var _hyperlink:String = "";

		[Bindable]
		[Inspectable(category="General")]
		public function set hyperlink(value:String):void {
			
			// always remove previous listener
			removeEventListener(MouseEvent.CLICK, linkClickHandler);
			_hyperlink = value;
			
			if (value==null || value=="") {
				removeEventListener(MouseEvent.CLICK, linkClickHandler);
			}
			else {
				addEventListener(MouseEvent.CLICK, linkClickHandler, false, 0, true);
			}
			
			// set tool tip default
			if (toolTip=="" || toolTip==null) {
				toolTip = _hyperlink;
			}
		}
		
		public function get hyperlink():String {
			return _hyperlink;
		}
		
		private var _hyperlinkTarget:String = "";
		
		// once a value is set in the hyperlink property
		// a target can be set to one of the following
		// 
		// _state - a preexisting state in a flex application (implied by exact string match in hyperlink property)
		// _anchor - an anchor in a flex application (implied by #anchorName in the hyperlink property)
		// _self - replace the content in this window
		// _blank - new window
		// _tab - new tab (not implemented)
		// _download - force download of file
		// _internal - use internal media handler to display (download prompt appears if media is not supported)
		// name_of_frame - sent to a frame or window with the name as long as a state with the same name doesnt exist
		[Bindable]
		[Inspectable(category="General")]
		public function set hyperlinkTarget(value:String):void {
			_hyperlinkTarget = value;
		}

		public function get hyperlinkTarget():String {
			return _hyperlinkTarget;
		}
		
		private var _anchorName:String = "";
	
		[Bindable]
		[Inspectable(category="General")]
		public function set anchorName(value:String):void {
			_anchorName = value;
		}

		public function get anchorName():String {
			return _anchorName;
		}
		
		private var _group:String = "";
		
		// set the group here
		// used for grouping things
		[Bindable]
		[Inspectable(category="General")]
		public function set group(value:String):void {
			_group = value;
		}

		public function get group():String {
			return _group;
		}
        
        // when the user clicks on this link we handle it based on the content
        // if a state exists with the same name then we navigate to that state
        // if a it is a reference to an mime type flash player can handle then
        // we display it 
        // if not we navigate to it
        // we should display media - images, audio, video 
        // we should check the hyperlinkTarget for explicit instructions
        // including navigating to a link, downloading a file or displaying a file
        // we should really put this in another class that handles this all for us
        public function linkClickHandler(event:MouseEvent):void {
        	if (hyperlink==null) return;

        	var lm:LinkManager = LinkManager.getInstance();
        	lm.handleHyperlink(hyperlink, hyperlinkTarget, event.currentTarget);
        	
        }
		
	}
}
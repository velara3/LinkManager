




package com.flexcapacitor.controls {
	
	import com.flexcapacitor.managers.AnchorManager;
	import com.flexcapacitor.managers.LinkManager;
	import com.flexcapacitor.utils.ApplicationUtils;
	import com.flexcapacitor.utils.LeadingZeros;
	import com.flexcapacitor.vo.LinkInfo;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import mx.controls.Text;
	import mx.events.FlexEvent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;

	public class TextLink extends Text implements IHyperlink {
		
		public var anchorManager:AnchorManager = AnchorManager.getInstance();
		
		public function TextLink() {
			super();
	
			// set default properties here
			
			// Sprite variables.
			// enables the hand cursor
			buttonMode = true;
			mouseChildren = false;
			useHandCursor = true;
			
			// let people select text people
			selectable = true;
			
	        // Register for player events.
	        addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
	        addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
	        
	        anchorManager.addItem(this);
			
			if (application.initialized) {
				init(new FlexEvent("whatever")); // 
			}
			else {
				application.addEventListener(FlexEvent.CREATION_COMPLETE, init, false, 0, true);
			}
		}
		
		public function get application():Object {
			return LinkManager.getInstance().document;
		}
		
		private function init(event:FlexEvent):void {
			var linkManager:LinkManager = LinkManager.getInstance();
			linkManager.addEventListener(linkManager.HYPERLINK_EVENT, checkLinkStateHandler, false, 0, true);
			application.removeEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		private function checkLinkStateHandler(event:Event):void {
			// TODO: Get this working
			
			//checkForVisitedLink(event);
			//checkForActiveLink(event);
		}
		
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
				toolTip = pageTitle!="" ? pageTitle : _hyperlink;
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
		
		[Bindable]
		[Inspectable(category="General")]
		public var rollOverStyle:String = "";
		
		[Bindable]
		[Inspectable(category="General")]
		public var rollOutStyle:String = "";
		public var currentStyleName:Object = "";
		
		public var originalDecoration:String = "";
		
		public var originalWeight:String = "";
		
		public var originalColor:Number = 0xFFFFFF;
        
        // when the user clicks on this link we handle it based on the content
        // if a state exists with the same name then we navigate to that state
        // if a it is a reference to an mime type flash player can handle then
        // we display it 
        // if not we navigate to it
        // we should display media - images, audio, video 
        // we should check the hyperlinkTarget for explicit instructions
        // including navigating to a link, downloading a file or displaying a file
        public function linkClickHandler(event:MouseEvent):void {
        	if (hyperlink==null) return;

        	var lm:LinkManager = LinkManager.getInstance();
        	lm.handleHyperlink(hyperlink, hyperlinkTarget, event.currentTarget);
        	
        }
		
		// Define a static variable
        private static var classConstructed:Boolean = classConstruct();
        
		// set default styles here
        // Define a static method.
        private static function classConstruct():Boolean {
            /*if (!StyleManager.getStyleDeclaration("TextLink")) {
                // If there is no CSS definition for TextLink
                // then create one and set the default value.
                var newStyleDeclaration:CSSStyleDeclaration  = new CSSStyleDeclaration();
                
				// set default styles here
                //newStyleDeclaration.setStyle("focusThickness", "0");

                //StyleManager.setStyleDeclaration("TextLink", newStyleDeclaration, true);
            }*/
            return true;
        }
		
		private function rollOverHandler(event:MouseEvent):void {
			var rollOverColor:uint = getStyle("rollOverColor");
			var rollOverWeight:String = getStyle("rollOverWeight");
			var underlineOnRollOver:Boolean = getStyle("underlineOnRollOver");
			
			// show the url in the status bar
			// doesn't seem to work :P
			// call fcSetWindowStatus(url);
			if (hyperlink!="") {
				//ExternalInterface.call("eval", "window.document.status='"+hyperlink+"'");
			}
			else {
				//cm.url = url;
			}
			
			// save reference to the current style
			this.currentStyleName = this.styleName;
			
			// underline on roll over
			if (underlineOnRollOver) {
				this.originalDecoration = this.getStyle("textDecoration");
				this.setStyle('textDecoration', 'underline');
			}
			
			// bold on roll over
			if (rollOverWeight=="bold") {
				this.originalWeight = this.getStyle('fontWeight');
				this.setStyle('fontWeight', 'bold');
			}
			
			// color to display on roll over
			if (!isNaN(rollOverColor)) {
				this.originalColor = this.getStyle('color');
				var newColor:String = LeadingZeros.staticInstance.padString(Number(rollOverColor).toString(16), 6);
				this.setStyle('color', "#" + String(newColor));
			}
			
			// update the style
			if (rollOverStyle=="") {
				return;
			}
			
			// show the roll over style
			this.styleName = rollOverStyle;
		}
		
		private function rollOutHandler(event:MouseEvent):void {
			var rollOverColor:uint = getStyle("rollOverColor");
			var rollOverWeight:String = getStyle("rollOverWeight");
			var underlineOnRollOver:Boolean = getStyle("underlineOnRollOver");
			
			// show the url in the status bar
			if (hyperlink!="") {
				// doesn't work maybe because you cant set the status bar anymore???
				ExternalInterface.call("eval", "window.status='doesnt work'");
			}
			else {
				//cm.url = "";
			}
			
			// underline on roll over
			if (underlineOnRollOver) {
				this.setStyle("textDecoration", originalDecoration);
			}
			
			// revert to original weight
			if (rollOverWeight) {
				this.setStyle('fontWeight', originalWeight);
			}
			
			// revert to original color
			if (!isNaN(rollOverColor)) {
				this.setStyle('color', "#" + LeadingZeros.staticInstance.padString(Number(originalColor).toString(16), 6));
			}
			
			// update the style
			if (rollOutStyle!="") {
				this.styleName = this.rollOutStyle;
			}
			else if (currentStyleName!="" && this.currentStyleName!=null) {
				this.styleName = this.currentStyleName;
			}
			else {
				//this.setStyle('textDecoration', 'none');
				//this.setStyle('color', "0x"+ this.originalColor.toString(16));
			}
		}
		
		private function checkForActiveLink(event:Event):void {
			var activeLocation:Boolean = false;
			var color:uint = getStyle("color");
			var visitedLinkColor:uint = getStyle("activeLinkColor");
			var linkManager:LinkManager = LinkManager.getInstance();
			var fragment:String = linkManager.getFragment();
			activeLocation = linkManager.isLinkActive(this.hyperlink);
			
			if (activeLocation) {
				trace("Link Manager.TextLink: Active '" + hyperlink +"'");
				
				// color to display on roll over
				if (!isNaN(visitedLinkColor)) {
					this.originalColor = this.getStyle('color');
					var newColor:String = LeadingZeros.staticInstance.padString(Number(visitedLinkColor).toString(16), 6);
					this.setStyle('color', "#" + String(newColor));
				}
			}
		}
		
		private function checkForVisitedLink(event:Event):void {
			var visitedLocation:Boolean = false;
			var color:uint = getStyle("color");
			var visitedLinkColor:uint = getStyle("visitedLinkColor");
			var linkManager:LinkManager = LinkManager.getInstance();
			visitedLocation = linkManager.isLinkVisited(this.hyperlink);
			
			if (visitedLocation) {
				trace("Link Manager.TextLink: Visited before '" + hyperlink +"'");
				
				// color to display on roll over
				if (!isNaN(visitedLinkColor)) {
					this.originalColor = this.getStyle('color');
					var newColor:String = LeadingZeros.staticInstance.padString(Number(visitedLinkColor).toString(16), 6);
					this.setStyle('color', "#" + String(newColor));
				}
			}
		}
		
	}
}
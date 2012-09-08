




package com.flexcapacitor.managers {
	
	import com.flexcapacitor.utils.ApplicationUtils;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.utils.getTimer;
	
	import mx.collections.ArrayCollection;
	import mx.core.Application;
	import mx.core.FlexVersion;
	import mx.core.UIComponent;
	
	import spark.components.Scroller;
	
	public class AnchorManager extends EventDispatcher {


		private var _items:Array = new Array();
		
		[Bindable]
		public var items:ArrayCollection = new ArrayCollection(_items);
		
		[Bindable]
		public var anchorPending:Boolean = false;
		
		[Bindable]
		public var currentState:String = "";
		
		[Bindable]
		public var useBrowserScrollBars:Boolean = false;
		
		[Bindable]
		public var TOP:String = "TOP";
		
		[Bindable]
		public var BOTTOM:String = "BOTTOM";
		
		[Bindable]
		public var CURRENT:String = "CURRENT";
		
		private static var _instance:AnchorManager;
		
		// default time to wait for the anchor to be added to the stage
		// default value is "60000" which is 60 seconds
		[Bindable]
		public var timeout:uint = 60000;
		
		private var anchorPendingTime:Number = 0;
		
		public function AnchorManager() {
			_instance = this;
		}
		
		public static function getInstance():AnchorManager {
			if (_instance==null) {
				_instance = new AnchorManager();
				return _instance;
			}
			return _instance;
		}
		
		private var _anchorName:String;
	
		[Bindable]
		public function set anchorName(value:String):void {
			_anchorName = value;
		}

		public function get anchorName():String {
			return _anchorName;
		}
		
		// get name of anchor
		// search through list of anchors and see if we find it
		// if we find it then we move to it
		// if we don't find it we set a timeout and
		// watch the anchors added in the addItem() method to see if it's added there
		// if it's not added after the timeout
		// if we change states (usually set outside of this class) then we clear the anchor
		public function addAnchorWatch(anchor:String, state:String):void {
			anchorName = anchor;
			currentState = (state=="" || state==null) ? getCurrentState() : state ;
			
			var anchorFound:Boolean = anchorExists(anchorName);
			
			// we check for special named anchors
			if (anchorName==TOP) {
				scrollToTop();
				clearAnchorWatch();
				return;
			}
			
			if (anchorFound) {
				scrollToAnchor(anchorName);
				clearAnchorWatch();
			}
			else {
				anchorPendingTime = getTimer();
				anchorPending = true;
			}
			
		}
		
		public function clearAnchorWatch():void {
			anchorName = "";
			anchorPending = false;
			anchorPendingTime = 0;
		}
		
		// find and scroll to an anchor
		// according to the w3c anchor spec we should be able ot scroll via element id
		// TODO: add scroll to id
		// TODO: search display list instead of setting a timer (check ViewDisplayList class)
		// - we set a timer because we didnt know when we'd get a result back
		// in the latest link manager we can use a "wait" action to wait for async calls
		// and then scroll to the anchor however,
		// TODO: images may still be loading so we need to create an onLoad event that waits for 
		// images to finish loading
		public function scrollToAnchor(name:String):void {
			var anchorFound:Boolean = false;
			var item:DisplayObject;
			var top:Number;
			
			// scroll to the top of the application
			if (name==TOP) {
				scrollToTop();
				anchorPending = false;
				return;
			}
			
			// scroll to the bottom of the application
			if (name==BOTTOM) {
				scrollToBottom();
				anchorPending = false;
				return;
			}
			
			// don't scroll at all or move to location of mouse click event
			if (name==CURRENT) {
				// TODO: in the future scroll to the vertical position of where the user clicked
				anchorPending = false;
				return;
			}
			
			// if a Number is given try and scroll to it
			if (!isNaN(Number(name))) {
				scrollToPosition(Number(name));
				anchorPending = false;
				return;
			}
			
			anchorFound = anchorExists(name);
			
			// should we make sure the anchor is on the display list too?
			if (anchorFound) {
				var currentTop:int = 0;
				item = getItemById(name) as DisplayObject;
				if (isFlex3) {
					if (item!=null && item.stage!=null) {
						currentTop = getVerticalScrollPosition();
						top = item.localToGlobal(new Point(0,0)).y + currentTop;
						scrollToPosition(Number(top));
					}
				}
				else {
					if (item!=null) {
						currentTop = getVerticalScrollPosition();
						var point:Object = UIComponent(item).localToGlobal(new Point(0,0));
						var point2:Object = UIComponent(item).localToContent(new Point(0,0));
						top = item.localToGlobal(new Point(0,0)).y;
						trace("current top " + currentTop);
						trace("top="+top);
						top = top + currentTop;
						scrollToPosition(Number(top));
					}
				}
				anchorPending = false;
				return;
			}
		}
		
		public function scrollToTop():void {
			scrollToPosition(0);
		}
		
		public function scrollToBottom():void {
			var scrollPosition:int = 100000; 
			
			if (application.stage) {
				scrollPosition = application.stage.height;
			}
			
			scrollToPosition(scrollPosition);
		}
		
		public function scrollToPosition(value:int = 0):void {
			//trace ("scrolling to +" + value);
			setVerticalScrollPosition(value, useBrowserScrollBars);
			
			//trace ("scrolling to b +" + value);
			//trace ("app scroll position +" + application.verticalScrollPosition);
			application.invalidateDisplayList();
			//application.validateNow();
		}
		
		public function timeoutAnchor():void {
			anchorPending = false;
		}
		
		public function isKeyword(value:String):Boolean {
			if (value==TOP || value==BOTTOM || value==CURRENT) {
				return true;
			}
			return false;
		}

		public function getAllItems():Array {
			return _items;
		}
		
		public function getItemById(id:String):Object {
			for each (var anchor:Object in _items) {
				if (anchor.anchorName.toLowerCase()==id.toLowerCase() 
					|| anchor.anchorName==id
					|| anchor.name==id) {
					return anchor;
				}
			}
			return null;
		}
		
		// TODO: It might be better to just scan the display list
		// then we could check the anchorName property
		// and support moving to a display object by checking it's id
		public function anchorExists(name:String):Boolean {
			var visible:Boolean = false;
			name = name.toLowerCase();
			
			for each (var anchor:Object in _items) {
				// make sure it's on the display list
				visible = (anchor.stage!=null);
				var anchorName:String = String(anchor.anchorName);
				
				if (visible && anchorName!=null && anchorName.toLowerCase()==name) {
					return true;
				}
				else if (visible && anchor.id!=null && anchor.id.toLowerCase()==name) {
					return true;
				}
				else if (visible && anchor.name!=null && anchor.name.toLowerCase()==name) {
					return true;
				}
			}
			return false;
		}
		
		public function addItem(item:Object):void {
			items.addItem(item);
			var currentTime:Number = getTimer();
			
			
			if (anchorPending) {
				
				// we should time out the anchor if it exceeds our timeout value
				if ((currentTime - timeout) > anchorPendingTime) {
					
					trace("ANCHOR MANAGER: Anchor call has expired");
					//clearAnchorWatch();
				}
				else {

					// is this the anchor we're looking for?
					if (String(item.anchorName).toLowerCase()==anchorName.toLowerCase()) {
						scrollToAnchor(anchorName);
						clearAnchorWatch();
					}
					// these aren't the droids, i mean anchor's we're looking for
					else {
						
					}
				}
			}
		}
		
		public function removeItem(item:DisplayObject):void {
			var index:uint = items.getItemIndex(item);
			items.removeItemAt(index);
		}
		
	    public function getCurrentState():String {
	    	var state:String = application.currentState;
	    	if (state=="" || state==null) {
	    		state = "";
	    	}
	    	return state;
	    }
		
		private var isFlex3:Boolean = FlexVersion.compatibilityVersionString=="3.0.0";
		
		public function get application():Object {
			return ApplicationUtils.getInstance();
		}
		
		public function getVerticalScrollPosition():int {
			if (isFlex3) {
				return application.verticalScrollPosition;
			}
			else {
				if (scroller==null || scroller.viewport==null) {
					return 0;
				}
				var top:int = scroller.localToGlobal(new Point()).y;
				var currentPosition:int = scroller.viewport.verticalScrollPosition + top;
				return currentPosition;
			}
		}
		
		public function setVerticalScrollPosition(value:int = 0, isBrowser:Boolean = false):void {
			var foundScroller:Boolean = false;
			
			if (isBrowser) {
				ExternalInterface.call("eval", "window.scrollTo(0, " + value + ")");
			}
			else if (isFlex3) {
				application.verticalScrollPosition = value;
			}
			else {
				if (scroller!=null && Object(scroller).viewport!=null) {
					Object(scroller).viewport.verticalScrollPosition = value;
				}
			}
			
		}
		
		public function get scroller():Object {
			if (!isFlex3) {
				for (var i:int=0;i<Object(application.contentGroup).numChildren;i++) {
					var item:Object = Object(application.contentGroup).getChildAt(i) as Object;
					
					if (item is Scroller) {
						return item;
					}
				}
				
				//trace("No scroller was found. Please wrap your content in a Scroller component");
				return null;
			}
			
			return null;
		}

	}
}
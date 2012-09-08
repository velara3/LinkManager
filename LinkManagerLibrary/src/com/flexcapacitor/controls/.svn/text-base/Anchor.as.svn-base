



package com.flexcapacitor.controls {
	import com.flexcapacitor.managers.LinkManager;
	import com.flexcapacitor.utils.ApplicationUtils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IStyleManager2;
	
	import spark.components.Group;

	public class Anchor extends Group implements IHyperlink {
		
		public var useDefaultTooltip:Boolean = false;
		
		public function Anchor() {
			super();
			
			// set default properties here
			buttonMode = true;
			//mouseChildren = false;
			useHandCursor = true;
			
			application.addEventListener(FlexEvent.CREATION_COMPLETE, init, false, 0, true);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 0, true);
		}
		
		protected function addedToStageHandler(event:Event):void {
			LinkManager.getInstance().addAnchor(this);
			addHandlers();
		}
		
		protected function removedFromStageHandler(event:Event):void {
			LinkManager.getInstance().removeAnchor(this);
		}
		
		public function get application():Object {
			return LinkManager.getInstance().document;
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
		
		private function init(event:FlexEvent):void {
			
			addHandlers();
			
		}

		private var _hyperlink:String = "";
		
		[Bindable]
		[Inspectable(category="General")]
		public function set hyperlink(value:String):void {
			// always remove previous listener
			removeEventListener(MouseEvent.CLICK, linkClickHandler);
			_hyperlink = value;
		}
		
		public function get hyperlink():String {
			return _hyperlink;
		}
		
		private var _hyperlinkAlternative:String;
		
		/**
		 * Toggle between the hyperlink and this 
		 * */
		[Bindable]
		[Inspectable(category="General")]
		public function set hyperlinkAlternative(value:String):void {
			// always remove previous listener
			removeEventListener(MouseEvent.CLICK, linkClickHandler);
			_hyperlinkAlternative = value;
		}
		
		public function get hyperlinkAlternative():String {
			return _hyperlinkAlternative;
		}
		
		public function addHandlers():void {
			
			if (target) {
				// remove current anchor listener and add one to the target
				removeEventListener(MouseEvent.CLICK, linkClickHandler);
				target.addEventListener(MouseEvent.CLICK, linkClickHandler, false, 0, true);
				
				// add support to show hand cursor
				if (useHandCursor) {
					if (UIComponent(target).hasOwnProperty("buttonMode")) {
						target['buttonMode'] = true;
					}
					if (UIComponent(target).hasOwnProperty("mouseChildren")) {
						target['mouseChildren'] = false;
					}
					if (UIComponent(target).hasOwnProperty("useHandCursor")) {
						target['useHandCursor'] = true;
					}		
				}
				
				// set tool tip default
				if (useDefaultTooltip && UIComponent(target).hasOwnProperty("toolTip")) {
					if (target['toolTip']=="" || target['toolTip']==null) {
						target['toolTip'] = _hyperlink;
					}
				}
				
				// hide the component
				hideComponent();
			}
			else {
				removeEventListener(MouseEvent.CLICK, linkClickHandler);
				addEventListener(MouseEvent.CLICK, linkClickHandler, false, 0, true);
				
				// set tool tip default
				// this shouldn't work???
				if (useDefaultTooltip) {
					if (toolTip=="" || toolTip==null) {
						toolTip = _hyperlink;
					}
				}
			}
		}
		
		private var _target:Object;
		
		// let the user specify a target so the anchor doesnt have to wrap the component
		// the target needs to support click event
		[Bindable]
		[Inspectable(category="General")]
		public function set target(value:Object):void {
			
			// we should check if the previous target already has a listener and remove it
			if (_target!=null) {
				UIComponent(_target).removeEventListener(MouseEvent.CLICK, linkClickHandler);
			}
			_target = value as UIComponent;
			
			// if target exists then add a listener and remove the current
			if (value) {
				
				// remove current anchor listener and add one to the target
				removeEventListener(MouseEvent.CLICK, linkClickHandler);
				_target.addEventListener(MouseEvent.CLICK, linkClickHandler, false, 0, true);
				
				// add support to show hand cursor
				if (useHandCursor) {
					if (UIComponent(target).hasOwnProperty("buttonMode")) {
						_target['buttonMode'] = true;
					}
					if (UIComponent(target).hasOwnProperty("mouseChildren")) {
						_target['mouseChildren'] = false;
					}
					if (UIComponent(target).hasOwnProperty("useHandCursor")) {
						_target['useHandCursor'] = true;
					}
				}
				
				// hide the anchor component (does not hide the target)
				hideComponent();
			}
		}

		public function get target():Object {
			return _target;
		}
		
		// hides the anchor component (not the target) when a target is provided
		// we might want to create another class not based on UIComponent
		// at this point we won't worry about it and just hide it and not include it in the layout
		public function hideComponent():void {
			if (target && target.parent && target.parent!=this && target.parent.parent!=this) {
				width = 0;
				height = 0;
				includeInLayout = false;
			}
		}
		
		// click handler		
        public function linkClickHandler(event:MouseEvent):void {
        	if (hyperlink==null) return;
			
			var linkManager:LinkManager = LinkManager.getInstance();
			var currentFragment:String = linkManager.fragment;
			var destinationLink:String = hyperlink;
			
			// if an alternative hyperlink is provided and the current hyperlink exactly matches
			// the hyperlink property toggle to the alternative 
			if (hyperlinkAlternative && currentFragment==hyperlink) {
				destinationLink = hyperlinkAlternative;
			}
			
			linkManager.handleHyperlink(destinationLink, hyperlinkTarget, event.currentTarget);
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
	
		[Bindable]
		[Inspectable(category="General")]
		public function set group(value:String):void {
			_group = value;
		}

		public function get group():String {
			return _group;
		}
		
 		// Define a static variable
        private static var classConstructed:Boolean = classConstruct();
        
		// set default styles here
        // Define a static method.
        private static function classConstruct():Boolean {
           /* if (!IStyleManager2.getStyleDeclaration("Anchor")) {
                // If there is no CSS definition for TextLink
                // then create one and set the default value.
                var newStyleDeclaration:CSSStyleDeclaration  = new CSSStyleDeclaration();

				// set default styles here
				//1000: Ambiguous reference to setStyle
                //newStyleDeclaration.setStyle("verticalAlign", "middle");
                //newStyleDeclaration.setStyle("horizontalAlign", "center");
                //newStyleDeclaration.public::setStyle("backgroundColor", undefined);
                //newStyleDeclaration.public::setStyle("backgroundImage", undefined);

				IStyleManager2.setStyleDeclaration("Anchor", newStyleDeclaration, true);
            }*/
            return true;
        } 
		
	    /**
	     *  @private
	     *  Create child objects.
	     */
	    override protected function createChildren():void {
	        super.createChildren();
			
	    }
		
	}
}
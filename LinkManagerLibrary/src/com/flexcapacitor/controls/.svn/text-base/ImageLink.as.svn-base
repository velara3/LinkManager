




package com.flexcapacitor.controls {
	
	import com.flexcapacitor.managers.AnchorManager;
	import com.flexcapacitor.managers.LinkManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.core.Application;
	import mx.core.Container;
	import mx.core.DragSource;
	import mx.core.EdgeMetrics;
	import mx.core.IFlexDisplayObject;
	import mx.core.mx_internal;
	import mx.events.CloseEvent;
	import mx.managers.DragManager;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.ISimpleStyleClient;
	import mx.styles.StyleManager;

	use namespace mx_internal;
	use namespace mx_internal;
	
	// mx.core.IRectangularBorder;
	
	/**
	 *  Alpha level of the color defined by the <code>backgroundColor</code>
	 *  property, of the image or SWF file defined by the <code>backgroundImage</code>
	 *  style.
	 *  Valid values range from 0.0 to 1.0. For most controls, the default value is 1.0, 
	 *  but for ToolTip controls, the default value is 0.95 and for Alert controls, the default value is 0.9.
	 *  
	 *  @default 1.0
	 */
	[Style(name="backgroundAlpha", type="Number", inherit="no")]
	
	/**
	 *  Background color of a component.
	 *  You can have both a <code>backgroundColor</code> and a
	 *  <code>backgroundImage</code> set.
	 *  Some components do not have a background.
	 *  The DataGrid control ignores this style.
	 *  The default value is <code>undefined</code>, which means it is not set.
	 *  If both this style and the <code>backgroundImage</code> style
	 *  are <code>undefined</code>, the component has a transparent background.
	 *
	 *  <p>For the Application container, this style specifies the background color
	 *  while the application loads, and a background gradient while it is running. 
	 *  Flex calculates the gradient pattern between a color slightly darker than 
	 *  the specified color, and a color slightly lighter than the specified color.</p>
	 * 
	 *  <p>The default skins of most Flex controls are partially transparent. As a result, the background color of 
	 *  a container partially "bleeds through" to controls that are in that container. You can avoid this by setting the 
	 *  alpha values of the control's <code>fillAlphas</code> property to 1, as the following example shows:
	 *  <pre>
	 *  &lt;mx:<i>Container</i> backgroundColor="0x66CC66"/&gt;
	 *      &lt;mx:<i>ControlName</i> ... fillAlphas="[1,1]"/&gt;
	 *  &lt;/mx:<i>Container</i>&gt;</pre>
	 *  </p>
	 */
	[Style(name="backgroundColor", type="uint", format="Color", inherit="no")]
	
	/**
	 *  Background color of the component when it is disabled.
	 *  The global default value is <code>undefined</code>.
	 *  The default value for List controls is <code>0xDDDDDD</code> (light gray).
	 *  If a container is disabled, the background is dimmed, and the degree of
	 *  dimming is controlled by the <code>disabledOverlayAlpha</code> style.
	 */
	[Style(name="backgroundDisabledColor", type="uint", format="Color", inherit="yes")]
	
	/**
	 *  Background image of a component.  This can be an absolute or relative
	 *  URL or class.  You can either have both a <code>backgroundColor</code> and a
	 *  <code>backgroundImage</code> set at the same time. The background image is displayed
	 *  on top of the background color.
	 *  The default value is <code>undefined</code>, meaning "not set".
	 *  If this style and the <code>backgroundColor</code> style are undefined,
	 *  the component has a transparent background.
	 * 
	 *  <p>The default skins of most Flex controls are partially transparent. As a result, the background image of 
	 *  a container partially "bleeds through" to controls that are in that container. You can avoid this by setting the 
	 *  alpha values of the control's <code>fillAlphas</code> property to 1, as the following example shows:
	 *  <pre>
	 *  &lt;mx:<i>Container</i> backgroundColor="0x66CC66"/&gt;
	 *      &lt;mx:<i>ControlName</i> ... fillAlphas="[1,1]"/&gt;
	 *  &lt;/mx:<i>Container</i>&gt;</pre>
	 *  </p>
	 */
	[Style(name="backgroundImage", type="Object", format="File", inherit="no")]
	
	/**
	 *  Scales the image specified by <code>backgroundImage</code>
	 *  to different percentage sizes.
	 *  A value of <code>"100%"</code> stretches the image
	 *  to fit the entire component.
	 *  To specify a percentage value, you must include the percent sign (%).
	 *  The default for the Application container is <code>100%</code>.
	 *  The default value for all other containers is <code>auto</code>, which maintains
	 *  the original size of the image.
	 */
	[Style(name="backgroundSize", type="String", inherit="no")]
	
	/**
	 *  Color of the border.
	 *  The default value depends on the component class;
	 *  if not overridden for the class, the default value is <code>0xB7BABC</code>.
	 */
	[Style(name="borderColor", type="uint", format="Color", inherit="no")]
	
	/**
	 *  Bounding box sides.
	 *  A space-delimited String that specifies the sides of the border to show.
	 *  The String can contain <code>"left"</code>, <code>"top"</code>,
	 *  <code>"right"</code>, and <code>"bottom"</code> in any order.
	 *  The default value is <code>"left top right bottom"</code>,
	 *  which shows all four sides.
	 *
	 *  This style is only used when borderStyle is <code>"solid"</code>.
	 */
	[Style(name="borderSides", type="String", inherit="no")]
	
	/**
	 *  The border skin class of the component. 
	 *  The mx.skins.halo.HaloBorder class is the default value for all components 
	 *  that do not explicitly set their own default. 
	 *  The Panel container has a default value of mx.skins.halo.PanelSkin.
	 *  To determine the default value for a component, see the default.css file.
	 *
	 *  @default mx.skins.halo.HaloBorder
	 */
	[Style(name="borderSkin", type="Class", inherit="no")]
	
	/**
	 *  Bounding box style.
	 *  The possible values are <code>"none"</code>, <code>"solid"</code>,
	 *  <code>"inset"</code>, and <code>"outset"</code>.
	 *  The default value depends on the component class;
	 *  if not overridden for the class, the default value is <code>"inset"</code>.
	 *  The default value for most Containers is <code>"none"</code>.
	 */
	[Style(name="borderStyle", type="String", enumeration="inset,outset,solid,none", inherit="no")]
	
	/**
	 *  Bounding box thickness.
	 *  Only used when <code>borderStyle</code> is set to <code>"solid"</code>.
	 *
	 *  @default 1
	 */
	[Style(name="borderThickness", type="Number", format="Length", inherit="no")]
	
	/**
	 *  Radius of component corners.
	 *  The default value depends on the component class;
	 *  if not overriden for the class, the default value is 0.
	 *  The default value for ApplicationControlBar is 5.
	 */
	[Style(name="cornerRadius", type="Number", format="Length", inherit="no")]
	
	/**
	 *  Boolean property that specifies whether the component has a visible
	 *  drop shadow.
	 *  This style is used with <code>borderStyle="solid"</code>.
	 *  The default value is <code>false</code>.
	 *
	 *  <p><b>Note:</b> For drop shadows to appear on containers, set
	 *  <code>backgroundColor</code> or <code>backgroundImage</code> properties.
	 *  Otherwise, the shadow appears behind the container because
	 *  the default background of a container is transparent.</p>
	 */
	[Style(name="dropShadowEnabled", type="Boolean", inherit="no")]
	
	/**
	 *  Color of the drop shadow.
	 *
	 *  @default 0x000000
	 */
	[Style(name="dropShadowColor", type="uint", format="Color", inherit="yes")]
	
	/**
	 *  Direction of the drop shadow.
	 *  Possible values are <code>"left"</code>, <code>"center"</code>,
	 *  and <code>"right"</code>.
	 *
	 *  @default "center"
	 */
	[Style(name="shadowDirection", type="String", enumeration="left,center,right", inherit="no")]
	
	/**
	 *  Distance of the drop shadow.
	 *  If the property is set to a negative value, the shadow appears above the component.
	 *
	 *  @default 2
	 */
	[Style(name="shadowDistance", type="Number", format="Length", inherit="no")]
	
	/**
	 *  Number of pixels between the component's left border
	 *  and the left edge of its content area.
	 *  <p>The default value is 0.</p>
	 *  <p>The default value for a Button control is 10.</p>
	 *  <p>The default value for the ComboBox control is 5.</p>
	 *  <p>The default value for the Form container is 16.</p>
	 *  <p>The default value for the Tree control is 2.</p>
	 */
	[Style(name="paddingLeft", type="Number", format="Length", inherit="no")]
	
	/**
	 *  Number of pixels between the component's right border
	 *  and the right edge of its content area.
	 *  <p>The default value is 0.</p>
	 *  <p>The default value for a Button control is 10.</p>
	 *  <p>The default value for the ComboBox control is 5.</p>
	 *  <p>The default value for the Form container is 16.</p>
	 */
	[Style(name="paddingRight", type="Number", format="Length", inherit="no")]
	
	/**
	 *  Number of pixels between the component's bottom border
	 *  and the bottom edge of its content area.
	 *
	 *  @default 0
	 */
	[Style(name="paddingBottom", type="Number", format="Length", inherit="no")]
	
	/**
	 *  Number of pixels between the component's top border
	 *  and the top edge of its content area.
	 *  
	 *  @default 0
	 */
	[Style(name="paddingTop", type="Number", format="Length", inherit="no")]

	public class ImageLink extends Image implements IHyperlink {
		
		public var preventDragAndDrop:Boolean = false;
		
		public function ImageLink() {
			super();
			
			buttonMode = true;
			mouseChildren = false;
			useHandCursor = true;
			
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
			if ((toolTip=="" || toolTip==null) && (_hyperlink!="" || _hyperlink!=null)) {
				toolTip = _hyperlink;
			}
		}
		
		public function get hyperlink():String {
			return _hyperlink;
		}
		
		// click handler
        public function linkClickHandler(event:MouseEvent):void {
        	if (hyperlink==null) return;

        	var lm:LinkManager = LinkManager.getInstance();
        	lm.handleHyperlink(hyperlink, hyperlinkTarget, event.currentTarget);
        	
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
		// name_of_frame or name of component - sent to a frame or window with the name as long as a state with the same name doesnt exist
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

	    /**
	     *  The internal subcontrol that draws the border and background.
	     */
	    mx_internal var border:IFlexDisplayObject;
		
 		// Define a static variable
        private static var classConstructed:Boolean = classConstruct();
        
		// set default styles here
        // Define a static method.
        private static function classConstruct():Boolean {
			/*if (!super.styleManager.getStyleDeclaration("ImageLink")) {
				// If there is no CSS definition for TextLink
				// then create one and set the default value.
				var newStyleDeclaration:CSSStyleDeclaration = new CSSStyleDeclaration();
				
				// set default styles here
				//1000: Ambiguous reference to setStyle
				//newStyleDeclaration.setStyle("verticalAlign", "middle");
				//newStyleDeclaration.setStyle("horizontalAlign", "center");
				//newStyleDeclaration.public::setStyle("backgroundColor", undefined);
				//newStyleDeclaration.public::setStyle("backgroundImage", undefined);
				
				styleManager.setStyleDeclaration("ImageLink", newStyleDeclaration, true);
			}
			if (!StyleManager.getStyleDeclaration("DragManager")) {
				// If there is no CSS definition for DragManager
				// then create one and set the default value.
				var newDragManagerDeclaration:CSSStyleDeclaration = new CSSStyleDeclaration();
				
				// set default styles here
				//1000: Ambiguous reference to setStyle
				//mx.styles.CSSStyleDeclaration(newDragManagerDeclaration).setStyle("rejectCursor", null);
				
				StyleManager.setStyleDeclaration("DragManager", newDragManagerDeclaration, true);
			}*/
            return true;
        } 
		
	    /**
	     *  @private
	     *  Create child objects.
	     */
	    override protected function createChildren():void {
	        super.createChildren();
	
	        //createBorder();
	    }
	    
	    /**
	     *  @private
	     */
	    override protected function measure():void {
	        super.measure();
	
	        // var bm:EdgeMetrics = border && border is IRectangularBorder ? IRectangularBorder(border).borderMetrics : EdgeMetrics.EMPTY;
	    }
	    
	    /**
	     *  @private
	     *  Stretch the border and fit the Image inside it.
	     */
	    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void { 
	    	      	
	        super.updateDisplayList(unscaledWidth, unscaledHeight);
	        
	        // The border doesn't really work 
	        // - background works ok if it's visible
	        // the problem i can't get around is how to resize the image to fit inside of the border
	        var bm:EdgeMetrics;
	
	        if (border) {
	            border.setActualSize(unscaledWidth, unscaledHeight);
	            bm = Object(border).hasOwnProperty("borderMetrics") ? border["borderMetrics"] : EdgeMetrics.EMPTY;
	        }
	        else {
	            bm = EdgeMetrics.EMPTY;
	        }
	        
	        var paddingLeft:Number = getStyle("paddingLeft");
	        var paddingRight:Number = getStyle("paddingRight");
	        var paddingTop:Number = getStyle("paddingTop");
	        var paddingBottom:Number = getStyle("paddingBottom");
	        var widthPad:Number = bm.left + bm.right;
	        var heightPad:Number = bm.top + bm.bottom + 1;
	        
	        //var contentHolder:DisplayObject = content;
	        
	        // adding a border so we rescale the image contents
	        // not sure if this is the correct way to do it
	        // copied from another class
	        
	        // this doesn't really work
	        // just put a canvas border around it dude
	        /* if (border) {
		        contentHolder.x = bm.left;
		        contentHolder.y = bm.top;
		
		        if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0)
		        {
		            contentHolder.x += paddingLeft;
		            contentHolder.y += paddingTop;
		            widthPad += paddingLeft + paddingRight;
		            heightPad += paddingTop + paddingBottom;
		        }
		        
		        contentHolder.width = Math.max(0, unscaledWidth - widthPad);
		        contentHolder.height = Math.max(0, unscaledHeight - heightPad);
	        } */
	    }
	    
	    /**
	     *  @private
	     */
	    override public function styleChanged(styleProp:String):void {
	        var allStyles:Boolean = (styleProp == null || styleProp == "styleName");
	
	        super.styleChanged(styleProp);
	        
	        // Replace the borderSkin
	        if (allStyles || styleProp == "borderSkin") {
	            if (border) {
	                removeChild(DisplayObject(border));
	                border = null;
	                createBorder();
	            }
	        }
	    }
    
	    /**
	     *  Creates the border for this component.
	     *  Normally the border is determined by the
	     *  <code>borderStyle</code> and <code>borderSkin</code> styles.  
	     *  It must set the border property to the instance
	     *  of the border.
	     */
	    protected function createBorder():void {
	        if (!border) {
	            var borderClass:Class = getStyle("borderSkin");
	
	            if (borderClass != null) {
	                border = new borderClass();
	    
	                if (border is ISimpleStyleClient)
	                    ISimpleStyleClient(border).styleName = this;
	    
	                // Add the border behind all the children.
	                addChildAt(DisplayObject(border), 0);
	    
	                invalidateDisplayList();
	            }
	        }
	    }

	}
}
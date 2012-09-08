////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2003-2007 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.flexcapacitor.skins {

	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	import mx.skins.ProgrammaticSkin;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IStyleClient;

	/**
	 *  Defines the skin for the focus indicator. This is the rectangle that appears around a control when it has focus.
	 */
	public class DottedFocusRect extends ProgrammaticSkin implements IStyleClient {
		public function DottedFocusRect() {
			super();
		}
		/**
		 *  @private
		 */
		private var _focusColor:Number;

		//--------------------------------------------------------------------------
		//  Properties: IStyleClient
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 */
		public function get className():String {
			return "DottedFocusRect";
		}

		//----------------------------------
		//  inheritingStyles
		//----------------------------------

		/**
		 *  @private
		 */
		public function get inheritingStyles():Object {
			return styleName.inheritingStyles;
		}

		/**
		 *  @private
		 */
		public function set inheritingStyles(value:Object):void {
		}

		//----------------------------------
		//  nonInheritingStyles
		//----------------------------------

		/**
		 *  @private
		 */
		public function get nonInheritingStyles():Object {
			return styleName.nonInheritingStyles;
		}

		/**
		 *  @private
		 */
		public function set nonInheritingStyles(value:Object):void {
		}

		//----------------------------------
		//  styleDeclaration
		//----------------------------------

		/**
		 *  @private
		 */
		public function get styleDeclaration():CSSStyleDeclaration {
			return CSSStyleDeclaration(styleName);
		}

		/**
		 *  @private
		 */
		public function set styleDeclaration(value:CSSStyleDeclaration):void {
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 */
		override protected function updateDisplayList(w:Number, h:Number):void {
			super.updateDisplayList(w, h);

			var focusBlendMode:String = getStyle("focusBlendMode");
			var focusAlpha:Number = getStyle("focusAlpha");
			var focusColor:Number = getStyle("focusColor");
			var cornerRadius:Number = getStyle("cornerRadius");
			var focusThickness:Number = getStyle("focusThickness");
			var focusRoundedCorners:String = getStyle("focusRoundedCorners");
			var themeColor:Number = getStyle("themeColor");
			var dotWidth:Number = getStyle("focusDotWidth");
			var dotHeight:Number = getStyle("focusDotHeight");
			var dotSpacing:Number = getStyle("focusDotSpacing");
			var focusEdgeExtensionLength:Number = getStyle("focusEdgeExtensionLength");
			var focusSides:Boolean = Boolean(getStyle("focusSides"));

			var rectColor:Number = focusColor;
			if (isNaN(rectColor))
				rectColor = themeColor;
			
			if (isNaN(dotWidth) || dotWidth==0)
				dotWidth = 1;
			
			if (isNaN(dotHeight) || dotHeight==0)
				dotHeight = 1;
			
			if (isNaN(dotSpacing) || dotSpacing==0)
				dotSpacing = 1;
			
			if (isNaN(focusEdgeExtensionLength) || focusEdgeExtensionLength==0)
				focusEdgeExtensionLength = 1;
			
			graphics.clear();

			if (focusBlendMode)
				blendMode = focusBlendMode;

			var ellipseSize:Number;
			
			if (w==0 || h==0) return;
			
			
			var dashedLine:DashedLine = new DashedLine(graphics, dotWidth, dotSpacing);
			var padding:Number = -2
			var x1:Number = 0;
			var y1:Number = 3;
			var w1:Number = x1 + w;
			var h1:Number = y1 + h - 9;
			focusThickness = .5;
			dashedLine.sides = focusSides;
			dashedLine.edgeOffset = focusEdgeExtensionLength;
			dashedLine.lineStyle(focusThickness, 0x000000, focusAlpha);
			dashedLine.drawRectangle(x1, y1, w1, h1, .4, 1.6);
			
			return;
			
			var g:Graphics = graphics;

			// outer ring - original
			/*var tile:BitmapData = new BitmapData(dotWidth + dotSpacing, dotHeight + 1, true);
			var r1:Rectangle = new Rectangle(0, 0, dotWidth, dotHeight);
			var argb:uint = getARGB(rectColor, 255);
			tile.fillRect(r1, argb);
			var r2:Rectangle = new Rectangle(dotWidth, 0, dotWidth + dotSpacing, dotHeight);
			tile.fillRect(r2, 0x00000000);
			g.beginBitmapFill(tile, null, true);*/
			
			// Do dotted fill.
			var tile:BitmapData = new BitmapData(dotWidth + dotSpacing, dotHeight+1, true);
			var r1:Rectangle = new Rectangle(0, 0, dotWidth, dotHeight);
			var argb:uint = getARGB(rectColor, 255);
			tile.fillRect(r1, argb);
			var r2:Rectangle = new Rectangle(dotWidth, 0, dotWidth + dotSpacing, dotHeight);
			tile.fillRect(r2, 0x00000000);
			g.beginBitmapFill(tile, null, true);
			
			//g.beginFill(rectColor, focusAlpha);
			
			
			
			ellipseSize = (cornerRadius > 0 ? cornerRadius + focusThickness : 0) * 2;
			g.drawRoundRect(0, 0, w, h, ellipseSize, ellipseSize);
			ellipseSize = cornerRadius * 2;
			g.drawRoundRect(focusThickness, focusThickness, w - 2 * focusThickness, h - 2 * focusThickness, ellipseSize, ellipseSize);
			g.endFill();
			return;
			// inner ring
			g.beginFill(rectColor, focusAlpha);
			ellipseSize = (cornerRadius > 0 ? cornerRadius + focusThickness / 2 : 0) * 2;
			g.drawRoundRect(focusThickness / 2, focusThickness / 2, w - focusThickness, h - focusThickness, ellipseSize, ellipseSize);
			ellipseSize = cornerRadius * 2;
			g.drawRoundRect(focusThickness, focusThickness, w - 2 * focusThickness, h - 2 * focusThickness, ellipseSize, ellipseSize);
			g.endFill();
		}

		private function getARGB(rgb:uint, newAlpha:uint):uint {
			var argb:uint = 0;
			argb += (newAlpha << 24);
			argb += (rgb);
			return argb;
		}
		

		//--------------------------------------------------------------------------
		//  Methods: IStyleClient
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 */
		override public function getStyle(styleProp:String):* {
			return styleProp == "focusColor" ? _focusColor : super.getStyle(styleProp);
		}

		/**
		 *  @private
		 */
		public function setStyle(styleProp:String, newValue:*):void {
			if (styleProp == "focusColor")
				_focusColor = newValue;
		}

		/**
		 *  @private
		 */
		public function clearStyle(styleProp:String):void {
			if (styleProp == "focusColor")
				_focusColor = NaN;
		}

		/**
		 *  @private
		 */
		public function getClassStyleDeclarations():Array {
			return [];
		}

		/**
		 *  @private
		 */
		public function notifyStyleChangeInChildren(styleProp:String, recursive:Boolean):void {
		}

		/**
		 *  @private
		 */
		public function regenerateStyleCache(recursive:Boolean):void {
		}

		/**
		 *  @private
		 */
		public function registerEffects(effects:Array /* of String */):void {
		}
	}

}

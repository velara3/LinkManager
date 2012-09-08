




package com.flexcapacitor.skins {
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	import mx.skins.halo.HaloFocusRect;
	import mx.styles.StyleManager;
	import mx.utils.GraphicsUtil;
	
	public class LinkFocusRectangle extends HaloFocusRect {
		
		
		public function LinkFocusRectangle() {
			super();
		}
		
		
		override protected function updateDisplayList(w:Number, h:Number):void{
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
			
			var rectColor:Number = focusColor;
			if (isNaN(rectColor))
				rectColor = themeColor;
			
			if (isNaN(dotWidth))
				dotWidth = 1;
			
			if (isNaN(dotHeight))
				dotHeight = 1;
			
			if (isNaN(dotSpacing))
				dotSpacing = 1;
			
			var g:Graphics = graphics;
			g.clear();
			
			if (focusBlendMode)
				blendMode = focusBlendMode;
			
			if (focusRoundedCorners != "tl tr bl br" && cornerRadius > 0)
			{
				// We have rounded corners on just some of the corners.
				
				var tl:Number = 0;
				var bl:Number = 0;
				var tr:Number = 0;
				var br:Number = 0;
				
				var nr:Number = cornerRadius + focusThickness;
				
				if (focusRoundedCorners.indexOf("tl") >= 0)
					tl = nr;
				
				if (focusRoundedCorners.indexOf("tr") >= 0)
					tr = nr;
				
				if (focusRoundedCorners.indexOf("bl") >= 0)
					bl = nr;
				
				if (focusRoundedCorners.indexOf("br") >= 0)
					br = nr;
				
				// outer ring
				g.beginFill(rectColor, focusAlpha);
				GraphicsUtil.drawRoundRectComplex(g, 0, 0, w, h, tl, tr, bl, br);
				tl = tl ? cornerRadius : 0;
				tr = tr ? cornerRadius : 0;
				bl = bl ? cornerRadius : 0;
				br = br ? cornerRadius : 0;
				GraphicsUtil.drawRoundRectComplex(g, focusThickness, focusThickness,
					w - 2 * focusThickness, h - 2 * focusThickness,
					tl, tr, bl, br);
				g.endFill();
				
				// inner ring
				nr = cornerRadius + (focusThickness / 2);
				tl = tl ? nr : 0;
				tr = tr ? nr : 0;
				bl = bl ? nr : 0;
				br = br ? nr : 0;
				g.beginFill(rectColor, focusAlpha);
				GraphicsUtil.drawRoundRectComplex(g, focusThickness / 2, focusThickness / 2,
					w - focusThickness, h - focusThickness,
					tl, tr, bl, br);
				tl = tl ? cornerRadius : 0;
				tr = tr ? cornerRadius : 0;
				bl = bl ? cornerRadius : 0;
				br = br ? cornerRadius : 0;
				GraphicsUtil.drawRoundRectComplex(g, focusThickness, focusThickness,
					w - 2 * focusThickness, h - 2 * focusThickness,
					tl, tr, bl, br);
				g.endFill();
			}
			else
			{
				
				// dot spacing
				//graphics.clear();
				var tile:BitmapData = new BitmapData(dotWidth + dotSpacing, h + 1, true);
				
				// top line
				var r1:Rectangle = new Rectangle(0, 0, dotWidth, dotHeight);
				var argb:uint = returnARGB(focusColor, 255);
				tile.fillRect(r1, argb);
				var r2:Rectangle = new Rectangle(dotWidth, 0, dotWidth + dotSpacing, h);
				tile.fillRect(r2, 0x00000000);

				
				// bottom line
				var r3:Rectangle = new Rectangle(0, h, dotWidth, dotHeight);
				tile.fillRect(r3, argb);
				var r4:Rectangle = new Rectangle(dotWidth, h, dotWidth + dotSpacing, h);
				tile.fillRect(r4, 0x00000000);
				
				g.beginBitmapFill(tile, null, true);
				g.drawRect(0, 0, w, dotHeight);
				g.drawRect(0, h, w, dotHeight);
				g.endFill();
				
				return;
				
				
				
				var ellipseSize:Number;
				
				// outer ring
				g.beginFill(rectColor, focusAlpha);
				ellipseSize = (cornerRadius > 0 ? cornerRadius + focusThickness : 0) * 2;
				g.drawRoundRect(0, 0, w, h, ellipseSize, ellipseSize);
				ellipseSize = cornerRadius * 2;
				g.drawRoundRect(focusThickness, focusThickness,
					w - 2 * focusThickness, h - 2 * focusThickness,
					ellipseSize, ellipseSize);
				g.endFill();

				
				// inner ring
				g.beginFill(rectColor, focusAlpha);
				ellipseSize = (cornerRadius > 0 ? cornerRadius + focusThickness / 2 : 0) * 2;
				g.drawRoundRect(focusThickness / 2, focusThickness / 2,
					w - focusThickness, h - focusThickness,
					ellipseSize, ellipseSize);
				ellipseSize = cornerRadius * 2;
				g.drawRoundRect(focusThickness, focusThickness,
					w - 2 * focusThickness, h - 2 * focusThickness,
					ellipseSize, ellipseSize);
				g.endFill();
			}
			
		}
		
		private function returnARGB(rgb:uint, newAlpha:uint):uint {
			var argb:uint = 0;
			argb += (newAlpha<<24);
			argb += (rgb);
			return argb;
		}

		
	}
}
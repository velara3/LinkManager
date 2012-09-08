


package com.flexcapacitor.context.menu {
	
	import com.flexcapacitor.controls.ImageViewer;
	import com.flexcapacitor.utils.ApplicationUtils;
	
	import flash.display.DisplayObject;
	import flash.events.ContextMenuEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	

	public class ImageView extends MenuItem {
		
		public var openViewImageInBrowser:Boolean = false;
		public var width:uint = 0;
		public var height:uint = 0;
		
		public function ImageView() {
			super();
			
			caption = "View Image";
		}
		
		override public function itemSelectedHandler(event:ContextMenuEvent):void {
			//var url:String = "http://google.com";
			if (openViewImageInBrowser) {
				navigateToURL(new URLRequest(source),'_self');
			}
			else {
				openPreview(source);
			}
		}

		// show a preview of the image
		public function openPreview(url:String):void {
			
			var imageViewer:ImageViewer = new ImageViewer();
			var modal:Boolean = false;

        	//if (!imageViewer.parent)
            //	imageViewer.parent = Sprite(FlexGlobals.topLevelApplication);  
            
			imageViewer.name = "viewImageImage1";
			imageViewer.source = url;
			imageViewer.imageName = url;
			imageViewer.imageWidth = width;
			imageViewer.imageHeight = height;
			imageViewer.width = application.width;
			imageViewer.height = application.height;
			/* imageViewer.imageWidth = ImageLink(event.contextMenuOwner).content.width;
			imageViewer.imageHeight = ImageLink(event.contextMenuOwner).content.height;
			imageViewer.image = ImageLink(event.contextMenuOwner); */
			
			// Setting a module factory allows the correct embedded font to be found.
	        if (imageViewer is UIComponent) {
	        	imageViewer.moduleFactory = UIComponent(imageViewer).moduleFactory;
			}
	        	
	        PopUpManager.addPopUp(imageViewer, DisplayObject(application), modal);
		}
	}
}
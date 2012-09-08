


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
	
	
	public class ImageEdit extends MenuItem {
		
		public var openViewImageInBrowser:Boolean = false;
		public var width:uint = 0;
		public var height:uint = 0;
		
		public function ImageEdit() {
			super();
			
			caption = "Edit in Photoshop...";
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
			
			var imageEditor:ImageViewer = new ImageViewer();
			var modal:Boolean = false;
			
			//if (!imageViewer.parent)
			//	imageViewer.parent = Sprite(FlexGlobals.topLevelApplication);  
			
			imageEditor.name = "editImageImage1";
			imageEditor.source = url;
			imageEditor.imageName = url;
			imageEditor.imageWidth = width;
			imageEditor.imageHeight = height;
			imageEditor.width = application.width;
			imageEditor.height = application.height;
			imageEditor.editMode = true;
			/* imageEditor.imageWidth = ImageLink(event.contextMenuOwner).content.width;
			imageEditor.imageHeight = ImageLink(event.contextMenuOwner).content.height;
			imageEditor.image = ImageLink(event.contextMenuOwner); */
			
			// Setting a module factory allows the correct embedded font to be found.
			if (imageEditor is UIComponent) {
				imageEditor.moduleFactory = UIComponent(imageEditor).moduleFactory;
			}
			
			PopUpManager.addPopUp(imageEditor, DisplayObject(application), modal);
		}
	}
}
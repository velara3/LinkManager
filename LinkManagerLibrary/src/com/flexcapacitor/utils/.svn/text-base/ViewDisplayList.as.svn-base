/**
 * Traverses the display list and outputs MXML
 * 
 * @author - inspired by dude at...
 * http://play.blog2t.net/finding-the-missing-child/
 * 
 * @modified - Judah Frangipane
 * 
 * */

package com.flexcapacitor.utils {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.Application;

	public class ViewDisplayList {

		public var xml:XML;
		public static var staticInstance:ViewDisplayList = new ViewDisplayList();
		
		public function ViewDisplayList() {
			
		}

	    public function traceDisplayList(container:DisplayObjectContainer, xmlNode:* = "", depth:int = 0):String {
	        var currentNode:XML = new XML();
	        
	        if (xmlNode is XML) {
	        	currentNode = xmlNode;
	        }
	        else {
	        	xml = new XML("<"+application.name+"/>");
	        	currentNode = xml;
	        }
			
			var node:XML = new XML("<node/>");
	        var i:int = container.numChildren;

	        while (i--) {
	            var child:DisplayObject = container.getChildAt(i);
	            var className:String = getQualifiedClassName(child);
	            var packageName:String = className.split("::")[0];
	            className = className.split("::")[1];
	            if (className=="UITextField") continue;
	            node = new XML("<node/>");
	            //node.setName(packageName+"."+className);
	            node.setName(className);
	            //node.setNamespace(packageName);
	            //if (child.hasOwnProperty("name") && child['name']!="") node.@name = child["name"];
	            if (child.hasOwnProperty("id") && child['id']!="" && child['id']!=null) node.@id = child["id"];
	            if (child.hasOwnProperty("label") && child['label']!="") node.@label = child["label"];
	            if (child.hasOwnProperty("width") && child['width']!="" && child['width']!=null) node.@width = child["width"];
	            if (child.hasOwnProperty("height") && child['height']!="" && child['height']!=null) node.@height = child["height"];
	            if (child.hasOwnProperty("percentWidth") && !isNaN(child['percentWidth'])) node.@width = child["percentWidth"]+"%";
	            if (child.hasOwnProperty("percentHeight") && !isNaN(child['percentHeight'])) node.@height = child["percentHeight"]+"%";
	            if (child.hasOwnProperty("x") && child['x']!=0) node.@x = child["x"];
	            if (child.hasOwnProperty("y") && child['y']!=0) node.@y = child["y"];
	            if (child.hasOwnProperty("getStyle") && child['getStyle']('top')) node.@top = child['getStyle']('top');
	            if (child.hasOwnProperty("getStyle") && child['getStyle']('left')) node.@left = child['getStyle']('left');
	            if (child.hasOwnProperty("getStyle") && child['getStyle']('right')) node.@right = child['getStyle']('right');
	            if (child.hasOwnProperty("getStyle") && child['getStyle']('bottom')) node.@bottom = child['getStyle']('bottom');
	            if (child.hasOwnProperty("getStyle") && child['getStyle']('verticalCenter')) {
	            	node.@verticalCenter = child['getStyle']('verticalCenter');
	            	delete node.@y;
	            }
	            if (child.hasOwnProperty("getStyle") && child['getStyle']('horizontalCenter')) {
	            	node.@horizontalCenter = child['getStyle']('horizontalCenter');
	            	delete node.@x;
	            }
	            currentNode.appendChild(node);
	
	            if (child is DisplayObjectContainer) {
	            	traceDisplayList(DisplayObjectContainer(child), node, depth + 1);
	            }
	            
	        }
	        
	        if (depth==0) {
	        	trace(xml.toXMLString());
	        	return xml.toXMLString();
	        }
	        return "";
	    }
		
		public function get application():Object {
			return ApplicationUtils.getInstance();
		}
	}
}
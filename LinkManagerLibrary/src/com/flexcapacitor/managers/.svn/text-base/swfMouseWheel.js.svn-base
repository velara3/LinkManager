/**
 * SWFMacMouseWheel v2.0: Mac Mouse Wheel functionality in flash - http://blog.pixelbreaker.com/
 *
 * SWFMacMouseWheel is (c) 2007 Gabriel Bucknall and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * Modified by Judah Frangipane - http: // www.judahfrangipane.com
 *
 */
swfMouseWheel = function() {
	
	var u = navigator.userAgent.toLowerCase();
	var p = navigator.platform.toLowerCase();
	var mac = p ? /mac/.test(p) : /mac/.test(u);
	var items = [];
	
	if(!mac) return null;

	if (typeof(swfMouseWheelItems)!="undefined") {
		items = swfMouseWheelItems;
	}
	
	var getSWF = function (id) {
		if (navigator.appName.indexOf ("Microsoft") !=-1) {
			return window[id];
		} else {
			return window.document[id];
		}
	}
	
	var deltaFilter = function(event) {
		var delta = 0;
        if (event.wheelDelta) {
			delta = event.wheelDelta/120;
			if (window.opera) delta = -delta;
        } else if (event.detail) {
            delta = -event.detail;
        }
        if (event.preventDefault) event.preventDefault();
		return delta;
	}
	
	var deltaDispatcher = function(event) {
		var delta = deltaFilter(event);
		var swf;
		for (var i=0; i<items.length; i++ ) {
			if (event.target.id != items[i]) return;
			swf = getSWF(items[i]);
			if ( typeof( swf.externalMouseEvent ) == 'function' ) swf.externalMouseEvent( delta );
		}
	}
	
	if (window.addEventListener) window.addEventListener('DOMMouseScroll', deltaDispatcher, false);
	window.onmousewheel = document.onmousewheel = deltaDispatcher;
			
	return {
		addItem: function(id) {
			items[items.length] = id;
		}
	};
}();
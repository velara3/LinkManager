function fcSetWindowStatus(url) {
	window.status = url;
}

function fcBookmark (title, url) {
	var useragent = navigator.userAgent.toLowerCase();
	var message = 'Bookmarks do not work with the file:// protocol.\nTest on a http:// server.\n';
	message += '\nTitle: ' + title + '\nBookmark Location: ' + url;
	
	// firefox 
	if (window.sidebar) {
		if (String(document.location).indexOf('file://')>-1) { 
			alert(message);
			return;
		}
		window.sidebar.addPanel(title, url, '');
	}
	else if (window.opera && window.print) {
		var elem = document.createElement('a');
		elem.setAttribute('href',url);
		elem.setAttribute('title',title);
		elem.setAttribute('rel','sidebar');
		elem.click();
	}
	else if (useragent.indexOf("safari") != -1) {
		alert("To bookmark the current page select Add Bookmark from the Bookmark menu");
	}
	else if (document.all) {
		window.external.AddFavorite(url, title);
	}
};

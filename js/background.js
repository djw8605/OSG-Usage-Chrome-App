chrome.app.runtime.onLaunched.addListener(function(launchData) {
    window.open("../main.html");
});




/*
    Listen for settings change events
*/
chrome.runtime.onMessage.addListener( function(request, sender, sendResponse) {
    
    
    if (request.message == "saveSettings") {
        saveSettings(request.settings);
    } else if (request.message = "getSettings") {
        getSettings(sendResponse);
        return true;
    }
    
});


var saveSettings = function(settings) {
    
    json_string = JSON.stringify(settings)
    
    chrome.storage.sync.set( {settings: json_string}, function() {
        if (chrome.runtime.lastError != null) {
            console.log("Error setting settings: " + chrome.runtime.lastError);
        } else {
            console.log("Saving to sync was successful!");
        }
    });
    
}


var getSettings = function(sendResponse) {
    
    chrome.storage.sync.get ('settings', function(items) {
        if ( items.settings != undefined ) {
            settings = JSON.parse(items.settings);
            
        } else {
            settings = {};
        }
        
        
        sendResponse(settings);
        
    });
        
}

extensionId = "alkjffnoibidbaiajhnhbnnfjidkbblf";
chrome.runtime.onMessageExternal.addListener(function(request, sender, sendResponse) {
    // Only trust our extension
    if (sender.id != extensionId)
        return;
        
    else if (request.message == "getProfiles") {
        
        getSettings(function(settings) {
            
            // Format the settings to profile
            profiles = new Array();
            for ( var key in settings.profiles ) {
                profiles.push({name: settings.profiles[key].name, id: settings.profiles[key].id });
            }
            console.log("Got getProfiles... returning:");
            console.log(profiles);
            sendResponse(profiles);
            
        });
        
        return true;
        
    } else {
        console.log("Message not understood:")
        console.log(request)
        
    }
});





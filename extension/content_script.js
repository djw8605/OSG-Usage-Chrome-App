

var addOverlay = function(overlayDiv) {
    textDiv = $('<div></div>')
    .addClass("osg-graph-save-overlay")
    .text("OSG")
    .hover(showProfiles, hoverOut);

    var graphDiv = $( overlayDiv ).parent().append(textDiv);

}

var hoverOut = function(eventObject) {
    $(this).removeClass("osg-graph-save-hover");
    $(this).text("OSG");

    
}


var addGraph = function(graphURL, profileId) {
    console.log("Should add " + graphURL + " to profile: " + profileId);
    
}


var showProfiles = function(eventObject) {
    
    if (profiles == null) {
        $(this).text("Unable to receive profiles from App.<br />Please open the OSG App");
        $(this).addClass("osg-graph-save-hover");
        return;
    }
    
    list = $("<ul></ul>");
    for (profile in profiles) {
        profileId = profiles[profile].id;
        item = $("<li></li>").text(profiles[profile].name).click({profileId: profileId}, function(event) {
            parent = $(this).parent().parent().parent();
            findResults = $(parent).find("img").first();
            
            graphURL = $(findResults).attr("src");
            
            addGraph(graphURL, event.data.profileId);
        });
        list.append(item);
    }
    
    $(this).append(list);
    //$(this).html("<ul><li>Profile A</li><li>Profile B</li></ul>");
    $(this).addClass("osg-graph-save-hover");

    
}

profiles = null;

var getProfiles = function() {
    
    var extensionId = "ibjjppcfhepddgaackdlmafpglnalkfd";
    
    // Connect and get the extension
    chrome.runtime.sendMessage(extensionId, {"message": "getProfiles"}, function(response) {
        if (response == undefined ) {
            console.log("Error sending message to OSG App:");
            console.log(chrome.runtime.lastError);
        } else {
            profiles = response;
            console.log("Got response from other app:");
            console.log(response);
        }
    });
    
}


$( document ).ready(function() {
    
    
    // Get the profiles
    getProfiles();
    
    
    var target = $("img").each(function() {

        // Check if we care about the image
        srcAttr = $(this).attr("src");
        src_re = /^\/gratia\/.*/;
        static_re = /.*static.*/;
        if (!src_re.test(srcAttr) || static_re.test(srcAttr)) {
            return;
        }
        imageDiv = $("<div></div>").addClass("osg-graph-save-graphDiv");
        $(this).wrap(imageDiv);
        var graphDiv = $( this ).parent()
        if (this.complete) {
            graphDiv.width($(this).width());
            graphDiv.height($(this).height());
            addOverlay(this);
        } else {
            $(this).load(function() {
                graphDiv.width($(this).width());
                graphDiv.height($(this).height());
                addOverlay(this);
            });
        }
        
            
    });
    
})







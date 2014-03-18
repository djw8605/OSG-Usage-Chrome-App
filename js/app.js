
osgUsageApp = angular.module('osgUsageApp', ['ui.bootstrap']);

osgUsageApp.controller('OSGUsageViewCtrl', function($scope, $modal, $log) {
    
    $scope.launchProfileCreation = function() {
        $log.info("Opening Profile Creation...");
        var modalInstance = $modal.open({
            templateUrl: 'html/profile_setup.html',
            controller: ProfileSetupControllerInstance
        });
        
        modalInstance.result.then(function(selectedProfile) {
            $scope.selected_profile = selectedProfile;
            
            // First, get the settings object
            chrome.storage.sync.get("settings", function(settings) {
                
                // Modify the settings object accordingly
                settings.default_profile = selectedProfile
                if ( ! settings.hasOwnProperty('profiles')) {
                    settings.profiles = new Array();
                }
                
                // Create the profile
                profile = { 'name': selectedProfile, 'url': selectedProfile };
                settings.profiles.push(profile);
                $scope.profiles = settings.profiles;
                
                // Now set the settings object
                chrome.storage.sync.set({'settings': [ selectedProfile ]}, function() {
                    if (!chrome.runtime.lastError) {
                        $log.info("Set profile to " + selectedProfile); 
                    } else {
                        $log.error("Error setting profile to " + selectedProfile + ": " + chrome.runtime.lastError)
                    }
                });
            });
        });

            
        
    };
    
    // Check for the profiles
    $scope.checkForProfiles = function() {
        $log.info("Checking for profiles...");
        chrome.storage.sync.get("settings", function(items) {
            if (items.hasOwnProperty("default_profile") == 0) {
                $log.info("No profiles detected...prompting for creation");
                $scope.launchProfileCreation();
            } else {
                $log.info("Received profiles");
                $log.info(JSON.stringify(items));
            }
            
        });
        
        
    };
    
    $scope.checkForProfiles();
    
});


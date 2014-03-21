

    
    var ProfileSetupControllerInstance = function($scope, $modalInstance, $http, $log) {

        $http.get('../data/templates.json').success(function(data) {
           $log.info("Got templates data!");
           $scope.templates = data;
           $scope.selected = $scope.templates[0];
        });



        $scope.save = function() {
            $modalInstance.close();
        }

        $scope.cancel = function() {
            $modalInstance.dismiss('cancel');
        }


        $scope.addProfile = function(template) {
    
            $modalInstance.close(template);
        }
        
        $scope.checkRequirements = function(template, requirement) {
            if (template.requirements.indexOf(requirement) > -1)
                return true;
            else
                return false;
        }



    };
    
    angular.module('osgUsageApp.controllers', ['ui.bootstrap', 'osgUsageApp.settings'])
    
    
    .controller('OSGUsageViewCtrl', function($scope, $modal, $log, settingsService, $location) {

        $scope.launchProfileCreation = function() {
            $log.info("Opening Profile Creation...");
            var modalInstance = $modal.open({
                templateUrl: 'html/profile_setup.html',
                controller: ProfileSetupControllerInstance,
                backdrop: 'static'
            });
    
            // Respond to the modal response
            modalInstance.result.then(function(selectedTemplate) {
                
                // Create the profile
                profile = { 'template': selectedTemplate, 'name': selectedTemplate.name };
        
                // Modify the settings object accordingly
                /*
                settings.default_profile = profile
                if ( ! settings.hasOwnProperty('profiles')) {
                    settings.profiles = new Array();
                }
                */
                
                settingsService.addProfile(profile)
                profile_array = new Array();
                profiles = settingsService.getProfiles()
                
                
                for (var key in profiles) {
                    profile_array.push(profiles[key]);
                }
                $scope.profiles = profile_array
                
                $scope.currentProfile = profile;
                $log.info($scope.profiles);
                
                $location.hash("#/profile/" + profile.template.id)
                
                /*
        
                // First, get the settings object
                chrome.storage.sync.get('settings', function(items) {
            
                    if (! items.hasOwnProperty('settings')) {
                        items.settings = new Array();
                    }
                    var settings = items.settings;
            
                    // Create the profile
                    profile = { 'template': selectedTemplate, 'name': selectedTemplate.name };
            
                    // Modify the settings object accordingly
                    settings.default_profile = profile
                    if ( ! settings.hasOwnProperty('profiles')) {
                        settings.profiles = new Array();
                    }
                    settings.profiles.push(profile);
                    $scope.profiles = settings.profiles;
                    $scope.currentProfile = profile;
            
                    // Now set the settings object
                    settingsService.addProfile(profile);
                    
                    chrome.storage.sync.set({'settings': settings }, function() {
                        if (!chrome.runtime.lastError) {
                            $log.info("Set profile to " + selectedProfile); 
                        } else {
                            $log.error("Error setting profile to " + selectedProfile + ": " + chrome.runtime.lastError)
                        }
                    });
                });
                */
            });

        
    
        };

        // Check for the profiles
        $scope.checkForProfiles = function() {
            $log.info("Checking for profiles...");
            chrome.storage.sync.get("settings", function(items) {
                if ( items.hasOwnProperty("settings")) {
                    if ( items.settings.hasOwnProperty("default_profile")) {
                        $log.info("Received profiles");
                        $scope.profiles = items.settings.profiles;
                    } else {
                        $log.info("No profiles detected...prompting for creation");
                        $scope.launchProfileCreation();
                    }
                } else {
                    $log.info("No profiles detected...prompting for creation");
                    $scope.launchProfileCreation();
                }
        
            });
    
    
        };


        $scope.clearProfiles = function() {
            // Remove the profiles and the default profile
            // First, get the settings object
            chrome.storage.sync.get("settings", function(items) {
                delete items.settings.profiles;
                delete items.settings.default_profile;
                delete $scope.profiles
        
                // Now set the settings object
                chrome.storage.sync.set({'settings': items.settings }, function() {
                    if (!chrome.runtime.lastError) {
                        $log.info("Set settings to " + JSON.stringify(settings)); 
                    } else {
                        $log.error("Error setting settings to " + JSON.stringify(settings) + ": " + chrome.runtime.lastError)
                    }
                });
            });
        }

        chrome.storage.sync.remove('settings');
        $scope.checkForProfiles();

    });
    
    
    
    
 


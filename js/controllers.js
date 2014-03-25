

    
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
            
            // Get the query params
            $log.info("Exporting template")
            $log.info(template)
            
            $modalInstance.close(template);
        }
        
        $scope.checkRequirements = function(template, requirement) {
            if (template.requirements.indexOf(requirement) > -1)
                return true;
            else
                return false;
        }



    };
    
    angular.module('osgUsageApp.controllers', [ 'ui.bootstrap', 'osgUsageApp.settings', 
                                                'osgUsageApp.controller.containergraph'])
    
    
    .controller('OSGUsageViewCtrl', function($scope, $modal, $log, settingsService, $location) {

        $scope.launchProfileCreation = function() {
            $log.info("Opening Profile Creation...");
            var modalInstance = $modal.open({
                templateUrl: 'html/profile_setup.html',
                controller: ProfileSetupControllerInstance,
                backdrop: 'static'
            });
    
            // Respond to the modal response
            modalInstance.result.then(function(selectedTemplate, queryParams) {
                
                // Create the profile
                profile = { 'template': selectedTemplate, 'name': selectedTemplate.name,
                            'id': selectedTemplate.id, 'queryParams': queryParams };
        
                
                settingsService.addProfile(profile)
                
                
                // Get the profiles, and put them in the menu
                settingsService.getProfiles().then($scope.updateProfileMenu);
                $scope.currentProfile = profile;
                $scope.redirectToProfile(profile.id);
                
            });
        
    
        };
        
        $scope.redirectToProfile = function(profileId) {
            new_url = "/profile/" + profileId;
            $log.info("Redirecting to " + new_url)
            $location.url(new_url);
        };
        
        $scope.updateProfileMenu = function(profiles) {
            profile_array = new Array();
            for (var key in profiles) {
                profile_array.push(profiles[key]);
            }
            $scope.profiles = profile_array
        };

        // Check for the profiles
        $scope.checkForProfiles = function() {
            $log.info("Checking for profiles...");
            settingsService.getProfiles().then(function(profiles) {
                if (profiles == null) {
                    $log.info("No profiles detected...prompting for creation");
                    $scope.launchProfileCreation();
                } else {
                    $log.info("Received profiles");
                    $scope.updateProfileMenu(profiles);
                    
                    // Get the default profile and redirect to it
                    settingsService.getDefaultProfile().then(function(profile){
                        $scope.currentProfile = profile;
                        $log.info("Default profile is: " + profile.name)
                        $scope.redirectToProfile(profile.id);
                    });
                }
                 
            });
    
        };


        $scope.clearProfiles = function() {
            // Remove the profiles and the default profile
            settingsService.removeProfiles()
        }

        $scope.checkForProfiles();

    });
    
    
    
    
 


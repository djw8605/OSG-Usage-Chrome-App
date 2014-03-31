

    
    var ProfileSetupControllerInstance = function($scope, $modalInstance, $http, $log, $resource) {

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
            $log.info("Exporting template   ")
            
            
            if (template.customURL != null) {
                // Get the JSON from the URL
                var downloaded_profile = $resource(template.customURL).get({}, function() {
                    $log.info("Got downloaded profile:");
                    $log.info(downloaded_profile);
                    // angular.copy(downloaded_profile.profile_json, template);
                    returnDict = {};
                    profile = $.parseJSON(downloaded_profile.profile_json)
                    profile.id = downloaded_profile.id
                    $log.info(profile)
                    $modalInstance.close(profile);
                });
            } else {
                $log.info(template)
                $modalInstance.close(template);
            }
            

        }
        
        $scope.checkRequirements = function(template, requirement) {
            if (template.requirements.indexOf(requirement) > -1)
                return true;
            else
                return false;
        }



    };
    
    angular.module('osgUsageApp.controllers', [ 'ui.bootstrap', 'osgUsageApp.settings', 
                                                'osgUsageApp.controller.containergraph', 'ngResource', 'osgUsageApp.controller.sharedialog'])
    
    
    .controller('OSGUsageViewCtrl', function($scope, $modal, $log, settingsService, $location, $rootScope, $resource) {

        $scope.launchProfileCreation = function() {
            $log.info("Opening Profile Creation...");
            var modalInstance = $modal.open({
                templateUrl: 'html/profile_setup.html',
                controller: ProfileSetupControllerInstance,
                backdrop: 'static'
            });
    
            // Respond to the modal response
            modalInstance.result.then(function(selectedTemplate) {
                
                // The template is now the initial profile!
                profile = selectedTemplate;
                
                settingsService.addProfile(profile);
                
                
                // Get the profiles, and put them in the menu
                settingsService.getProfiles().then($scope.updateProfileMenu);
                $rootScope.profile = profile
                $rootScope.$broadcast('profileUpdate');
                
                $scope.redirectToProfile(profile.id);
                
            });
        
    
        };
        
        $scope.shareProfile = function() {
            // Share the current profile

            var modalInstance = $modal.open({
                templateUrl: 'html/shareDialog.html',
                controller: 'ShareDiaglogCtrl',
            });
            
            

        }
        
        $scope.profileUpdate = function(event) {
            // The profile has been updated, take the rootScope's value and put it in currentProfile
            $log.info("Profile was updated, updating currentProfile");
            $scope.currentProfile = $rootScope.profile
        }
        
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
                        $rootScope.profile = profile;
                        $rootScope.$broadcast('profileUpdate');

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
        
        $scope.$on('profileUpdate', $scope.profileUpdate)
        $scope.checkForProfiles();

    });
    
    
    
    
 


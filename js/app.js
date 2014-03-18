
osgUsageApp = angular.module('osgUsageApp', ['ui.bootstrap']);

osgUsageApp.controller('OSGUsageViewCtrl', function($scope, $modal, $log) {
    
    $scope.launchProfileCreation = function() {
        $log.info("Opening Profile Creation...");
        var modalInstance = $modal.open({
            templateUrl: 'html/profile_setup.html',
            controller: ProfileSetupControllerInstance
        });
        
    };
    
    $scope.checkForProfiles = function() {
        $log.info("Checking for profiles...");
        chrome.storage.sync.get("profiles", function(items) {
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


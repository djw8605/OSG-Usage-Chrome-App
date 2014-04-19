/**
 * $.parseParams - parse query string paramaters into an object.
 */
/*global define*/

define([ 'jquery', 'angular', 'settings', 'ui-bootstrap-tpls', 'angular-resource', 'shareController', 'addGraphCtrl', 'graphContainerCtrl'  ], function ($) {

(function($) {
var re = /([^&=]+)=?([^&]*)/g;
var decodeRE = /\+/g;  // Regex for replacing addition symbol with a space
var decode = function (str) {return decodeURIComponent( str.replace(decodeRE, " ") );};
$.parseParams = function(query) {
    var params = {}, e;
    while ( e = re.exec(query) ) {
        var k = decode( e[1] ), v = decode( e[2] );
        if (k.substring(k.length - 2) === '[]') {
            k = k.substring(0, k.length - 2);
            (params[k] || (params[k] = [])).push(v);
        }
        else params[k] = v;
    }
    return params;
};
})(jQuery);


    var ProfileSetupControllerInstance = function($scope, $modalInstance, $http, $log, $resource) {

        $http.get('data/templates.json').success(function(data) {
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
    ProfileSetupControllerInstance.$inject = [ '$scope', '$modalInstance', '$http', '$log', '$resource' ];


    var mainController = function($scope, $modal, $log, settingsService, $location, $rootScope, $resource) {

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

        $scope.addGraph = function() {
            // Code to add a custom or builtin graph
            modalInstance = $modal.open({
                templateUrl: 'html/add_graph.html',
                controller: 'AddGraphCtrl'
            });

            modalInstance.result.then(function(graph) {
                $log.info("Graph add closed...");
                // Create the 'id' for the graph
                graphId = Math.floor((Math.random()*100000)+1).toString();
                while ($rootScope.profile.graphs.hasOwnProperty(graphId)) {
                    graphId = (parseInt(graphId)+1).toString();
                }


                // Add the graph
                graph.graphId = graphId
                $rootScope.profile.graphs[graphId] = graph

            });


        }

        $scope.editGraphs = function() {
            // Code to edit all graphs

            // Bring up the edit params page
            modalInstance = $modal.open({
                templateUrl: 'html/edit_params.html',
                controller: 'EditParamsCtrl',
                resolve: {
                    queryParams: function () {
                        return $scope.profile.queryParams
                    },

                    graphData: function () {
                        return $scope.profile;
                    },

                    modalTitle: function() {
                        return "Profile Wide Parameters";
                    }
                }
            });

            modalInstance.result.then(function(params) {
                $log.info("Profile graph edit closed...");
                $scope.profile.queryParams = params;
                $rootScope.$broadcast('profileQueryChange', $scope.profile.queryParams);
            });

        }


        $scope.clearProfiles = function() {
            // Remove the profiles and the default profile
            settingsService.removeProfiles()

            // Delete the current profile
            delete $rootScope.profile

            // Redirect to the default profile
            $scope.redirectToProfile('_default')

            $scope.updateProfileMenu(null);
            $rootScope.$broadcast('profileUpdate');

            $scope.checkForProfiles()
        }

        $scope.$on('profileUpdate', $scope.profileUpdate)
        $scope.checkForProfiles();

    }
    mainController.$inject = [ '$scope', '$modal', '$log', 'settingsService', '$location', '$rootScope', '$resource' ];
    //mainController.$inject = [ '$scope', '$modal', '$log', '$location', '$rootScope', '$resource' ];
    return angular.module('osgUsageApp.controllers', [ 'ui.bootstrap', 'osgUsageApp.settings',
                                                'osgUsageApp.controller.containergraph', 'ngResource', 'osgUsageApp.controller.sharedialog',
                                                'osgUsageApp.controller.addgraph'])


    .controller('OSGUsageViewCtrl', mainController);



});

define [ 'angular', 'settings', 'profileService' ], () ->

    graphContainerControllerModule = angular.module 'osgUsageApp.controller.containergraph', ['osgUsageApp.settings', 'osgUsageApp.profileService']

    graphContainerControllerModule.controller 'GraphContainerCtrl',

        class GraphContainerCtrl
            @$inject = ['$scope', '$routeParams', '$log', 'settingsService', '$location', '$rootScope', 'profileService']
            constructor: (@$scope, @$routeParams, @$log, @settingsService, @$location, @$rootScope, @profileService) ->
                @$log.info("Got #{ @$routeParams.profileId }")
                @$log.info("Got #{ @$scope.profile }")
                @settingsService.getProfile(@$routeParams.profileId).then (profile) =>
                    if (! profile? )
                        @$log.warn("Got null for profile, Checking for profile from URL")
                        @profileService.getProfile(@$routeParams.profileId).then (new_profile) =>
                            @settingsService.addProfile(new_profile)
                            @$rootScope.profile = new_profile
                            @$rootScope.$broadcast('profileUpdate');
                            @$log.info("Profile was updated by URL, broadcasting...")
                            @$scope.profile = new_profile
                            @$scope.graphs = new_profile.graphs

                        , (reason) =>
                            @$log.info("Didn't get a profile")

                    else
                        if ( not @$rootScope.profile? or @$rootScope.profile.id != profile.id )
                            @$rootScope.profile = profile
                            @$rootScope.$broadcast('profileUpdate');
                            @$log.info("Profile was updated by URL, broadcasting...")

                        @$log.info("Profile Name: #{profile.name}")
                        @$log.info("Profile Graphs: #{profile.graphs}")
                        @$scope.profile = profile
                        @$scope.graphs = profile.graphs

define [ 'angular', 'settings' ], (angular) ->

    graphContainerControllerModule = angular.module 'osgUsageApp.controller.containergraph', ['osgUsageApp.settings']

    graphContainerControllerModule.controller 'GraphContainerCtrl',

        class GraphContainerCtrl

            constructor: (@$scope, @$routeParams, @$log, @settingsService, @$location, @$rootScope) ->
                @$log.info("Got #{ @$routeParams.profileId }")
                @$log.info("Got #{ @$scope.profile }")
                @settingsService.getProfile(@$routeParams.profileId).then (profile) =>
                    if (! profile? )
                        @$log.warn("Got null for profile, probably at wrong URL.")
                    else
                        if ( not @$rootScope.profile? or @$rootScope.profile.id != profile.id )
                            @$rootScope.profile = profile
                            @$rootScope.$broadcast('profileUpdate');
                            @$log.info("Profile was updated by URL, broadcasting...")

                        @$log.info("Profile Name: #{profile.name}")
                        @$log.info("Profile Graphs: #{profile.graphs}")
                        @$scope.profile = profile
                        @$scope.graphs = profile.graphs


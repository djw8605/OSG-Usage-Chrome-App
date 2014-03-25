graphContainerControllerModule = angular.module 'osgUsageApp.controller.containergraph', ['osgUsageApp.settings']

graphContainerControllerModule.controller 'GraphContainerCtrl',

    class GraphContainerCtrl
        
        constructor: (@$scope, @$routeParams, @$log, @settingsService, @$location) ->
            @$log.info("Got #{ @$routeParams.profileId }")
            @$log.info("Got #{ @$scope.profile }")
            profile = @settingsService.getProfile(@$routeParams.profileId)
            if (! profile? )
                @$log.warn("Got null for profile, probably at wrong URL.")
            else
                profile = @settingsService.getProfile(@$routeParams.profileId)
                @$log.info("Profile Name: #{profile.name}")
                @$log.info("Profile Graphs: #{profile.template.graphs}")
                @$scope.graphs = profile.template.graphs
            
            
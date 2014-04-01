addGraphController = angular.module 'osgUsageApp.controller.addgraph', []

addGraphController.controller 'AddGraphCtrl',

    class AddGraphCtrl
        constructor: (@$scope, @$rootScope, @$log, @$modalInstance) ->
            @$scope.graph = {}
            @$scope.graph.queryParams = {}
            @$scope.addGraph = @addGraph
            @$scope.cancel = @cancel
            
        addGraph: () =>
            graphUrlRegex = /^([\w\:\/\.]*)/
            @$scope.graph.baseUrl = graphUrlRegex.exec(@$scope.graph.baseUrl)[0]
            @$log.info("Got new baseUrl")
            @$log.info(@$scope.graph.baseUrl)
            @$modalInstance.close(@$scope.graph)

            
        cancel: () =>
            $modalInstance.dismiss('cancel')
        
addGraphController = angular.module 'osgUsageApp.controller.addgraph', []

addGraphController.controller 'AddGraphCtrl',

    class AddGraphCtrl
        constructor: (@$scope, @$rootScope, @$log, @$modalInstance) ->
            @$scope.graph = {}
            @$scope.graph.queryParams = {}
            @$scope.addGraph = @addGraph
            @$scope.cancel = @cancel
            
        addGraph: () =>
            
            @$modalInstance.close(@$scope.graph)

            
        cancel: () =>
            $modalInstance.dismiss('cancel')
        
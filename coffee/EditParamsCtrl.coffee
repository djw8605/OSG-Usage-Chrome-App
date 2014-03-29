
editParamsControllerModule = angular.module 'osgUsageApp.controller.editparams', ['osgUsageApp.graphService', 'ui.bootstrap']


editParamsControllerModule.controller 'EditParamsCtrl',

    class EditParamsCtrl
        constructor: (@$scope, @$log, @$modalInstance, @queryParams) ->
            @$scope.params = @queryParams
            @$scope.submitRefineParams = @submitRefineParams
            
        submitRefineParams: () =>
            
            @$modalInstance.close()
            

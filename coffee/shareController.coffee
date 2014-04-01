shareDialogController = angular.module 'osgUsageApp.controller.sharedialog', ['ngResource']

shareDialogController.directive 'selectOnClick', () ->
    toReturn = 
        restrict: 'A',
        link: (scope, element, attrs) =>
            element.on 'click', () -> 
                this.select()
            
        
    



shareDialogController.controller 'ShareDiaglogCtrl',

    class ShareDiaglogCtrl
        constructor: (@$scope, @$rootScope, @$resource, @$log, @$modalInstance) ->
            @$scope.shareProfile = @shareProfile
            @$scope.newProfile = {}

            
        shareProfile: () =>
            # Deep copy the profile
            newProfile = angular.copy(@$rootScope.profile)
            
            # Set the profile's name and description
            newProfile.name = @$scope.newProfile.name
            newProfile.description = @$scope.newProfile.description
            
            strProfile = JSON.stringify(newProfile)
            
            @$scope.loading = true
            
            @$resource("https://osg-gratia-share.appspot.com/api/profile").save strProfile, (value, headers) => 
                @$scope.shareURL = value.url
                @$log.info("Success sharing profile")
                @$log.info(value)
                @$scope.loading = false
                
                
            
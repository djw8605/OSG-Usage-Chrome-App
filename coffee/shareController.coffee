
define ['angular', 'angular-resource' ], () ->

    shareDialogController = angular.module 'osgUsageApp.controller.sharedialog', ['ngResource']

    shareDialogController.directive 'selectOnClick', () ->
        toReturn =
            restrict: 'A',
            link: (scope, element, attrs) =>
                element.on 'click', () ->
                    this.select()






    shareDialogController.controller 'ShareDiaglogCtrl',

        class ShareDiaglogCtrl
            @$inject = ['$scope', '$rootScope', '$resource', '$log', '$modalInstance' ]
            constructor: (@$scope, @$rootScope, @$resource, @$log, @$modalInstance) ->
                @$scope.shareProfile = @shareProfile
                @$scope.closeShare = @closeShare
                @$scope.newProfile = {}


            shareProfile: () =>
                @$scope.errorMessage = null
                # Deep copy the profile
                newProfile = angular.copy(@$rootScope.profile)

                # Set the profile's name and description
                newProfile.name = @$scope.newProfile.name
                newProfile.description = @$scope.newProfile.description

                strProfile = JSON.stringify(newProfile)

                @$scope.loading = true

                @$resource("/api/profile").save strProfile, (value, headers) =>
                    @$scope.shareURL = value.url
                    @$scope.embedURL = value.embed
                    @$log.info("Success sharing profile")
                    @$log.info(value)
                    @$scope.loading = false

                , (httpResponse) =>
                    # Error sharing
                    @$log.error("Error sharing profile")
                    @$log.error(httpResponse)
                    @$scope.loading = false
                    @$scope.errorMessage = "Error sharing profile.  Status: #{httpResponse.status}"


            closeShare: () =>
                @$modalInstance.dismiss()

    return shareDialogController

define [ 'angular' ], () ->

    newProfileCtrl = angular.module 'osgUsageApp.controller.newProfileCtrl', []

    newProfileCtrl.controller 'NewProfileCtrl',

        class NewProfileCtrl
            @$inject = [ '$scope', '$log' ]

            constructor: (@$scope, @$log) ->
                @$log.info("This is a logging test")

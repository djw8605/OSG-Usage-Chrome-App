define [ 'angular', 'graphService', 'ui-bootstrap-tpls' ], (angular) ->

    editParamsControllerModule = angular.module 'osgUsageApp.controller.editparams', ['osgUsageApp.graphService', 'ui.bootstrap']


    dateregex = /^$|^20\d{2}\-\d{2}\-\d{2}\s\d{2}\:\d{2}\:\d{2}$/

    editParamsControllerModule.directive 'inputdate', ->
        return {
            require: 'ngModel',
            link: (scope, element, attrs, ctrl) =>
                ctrl.$parsers.unshift (viewValue) =>
                    if (dateregex.test(viewValue))
                        ctrl.$setValidity('inputdate', true)
                        return viewValue
                    else
                        ctrl.$setValidity('inputdate', false)
                        return undefined




        }


    editParamsControllerModule.controller 'EditParamsCtrl',

        class EditParamsCtrl
            constructor: (@$scope, @$log, @$modalInstance, @queryParams, @graphData, @modalTitle) ->
                @$scope.params = angular.copy(@queryParams)
                @$scope.graphData = @graphData
                @$scope.modalTitle = @modalTitle
                @$scope.submitRefineParams = @submitRefineParams
                @$scope.dismiss = @dismiss

                nowdate = new Date()
                twoWeeksAgo = new Date()
                twoWeeksAgo.setDate(twoWeeksAgo.getDate() - 14)

                @$scope.starttimePlaceholder = @getFormattedDate(twoWeeksAgo)
                @$scope.endtimePlaceholder = @getFormattedDate(nowdate)


            getFormattedDate: (date) ->
                str = date.getFullYear() + "-" + @pad(date.getMonth(), 2) + "-" + @pad(date.getDate(), 2) + " " +  @pad(date.getHours(), 2) + ":" + @pad(date.getMinutes(), 2) + ":" + @pad(date.getSeconds(), 2);
                str

            pad: (num, size) ->
                s = num+"";
                while s.length < size
                    s = "0" + s
                return s;


            submitRefineParams: () =>

                @$modalInstance.close(@$scope.params)

            dismiss: () =>
                @$modalInstance.dismiss()

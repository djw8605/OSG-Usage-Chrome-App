 
app = angular.module('osgUsageApp', ['ui.bootstrap','osgUsageApp.controllers', 'osgUsageApp.settings', 'ngRoute', 'osgUsageApp.controller.graph' ])
.config( [
    '$compileProvider',
    function( $compileProvider )
    {   
        $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|chrome-extension):/);
        // Angular before v1.2 uses $compileProvider.urlSanitizationWhitelist(...)
    }
])

.config(['$routeProvider', 
    function($routeProvider) {
        $routeProvider.
        when( '/profile/:profileId', {
            templateUrl: '../html/graphs.html',
            controller: 'GraphContainerCtrl'
        }).
        otherwise({
            redirectTo: '/profile/_default'
        })
        
        
    }]);
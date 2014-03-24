 
app = angular.module('osgUsageApp', ['ui.bootstrap','osgUsageApp.controllers', 'osgUsageApp.settings', 'ngRoute', 'osgUsageApp.controller.graph' ])
.config( [
    '$compileProvider',
    function( $compileProvider )
    {   
        $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|chrome-extension|filesystem:chrome-extension|blob:chrome-extension):/);
        // Angular before v1.2 uses $compileProvider.urlSanitizationWhitelist(...)
        var currentImgSrcSanitizationWhitelist = $compileProvider.imgSrcSanitizationWhitelist();
        newImgSrcSanitizationWhiteList = currentImgSrcSanitizationWhitelist.toString().slice(0,-1)+'|filesystem:chrome-extension:'+'|blob:chrome-extension%3A'+currentImgSrcSanitizationWhitelist.toString().slice(-1);
        console.log("Changing imgSrcSanitizationWhiteList from "+currentImgSrcSanitizationWhitelist+" to "+newImgSrcSanitizationWhiteList);

        $compileProvider.imgSrcSanitizationWhitelist(newImgSrcSanitizationWhiteList); 
        
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
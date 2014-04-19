/*jslint devel: true */
/*global define  */

define([ 'angular', 'controllers', 'angular-route', 'graph', 'angular-animate', 'NewProfileCtrl' ], function () {

    var app = angular.module('osgUsageApp', [   'ui.bootstrap', 'osgUsageApp.controllers',
                                                'osgUsageApp.settings', 'ngRoute',
                                                'osgUsageApp.controller.graph', 'ngAnimate',
                                                'flash', 'osgUsageApp.controller.newProfileCtrl' ])
        .config([
            '$compileProvider',
            function ($compileProvider) {
                $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|chrome-extension|filesystem:chrome-extension|blob:chrome-extension):/);
                // Angular before v1.2 uses $compileProvider.urlSanitizationWhitelist(...)
                var currentImgSrcSanitizationWhitelist = $compileProvider.imgSrcSanitizationWhitelist(),
                    newImgSrcSanitizationWhiteList = /^\s*(https?|ftp|file|data:image\/|filesystem:chrome-extension|blob:chrome-extension):\//;
                console.log("Changing imgSrcSanitizationWhiteList from " + currentImgSrcSanitizationWhitelist + " to " + newImgSrcSanitizationWhiteList);
                $compileProvider.imgSrcSanitizationWhitelist(newImgSrcSanitizationWhiteList);

            }
        ])

        .config(['$routeProvider',
            function ($routeProvider) {
                $routeProvider.
                    when('/profile/:profileId', {
                        templateUrl: 'html/graphs.html',
                        controller: 'GraphContainerCtrl'
                    }).
                    when('/newprofile', {
                        templateUrl: 'html/newprofile.html',
                        controller: 'NewProfileCtrl'
                    }).
                    otherwise({
                        redirectTo: '/profile/_default'
                    });


            }]);
    return app;
});

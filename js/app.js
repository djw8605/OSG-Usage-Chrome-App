
define([
    'angular',
    'ui-bootstrap-tpls',
    'controllers',
    '../coffee/settings'
    ], function(angular, ui_bootstrap_tpls, controllers) {
        
        
        return angular.module('osgUsageApp', ['ui.bootstrap','osgUsageApp.controllers', 'osgUsageApp.settings' ]);

        
           
    });



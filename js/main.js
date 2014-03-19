require.config({
	paths: {
		angular: 'angular',
	},
	shim: {
        'ui-bootstrap-tpls': {
            'exports': 'angular',
            'deps': ['angular'] },
            
		'angular' : {'exports' : 'angular'}

	},
	priority: [
		"angular"
	]
});

window.name = "NG_DEFER_BOOTSTRAP!";

require([
    "angular",
    "app"
    ], function(angular, app) {
        
     var $html = angular.element(document.getElementsByTagName('html')[0]);
     angular.element().ready(function(){
         angular.resumeBootstrap([app['name']]);
     });   
        
        
    });


require.config({
	paths: {
		angular: 'angular',
	},
	shim: {
        'ui-bootstrap-tpls': {
            'exports': 'angular',
            'deps': ['angular']
        },

        'angular-route': {
		    'export': 'angular',
			'deps': ['angular']
        },

		'angular-resource': {
		    'export': 'angular',
			'deps': ['angular']
        },

        'angular-animate': {
		    'export': 'angular',
			'deps': ['angular']
        },

        'angular-flash': {
            'export': 'angular',
            'deps': ['angular']
        },

		'angular' : {'exports' : 'angular'},

        'jquery': {
            'exports': '$'
        }


	},
	priority: [
		"angular"
	]
});

window.name = "NG_DEFER_BOOTSTRAP!";

require([
    "angular",
    "app"
    ], function(angular_bad, app) {

     var $html = angular.element(document.getElementsByTagName('html')[0]);
     angular.element().ready(function(){
         angular.resumeBootstrap([app['name']]);
     });


    });

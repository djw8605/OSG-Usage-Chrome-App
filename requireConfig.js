({
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
})

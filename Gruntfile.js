module.exports = function(grunt) {

  var destinationFolder = './dist';

  grunt.initConfig({

    // Meta data
    pkg: grunt.file.readJSON('package.json'),
    destinationFolder: destinationFolder,

    clean : [
         '<%= destinationFolder %>'
    ],

    watch: {
      coffee_scripts: {
        files: ['coffee/*.coffee'],
        tasks: ['coffee']
      },
      scripts: {
        files: ['js/*.js'],
        tasks: ['requirejs']
      }
    },

    coffee: {
      glob_to_multiple: {
        expand: true,
        flattein: true,
        cwd: "coffee/",
        src: '*.coffee',
        dest: 'js/',
        ext: '.js'
      },
    },

    requirejs: {
      compile: {
        options: {
          mainConfigFile: 'requireConfig.js',
          baseUrl: "js",
          generateSourceMaps: true,
          preserveLicenseComments: false,
          optimize: 'uglify2',
          //name: 'main',
          modules: [ {
            name: 'main'
          }
          ],
          // out: '<%= destinationFolder %>/js/main.js',
          dir: '<%= destinationFolder %>/js'

        }
      },
      optimize_css: {
        options: {
          baseUrl: "css",
          dir: '<%= destinationFolder %>/css/'
        }
      }
    },

    copy: {
      main: {
        files: [
          {
            expand: true,
            src: 'html/*',
            dest: '<%= destinationFolder %>'
          },
          {
            src: 'main.html',
            dest: 'dist/'
          },
          {
            expand: true,
            src: 'data/*',
            dest: '<%= destinationFolder %>'
          },
          {
            expand: true,
            src: 'fonts/*',
            dest: '<%= destinationFolder %>'
          },
          {
            src: 'js/require.min.js',
            dest: '<%= destinationFolder %>/js/require.min.js'
          }

        ]
      }
    }


  });

  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-requirejs');
  grunt.loadNpmTasks('grunt-contrib-clean');

  grunt.registerTask('default', ['clean', 'coffee', 'requirejs', 'copy']);

};

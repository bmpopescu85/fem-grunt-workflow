module.exports = function(grunt) {

  // task configurations
  var config = {
    concat: {
      app: {
        dest: "generated/js/app.min.js",
        src: [
          "vendor/js/jquery.js",
          "vendor/js/angular.js",
          "vendor/js/underscore.js",
          "vendor/js/base64.js",
          "vendor/js/extend.js",
          "js/config/**/*.js",
          "js/app.js",
          "js/data/**/*.js",
          "js/directives/**/*.js",
          "js/controllers/**/*.js",
          "js/services/**/*.js",
          "js/**/*.js"
        ]
      }
    }
  };

  // initializing task configuration
  grunt.initConfig(config);

  // loading local tasks
  grunt.loadTasks("tasks");

  // loading external tasks (aka: plugins)
  grunt.loadNpmTasks("grunt-contrib-concat");

  // creating workflows
  grunt.registerTask('default', ['concat']);

};

module.exports = (grunt) ->

  # task configurations
  # initializing task configuration
  grunt.initConfig

    # meta data
    pkg: grunt.file.readJSON("package.json")
    banner: "/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - " +
      "<%= grunt.template.today(\"yyyy-mm-dd\") %>\n" +
      "<%= pkg.homepage ? \"* \" + pkg.homepage + \"\\n\" : \"\" %>" +
      "* Copyright (c) <%= grunt.template.today(\"yyyy\") %> <%= pkg.author.name %>;" +
      " Licensed <%= _.pluck(pkg.licenses, \"type\").join(\", \") %> */\n"

    # files that our tasks will use
    files:
      html:
        src: "app/index.html"

      less:
        src: ["app/css/style.less"]

      js:
        vendor: [
          "app/vendor/js/jquery.js"
          "app/vendor/js/angular.js"
          "app/vendor/js/underscore.js"
          "app/vendor/js/base64.js"
          "app/vendor/js/extend.js"
        ]

        src: [
          "app/js/config/**/*.js"
          "app/js/app.js"
          "app/js/data/**/*.js"
          "app/js/directives/**/*.js"
          "app/js/controllers/**/*.js"
          "app/js/services/**/*.js"
          "app/js/**/*.js"
        ]

    clean:
      workspaces: ["dist", "generated"]

    # create the style.css file from style.less file
    less:
      options:
        paths: ["app/css"]
        ieCompat: false

      dev:
        src: "<%= files.less.src %>"
        dest: "generated/css/style.css"

      dist:
        options:
          cleancss: true
          compress: true
        src: "<%= files.less.src %>"
        dest: "dist/css/style.css"

    # create the JS file
    concat:
      js:
        src: ["<%= files.js.vendor %>", "<%= files.js.src %>"]
        dest: "generated/js/app.min.js"

    uglify:
      options:
        banner: "<%= banner %>"

      dist:
        src: "<%= concat.js.dest %>" # input from the concat process
        dest: "dist/js/app.min.js"

    # copy the html files
    copy:
      html:
        files:
          "generated/index.html" : "<%= files.html.src %>"
          "dist/index.html"      : "<%= files.html.src %>"

    server:
      webRoot: "#{process.env.SERVER_BASE || 'generated'}"
      web:
        port: 8000

    open:
      dev:
        path: "http://localhost:<%= server.web.port %>"

    watch:
      options:
        livereload: true

      # targets for watch
      html:
        files: ["<%= files.html.src %>"]
        tasks: ["copy"]

      js:
        files: ["<%= files.js.vendor %>", "<%= files.js.src %>"]
        tasks: ["concat"]

      less:
        files: ["<%= files.less.src %>"]
        tasks: ["less:dev"]



  # loading local tasks
  grunt.loadTasks "tasks"

  # loading external tasks (aka: plugins)
  # Loads all plugins that match "grunt-", in this case all of our current plugins
  require('matchdep').filterAll('grunt-*').forEach(grunt.loadNpmTasks)

  # creating workflows
  grunt.registerTask "default", ["less:dev", "concat", "copy", "server", "open", "watch"]
  grunt.registerTask "build", ["clean", "less:dist", "concat", "uglify", "copy"]
  grunt.registerTask "prodsim", ["build", "server", "open", "watch"]

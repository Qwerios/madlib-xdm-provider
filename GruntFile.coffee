module.exports = ( grunt ) ->

    sourceFiles = [ "./src/index.coffee" ]
    watchFiles  = [ "./src/**/*.coffee", "./src/**/*/js", "./src/**/*.html" ]

    pkg = grunt.file.readJSON( "package.json" )

    # Project configuration
    #
    grunt.initConfig
        pkg:    pkg

        # Clean the distribution folder
        #
        clean:
            dist:
                src: [ "dist" ]

            uglify:
                src: [ "dist/src/xdm.js" ]

        # Watch the files for changes and rebuild as needed
        #
        watch:
            options:
                livereload: true

            src:
                files: watchFiles
                tasks: [ "browserify:watch", "copy:dist", "string-replace:debug" ]


        # Bundle the code modules
        #
        browserify:
            dist:
                files:
                    "dist/src/xdm.js": sourceFiles

                options:
                    browserifyOptions:
                        extensions:         [ ".coffee" ]

            debug:
                files:
                    "dist/src/xdm.js": sourceFiles

                options:
                    browserifyOptions:
                        extensions:         [ ".coffee" ]

                    bundleOptions:
                        debug:              true

            watch:
                files:
                    "dist/src/xdm.js": sourceFiles

                options:
                    watch:                  true

                    browserifyOptions:
                        extensions:         [ ".coffee" ]

                    bundleOptions:
                        debug:              true

        # Optimize the JavaScript code
        #
        uglify:
            dist:
                files:
                    "dist/src/xdm.min.js": [ "dist/src/xdm.js" ]

        # Add the build number to the bundle loader for cache busting reasons
        #
        "string-replace":
            dist:
                files:
                    "dist/src/index.html": "src/index.html"
                options:
                    replacements: [
                        pattern:        "xdm.min.js"
                        replacement:    "xdm.min.js?build=" + pkg.version
                    ]
            debug:
                files:
                    "dist/src/index.html": "src/index.html"
                options:
                    replacements: [
                        pattern:        "xdm.min.js"
                        replacement:    "xdm.js?build=" + pkg.version
                    ]

        # Prepare the dist folder
        #
        copy:
            dist:
                files:
                    [
                        expand: true
                        cwd: "src"
                        src:
                            [
                                "**/*"
                                "!**/*.coffee"
                            ]
                        dest: "dist/src"
                    ,
                        expand: true
                        cwd: "node_modules/madlib-shim-easyxdm/lib"
                        src:
                            [
                                "easyxdm.swf"
                            ]
                        dest: "dist/src"
                    ]

        # Create the distribution archive
        #
        compress:
            dist:
                options:
                    archive: "dist/<%= pkg.name %>-<%= pkg.version %>.zip"
                expand: true
                cwd:    "dist/src"
                src:    [ "**/*" ]
                dest:   "."

            debug:
                options:
                    archive: "dist/<%= pkg.name %>-<%= pkg.version %>-DEBUG.zip"
                expand: true
                cwd:    "dist/src"
                src:    [ "**/*" ]
                dest:   "."


        mochaTest:
            test:
                options:
                    reporter:   "spec"
                    require:    "coffee-script"
                    timeout:    30000
                src: [ "test/**/*.js", "test/**/*.coffee" ]


    # These plug-ins provide the necessary tasks
    #
    grunt.loadNpmTasks "grunt-browserify"
    grunt.loadNpmTasks "grunt-contrib-watch"
    grunt.loadNpmTasks "grunt-contrib-clean"
    grunt.loadNpmTasks "grunt-contrib-copy"
    grunt.loadNpmTasks "grunt-contrib-compress"
    grunt.loadNpmTasks "grunt-contrib-uglify"
    grunt.loadNpmTasks "grunt-mocha-test"
    grunt.loadNpmTasks "grunt-string-replace"

    # Default tasks
    #
    grunt.registerTask "default",
    [
        "clean:dist"
        "browserify:dist"
        "uglify:dist"
        "clean:uglify"
        "copy:dist"
        "string-replace:dist"
        "compress:dist"
    ]

    grunt.registerTask "debug",
    [
        "clean:dist"
        "browserify:debug"
        "copy:dist"
        "string-replace:debug"
        "compress:debug"
    ]

    grunt.registerTask "test",
    [
        "mochaTest"
    ]
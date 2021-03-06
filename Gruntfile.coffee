module.exports = (grunt) ->

  grunt.initConfig

    clean: ['dist', '.tmp']

    copy:
      bower:
        files: [
          expand: true
          src: 'bower_components/**'
          dest: 'dist/'
        ]

    coffee:
      lib:
        files: [
          expand: true
          src: '**/*.coffee'
          dest: 'dist/lib'
          cwd: 'lib'
          ext: '.js'
        ]
      test:
        files:
          'test/test.js': 'test/*.coffee'
      bower:
        files:
          '.tmp/concat/lib.js': ['lib/geekywalletlib.coffee']
      app:
        files:
          'dist/app.js': 'app/app.coffee'
          'dist/wallet.js': 'app/scripts/**/*.coffee'

    concat:
      options:
        banner: grunt.file.read 'dist-banner'
        footer: grunt.file.read 'dist-footer'
      bower:
        src: [
          '.tmp/concat/parser.js',
          '.tmp/concat/lib.js'
        ],
        dest: 'dist/geekywallet.js'

    jade:
      app:
        files: [
          expand: true
          src: '**/*.jade'
          dest: 'dist'
          cwd: 'app/views'
          ext: '.html'
        ]

    mochaTest:
      test:
        options:
          reporter: 'spec'
        src: ['test/**/*.js']

    watch:
      app:
        files: [
          '**/*.coffee'
          '**/*.jade'
        ]
        tasks: ['build']
      test:
        files: ['**/*.coffee', '**/*.wallet']
        tasks: ['test']
        options:
          atBegin: true

    peg:
      wallet:
        src: 'lib/syntax/grammar.peg'
        dest: 'dist/lib/syntax/parser.js'
        options:
          exportVar: 'parser'
      bower:
        src: 'lib/syntax/grammar.peg'
        dest: '.tmp/concat/parser.js'
        options:
          exportVar: 'parser'

    file_append:
      default_options:
        files:
          'dist/lib/syntax/parser.js':
            append: 'define(function() { return parser; });'
            input: 'dist/lib/syntax/parser.js'

    connect:
      options:
        port: 9000
        hostname: '0.0.0.0'
        livereload: 35729
      dist:
        options:
          base: 'dist'

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-peg'
  grunt.loadNpmTasks 'grunt-file-append'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-concat'

  grunt.registerTask 'test', ['coffee:test', 'coffee:lib', 'mochaTest']
  grunt.registerTask 'build', ['clean', 'coffee:bower', 'peg', 'concat:bower']
  grunt.registerTask 'app', ['clean', 'copy:bower', 'coffee:lib', 'coffee:app', 'jade:app', 'peg', 'file_append']
  grunt.registerTask 'serve', ['app', 'connect', 'watch:app']

  grunt.registerTask 'default', 'build'

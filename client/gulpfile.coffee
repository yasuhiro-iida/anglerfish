gulp = require 'gulp'
plumber = require 'gulp-plumber'
jade = require 'gulp-jade'
stylus = require 'gulp-stylus'
coffee = require 'gulp-coffee'
browserSync = require('browser-sync').create()

gulp.task 'browser-sync', ['coffee', 'jade', 'stylus'], ->
  browserSync.init
    server:
      baseDir: './dist'
      routes:
        '/bower_components': 'bower_components'

  gulp.watch './src/*.jade', ['jade'], browserSync.reload
  gulp.watch './src/stylus/*.stylus', ['stylus'], browserSync.reload
  gulp.watch './src/coffee/*.coffee', ['coffee'], browserSync.reload

gulp.task 'jade', ->
  gulp.src './src/*.jade'
    .pipe jade
      pretty: true
    .pipe gulp.dest './dist'
    .pipe browserSync.stream()

gulp.task 'stylus', ->
  gulp.src './src/stylus/*.stylus'
    .pipe plumber()
    .pipe stylus()
    .pipe gulp.dest './dist/css'
    .pipe browserSync.stream()

gulp.task 'coffee', ->
  gulp.src './src/coffee/*.coffee'
    .pipe plumber()
    .pipe coffee()
    .pipe gulp.dest './dist/js'
    .pipe browserSync.stream()

gulp.task 'default', ['browser-sync']

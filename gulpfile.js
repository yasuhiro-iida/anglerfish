var gulp = require('gulp');
var jade = require('gulp-jade');
var stylus = require('gulp-stylus');
var browserSync = require('browser-sync').create();

gulp.task('browser-sync', ['app', 'jade', 'stylus'], function() {
  browserSync.init({
    server: {
      baseDir: './dist',
      routes: {
        '/bower_components': 'bower_components'
      }
    }
  });

  gulp.watch('./src/app.js', ['app'], browserSync.reload);
  gulp.watch('./src/*.jade', ['jade'], browserSync.reload);
  gulp.watch('./src/stylus/*.stylus', ['stylus'], browserSync.reload);
});

gulp.task('app', function() {
  gulp.src('./src/app.js')
    .pipe(gulp.dest('./dist'));
});

gulp.task('jade', function() {
  return gulp.src('./src/*.jade')
    .pipe(jade({
      pretty: true
    }))
    .pipe(gulp.dest('./dist'))
    .pipe(browserSync.stream());
});

gulp.task('stylus', function() {
  return gulp.src('./src/stylus/*.stylus')
    .pipe(stylus())
    .pipe(gulp.dest('./dist/css'))
    .pipe(browserSync.stream());
});

gulp.task('default', ['browser-sync']);

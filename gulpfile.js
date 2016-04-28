var gulp = require('gulp');
var jade = require('gulp-jade');
var browserSync = require('browser-sync').create();

gulp.task('browser-sync', ['jade'], function() {
  browserSync.init({
    server: {
      baseDir: './dist',
      routes: {
        '/bower_components': 'bower_components',
        '/app.js': 'app.js'
      }
    }
  });

  gulp.watch('./**/*.jade', ['jade-watch']);
});

gulp.task('jade-watch', ['jade'], browserSync.reload);

gulp.task('jade', function() {
  return gulp.src('./**/*.jade')
    .pipe(jade({
      pretty: true
    }))
    .pipe(gulp.dest('./dist'))
    .pipe(browserSync.stream());
});

gulp.task('default', ['browser-sync']);

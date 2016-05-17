gulp = require('gulp')
plumber = require('gulp-plumber')
coffee = require('gulp-coffee')
coffeelint = require('gulp-coffeelint')
nodemon = require('gulp-nodemon')

gulp.task('nodemon', ['coffee', 'coffeelint'], ->
  nodemon({
    script: 'server.js'
    ext: 'coffee'
    env: { 'NODE_ENV': 'development' }
    tasks: ['coffee', 'coffeelint']
  })
)

gulp.task('coffee', ->
  gulp.src(['./server.coffee', './coffee/**/*.coffee'])
    .pipe(plumber())
    .pipe(coffee())
    .pipe(gulp.dest('./'))
)

gulp.task('coffeelint', ->
  gulp.src(['./server.coffee', './coffee/**/*.coffee'])
    .pipe(coffeelint())
    .pipe(coffeelint.reporter('coffeelint-stylish'))
)

gulp.task('default', ['nodemon'])

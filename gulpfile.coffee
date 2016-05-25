gulp = require('gulp')
plumber = require('gulp-plumber')
jade = require('gulp-jade')
stylus = require('gulp-stylus')
coffee = require('gulp-coffee')
coffeelint = require('gulp-coffeelint')
ngConstant = require('gulp-ng-constant')
bsync = require('browser-sync').create()
Server = require('karma').Server
nodemon = require('gulp-nodemon')

console.log()

sources = {
  jade: './src/client/**/*.jade'
  stylus: './src/client/stylus/**/*.stylus'
  coffeeClient: './src/client/coffee/**/*.coffee'
  coffeeServer: './src/server/coffee/**/*.coffee'
}

gulp.task('jade', ->
  gulp.src(sources.jade)
    .pipe(jade(pretty: true))
    .pipe(gulp.dest('./dist'))
    .pipe(bsync.stream())
)

gulp.task('stylus', ->
  gulp.src(sources.stylus)
    .pipe(plumber())
    .pipe(stylus())
    .pipe(gulp.dest('./dist/css'))
    .pipe(bsync.stream())
)

gulp.task('coffee-client', ->
  gulp.src(sources.coffeeClient)
    .pipe(plumber())
    .pipe(coffee())
    .pipe(gulp.dest('./dist/js'))
    .pipe(bsync.stream())
)

gulp.task('coffee-server', ->
  gulp.src(sources.coffeeServer)
    .pipe(plumber())
    .pipe(coffee())
    .pipe(gulp.dest('./server'))
    .pipe(bsync.stream())
)

gulp.task('coffeelint', ->
  gulp.src([sources.coffeeClient, sources.coffeeServer])
    .pipe(coffeelint())
    .pipe(coffeelint.reporter('coffeelint-stylish'))
)

gulp.task('sdk', ->
  gulp.src('./src/client/sdk/lb-services.js')
    .pipe(gulp.dest('./dist/js'))
)

gulp.task('config', ->
  config = require('./config.json')
  ngConstant({
    constants: config.constants[process.env.DEPLOY_ENV || 'development']
    stream: true
    name: config.name
    deps: config.deps
  })
    .pipe(gulp.dest('./dist/js'))
)

gulp.task('browser-sync', ['jade', 'stylus', 'coffee-client', 'sdk', 'config', 'start-server'], ->
  bsync.init(
    server:
      baseDir: './dist'
  )

  gulp.watch(sources.jade, ['jade'], bsync.reload)
  gulp.watch(sources.stylus, ['stylus'], bsync.reload)
  gulp.watch(sources.coffeeClient, ['coffee-client'], bsync.reload)
)

gulp.task('start-server', ['coffee-server'], ->
  nodemon({
    script: './server/server.js'
    ext: 'coffee'
    env: { 'NODE_ENV': 'development' }
    tasks: ['coffee-server']
  })
)

gulp.task('default', ['browser-sync'])

gulp.task('test', ['config', 'sdk'], (done) ->
  new Server(configFile: __dirname + '/karma.conf.coffee', done)
    .start()
)

gulp.task('test-singlerun', ['config', 'sdk'], (done) ->
  new Server({
    configFile: __dirname + '/karma.conf.coffee'
    singleRun: true
  }
  , done)
    .start()
)

gulp.task('compile', ['jade', 'stylus', 'coffee-client', 'coffee-server', 'sdk', 'config'])

gulp.task('lint', ['coffeelint'])

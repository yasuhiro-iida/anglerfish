module.exports = (config) ->
  config.set(

    basePath: ''

    frameworks: ['jasmine']

    files: [
      './dist/bower_components/angular/angular.min.js'
      './dist/bower_components/angular-resource/angular-resource.min.js'
      './dist/bower_components/angular-mocks/angular-mocks.js'
      './src/client/coffee/**/*.coffee'
      './test/unit/coffee/**/*Spec.coffee'
      './src/client/sdk/*.js'
    ]

    exclude: [
    ]

    preprocessors:
      './src/client/coffee/**/*.coffee': ['coverage']
      './test/unit/coffee/**/*Spec.coffee': ['coffee']

    coffeePreprocessor:
      options:
        sourceMap: true

    reporters: ['progress', 'coverage']

    coverageReporter:
      type: 'html'
      dir: 'coverage'
      instrumenters:
        ibrik : require('ibrik')
      instrumenter:
        '**/*.coffee': 'ibrik'

    port: 9876

    colors: true

    logLevel: config.LOG_INFO

    autoWatch: true

    browsers: ['Chrome']

    plugins: [
      'karma-chrome-launcher'
      'karma-jasmine'
      'karma-coffee-preprocessor'
      'karma-coverage'
    ]

    singleRun: false

    concurrency: Infinity
  )

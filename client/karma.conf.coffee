module.exports = (config) ->
  config.set

    basePath: ''

    frameworks: ['jasmine']

    files: [
      './bower_components/angular/angular.min.js',
      './bower_components/angular-mocks/angular-mocks.js',
      './src/coffee/*.coffee',
      './test/unit/coffee/*Spec.coffee'
    ]

    exclude: [
    ]

    preprocessors:
      './src/coffee/*.coffee': ['coffee']
      './test/unit/coffee/*Spec.coffee': ['coffee']

    reporters: ['progress']

    port: 9876

    colors: true

    logLevel: config.LOG_INFO

    autoWatch: true

    browsers: ['Chrome']

    plugins: [
      'karma-chrome-launcher',
      'karma-jasmine',
      'karma-coffee-preprocessor'
    ]

    singleRun: false

    concurrency: Infinity

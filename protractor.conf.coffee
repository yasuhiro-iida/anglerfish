exports.config = {

  specs: ['e2e/*.coffee']

  seleniumServerJar: './node_modules/protractor/selenium/selenium-server-standalone-2.52.0.jar'

  capabilities: {
    'browserName': 'chrome'
  }

  baseUrl: 'http://localhost:8000/'

  framework: 'jasmine'

  plugins: [
    package: "protractor-coffee-preprocessor"
  ]

  # jasmineNodeOpts: {
  #   showColors: true
  #   includeStackTrace: true
  #   defaultTimeoutInterval: 30000
  # }
}

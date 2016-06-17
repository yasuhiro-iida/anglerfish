describe('サインアップテスト', ->
  emailField = element(By.model('vm.email'))
  passwordField = element(By.model('vm.password'))
  signUpBtn = element(By.css('button[type=submit]'))

  hasClass = (element, cls) ->
    return element.getAttribute('class').then((classes) ->
      return classes.split(' ').indexOf(cls) != -1
    )

  beforeEach(->
    browser.get('/#/signup')
    browser.waitForAngular()
  )

  it('サインアップできる', ->
    emailField.sendKeys('qux@qux.com')
    passwordField.sendKeys('qux')
    signUpBtn.click()

    expect(browser.getLocationAbsUrl()).toEqual('/login')
  )

  it('EmailとPassword入力は必須である', ->
    signUpBtn.click()

    expect(browser.getLocationAbsUrl()).toEqual('/signup')
    expect(hasClass(emailField, 'ng-invalid-required')).toBe(true)
    expect(hasClass(passwordField, 'ng-invalid-required')).toBe(true)
  )

  it('Emailの入力形式チェックが有効である', ->
    emailField.sendKeys('foo')
    passwordField.sendKeys('foo')
    signUpBtn.click()

    expect(browser.getLocationAbsUrl()).toEqual('/signup')
    expect(hasClass(emailField, 'ng-invalid-email')).toBe(true)
  )
)

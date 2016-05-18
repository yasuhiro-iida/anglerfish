module.exports = (app) ->
  User = app.models.User
  User.create({email: 'foo@foo.com', password: 'foo'}, (err, user) ->
    console.log(user)
  )

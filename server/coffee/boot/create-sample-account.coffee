module.exports = (app) ->
  Account = app.models.Account
  ToDo = app.models.ToDo

  accounts = [
    {email: 'foo@foo.com', password: 'foo'}
    {email: 'bar@bar.com', password: 'bar'}
    {email: 'baz@baz.com', password: 'baz'}
  ]

  createTodos = (account) ->
    name = account.email.split('@')[0]
    [
      {title: name + '-task1', done: false, accountId: account.id}
      {title: name + '-task2', done: true, accountId:  account.id}
      {title: name + '-task3', done: false, accountId: account.id}
    ]

  Account.create(accounts, (err, accounts) ->
    for account in accounts
      todos = createTodos(account)
      ToDo.create(todos, (err, todos) ->

        console.log(todos)
      )
  )

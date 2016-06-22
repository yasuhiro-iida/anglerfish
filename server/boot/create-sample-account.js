var async = require('async');

module.exports = function(app) {
  var ds = app.dataSources.mysqlDs;
  var fns;

  if (process.env.NODE_ENV === 'production') {
    fns = [update];
  } else {
    fns = [migrate, createAccounts, createTodos];
  }

  async.waterfall(fns, function(err, result) {
    if (err) console.log('Error: ' + err);
    console.log('DB connection Success!');
  });

  function update(callback) {
    ds.isActual(function(err, actual) {
      if (err) callback(err);

      if (!actual) {
        ds.autoupdate(function(err) {
          if (err) callback(err);
        });
      }
      console.log('Model is synced. Migration not needed.')
      callback();
    });
  }

  function migrate(callback) {
    ds.automigrate(function(err) {
      if (err) callback(err);
      callback();
    });
  }

  function createAccounts(callback) {
    var accounts = [
      {
        email: 'foo@foo.com',
        password: 'foo'
      },
      {
        email: 'bar@bar.com',
        password: 'bar'
      },
      {
        email: 'baz@baz.com',
        password: 'baz'
      }
    ];

    app.models.Account.create(accounts, callback);
  }

  function createTodos(accounts, callback) {
    var todos = [];
    for (var i = 0, len = accounts.length; i < len; i++) {
      todos.push(createSampleTodo(accounts[i]));
    }
    app.models.ToDo.create(todos, callback);

    function createSampleTodo(account) {
      var name = account.email.split('@')[0];
      return [
        {
          title: name + '-task1',
          done: false,
          registeredAt: new Date(2016, 4-1, 1),
          accountId: account.id
        },
        {
          title: name + '-task2',
          done: true,
          registeredAt: new Date(2016, 4-1, 1),
          accountId: account.id
        },
        {
          title: name + '-task3',
          done: false,
          registeredAt: new Date(2016, 4-1, 1),
          accountId: account.id
        }
      ];
    }
  }

};

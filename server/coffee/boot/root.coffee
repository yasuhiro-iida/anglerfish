module.exports = (server) ->
  router = server.loopback.Router()
  router.get('/', server.loopback.status())
  server.use(router)

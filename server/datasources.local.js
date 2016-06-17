module.exports = {
  mysqlDs: {
    host: process.env.DB_HOST || '192.168.99.100',
    port: process.env.DB_PORT || 3306,
    database: process.env.DB_DATABASE || "ebdb",
    username: process.env.DB_USERNAME || "anglerfish",
    password: process.env.DB_PASSWORD || "^anglerfish$"
  }
}

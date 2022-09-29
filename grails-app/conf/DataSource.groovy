dataSource {
        driverClassName = "org.postgresql.Driver"
        dialect = "custom.dialect.postgres.TableNameSequencePostgresDialect"
}

// environment specific settings
environments {
        development {
                dataSource {
                        pooled = false
                        dbCreate = "update"
                        url = "jdbc:postgresql://localhost:5438/etude"
                        username = "etude"
                        password = "etude"
                }
        }
        test {
                dataSource {
                        dbCreate = "update"
                        url = "jdbc:postgresql://localhost:5432/etudetest"
                        username = "sa"
                        password = ""
                }
        }
        production {
                dataSource {
                        dbCreate = "update"
                      String dbName = System.env.RDS_DB_NAME ?: "etude";
                      String _username = System.env.RDS_USERNAME ?: "etude";
                      String _password = System.env.RDS_PASSWORD ?: "etude";
                      String hostname = System.env.RDS_HOSTNAME ?: "localhost";
                      String port = System.env.RDS_PORT ?: "5432";
                      String jdbcUrl = "jdbc:postgresql://" + hostname + ":" + port + "/" + dbName + "?user=" + _username + "&password=" + _password;
                        url = jdbcUrl
                        username = _username
                        password = _password
                }
        }
}

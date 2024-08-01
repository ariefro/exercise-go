package main

import (
	"database/sql"
	"log"

	"github.com/ariefro/simple-transaction/api"
	db "github.com/ariefro/simple-transaction/db/sqlc"
	"github.com/ariefro/simple-transaction/util"
	_ "github.com/lib/pq"
)

func main() {
	config, err := util.LoadConfig(".")
	if err != nil {
		log.Fatal("cannont load config: ", err)
	}

	var conn *sql.DB
	if config.Environment == "local" {
		conn, err = sql.Open(config.DBDriver, config.DBSourceDev)
	} else {
		conn, err = sql.Open(config.DBDriver, config.DBSource)
	}
	if err != nil {
		log.Fatal("cannot connect to db:", err)
	}

	store := db.NewStore(conn)
	server, err := api.NewServer(config, store)

	err = server.Start(config.ServerAddress)
	if err != nil {
		log.Fatal("cannot start server:", err)
	}
}

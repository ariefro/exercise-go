package main

import (
	"database/sql"
	"log"
	"net"

	db "github.com/ariefro/simple-transaction/db/sqlc"
	"github.com/ariefro/simple-transaction/gapi"
	"github.com/ariefro/simple-transaction/pb"
	"github.com/ariefro/simple-transaction/util"
	_ "github.com/lib/pq"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
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
	runGrpcServer(config, store)
}

func runGrpcServer(config util.Config, store db.Store) {
	server, err := gapi.NewServer(config, store)
	if err != nil {
		log.Fatal("cannot create server: ", err)
	}

	grpcServer := grpc.NewServer()
	pb.RegisterSimpleTransactionServer(grpcServer, server)
	reflection.Register(grpcServer)

	listener, err := net.Listen("tcp", config.GRPCServerAddress)
	if err != nil {
		log.Fatal("cannot create listener: ", err)
	}

	log.Printf("start gRPC server at %s", listener.Addr().String())
	if err := grpcServer.Serve(listener); err != nil {
		log.Fatal("cannot start gRPC server: ", err)
	}
}

// func runHttpServer(config util.Config, store db.Store) {
// 	server, err := api.NewServer(config, store)
// 	if err != nil {
// 		log.Fatal("cannot create server:", err)
// 	}

// 	if err := server.Start(config.HttpServerAddress); err != nil {
// 		log.Fatal("cannot start server:", err)
// 	}
// }

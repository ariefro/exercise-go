package gapi

import (
	"fmt"

	db "github.com/ariefro/simple-transaction/db/sqlc"
	"github.com/ariefro/simple-transaction/middlewares"
	"github.com/ariefro/simple-transaction/pb"
	"github.com/ariefro/simple-transaction/util"
)

// Server serves gRPC requests
type Server struct {
	pb.UnimplementedSimpleTransactionServer
	config     util.Config
	store      db.Store
	tokenMaker middlewares.Maker
}

// NewServer creates a new gRPC server
func NewServer(config util.Config, store db.Store) (*Server, error) {
	tokenMaker, err := middlewares.NewPasetoMaker(config.TokenSymmetricKey)
	if err != nil {
		return nil, fmt.Errorf("cannot create token maker: %w", err)
	}

	server := &Server{
		config:     config,
		store:      store,
		tokenMaker: tokenMaker,
	}

	return server, nil
}

package api

import (
	db "github.com/ariefro/go-exercise/db/sqlc"
	"github.com/gin-gonic/gin"
)

// Server serves HTTP requests
type Server struct {
	store  *db.Store
	router *gin.Engine
}

// NewServer creates a new HTTP server and setup routing.
func NewServer(store *db.Store) *Server {
	server := &Server{store: store}
	router := gin.Default()

	router.POST("/api/accounts", server.createAccount)
	router.GET("/api/account/:id", server.getAccount)
	router.GET("/api/accounts", server.listAccount)
	router.PUT("/api/account", server.updateAccount)
	router.DELETE("/api/account/:id", server.deleteAccount)

	server.router = router
	return server
}

func errorResponse(err error) gin.H {
	return gin.H{"error_message": err.Error()}
}

func (server *Server) Start(address string) error {
	return server.router.Run(address)
}

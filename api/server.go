package api

import (
	db "github.com/ariefro/go-exercise/db/sqlc"
	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
	"github.com/go-playground/validator/v10"
)

// Server serves HTTP requests
type Server struct {
	store  db.Store
	router *gin.Engine
}

// NewServer creates a new HTTP server and setup routing.
func NewServer(store db.Store) *Server {
	server := &Server{store: store}
	router := gin.Default()

	// register the custom currency validator
	if v, ok := binding.Validator.Engine().(*validator.Validate); ok {
		v.RegisterValidation("currency", validCurrency)
	}

	router.POST("/api/sign-up", server.createUser)

	router.POST("/api/accounts", server.createAccount)
	router.GET("/api/account/:id", server.getAccount)
	router.GET("/api/accounts", server.listAccount)
	router.PUT("/api/account", server.updateAccount)
	router.DELETE("/api/account/:id", server.deleteAccount)

	router.POST("/api/transfers", server.createTransfer)

	server.router = router
	return server
}

func errorResponse(err error) gin.H {
	return gin.H{"error_message": err.Error()}
}

func (server *Server) Start(address string) error {
	return server.router.Run(address)
}

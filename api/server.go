package api

import (
	"fmt"

	db "github.com/ariefro/go-exercise/db/sqlc"
	"github.com/ariefro/go-exercise/middlewares"
	"github.com/ariefro/go-exercise/util"
	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
	"github.com/go-playground/validator/v10"
)

// Server serves HTTP requests
type Server struct {
	config     util.Config
	store      db.Store
	tokenMaker middlewares.Maker
	router     *gin.Engine
}

func (server *Server) setupRouter() {
	router := gin.Default()

	api := router.Group("/api")
	api.POST("/user/register", server.createUser)
	api.POST("/user/login", server.loginUser)
	api.POST("/refresh-access", server.renewAccessToken)

	authRoutes := api.Use(authMiddleware(server.tokenMaker))
	authRoutes.POST("/accounts", server.createAccount)
	authRoutes.GET("/account/:id", server.getAccount)
	authRoutes.GET("/accounts", server.listAccounts)
	authRoutes.PUT("/account", server.updateAccount)
	authRoutes.DELETE("/account/:id", server.deleteAccount)

	authRoutes.POST("/transfers", server.createTransfer)

	server.router = router
}

// NewServer creates a new HTTP server and setup routing.
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

	if v, ok := binding.Validator.Engine().(*validator.Validate); ok {
		v.RegisterValidation("currency", validCurrency)
	}

	server.setupRouter()
	return server, nil
}

func errorResponse(err error) gin.H {
	return gin.H{"error_message": err.Error()}
}

func (server *Server) Start(address string) error {
	return server.router.Run(address)
}

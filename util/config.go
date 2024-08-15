package util

import (
	"log"
	"os"
	"time"

	"github.com/spf13/viper"
)

type Config struct {
	AccessTokenDuration  time.Duration `mapstructure:"ACCESS_TOKEN_DURATION"`
	DBDriver             string        `mapstructure:"DB_DRIVER"`
	DBSource             string        `mapstructure:"DB_SOURCE"`
	MigrationSourceURL   string        `mapstructure:"MIGRATION_SOURCE_URL"`
	Environment          string        `mapstructure:"APP_ENVIRONMENT"`
	HttpServerAddress    string        `mapstructure:"HTTP_SERVER_ADDRESS"`
	GRPCServerAddress    string        `mapstructure:"GRPC_SERVER_ADDRESS"`
	RefreshTokenDuration time.Duration `mapstructure:"REFRESH_TOKEN_DURATION"`
	TokenSymmetricKey    string        `mapstructure:"TOKEN_SYMMETRIC_KEY"`
}

func LoadConfig(path string) (config Config, err error) {
	env := os.Getenv("APP_ENVIRONMENT")
	if env == "" {
		log.Println("No App env")
		env = "local"
	}

	viper.AddConfigPath(path)
	viper.SetConfigName(env)
	viper.SetConfigType("env")

	viper.AutomaticEnv()

	err = viper.ReadInConfig()
	if err != nil {
		log.Fatalf("failed to read config: %v", err)
	}

	err = viper.Unmarshal(&config)
	if err != nil {
		log.Fatalf("failed to unmarshal config: %v", err)
	}

	return
}

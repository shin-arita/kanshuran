package config

import "os"

type Config struct {
	AppEnv      string
	APIPort     string
	DatabaseURL string
	RedisAddr   string
	CORSOrigin  string
	StorageRoot string
}

func Load() *Config {
	return &Config{
		AppEnv:      getEnv("APP_ENV", "local"),
		APIPort:     getEnv("API_PORT", "8080"),
		DatabaseURL: getEnv("DATABASE_URL", "postgres://kanshuran:kanshuran_password@db:5432/kanshuran?sslmode=disable"),
		RedisAddr:   getEnv("REDIS_ADDR", "redis:6379"),
		CORSOrigin:  getEnv("CORS_ALLOW_ORIGIN", "http://localhost:5173"),
		StorageRoot: getEnv("LOCAL_STORAGE_ROOT", "/app/storage"),
	}
}

func getEnv(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}

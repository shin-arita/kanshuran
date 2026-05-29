package main

import (
	"log"

	"github.com/gin-gonic/gin"

	"kanshuran-api/internal/config"
	"kanshuran-api/internal/db"
	"kanshuran-api/internal/handler"
	kredis "kanshuran-api/internal/redis"
)

func main() {
	cfg := config.Load()

	pool, err := db.New(cfg.DatabaseURL)
	if err != nil {
		log.Fatalf("db init failed: %v", err)
	}
	defer pool.Close()

	_, err = kredis.New(cfg.RedisAddr)
	if err != nil {
		log.Fatalf("redis init failed: %v", err)
	}

	r := gin.Default()
	r.Use(corsMiddleware(cfg.CORSOrigin))

	health := handler.NewHealthHandler(pool)
	r.GET("/health", health.Health)

	v1 := r.Group("/api/v1")
	v1.GET("/health", health.HealthV1)

	log.Printf("starting server on :%s (env=%s)", cfg.APIPort, cfg.AppEnv)
	if err := r.Run(":" + cfg.APIPort); err != nil {
		log.Fatalf("server error: %v", err)
	}
}

func corsMiddleware(origin string) gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Header("Access-Control-Allow-Origin", origin)
		c.Header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		c.Header("Access-Control-Allow-Headers", "Content-Type, Authorization")
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}
		c.Next()
	}
}

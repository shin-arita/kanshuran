package handler

import (
	"context"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgxpool"
)

type HealthHandler struct {
	db *pgxpool.Pool
}

func NewHealthHandler(db *pgxpool.Pool) *HealthHandler {
	return &HealthHandler{db: db}
}

func (h *HealthHandler) Health(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"status": "ok"})
}

func (h *HealthHandler) HealthV1(c *gin.Context) {
	dbOK := "ok"
	if err := h.db.Ping(context.Background()); err != nil {
		dbOK = "error"
	}
	c.JSON(http.StatusOK, gin.H{"status": "ok", "db": dbOK})
}

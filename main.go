package main

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {
	gin.SetMode(gin.ReleaseMode)
	route := gin.New()
	route.GET("/", healthyCheck)

	if err := route.Run(":5000"); err != nil {
		log.Panic(err.Error())
	}
}

func healthyCheck(context *gin.Context) {
	context.JSON(http.StatusOK, gin.H{
		"message": "ok",
	})
}

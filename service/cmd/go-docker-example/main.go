package main

import (
	"fmt"

	gde "github.com/pnelson/go-docker-example"
	"github.com/pnelson/top95"
)

func main() {
	s := gde.New()
	fmt.Printf("go-docker-example: '%s'\n", s)
	if top95.Include(s) {
		fmt.Println("  included in top95")
	}
}

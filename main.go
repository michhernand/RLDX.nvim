package main

import (
	"context"
	"log"
	"os"

	"github.com/urfave/cli/v3"

	"dex/lib/nvim"
	dbcmd "dex/app/cmd/api"
)


func main() {
	cmd := &cli.Command{
		Commands: []*cli.Command{
			dbcmd.Cmd,
		},
		Action: nvim.StartService,
	}

	ctx := context.Background()
	err := cmd.Run(ctx, os.Args)
	if err != nil {
		log.Fatal(err)
	}
}

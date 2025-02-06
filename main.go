package main

import (
	"log"
	"os"
	"context"

	"github.com/urfave/cli/v3"

	nvimcmd "dex/app/nvim"
	dbcmd "dex/app/cmd/api"
)

func main() {
	cmd := &cli.Command{
		Commands: []*cli.Command{
			dbcmd.Cmd,
		},
		Action: nvimcmd.Start,
	}

	ctx := context.Background()
	err := cmd.Run(ctx, os.Args)
	if err != nil {
		log.Fatal(err)
	}
}

package main

import (
	"context"
	"log"
	"os"

	"github.com/urfave/cli/v3"

	nvimcmd "dex/app/cmd/nvim"
	dbcmd "dex/app/cmd/api"
)


func main() {
	cmd := &cli.Command{
		Commands: []*cli.Command{
			nvimcmd.Cmd,
			dbcmd.Cmd,
		},
	}

	ctx := context.Background()
	err := cmd.Run(ctx, os.Args)
	if err != nil {
		log.Fatal(err)
	}
}

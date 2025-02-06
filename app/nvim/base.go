package nvim

import (
	"os"
	"log"
	"context"

	"github.com/urfave/cli/v3"

	gonvim "github.com/neovim/go-client/nvim"
	dblib "dex/lib/api"
	nvimlib "dex/lib/nvim"
)

const db = "/Users/michael/dev/rolodex.nvim/rolodex.db"

var flags = []cli.Flag {
	&cli.StringFlag{
		Name: "database-filename",
		Value: db,
	},
}

func getClient() (*gonvim.Nvim, error) {
	log.SetFlags(0)

	stdout := os.Stdout
	os.Stdout = os.Stderr

	v, err := gonvim.New(os.Stdin, stdout, stdout, log.Printf)
	if err != nil {
		return nil, err
	}
	return v, nil
}

func Start(ctx context.Context, cmd *cli.Command) error {
	dbClient, err := dblib.NewRolodexAPI(
		cmd.String("database-filename"),
	)

	if err != nil {
		return err
	}
	rolo := nvimlib.NewRolodex(ctx, *dbClient)

	nvimClient, err := getClient()
	if err != nil {
		return err
	}

	nvimClient.RegisterHandler("dex_lookup", rolo.DexLookup)

	if err := nvimClient.Serve(); err != nil {
		log.Fatal(err)
	}
	return nil
}


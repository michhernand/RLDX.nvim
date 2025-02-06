package nvim

import (
	"os"
	"log"
	"context"

	"github.com/urfave/cli/v3"

	gonvim "github.com/neovim/go-client/nvim"
	nvimlib "dex/lib/nvim"
)

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
	rolo := nvimlib.NewRolodex(ctx)

	v, err := getClient()
	if err != nil {
		return err
	}

	v.RegisterHandler("dex_lookup", rolo.HandleRequest)

	if err := v.Serve(); err != nil {
		log.Fatal(err)
	}
	return nil
}


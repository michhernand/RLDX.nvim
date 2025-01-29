package nvim

import (
	"os"
	"log"
	"context"

	gonvim "github.com/neovim/go-client/nvim"
	nvimlib "dex/lib/nvim"
	"github.com/urfave/cli/v3"
)


func StartService(ctx context.Context, cmd *cli.Command) error {
	// Turn off timestamps in output.
	log.SetFlags(0)

	// Direct writes by the application to stdout garble the RPC stream.
	// Redirect the application's direct use of stdout to stderr.
	stdout := os.Stdout
	os.Stdout = os.Stderr

	// Create a client connected to stdio. Configure the client to use the
	// standard log package for logging.
	v, err := gonvim.New(os.Stdin, stdout, stdout, log.Printf)
	if err != nil {
		log.Fatal(err)
	}

	// Register function with the client.
	v.RegisterHandler("rolo", nvimlib.HandleRequest)

	// Run the RPC message loop. The Serve function returns when
	// nvim closes.
	if err := v.Serve(); err != nil {
		log.Fatal(err)
	}
	return nil
}


var Cmd = &cli.Command{
	Name: "nvim",
	Aliases: []string{"n"},
	Usage: "Launch nvim service",
	Action: StartService,
}


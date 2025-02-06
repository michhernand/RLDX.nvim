package nvim

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/urfave/cli/v3"

	gonvim "github.com/neovim/go-client/nvim"
)

func HandleRequest(v *gonvim.Nvim, args []interface{}) error {
	nargs := len(args)
	if nargs != 1 {
		return v.WriteErr(fmt.Sprintf("n_args: expected=1, actual=%d", nargs))
	}

	query, ok := args[0].(string)
	if !ok {
		return v.WriteErr("failed to cast query to string")
	}

	return v.WriteOut(fmt.Sprintf("Hello %s\n", query))
}

func StartService(ctx context.Context, cmd *cli.Command) error {
	log.SetFlags(0)

	stdout := os.Stdout
	os.Stdout = os.Stderr

	v, err := gonvim.New(os.Stdin, stdout, stdout, log.Printf)
	if err != nil {
		log.Fatal(err)
	}

	v.RegisterHandler("rolo", HandleRequest)

	if err := v.Serve(); err != nil {
		log.Fatal(err)
	}
	return nil
}


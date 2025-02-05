package nvim

import (
	"context"
	"fmt"
	"log"
	"os"
	"strings"

	"github.com/urfave/cli/v3"

	gonvim "github.com/neovim/go-client/nvim"
)

func HandleRequest(v *gonvim.Nvim, args []interface{}) error {
	nargs := len(args)
	if nargs != 2 {
		return fmt.Errorf("n_args: expected=0, actual=%d", nargs)
	}

	query, ok := args[0].(string)
	if !ok {
		return fmt.Errorf("failed to cast query to string")
	}

	v.WriteOut(query)
	if !strings.HasPrefix(query, "@") {
		return nil
	}

	posFloat, ok := args[1].(float64)
	if !ok {
		return fmt.Errorf("failed to cast pos to float64")
	}
	pos := int(posFloat)

	return v.WriteOut(fmt.Sprintf("Hello %s\n @ %d", query, pos))
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


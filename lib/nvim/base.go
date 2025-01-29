package nvim

import (
	"fmt"
	"strings"

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


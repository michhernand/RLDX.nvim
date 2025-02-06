package nvim

import (
	"context"
	"fmt"
	"strings"

	gonvim "github.com/neovim/go-client/nvim"

	dblib "dex/lib/api"
)

func NewRolodex(
	ctx context.Context,
	rolo dblib.RolodexAPI,
) *Rolodex {
	return &Rolodex{
		ctx: ctx,
		rolo: rolo,
	}
}

type Rolodex struct {
	ctx context.Context
	rolo dblib.RolodexAPI
}


func (r Rolodex) DexLookup(v *gonvim.Nvim, args []interface{}) ([]string, error) {
	nargs := len(args)
	if nargs != 1 {
		return []string{} ,fmt.Errorf("n_args: expected=1, actual=%d", nargs)
	}

	word, ok := args[0].(string)
	if !ok {
		return []string{}, fmt.Errorf("failed to cast arg to string")
	}
	word = strings.TrimPrefix(word, "\\")

	return []string{word, "apple", "banana", "cherry"}, nil
}


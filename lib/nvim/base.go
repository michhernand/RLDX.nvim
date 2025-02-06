package nvim

import (
	"context"
	"fmt"

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


func (r Rolodex) DexLookup(v *gonvim.Nvim, args []interface{}) error {
	nargs := len(args)
	if nargs != 2 {
		return v.WriteErr(fmt.Sprintf("n_args: expected=2 (text + pos), actual=%d", nargs))
	}

	in_prefix_word, ok := args[0].(bool)
	if !ok {
		return v.WriteErr("failed to cast arg to bool")
	}

	if in_prefix_word {
		return v.WriteOut(fmt.Sprintf("You're in a word"))
	}
	return nil

	// return v.WriteOut(fmt.Sprintf("Hello %s\n", query))
}


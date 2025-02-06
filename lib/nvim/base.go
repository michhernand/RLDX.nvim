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
	if nargs != 3 {
		return []string{} ,fmt.Errorf("n_args: expected=3, actual=%d", nargs)
	}

	in_prefix_word, ok := args[0].(bool)
	if !ok {
		return []string{}, fmt.Errorf("failed to cast arg to bool")
	}

	if !in_prefix_word {
		return []string{}, nil
	}

	word, ok := args[1].(string)
	if !ok {
		return []string{}, fmt.Errorf("failed to cast arg to string")
	}

	caseSensitive, ok := args[2].(bool)
	if !ok {
		return []string{}, fmt.Errorf("failed to cast arg to bool")
	}

	if !caseSensitive {
		word = strings.ToLower(word)
	}


	return []string{word, "apple", "banana", "cherry"}, nil
}


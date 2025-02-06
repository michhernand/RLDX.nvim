package nvim

import (
	"context"
	"fmt"

	gonvim "github.com/neovim/go-client/nvim"
)

func NewRolodex(ctx context.Context) *Rolodex {
	return &Rolodex{
		ctx: ctx,
	}
}

type Rolodex struct {
	ctx context.Context
}


func (r Rolodex) HandleRequest(v *gonvim.Nvim, args []interface{}) error {
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


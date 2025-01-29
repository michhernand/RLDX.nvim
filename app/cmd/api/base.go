package api

import (
	"github.com/urfave/cli/v3"
)

var Cmd = &cli.Command{
	Name: "db",
	Aliases: []string{"d"},
	Usage: "interact with index",
	Commands: []*cli.Command{
		insertCmd,
		searchCmd,
	},
}

package api

import (
	"context"
	"fmt"

	"github.com/urfave/cli/v3"

	apilib "dex/lib/api"
)


func Insert(ctx context.Context, cmd *cli.Command) error {
	var filepath string = cmd.String("db-filepath")
	if filepath == "" {
		return fmt.Errorf("a `db-filepath` argument is required")
	}

	var payload string = cmd.Args().Get(0)
	if payload == "" {
		return fmt.Errorf("a positional arg with payload is required")
	}

	client, err := apilib.NewRolodexAPI(filepath)
	if err != nil {
		return err
	}
	defer client.Ix.Close()

	err = client.Insert(payload)
	if err != nil {
		return err
	}

	return nil
}

var insertFlags = []cli.Flag{
	&cli.StringFlag{
		Name: "db-filepath",
		Value: "rolodex.db",
		Usage: "set rolodex db filepath",
	},

}

var insertCmd = &cli.Command{
	Name: "insert",
	Aliases: []string{"i"},
	Usage: "insert element into index",
	Action: Insert,
	Flags: insertFlags,
}

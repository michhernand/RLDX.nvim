package api

import (
	"context"
	"fmt"

	"github.com/urfave/cli/v3"

	apilib "dex/lib/api"
	m "dex/models"
)


func Search(ctx context.Context, cmd *cli.Command) error {
	var filepath string = cmd.String("db-filepath")
	if filepath == "" {
		return fmt.Errorf("a `db-filepath` argument is required")
	}

	var searchQuery = cmd.Args().Get(0)
	if searchQuery == "" {
		return fmt.Errorf("a positional arg with search-query is required")
	}

	client, err := apilib.NewRolodexAPI(filepath)
	if err != nil {
		return err
	}
	defer client.Ix.Close()

	hits, err := client.Search(searchQuery)
	if err != nil {
		return err
	}
	fmt.Printf("found %d hits\n", len(hits))


	for _, hit := range hits {
		name, ok := hit.Fields["Name"].(string)
		if !ok {
			return fmt.Errorf("error retrieving field")
		}
		identity := m.Identity{Name: name}
		fmt.Printf("Retrieved struct: %+v\n", identity)
	}
	return nil
}

var searchFlags = []cli.Flag{
	&cli.StringFlag{
		Name: "db-filepath",
		Value: "rolodex.db",
		Usage: "set rolodex db filepath",
	},
}

var searchCmd = &cli.Command{
	Name: "search",
	Aliases: []string{"s"},
	Usage: "query index",
	Action: Search,
	Flags: searchFlags,
}

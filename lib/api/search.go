package api

import (
	"github.com/blevesearch/bleve/v2"
	"github.com/blevesearch/bleve/v2/search"
)


func (r *RolodexAPI) Search(
	text string,
) (
	search.DocumentMatchCollection, 
	error,
) {
	query := bleve.NewPrefixQuery(text)

	searchRequest := bleve.NewSearchRequest(query)
	searchRequest.Fields = []string{"Name"} // Request stored fields

	searchResult, err := r.Ix.Search(searchRequest)
	if err != nil {
		return nil, err
	}

	return searchResult.Hits, nil
}



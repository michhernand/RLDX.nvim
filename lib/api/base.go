package api

import (
	"os"
	"github.com/blevesearch/bleve/v2"
)

func newIndex(filepath string) (*bleve.Index, error) {
	mapping := bleve.NewIndexMapping()

	fieldMapping := bleve.NewTextFieldMapping()
	fieldMapping.IncludeTermVectors = true

	docMapping := bleve.NewDocumentMapping()
	docMapping.AddFieldMappingsAt("Name", fieldMapping)

	mapping.AddDocumentMapping("_default", docMapping)

	ix, err := bleve.New(filepath, mapping)
	if err != nil {
		return nil, err
	}

	return &ix, nil
}

func getIndex(filepath string) (*bleve.Index, error) {
	if _, err := os.Stat(filepath); os.IsNotExist(err) {
		return newIndex(filepath)
	}

	ix, err := bleve.Open(filepath)
	if err != nil {
		return nil, err
	}
	return &ix, nil
}

func NewRolodexAPI(filepath string) (*RolodexAPI, error) {
	ix, err := getIndex(filepath)
	if err != nil {
		return nil, err
	}
	return &RolodexAPI{Ix: *ix}, nil
}

type RolodexAPI struct {
	Ix bleve.Index
}


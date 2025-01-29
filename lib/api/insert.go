package api

import (
	"github.com/google/uuid"

	m "dex/models"
)

func (r *RolodexAPI) Insert(text string) error {
	id := uuid.New().String()

	if err := r.Ix.Index(id, m.Identity{Name: text}); err != nil {
		return err
	}

	// return r.Ix.SetInternal([]byte(id), []byte(text))
	return nil
}


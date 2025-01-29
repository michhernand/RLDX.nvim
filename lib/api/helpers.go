package api


func (r *RolodexAPI) GetText(id string) (string, error) {
	// For Bleve v2, we can use the internal API to get the raw data
	raw, err := r.Ix.GetInternal([]byte(id))
	if err != nil {
		return "", err
	}
	
	if raw == nil {
		return "", nil
	}

	return string(raw), nil
}

package domain

type Table struct {
	Name    string `json:"name"`
	Total   int    `json:"total"`
	UserIDs []int  `json:"user_ids"`
}

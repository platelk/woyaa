package domain

import (
	"fmt"

	"github.com/zyedidia/generic/set"
)

type UserID int

func (u UserID) String() string {
	return fmt.Sprintf("%d", u)
}

type TableName string

type RoomNumber int

type User struct {
	ID               UserID     `json:"id"`
	FirstName        string     `json:"first_name"`
	LastName         string     `json:"last_name"`
	Email            Email      `json:"email"`
	Room             RoomNumber `json:"room"`
	Table            TableName  `json:"wedding_table"`
	FullPicturePath  string     `json:"full_picture_path"`
	RoundPicturePath string     `json:"round_picture_path"`
}

type Users []User

func (users Users) IDs() set.Set[UserID] {
	var ids []UserID
	for _, id := range users {
		ids = append(ids, id.ID)
	}
	return set.NewMapset(ids...)
}

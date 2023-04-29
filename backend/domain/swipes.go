package domain

import (
	"time"

	"github.com/zyedidia/generic/set"
)

type Swipe struct {
	FromUserID   UserID
	SwipedUserID UserID
	SwipedRight  bool
	At           time.Time
}

type Swipes []Swipe

func (swipes Swipes) IDs() set.Set[UserID] {
	var ids []UserID
	for _, id := range swipes {
		ids = append(ids, id.SwipedUserID)
	}
	return set.NewMapset(ids...)
}

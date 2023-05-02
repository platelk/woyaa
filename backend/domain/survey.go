package domain

import (
	"github.com/zyedidia/generic/set"
)

type QuestionID int
type QuestionIDs []QuestionID

func (ids QuestionIDs) ToSet() set.Set[QuestionID] {
	return set.NewMapset([]QuestionID(ids)...)
}

type Question struct {
	ID        QuestionID `json:"question_id"`
	Question  string     `json:"question"`
	IsAna     bool       `json:"is_ana"`
	IsYoann   bool       `json:"is_yoann"`
	NbAnswers int        `json:"nb_answers"`
	UserIDs   UserIDs    `json:"user_ids,omitempty"`
}

type QuestionAnswer struct {
	ID         QuestionID `json:"question_id"`
	FromUserID UserID     `json:"from_user_id"`
	UserIDs    UserIDs    `json:"user_ids"`
}

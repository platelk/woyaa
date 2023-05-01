package domain

type QuestionID int

type Question struct {
	ID        QuestionID `json:"question_id"`
	Question  string     `json:"question"`
	IsAna     bool       `json:"is_ana"`
	IsYoann   bool       `json:"is_yoann"`
	NbAnswers int        `json:"nb_answers"`
	UserIDs   []UserID   `json:"user_ids,omitempty"`
}

type QuestionAnswer struct {
	ID         QuestionID `json:"question_id"`
	FromUserID UserID     `json:"from_user_id"`
	UserIDs    []UserID   `json:"user_ids"`
}

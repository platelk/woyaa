package surveystore

import (
	"context"
	"fmt"

	"github.com/platelk/woyaa/backend/domain"
	"github.com/platelk/woyaa/backend/infra/userpg"
)

type UserPG struct {
	db *userpg.DB
}

func NewUserPG(db *userpg.DB) *UserPG {
	return &UserPG{
		db: db,
	}
}

func (u *UserPG) AnswerQuestion(c context.Context, answer domain.QuestionAnswer) error {
	for _, userID := range answer.UserIDs {
		err := u.db.Insert(c, userpg.SurveyAnswerTable, &userpg.SurveyAnswer{
			FromUserID:   int(answer.FromUserID),
			QuestionID:   int(answer.ID),
			AnswerUserID: int(userID),
		})
		if err != nil {
			return fmt.Errorf("can't insert question anser: %w", err)
		}
	}
	return nil
}

func (u *UserPG) GetAllQuestion(c context.Context) ([]domain.Question, error) {
	var swp []userpg.Survey
	err := u.db.Query(c, &swp, "select * from survey ORDER BY question_id")
	if err != nil {
		return nil, fmt.Errorf("can't retrieve swipes: %w", err)
	}
	var questions []domain.Question
	var question domain.Question
	questionID := 0
	for _, s := range swp {
		if s.QuestionID != questionID {
			question.NbAnswers = len(question.UserIDs)
			questions = append(questions, question)
			question = domain.Question{}
			questionID = s.QuestionID
		}
		question.Question = s.Question
		question.IsAna = s.IsAna
		question.IsYoann = s.IsYoann
		question.UserIDs = append(question.UserIDs, domain.UserID(s.UserID))
		question.ID = domain.QuestionID(s.QuestionID)
	}
	return questions, nil
}

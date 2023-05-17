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

func (u *UserPG) GetAnsweredQuestion(c context.Context, user domain.UserID) (map[domain.QuestionID]domain.UserIDs, error) {
	var answers []userpg.SurveyAnswer

	err := u.db.Query(c, &answers, "select question_id, answer_user_id from survey_answers WHERE from_user_id = $1 ORDER BY question_id,id DESC", user)
	if err != nil {
		return nil, fmt.Errorf("can't retrieve question: %w", err)
	}
	lastQuestionID := -1
	var proposedUser domain.UserIDs
	res := make(map[domain.QuestionID]domain.UserIDs)
	for _, answer := range answers {
		if _, ok := res[domain.QuestionID(answer.QuestionID)]; ok {
			continue
		}
		if answer.QuestionID != lastQuestionID {
			if lastQuestionID != -1 {
				res[domain.QuestionID(lastQuestionID)] = proposedUser.ToSet().Keys()
			}
			lastQuestionID = answer.QuestionID
			proposedUser = nil
		}
		proposedUser = append(proposedUser, domain.UserID(answer.AnswerUserID))
	}
	fmt.Println("answered question: ", res)
	return res, nil
}

func (u *UserPG) GetOneQuestion(c context.Context, id domain.QuestionID) (domain.Question, error) {
	var swp []userpg.Survey
	err := u.db.Query(c, &swp, "select * from survey WHERE question_id = $1", id)
	if err != nil {
		return domain.Question{}, fmt.Errorf("can't retrieve question: %w", err)
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
	question.NbAnswers = len(question.UserIDs)
	return question, nil
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

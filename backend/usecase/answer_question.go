package usecase

import (
	"context"
	"fmt"

	"github.com/platelk/woyaa/backend/domain"
)

type AnswerQuestion func(ctx context.Context, req *AnswerQuestionReq) (*AnswerQuestionRes, error)

type AnswerQuestionReq struct {
	QuestionID      domain.QuestionID
	FromUserID      domain.UserID
	ProposedUserIDs domain.UserIDs
}

type AnswerQuestionRes struct {
	QuestionID      domain.QuestionID
	Validated       bool
	ValidUserIDs    domain.UserIDs
	NotValidUserIDs domain.UserIDs
}

type SurveyAnswers interface {
	AnswerQuestion(c context.Context, answer domain.QuestionAnswer) error
	GetOneQuestion(c context.Context, id domain.QuestionID) (domain.Question, error)
}

func NewAnswerQuestion(answers SurveyAnswers, scorer Scorer) AnswerQuestion {
	return func(ctx context.Context, req *AnswerQuestionReq) (*AnswerQuestionRes, error) {
		question, err := answers.GetOneQuestion(ctx, req.QuestionID)
		if err != nil {
			return nil, fmt.Errorf("can't retrieve question: %w", err)
		}
		err = answers.AnswerQuestion(ctx, domain.QuestionAnswer{
			ID:         req.QuestionID,
			FromUserID: req.FromUserID,
			UserIDs:    req.ProposedUserIDs,
		})
		if err != nil {
			return nil, fmt.Errorf("can't register question answer: %w", err)
		}
		answersDiff := question.UserIDs.ToSet().Difference(req.ProposedUserIDs.ToSet())
		answersSame := question.UserIDs.ToSet().Union(req.ProposedUserIDs.ToSet())
		validated := answersDiff.Size() == 0 && answersSame.Size() == len(question.UserIDs)
		if validated {
			err = scorer.RegisterScore(ctx, req.FromUserID, question.NbAnswers*2, fmt.Sprintf("correct answer question %d", question.ID))
			if err != nil {
				return nil, fmt.Errorf("can't register score: %w", err)
			}
		}
		return &AnswerQuestionRes{
			QuestionID:      req.QuestionID,
			Validated:       validated,
			NotValidUserIDs: answersDiff.Keys(),
			ValidUserIDs:    answersSame.Keys(),
		}, nil
	}
}

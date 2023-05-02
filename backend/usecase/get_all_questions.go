package usecase

import (
	"context"
	"fmt"
	"math/rand"

	"github.com/platelk/woyaa/backend/domain"
)

type GetAllQuestions func(ctx context.Context, req *GetAllQuestionsReq) (*GetAllQuestionsResp, error)

type GetAllQuestionsReq struct {
	UserID domain.UserID
}

type GetAllQuestionsResp struct {
	Questions []domain.Question
}

type QuestionRetriever interface {
	GetAllQuestion(c context.Context) ([]domain.Question, error)
	GetAnsweredQuestion(c context.Context, user domain.UserID) (domain.QuestionIDs, error)
}

func NewGetAllQuestions(questionRetriever QuestionRetriever) GetAllQuestions {
	return func(ctx context.Context, req *GetAllQuestionsReq) (*GetAllQuestionsResp, error) {
		questions, err := questionRetriever.GetAllQuestion(ctx)
		if err != nil {
			return nil, fmt.Errorf("can't retrieve all questions: %w", err)
		}
		answeredQuestions, err := questionRetriever.GetAnsweredQuestion(ctx, req.UserID)
		if err != nil {
			return nil, fmt.Errorf("can't retrieve answered questions: %w", err)
		}
		questionSet := answeredQuestions.ToSet()
		var returnedQuestion []domain.Question
		for _, question := range questions {
			if questionSet.Has(question.ID) {
				continue
			}
			returnedQuestion = append(returnedQuestion, question)
		}
		rand.Shuffle(len(returnedQuestion), func(i, j int) {
			returnedQuestion[i], returnedQuestion[j] = returnedQuestion[j], returnedQuestion[i]
		})
		return &GetAllQuestionsResp{Questions: returnedQuestion}, nil
	}
}

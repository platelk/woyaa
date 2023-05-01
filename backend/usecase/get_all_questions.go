package usecase

import (
	"context"
	"fmt"

	"github.com/platelk/woyaa/backend/domain"
)

type GetAllQuestions func(ctx context.Context, req *GetAllQuestionsReq) (*GetAllQuestionsResp, error)

type GetAllQuestionsReq struct {
}

type GetAllQuestionsResp struct {
	Questions []domain.Question
}

type QuestionRetriever interface {
	GetAllQuestion(c context.Context) ([]domain.Question, error)
}

func NewGetAllQuestions(questionRetriever QuestionRetriever) GetAllQuestions {
	return func(ctx context.Context, req *GetAllQuestionsReq) (*GetAllQuestionsResp, error) {
		questions, err := questionRetriever.GetAllQuestion(ctx)
		if err != nil {
			return nil, fmt.Errorf("can't retrieve all questions: %w", err)
		}
		return &GetAllQuestionsResp{Questions: questions}, nil
	}
}

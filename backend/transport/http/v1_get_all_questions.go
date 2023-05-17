package http

import (
	"net/http"

	"github.com/labstack/echo/v4"

	"github.com/platelk/woyaa/backend/domain"
	"github.com/platelk/woyaa/backend/usecase"
)

const v1GetAllQuestionPath = "/api/v1/questions"

func (b *Builder) V1GetAllQuestion(questions usecase.GetAllQuestions) *Builder {
	b.e.GET(v1GetAllQuestionPath, v1GetAllQuestions(questions), b.authzMiddleware)

	return b
}

type getAllQuestionsResp struct {
	Questions []domain.Question `json:"questions"`
}

func v1GetAllQuestions(questions usecase.GetAllQuestions) echo.HandlerFunc {
	return func(c echo.Context) error {
		id := GetUserID(c)
		if id == 0 {
			return c.NoContent(http.StatusUnauthorized)
		}
		resp, err := questions(c.Request().Context(), &usecase.GetAllQuestionsReq{UserID: id})
		if err != nil {
			return c.String(http.StatusInternalServerError, err.Error())
		}
		for i := 0; i < len(resp.Questions); i++ {
			resp.Questions[i].UserIDs = []domain.UserID{}
		}
		return c.JSON(http.StatusOK, getAllQuestionsResp{Questions: resp.Questions})
	}
}

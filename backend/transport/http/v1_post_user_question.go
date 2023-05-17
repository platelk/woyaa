package http

import (
	"net/http"

	"github.com/labstack/echo/v4"

	"github.com/platelk/woyaa/backend/domain"
	"github.com/platelk/woyaa/backend/usecase"
)

const v1UserPostAnswers = "/api/v1/user/answer"

func (b *Builder) V1PostUserAnswers(question usecase.AnswerQuestion) *Builder {
	b.e.POST(v1UserPostAnswers, v1PostUserAnswerHandler(question), b.authzMiddleware)
	return b
}

type userAnswerReq struct {
	QuestionID      domain.QuestionID `json:"question_id"`
	ProposedUserIDs domain.UserIDs    `json:"proposed_user_ids"`
}

type userAnswerQuestionRes struct {
	QuestionID      domain.QuestionID `json:"question_id"`
	Validated       bool              `json:"validated"`
	ValidUserIDs    domain.UserIDs    `json:"valid_user_ids"`
	NotValidUserIDs domain.UserIDs    `json:"not_valid_user_ids"`
}

func v1PostUserAnswerHandler(question usecase.AnswerQuestion) echo.HandlerFunc {
	return func(c echo.Context) error {
		id := GetUserID(c)
		if id == 0 {
			return c.NoContent(http.StatusUnauthorized)
		}
		usrAnswerReq := &userAnswerReq{}
		err := c.Bind(&usrAnswerReq)
		if err != nil {
			return c.JSON(http.StatusBadRequest, nil)
		}
		res, err := question(c.Request().Context(), &usecase.AnswerQuestionReq{
			QuestionID:      usrAnswerReq.QuestionID,
			FromUserID:      id,
			ProposedUserIDs: usrAnswerReq.ProposedUserIDs,
		})
		if err != nil {
			return c.String(http.StatusInternalServerError, err.Error())
		}

		return c.JSON(http.StatusOK, &userAnswerQuestionRes{
			QuestionID:      res.QuestionID,
			Validated:       res.Validated,
			ValidUserIDs:    res.ValidUserIDs,
			NotValidUserIDs: res.NotValidUserIDs,
		})
	}
}

package http

import (
	"net/http"

	"github.com/labstack/echo/v4"

	"github.com/platelk/woyaa/backend/domain"
	"github.com/platelk/woyaa/backend/usecase"
)

const v1UserSwipe = "/api/v1/user/swipe"

func (b *Builder) V1PostUserSwipe(uc usecase.SwipeUserUseCase) *Builder {
	b.e.POST(v1UserSwipe, v1PostUserSwipeHandler(uc), b.authzMiddleware)

	return b
}

type swipeUserReq struct {
	SwipedUser  int  `json:"swiped_user"`
	SwipedRight bool `json:"swiped_right"`
}

type swipeUserResp struct {
	FoundMyTable       bool `json:"found_my_table"`
	NotFoundMyTable    bool `json:"not_found_my_table"`
	FoundNotMyTable    bool `json:"found_not_my_table"`
	NotFoundNotMyTable bool `json:"not_found_not_my_table"`
}

func v1PostUserSwipeHandler(swipeUser usecase.SwipeUserUseCase) echo.HandlerFunc {
	return func(c echo.Context) error {
		id := GetUserID(c)
		if id == 0 {
			return c.NoContent(http.StatusUnauthorized)
		}
		// Parse incoming request
		swipedUserReq := &swipeUserReq{}
		err := c.Bind(&swipedUserReq)
		if err != nil {
			return c.JSON(http.StatusBadRequest, nil)
		}
		if swipedUserReq.SwipedUser == 0 {
			return c.JSON(http.StatusBadRequest, nil)
		}
		res, err := swipeUser(c.Request().Context(), &usecase.SwipeUserReq{
			FromUser:    id,
			SwipedUser:  domain.UserID(swipedUserReq.SwipedUser),
			SwipedRight: swipedUserReq.SwipedRight,
		})
		if err != nil {
			return c.String(http.StatusInternalServerError, err.Error())
		}
		return c.JSON(http.StatusOK, &swipeUserResp{
			FoundMyTable:       res.FoundMyTable,
			NotFoundMyTable:    res.NotFoundMyTable,
			FoundNotMyTable:    res.FoundNotMyTable,
			NotFoundNotMyTable: res.NotFoundNotMyTable,
		})
	}
}

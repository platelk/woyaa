package main

import (
	"context"

	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"

	"github.com/platelk/woyaa/backend/adapter/accesstokens"
	"github.com/platelk/woyaa/backend/adapter/credstore"
	"github.com/platelk/woyaa/backend/adapter/scoresregistry"
	"github.com/platelk/woyaa/backend/adapter/swipestore"
	"github.com/platelk/woyaa/backend/adapter/tablestore"
	"github.com/platelk/woyaa/backend/adapter/userstore"
	"github.com/platelk/woyaa/backend/infra/userpg"
	"github.com/platelk/woyaa/backend/transport/http"
	"github.com/platelk/woyaa/backend/usecase"
)

func main() {
	// UNIX Time is faster and smaller than most timestamps
	zerolog.TimeFieldFormat = zerolog.TimeFormatUnix

	conf, err := LoadConfig()
	if err != nil {
		log.Fatal().Err(err).Msg("can't load config")
	}

	userPG, err := userpg.NewDB(context.Background(), conf.UserPGURL)
	if err != nil {
		log.Fatal().Err(err).Msg("can't connect to user db")
	}

	credStore := credstore.NewUserPG(userPG)
	tokens := accesstokens.NewJWT()
	userStore := userstore.NewUserPG(userPG)
	swipeStore := swipestore.NewUserPG(userPG)
	tableStore := tablestore.NewUserPG(userPG)
	scoreRegistry := scoresregistry.NewUserPG(userPG)

	s := http.NewBuilder().
		WithJWT(tokens).
		//ReverseProxy("http://localhost:51357/").
		WebSite("./build/web").
		DevUserPGAll(userPG).
		V1PostEmailLogin(usecase.NewEmailLogin(credStore, userStore, tokens)).
		V1GetUserMe(usecase.NewGetMyUserUseCase(userStore)).
		V1GetUser(usecase.NewGetUserUseCase(userStore, scoreRegistry)).
		V1GetUserSwipable(usecase.NewGetSwipableUserUseCase(userStore, swipeStore)).
		V1PostUserSwipe(usecase.NewSwipeUserUseCase(swipeStore, userStore, scoreRegistry)).
		V1GetUserScore(usecase.NewGetUserScoreUseCase(scoreRegistry)).
		V1GetTables(usecase.NewGetTables(tableStore)).
		Build()

	if err := s.Start(); err != nil {
		log.Fatal().Err(err).Msg("can't start http server")
	}
}

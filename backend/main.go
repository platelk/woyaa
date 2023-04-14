package main

import (
	"context"

	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"

	"github.com/platelk/woyaa/backend/adapter/accesstokens"
	"github.com/platelk/woyaa/backend/adapter/credstore"
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

	s := http.NewBuilder().
		WithJWT(tokens.JWTKey).
		WebSite("./build/web").
		DevUserPGAll(userPG).
		V1EmailLogin(usecase.NewEmailLogin(credStore, userStore, tokens)).
		V1UserMe().
		Build()

	if err := s.Start(); err != nil {
		log.Fatal().Err(err).Msg("can't start http server")
	}
}

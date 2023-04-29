package main

import (
	"bytes"
	"fmt"

	"github.com/gookit/config/v2"
	"github.com/gookit/config/v2/yaml"
	"github.com/rs/zerolog/log"
)

type Config struct {
	UserPGURL string `config:"user_pg_url" default:"${USER_PG_URL | postgresql://postgres:mysecretpassword@localhost:6432/users}"`
}

func LoadConfig() (*Config, error) {
	var cfg Config

	c := config.New("app").
		WithOptions(func(opt *config.Options) {
			opt.DecoderConfig.TagName = "config"
		}).
		WithOptions(config.ParseEnv).
		WithOptions(config.ParseDefault)

	c.AddDriver(yaml.Driver)

	err := c.Decode(&cfg)
	if err != nil {
		return nil, fmt.Errorf("can't decode config: %w", err)
	}
	buf := new(bytes.Buffer)
	_, _ = c.DumpTo(buf, config.JSON)
	log.Debug().Any("database", cfg.UserPGURL).Msg("config")
	return &cfg, nil
}

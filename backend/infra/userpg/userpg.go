package userpg

import (
	"context"
	"encoding/csv"
	"fmt"
	"io"
	"strconv"

	"github.com/rs/zerolog/log"
	"github.com/vingarcia/ksql"
	"github.com/vingarcia/ksql/adapters/kpgx"
)

type User struct {
	ID               int    `ksql:"id"`
	FirstName        string `ksql:"first_name"`
	LastName         string `ksql:"last_name"`
	Email            string `ksql:"email"`
	Room             int    `kql:"room"`
	Table            string `ksql:"wedding_table"`
	FullPicturePath  string `ksql:"full_picture_path"`
	RoundPicturePath string `ksql:"round_picture_path"`
}

// UsersTable informs KSQL the name of the table and that it can
// use the default value for the primary key column name: "id"
var UsersTable = ksql.NewTable("users")

type DB struct {
	ksql.DB
}

func NewDB(ctx context.Context, databaseURL string) (*DB, error) {
	conn, err := kpgx.New(ctx, databaseURL, ksql.Config{})
	if err != nil {
		return nil, fmt.Errorf("can't connect to user database: %w", err)
	}
	return &DB{
		DB: conn,
	}, nil
}

func (upg *DB) CreateTables(ctx context.Context) error {
	_, err := upg.Exec(ctx, `CREATE TABLE IF NOT EXISTS users (
	  	id INTEGER PRIMARY KEY,
		first_name TEXT,
		last_name TEXT,
		email TEXT,
		room INTEGER,
		wedding_table TEXT,
		full_picture_path TEXT,
		round_picture_path TEXT
	)`)
	if err != nil {
		return fmt.Errorf("can't create table user: %w", err)
	}
	_, err = upg.Exec(ctx, `CREATE UNIQUE INDEX IF NOT EXISTS user_email ON users (email)`)
	if err != nil {
		return fmt.Errorf("can't create index user_email: %w", err)
	}
	return nil
}

func (upg *DB) DropTables(ctx context.Context) error {
	_, err := upg.Exec(ctx, "DROP TABLE IF EXISTS users")
	if err != nil {
		return fmt.Errorf("can't drop table users: %w", err)
	}
	return nil
}

func (upg *DB) ImportCSV(ctx context.Context, reader *csv.Reader) error {
	nbInsert := 0
	for {
		record, err := reader.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			return fmt.Errorf("can't continue read on import csv on line %d: %w", nbInsert, err)
		}
		id, err := strconv.Atoi(record[0])
		if err != nil {
			return fmt.Errorf("can't convert id import csv on line %d: %w", nbInsert, err)
		}
		room, _ := strconv.Atoi(record[4])
		newUser := User{
			ID:               id + 1,
			FirstName:        record[1],
			LastName:         record[2],
			Email:            record[3],
			Room:             room,
			Table:            record[5],
			FullPicturePath:  record[6],
			RoundPicturePath: record[7],
		}
		err = upg.Insert(ctx, UsersTable, &newUser)
		if err != nil {
			log.Error().Int("user_id", id).Err(err).Msg("can't insert user")
		}

	}
	log.Info().Str("table", "users").Int("nb_insert", nbInsert).Msg("success import csv")
	return nil
}

func (upg *DB) Close(ctx context.Context) {
	upg.Close(ctx)
}

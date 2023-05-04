package userpg

import (
	"context"
	"encoding/csv"
	"fmt"
	"io"
	"strconv"
	"time"

	"github.com/rs/zerolog/log"
	"github.com/vingarcia/ksql"
	"github.com/vingarcia/ksql/adapters/kpgx"
)

type User struct {
	ID               int    `ksql:"id"`
	FirstName        string `ksql:"first_name"`
	LastName         string `ksql:"last_name"`
	Email            string `ksql:"email"`
	Room             int    `ksql:"room"`
	Table            string `ksql:"wedding_table"`
	FullPicturePath  string `ksql:"full_picture_path"`
	RoundPicturePath string `ksql:"round_picture_path"`
	GameTeam         string `ksql:"game_team"`
}

type Swipes struct {
	ID           int  `ksql:"id"`
	UserID       int  `ksql:"user_id"`
	SwipedUserID int  `ksql:"swiped_user_id"`
	SwipedRight  bool `ksql:"swiped_right"`
	// The timeNowUTC modifier will set this field to `time.Now().UTC()` before saving it:
	SwipedAt time.Time `ksql:"swiped_at,timeNowUTC"`
}

type Scores struct {
	ID      int       `ksql:"id"`
	UserID  int       `ksql:"user_id"`
	Value   int       `ksql:"score_value"`
	Reason  string    `ksql:"reason"`
	ScoreAt time.Time `ksql:"score_at,timeNowUTC"`
}

type Survey struct {
	ID         int    `ksql:"id"`
	QuestionID int    `ksql:"question_id"`
	IsYoann    bool   `ksql:"is_yoann"`
	IsAna      bool   `ksql:"is_ana"`
	Question   string `ksql:"question"`
	UserID     int    `ksql:"user_id"`
}

type SurveyAnswer struct {
	ID           int       `ksql:"id"`
	FromUserID   int       `ksql:"from_user_id"`
	AnswerUserID int       `ksql:"answer_user_id"`
	QuestionID   int       `ksql:"question_id"`
	ScoreAt      time.Time `ksql:"answer_at,timeNowUTC"`
}

// UsersTable informs KSQL the name of the table and that it can
// use the default value for the primary key column name: "id"
var UsersTable = ksql.NewTable("users")
var SwipesTable = ksql.NewTable("swipes")
var ScoresTable = ksql.NewTable("scores")
var SurveyTable = ksql.NewTable("survey")
var SurveyAnswerTable = ksql.NewTable("survey_answers")

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
	err := upg.CreateUsersTable(ctx)
	if err != nil {
		return err
	}
	err = upg.CreateSwipeTable(ctx)
	if err != nil {
		return err
	}
	err = upg.CreateScoreTable(ctx)
	if err != nil {
		return err
	}
	err = upg.CreateSurveyTable(ctx)
	if err != nil {
		return err
	}
	err = upg.CreateSurveyAnswerTable(ctx)
	if err != nil {
		return err
	}
	return nil
}

func (upg *DB) CreateUsersTable(ctx context.Context) error {
	_, err := upg.Exec(ctx, `CREATE TABLE IF NOT EXISTS users (
	  	id INTEGER PRIMARY KEY,
		first_name TEXT,
		last_name TEXT,
		email TEXT,
		room INTEGER,
		wedding_table TEXT,
		full_picture_path TEXT,
		round_picture_path TEXT,
		game_team TEXT
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

func (upg *DB) CreateSwipeTable(ctx context.Context) error {
	_, err := upg.Exec(ctx, `CREATE TABLE IF NOT EXISTS swipes (
    	  	id SERIAL PRIMARY KEY,
	  	user_id INTEGER,
		swiped_user_id INTEGER,
		swiped_right BOOLEAN,
		swiped_at TIMESTAMP
	)`)
	if err != nil {
		return fmt.Errorf("can't create table swipes: %w", err)
	}
	_, err = upg.Exec(ctx, `CREATE UNIQUE INDEX IF NOT EXISTS swiped_users ON swipes (user_id, swiped_user_id)`)
	if err != nil {
		return fmt.Errorf("can't create index swiped_users: %w", err)
	}
	return nil
}

func (upg *DB) CreateScoreTable(ctx context.Context) error {
	_, err := upg.Exec(ctx, `CREATE TABLE IF NOT EXISTS scores (
    	  	id SERIAL PRIMARY KEY,
	  	user_id INTEGER,
		score_value INTEGER,
		reason TEXT,
		score_at TIMESTAMP
	)`)
	if err != nil {
		return fmt.Errorf("can't create table swipes: %w", err)
	}
	_, err = upg.Exec(ctx, `CREATE INDEX IF NOT EXISTS score_user ON scores (user_id)`)
	if err != nil {
		return fmt.Errorf("can't create index swiped_users: %w", err)
	}
	return nil
}

func (upg *DB) CreateSurveyTable(ctx context.Context) error {
	_, err := upg.Exec(ctx, `CREATE TABLE IF NOT EXISTS survey (
    	  	id SERIAL PRIMARY KEY,
    	  	is_yoann BOOLEAN,
    	  	is_ana BOOLEAN,
	  	user_id INTEGER,
	  	question_id INTEGER,
		question TEXT
	)`)
	if err != nil {
		return fmt.Errorf("can't create table swipes: %w", err)
	}
	_, err = upg.Exec(ctx, `CREATE INDEX IF NOT EXISTS question_index ON survey (question_id, user_id)`)
	if err != nil {
		return fmt.Errorf("can't create index swiped_users: %w", err)
	}
	return nil
}

func (upg *DB) CreateSurveyAnswerTable(ctx context.Context) error {
	_, err := upg.Exec(ctx, `CREATE TABLE IF NOT EXISTS survey_answers (
    	  	id SERIAL PRIMARY KEY,
	  	from_user_id INTEGER,
	  	answer_user_id INTEGER,
	  	question_id INTEGER,
		answer_at TIMESTAMP
	)`)
	if err != nil {
		return fmt.Errorf("can't create table swipes: %w", err)
	}
	_, err = upg.Exec(ctx, `CREATE INDEX IF NOT EXISTS answer_question_index ON survey_answers (question_id, from_user_id)`)
	if err != nil {
		return fmt.Errorf("can't create index swiped_users: %w", err)
	}
	return nil
}

func (upg *DB) DropTables(ctx context.Context) error {
	_, err := upg.Exec(ctx, "DROP TABLE IF EXISTS users")
	if err != nil {
		return fmt.Errorf("can't drop table users: %w", err)
	}
	_, err = upg.Exec(ctx, "DROP TABLE IF EXISTS swipes")
	if err != nil {
		return fmt.Errorf("can't drop table swipes: %w", err)
	}
	_, err = upg.Exec(ctx, "DROP TABLE IF EXISTS scores")
	if err != nil {
		return fmt.Errorf("can't drop table scores: %w", err)
	}
	_, err = upg.Exec(ctx, "DROP TABLE IF EXISTS survey")
	if err != nil {
		return fmt.Errorf("can't drop table survey: %w", err)
	}
	_, err = upg.Exec(ctx, "DROP TABLE IF EXISTS survey_answers")
	if err != nil {
		return fmt.Errorf("can't drop table survey_answers: %w", err)
	}
	return nil
}

func (upg *DB) ImportSurveyCSV(ctx context.Context, reader *csv.Reader) error {
	nbInsert := 0
	for {
		record, err := reader.Read()
		if err == io.EOF {
			break
		}
		fmt.Println(record)
		id, err := strconv.Atoi(record[0])
		if err != nil {
			return fmt.Errorf("can't convert id import csv on line %d: %w", nbInsert, err)
		}
		isAna, isYoann := len(record[1]) > 0, len(record[2]) > 0
		question := record[3]
		for i := 4; i < len(record); i++ {
			userID, _ := strconv.Atoi(record[i])
			if userID == 0 {
				continue
			}
			newQuestion := Survey{
				QuestionID: id,
				IsYoann:    isYoann,
				IsAna:      isAna,
				Question:   question,
				UserID:     userID,
			}
			err = upg.Insert(ctx, SurveyTable, &newQuestion)
			if err != nil {
				log.Error().Int("question_id", id).Err(err).Msg("can't insert question")
			} else {
				log.Info().Int("question_id", id).Int("user_id", userID).Msg(question)
			}
		}
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
			ID:               id,
			FirstName:        record[1],
			LastName:         record[2],
			Email:            record[3],
			Room:             room,
			Table:            record[5],
			FullPicturePath:  record[6],
			RoundPicturePath: record[7],
			GameTeam:         record[8],
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

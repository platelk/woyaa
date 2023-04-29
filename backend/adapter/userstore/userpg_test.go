package userstore

import (
	"context"
	"testing"

	"github.com/platelk/woyaa/backend/infra/userpg"
)

func BenchmarkNewUserPG(b *testing.B) {
	userPG, err := userpg.NewDB(context.Background(), "postgresql://postgres:mysecretpassword@localhost:6432/users")
	if err != nil {
		b.Fatal(err.Error())
	}
	benchmarkUserStoreAll(b, NewUserPG(userPG))
}

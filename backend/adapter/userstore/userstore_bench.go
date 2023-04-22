package userstore

import (
	"context"
	"fmt"
	"math/rand"
	"testing"

	"github.com/platelk/woyaa/backend/domain"
)

func benchmarkUserStoreAll(b *testing.B, storer UserStorer) {
	benchmarkUserStore1000(b, storer)
	benchmarkUserStore10000(b, storer)
	//benchmarkUserStore100000(b, storer)
	//benchmarkUserStore1000000(b, storer)
}

func benchmarkUserStore(b *testing.B, i int, storer UserStorer) {
	ids := make([]domain.UserID, i)
	for k := 0; k < i; k++ {
		ids[k] = domain.UserID(rand.Intn(80))
	}
	b.Run(fmt.Sprintf("GetUserByID/%d", i), func(b *testing.B) {
		for n := 0; n < b.N; n++ {
			for j := 0; j < i; j++ {
				_, _ = storer.GetByID(context.Background(), ids[j])
			}
		}
	})
}

func benchmarkUserStore1000(b *testing.B, storer UserStorer) {
	benchmarkUserStore(b, 1000, storer)
}

func benchmarkUserStore10000(b *testing.B, storer UserStorer) {
	benchmarkUserStore(b, 10000, storer)
}

func benchmarkUserStore100000(b *testing.B, storer UserStorer) {
	benchmarkUserStore(b, 100000, storer)
}

func benchmarkUserStore1000000(b *testing.B, storer UserStorer) {
	benchmarkUserStore(b, 1000000, storer)
}

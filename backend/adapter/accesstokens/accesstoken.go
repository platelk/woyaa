package accesstokens

import (
	"context"
	"fmt"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"

	"github.com/platelk/woyaa/backend/domain"
)

// Create the JWT key used to create the signature
var jwtKey = []byte("my_secret_key")

const woyaaIssuer = "woyaa"
const expirationTime = 24 * time.Hour

type Claims struct {
	jwt.RegisteredClaims
}

type JWTAccessToken struct {
	JWTKey []byte
}

func NewJWT() *JWTAccessToken {
	return &JWTAccessToken{
		JWTKey: jwtKey,
	}
}

func (jat *JWTAccessToken) GenerateAccessToken(_ context.Context, user *domain.User) (domain.AccessToken, error) {
	// Create the JWT claims, which includes the username and expiry time
	claims := &Claims{
		RegisteredClaims: jwt.RegisteredClaims{
			ID:        uuid.New().String(),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
			Issuer:    woyaaIssuer,
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(expirationTime)),
			Subject:   fmt.Sprintf("%d:%s", user.ID, user.Email),
		},
	}
	// Declare the token with the algorithm used for signing, and the claims
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	// Create the JWT string
	tokenString, err := token.SignedString(jat.JWTKey)
	if err != nil {
		return "", fmt.Errorf("can't sign token: %w", err)
	}

	return domain.AccessToken(tokenString), nil
}

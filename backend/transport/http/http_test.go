package http

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestNewBuilder(t *testing.T) {
	b := NewBuilder().Build()
	require.NotNil(t, b)
}

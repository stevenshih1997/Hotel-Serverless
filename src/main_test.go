package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)


func TestFibonnaciInputLessOrEqualToOne(t *testing.T) {
	assert.Equal(t, 1, fibonacci(1))
}

func TestFibonnaciInputGreatherThanOne(t *testing.T) {
	assert.Equal(t, 13, fibonacci(7))
}
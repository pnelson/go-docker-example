package gde

import "github.com/pnelson/wordlist"

func New() string {
	return wordlist.NewPassword()
}

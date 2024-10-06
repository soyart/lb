package main

import (
	"os"
	"syscall"

	"golang.org/x/term"
)

func main() {
	fd := os.Stdout.Fd()
	w, _, err := term.GetSize(int(fd))
	if err != nil {
		syscall.Exit(-1)
	}

	line := make([]byte, w)
	for i := 0; i < w; i++ {
		line[i] = '='
	}

	os.Stdout.Write(line)
	os.Stdout.Write([]byte{'\n'})
}

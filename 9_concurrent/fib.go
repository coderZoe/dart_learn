package main

import (
	"fmt"
	"time"
)

func main() {
	start := time.Now()
	result := fib(50)
	end := time.Now()
	fmt.Printf("cost:%v,result:%d", end.Sub(start), result)
}

func fib(num int) int {
	if num <= 1 {
		return 1
	} else {
		return fib(num-1) + fib(num-2)
	}
}

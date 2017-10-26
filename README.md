# promise

[![GoDoc](https://godoc.org/github.com/ConnorDoyle/promise?status.svg)](https://godoc.org/github.com/ConnorDoyle/promise)

Promise is a disposable write-once latch, to act as a synchronization
barrier to signal completion of some asynchronous operation
(successful or otherwise).

Functions that operate on this type (IsComplete, Complete,
Await, AwaitUntil) are idempotent and thread-safe.

## Minimal example

```go
package main

import (
	"fmt"
	"github.com/ConnorDoyle/promise"
)

func main() {
	p := promise.New()
	go p.Complete(nil)
	p.Await()
	fmt.Println("goroutine ran")
}
```

_...and never rely on `Sleep` in test code again!_

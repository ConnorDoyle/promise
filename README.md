# promise

Promise is a disposable write-once latch, to act as a synchronization
barrier to signal completion of some asynchronous operation
(successful or otherwise).

Functions that operate on this type (IsComplete, Complete,
Await, AwaitUntil) are idempotent and thread-safe.

## Minimal example

```go
p := NewPromise()

go func() {
  p.Complete()
}()

p.Await()
fmt.Printf("goroutine ran")
```

_...and never rely on `Sleep` in test code again!_

package storage

import "io"

// Storage is the interface for file storage.
// LocalStorage is the current implementation; S3Storage will be added later.
type Storage interface {
	Put(key string, r io.Reader) error
	Get(key string) (io.ReadCloser, error)
	Delete(key string) error
}

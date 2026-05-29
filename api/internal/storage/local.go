package storage

import (
	"fmt"
	"io"
	"os"
	"path/filepath"
)

type LocalStorage struct {
	root string
}

func NewLocal(root string) *LocalStorage {
	return &LocalStorage{root: root}
}

func (s *LocalStorage) Put(key string, r io.Reader) error {
	dest := filepath.Join(s.root, key)
	if err := os.MkdirAll(filepath.Dir(dest), 0755); err != nil {
		return fmt.Errorf("local storage: mkdir: %w", err)
	}
	f, err := os.Create(dest)
	if err != nil {
		return fmt.Errorf("local storage: create: %w", err)
	}
	if _, err = io.Copy(f, r); err != nil {
		_ = f.Close()
		return err
	}
	return f.Close()
}

func (s *LocalStorage) Get(key string) (io.ReadCloser, error) {
	f, err := os.Open(filepath.Join(s.root, key))
	if err != nil {
		return nil, fmt.Errorf("local storage: open: %w", err)
	}
	return f, nil
}

func (s *LocalStorage) Delete(key string) error {
	if err := os.Remove(filepath.Join(s.root, key)); err != nil {
		return fmt.Errorf("local storage: remove: %w", err)
	}
	return nil
}

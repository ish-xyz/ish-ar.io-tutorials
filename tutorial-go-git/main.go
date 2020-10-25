package main

import (
        "fmt"

        billy "github.com/go-git/go-billy/v5"
        memfs "github.com/go-git/go-billy/v5/memfs"
        git "github.com/go-git/go-git/v5"
        http "github.com/go-git/go-git/v5/plumbing/transport/http"
        memory "github.com/go-git/go-git/v5/storage/memory"
)

var storer *memory.Storage
var fs billy.Filesystem

func main() {
        storer = memory.NewStorage()
        fs = memfs.New()

        // Authentication
        auth := &http.BasicAuth{
                Username: "your-git-user",
                Password: "your-git-pass",
        }

        repository := "https://github.com/your-org/your-repo"
        r, err := git.Clone(storer, fs, &git.CloneOptions{
                URL:  repository,
                Auth: auth,
        })
        if err != nil {
                fmt.Printf("%v", err)
                return
        }
        fmt.Println("Repository cloned")

        w, err := r.Worktree()
        if err != nil {
                fmt.Printf("%v", err)
                return
        }

        // Create new file
        filePath := "my-new-ififif.txt"
        newFile, err := fs.Create(filePath)
        if err != nil {
                return
        }
        newFile.Write([]byte("My new file"))
        newFile.Close()

        // Run git status before adding the file to the worktree
        fmt.Println(w.Status())

        // git add $filePath
        w.Add(filePath)

        // Run git status after the file has been added adding to the worktree
        fmt.Println(w.Status())

        // git commit -m $message
        w.Commit("Added my new file", &git.CommitOptions{})

        //Push the code to the remote
        err = r.Push(&git.PushOptions{
                RemoteName: "origin",
                Auth:       auth,
        })
        if err != nil {
                return
        }
        fmt.Println("Remote updated.", filePath)
        return
}
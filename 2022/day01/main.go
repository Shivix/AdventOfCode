package main

import (  
    "fmt"
    "os"
    "bufio"
    "log"
    "strconv"
    "sort"
)

func main() {  
    file, err := os.Open("input")
    if err != nil {
        log.Fatal(err)
    }
    defer file.Close()

    scanner := bufio.NewScanner(file)
    var result []int
    var current int
    for scanner.Scan() {
        line := scanner.Text()
        if line == "" {
            result = append(result, current)
            current = 0
        }
        i, _ := strconv.Atoi(line)
        current += i
    }
    
    sort.Sort(sort.Reverse(sort.IntSlice(result)))
    fmt.Println(result[0])
    fmt.Println(result[0] + result[1] + result[2])
}

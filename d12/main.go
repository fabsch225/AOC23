package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func count(s string, groups []int) int {
	n, m := len(s), len(groups)
	// memo[i][j]: ways to place groups[j:] in s[i:]
	memo := make([][]int, n+2)
	for i := range memo {
		memo[i] = make([]int, m+1)
		for j := range memo[i] {
			memo[i][j] = -1
		}
	}
	var f func(i, j int) int
	f = func(i, j int) int {
		if i >= n {
			if j == m {
				return 1
			}
			return 0
		}
		if memo[i][j] >= 0 {
			return memo[i][j]
		}
		res := 0
		if s[i] != '#' {
			res += f(i+1, j)
		}
		if s[i] != '.' && j < m {
			g := groups[j]
			if i+g <= n && !strings.Contains(s[i:i+g], ".") && (i+g == n || s[i+g] != '#') {
				res += f(i+g+1, j+1)
			}
		}
		memo[i][j] = res
		return res
	}
	return f(0, 0)
}

func main() {
	path := "in.txt"
	if len(os.Args) > 1 {
		path = os.Args[1]
	}
	file, err := os.Open(path)
	if err != nil {
		panic(err)
	}
	defer file.Close()
	p1, p2 := 0, 0
	sc := bufio.NewScanner(file)
	for sc.Scan() {
		parts := strings.Fields(sc.Text())
		if len(parts) != 2 {
			continue
		}
		var groups []int
		for _, x := range strings.Split(parts[1], ",") {
			v, _ := strconv.Atoi(x)
			groups = append(groups, v)
		}
		p1 += count(parts[0], groups)
		var ss []string
		var gg []int
		for k := 0; k < 5; k++ {
			ss = append(ss, parts[0])
			gg = append(gg, groups...)
		}
		p2 += count(strings.Join(ss, "?"), gg)
	}
	fmt.Println(p1)
	fmt.Println(p2)
}

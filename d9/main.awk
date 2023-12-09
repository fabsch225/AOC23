{
    n = NF
    for (i = 1; i <= n; i++) a[i] = $i
    first = 0
    sign = 1
    while (n > 0) {
        last += a[n]
        first += sign * a[1]
        sign = -sign
        zero = 1
        for (i = 1; i < n; i++) {
            a[i] = a[i + 1] - a[i]
            if (a[i] != 0) zero = 0
        }
        n--
        if (zero) break
    }
    p1 += last
    p2 += first
    last = 0
}
END { print p1; print p2 }

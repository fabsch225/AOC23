param([string]$File = (Join-Path $PSScriptRoot 'in.txt'))

$patterns = (Get-Content -Raw $File) -split "(?:\r?\n){2,}" | Where-Object { $_.Trim() }

# rows above the mirror line whose mismatch count is exactly $smudges
function Find-Mirror($rows, $smudges) {
    for ($i = 1; $i -lt $rows.Count; $i++) {
        $diff = 0
        for ($d = 0; $i - 1 - $d -ge 0 -and $i + $d -lt $rows.Count; $d++) {
            $a = $i - 1 - $d
            $b = $i + $d
            for ($k = 0; $k -lt $rows[$a].Length; $k++) {
                if ($rows[$a][$k] -ne $rows[$b][$k]) { $diff++ }
            }
            if ($diff -gt $smudges) { break }
        }
        if ($diff -eq $smudges) { return $i }
    }
    return 0
}

function Get-Columns($rows) {
    foreach ($x in 0..($rows[0].Length - 1)) {
        -join ($rows | ForEach-Object { $_[$x] })
    }
}

foreach ($smudges in 0, 1) {
    $sum = 0
    foreach ($p in $patterns) {
        $rows = @($p.Trim() -split "\r?\n")
        $cols = @(Get-Columns $rows)
        $sum += 100 * (Find-Mirror $rows $smudges) + (Find-Mirror $cols $smudges)
    }
    "part $($smudges + 1): $sum"
}

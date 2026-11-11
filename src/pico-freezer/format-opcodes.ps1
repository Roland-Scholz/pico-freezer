[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$Path = (Join-Path $PSScriptRoot 'opcodes.S'),
    [int[]]$ColumnWidths = @()
)

if ($ColumnWidths.Count -gt 0 -and $ColumnWidths.Count -ne 3) {
    throw 'ColumnWidths must contain exactly three values: cycles, opcode, description.'
}
if (@($ColumnWidths | Where-Object { $_ -lt 1 -or $_ -gt 200 }).Count -gt 0) {
    throw 'Each ColumnWidths value must be between 1 and 200.'
}

$resolvedPath = (Resolve-Path -LiteralPath $Path -ErrorAction Stop).Path
$content = [System.IO.File]::ReadAllText($resolvedPath)
$newline = if ($content.Contains("`r`n")) { "`r`n" } else { "`n" }
$hasFinalNewline = $content.EndsWith("`n") -or $content.EndsWith("`r")
$lines = [System.Text.RegularExpressions.Regex]::Split($content, "\r\n|\n|\r")
if ($hasFinalNewline) {
    $lines = $lines[0..($lines.Length - 2)]
}

$rows = @{}
$continuationIndexes = @{}
$separatorIndexes = [System.Collections.Generic.List[int]]::new()
$widths = @(0, 0, 0)
$lastRowIndex = $null
$rowPattern = '^\s*\|?\s*(.*?)\s*\|\s*(.*?)\s*\|\s*(.*?)\s*\|?\s*$'

for ($index = 0; $index -lt $lines.Length; $index++) {
    if ($lines[$index] -match $rowPattern) {
        $cells = @($Matches[1].Trim(), $Matches[2].Trim(), $Matches[3].Trim())
        if ([string]::IsNullOrWhiteSpace($cells[0]) -and [string]::IsNullOrWhiteSpace($cells[1]) -and $null -ne $lastRowIndex) {
            $previousCells = $rows[$lastRowIndex]
            $previousCells[2] = ($previousCells[2] + ' ' + $cells[2]).Trim()
            $continuationIndexes[$index] = $true
        }
        else {
            $rows[$index] = $cells
            $lastRowIndex = $index
        }
    }
    elseif ($lines[$index] -match '^\s*[-+|]+\s*$') {
        $separatorIndexes.Add($index)
    }
}

if ($rows.Count -eq 0) {
    throw "No three-column pipe-delimited rows found in '$resolvedPath'."
}

foreach ($cells in $rows.Values) {
    for ($column = 0; $column -lt 3; $column++) {
        $widths[$column] = [Math]::Max($widths[$column], $cells[$column].Length)
    }
}

if ($ColumnWidths.Count -gt 0) {
    for ($column = 0; $column -lt 3; $column++) {
        if ($ColumnWidths[$column] -lt $widths[$column]) {
            throw "Column $($column + 1) needs at least $($widths[$column]) characters."
        }
    }
    $widths = $ColumnWidths
}

$formattedSeparator = '+-' + ('-' * $widths[0]) + '-+-' + ('-' * $widths[1]) + '-+-' + ('-' * $widths[2]) + '-+'
$output = [System.Collections.Generic.List[string]]::new()

for ($index = 0; $index -lt $lines.Length; $index++) {
    if ($rows.ContainsKey($index)) {
        $cells = $rows[$index]
        $output.Add('| ' + $cells[0].PadRight($widths[0]) + ' | ' + $cells[1].PadRight($widths[1]) + ' | ' + $cells[2].PadRight($widths[2]) + ' |')
    }
    elseif ($continuationIndexes.ContainsKey($index)) {
        continue
    }
    elseif ($separatorIndexes.Contains($index)) {
        $output.Add($formattedSeparator)
    }
    else {
        $output.Add($lines[$index])
    }
}

$formattedContent = [string]::Join($newline, $output)
if ($hasFinalNewline) {
    $formattedContent += $newline
}

if ($PSCmdlet.ShouldProcess($resolvedPath, 'Equalize opcode table columns')) {
    $encoding = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($resolvedPath, $formattedContent, $encoding)
}
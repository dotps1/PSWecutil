function New-SubscriptionRunTimeStatusEventSource {

    [CmdletBinding()]
    [OutputType(
        [PSCustomObject]
    )]

    param (
        [Parameter(
            Mandatory = $true
        )]
        [Array]
        $StringArray
    )

    $startLine = ($StringArray |
        Select-String ":" -NotMatch |
            Select-Object -ExpandProperty LineNumber -First 1 -Skip 1) - 1
    $endLine = ($StringArray |
        Select-String ":" -NotMatch |
            Select-Object -ExpandProperty LineNumber -First 1 -Skip 2) - 2
    if ($endLine -lt 0) {
        $endLine = $StringArray.Count
    }
    $range = $endLine - $startLine

    $output = @()
    for ($i = $startLine; $i -lt $StringArray.Count; $i += $range + 1) {
        $hashTable = [HashTable]::new()
        ($StringArray[$i..($i + $range)]).ForEach({
            $parts = $_ -split ":"
            if ($parts.Count -eq 1) {
                $hashTable.Add(
                    "EventSource", $parts[0].Trim()
                )
            } else {
                $hashTable.Add(
                    $parts[0].Trim(), ($parts[1..$parts.count] -join ":").Trim()
                )
            }
        })

        $output += [PSCustomObject]$hashTable

        $output.PSObject.TypeNames.Insert(
            0, "PSWecutil.SubscriptionRunTimeStatusEventSource"
        )
    }
    Write-Output -InputObject $output
}

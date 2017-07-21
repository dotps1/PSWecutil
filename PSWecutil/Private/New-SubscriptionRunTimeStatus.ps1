function New-SubscriptionRunTimeStatus {

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

    $startLine = 1
    $endLine = ($StringArray |
        Select-String -Pattern ":" -NotMatch |
            Select-Object -ExpandProperty LineNumber -First 1 -Skip 1) - 2
    
    $hashTable = [HashTable]::new()
    ($StringArray[$startLine..$endLine]).ForEach({
        $parts = $_ -split ":"
        $hashTable.Add(
            $parts[0].Trim(), $parts[1].Trim()
        )
    })

    $output = [PSCustomObject]$hashTable

    $output.PSObject.TypeNames.Insert(
        0, "PSWecutil.SubscriptionRunTimeStatus"
    )

    Write-Output -InputObject $output
}

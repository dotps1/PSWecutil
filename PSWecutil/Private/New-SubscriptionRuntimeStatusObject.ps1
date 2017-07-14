function New-SubscriptionRuntimeStatusObject {

    [CmdletBinding()]
    [OutputType()]

    param (
        [Parameter()]
        $SubscriptionRuntimeStatus
    )

    $eventSources = $SubscriptionRuntimeStatus | Select-String -NotMatch ":" | Select-Object
    $eventSourcesCollection = @()

    for ($i = 1; $i -lt $eventSources.Count; $i++) {
        $startLine = $eventSources[$i].LineNumber - 1
        if (($i + 1) -gt $eventSources.Count - 1) {
            $endLine = $rs.Count
        } else {
            $endLine = $eventSources[$i + 1].LineNumber - 1
        }

        $eventSourceObject = [HashTable]@{
            EventSource = $SubscriptionRuntimeStatus[$startLine].Trim()
        }
        for ($l = $startLine + 1; $l -lt $endLine; $l++) {
            $line = $SubscriptionRuntimeStatus[$l]
            $propertyName = $line.Substring(
                0, $line.IndexOf(
                    ":"
                )
            ).Trim()

            $propertyValue = $line.Substring(
                $line.IndexOf(
                    ":"
                ) + 1
            ).Trim()

            $eventSourceObject.Add(
                $propertyName, $propertyValue
            )
        }

        $eventSourcesCollection += [PSCustomObject]$eventSourceObject
    }

    $output = [HashTable]::new()
    for ($i = 1; $i -lt $eventSources[1].LineNumber - 1; $i++) {
        $line = $SubscriptionRuntimeStatus[$i]
        $propertyName = $line.Substring(
            0, $line.IndexOf(
                ":"
            )
        ).Trim()

        $propertyValue = $line.Substring(
            $line.IndexOf(
                ":"
            ) + 1
        ).Trim()

        $output.Add(
            $propertyName, $propertyValue
        )
    }

    $output.EventSources = $eventSourcesCollection

    [PSCustomObject]$output
}

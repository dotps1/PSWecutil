function Get-SubscriptionRunTimeStatus {

    [CmdletBinding()]
    [OutputType()]

    param (
        [Parameter()]
        [Alias(
            "ComputerName"
        )]
        [String]
        $Name = $env:COMPUTERNAME,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]
        $SubscriptionId = $null,

        [Parameter()]
        [String[]]
        $EventSource = $null,

        [Parameter()]
        [PSCredential]
        $Credential = [PSCredential]::Empty
    )

    $subscriptionRunTimeStatus = Invoke-Command -ComputerName $Name -ScriptBlock { wecutil.exe get-subscriptionruntimestatus "$($args[0])" "$($args[1])" } -ArgumentList $SubscriptionId, $EventSource -Credential $Credential

    $output = New-SubscriptionRuntimeStatus -StringArray $subscriptionRunTimeStatus
    $eventSourceOutput = New-SubscriptionRuntimeStatusEventSource -StringArray $subscriptionRunTimeStatus
    $outputProperties = $output |
        Get-Member |
            Select-Object -ExpandProperty Name
    if ("EventSources" -notin $outputProperties) {
        Add-Member -InputObject $output -NotePropertyName "EventSources" -NotePropertyValue $eventSourceOutput 
    } else {
        $output.EventSources = $eventSourceOutput
    }

    Write-Output -InputObject $output
}

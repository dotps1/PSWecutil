function Get-SubscriptionRunTimeStatus {

    [CmdletBinding()]
    [OutputType()]

    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]
        $SubscriptionId,

        [Parameter()]
        [String]
        $EventSource,

        [Parameter()]
        [Alias(
            "ComputerName"
        )]
        [String]
        $Name = $env:COMPUTERNAME,

        [Parameter()]
        [PSCredential]
        $Credential = [PSCredential]::Empty
    )

    $scriptBlock = [ScriptBlock]{
        $wecsvc = Get-Service -Name Wecsvc
        if (-not ( $wecsvc.Status -eq "Running" )) {
            throw "Service not running."
        }

        $subscriptions = wecutil.exe enum-subscription

        foreach ($arg in $args[0]) {
            if ($arg -in $subscriptions) {
                $output = wecutil.exe get-subscriptionruntimestatus "$arg" "$($args[1])"

                Write-Output -InputObject $output
            } else {
                Write-Error "Subscription not found: '$arg'."
                continue
            }
        }  
    }

    $subscriptionRunTimeStatus = Invoke-Command -ComputerName $Name -ScriptBlock $scriptBlock -ArgumentList $SubscriptionId, $EventSource -Credential $Credential

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

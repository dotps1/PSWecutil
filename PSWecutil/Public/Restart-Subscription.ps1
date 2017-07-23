function Restart-Subscription {

    [CmdletBinding()]
    [OutputType()]

    param (
        [Parameter(
            Mandatory = $true
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
        $Credential
    )

    $scriptBlock = [ScriptBlock]{
        $wecsvc = Get-Service -Name Wecsvc
        if (-not ( $wecsvc.Status -eq "Running" )) {
            throw "Service not running."
        }

        $subscriptions = wecutil.exe enum-subscription

        foreach ($arg in $args[0]) {
            if ($arg -in $subscriptions) {
                wecutil.exe retry-subscription "$arg" "$($args[1])"
            } else {
                Write-Error "Subscription not found: '$arg'."
                continue
            }
        }
    }

    $shouldProcess = $PSCmdlet.ShouldProcess(
        $SubscriptionId
    )
    if ($shouldProcess) {
        Invoke-Command -ScriptBlock $scriptBlock -ArgumentList $SubscriptionId, $EventSource -ComputerName $Name -Credential $Credential
    }
}

function Remove-Subscription {

    [CmdletBinding(
        ConfirmImpact = "High",
        SupportsShouldProcess = $true
    )]
    [OutputType(
        [Void]
    )]

    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]
        $SubscriptionId,

        [Parameter()]
        [PSCredential]
        $Credential = [PSCredential]::Empty,

        [Parameter()]
        [Alias(
            "ComputerName"
        )]
        [String]
        $Name = $env:COMPUTERNAME
    )

    $scriptBlock = [ScriptBlock]{
        $wecsvc = Get-Service -Name Wecsvc
        if (-not ( $wecsvc.Status -eq "Running" )) {
            throw "Service not running."
        }

        $subscriptions = wecutil.exe enum-subscription
        
        foreach ($arg in $args) {
            if ($arg -in $subscriptions) {
                wecutil.exe delete-subscription "$arg"
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
        Invoke-Command -ScriptBlock $scriptBlock -ArgumentList $SubscriptionId -ComputerName $Name -Credential $Credential
    }
}

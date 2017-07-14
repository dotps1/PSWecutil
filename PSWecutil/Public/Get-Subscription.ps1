function Get-Subscription {

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
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]
        $SubscriptionId = $null,

        [Parameter()]
        [PSCredential]
        $Credential = [PSCredential]::Empty
    )

    [ScriptBlock]$scriptBlock = {
        $wecsvc = Get-Service -Name Wecsvc
        if (-not ( $wecsvc.Status -eq "Running" )) {
            throw "Service not running."
        }

        $subscriptions = wecutil.exe enum-subscription

        if ($args.Count -eq 0) {
            foreach ($subscription in $subscriptions) {
                [Xml]$output = wecutil.exe get-subscription "$subscription" /format:XML

                Write-Output -InputObject $output
            }
        } else {
            foreach ($arg in $args) {
                if ($arg -in $subscriptions) {
                    [Xml]$output = wecutil.exe get-subscription $arg /format:XML

                    Write-Output -InputObject $output
                } else {
                    Write-Error "Subscription not found: '$arg'."
                    Write-Output $null
                }
            }
        }
    }

    try {
        $subscriptionsXmls = Invoke-Command -ComputerName $Name -ScriptBlock $scriptBlock -ArgumentList $SubscriptionId -Credential $Credential -ErrorAction Stop

        foreach ($subscriptionsXml in $subscriptionsXmls) {
            if ($null -ne $subscriptionsXml) {
                New-SubscriptionObject -SubscriptionXml $subscriptionsXml
            }
        }

    } catch { 
        $PSCmdlet.ThrowTerminatingError(
            $_
        )
    }
}

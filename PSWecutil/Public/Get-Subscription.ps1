function Get-Subscription {

    [CmdletBinding()]
    [OutputType()]

    param (
        [Parameter()]
        [Alias(
            "ComputerName"
        )]
        [String]
        $Name,

        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]
        $SubscriptionName = $null,

        [Parameter()]
        [PSCredential]
        $Credential = [PSCredential]::Empty
    )

    begin {

    }

    process {
        try {
            [ScriptBlock]$scriptBlock = {
                $wecsvc = Get-Service -Name Wecsvc
                if (-not ( $wecsvc.Status -eq "Running" )) {
                    throw "Service not running."
                }

                $subscriptions = wecutil.exe enum-subscription

                if ($null -eq $args) {
                    foreach ($subscription in $subscriptions) {
                        [XML](wecutil.exe get-subscription "$subscription" /format:XML)
                    }
                } else {
                    foreach ($arg in $args) {
                        if ($arg -in $subscriptions) {
                            [Xml](wecutil.exe get-subscription $arg /format:XML)
                        } else {
                            Write-Error "Subscription not found: '$arg'."
                            Write-Output $null
                        }
                    }
                }
            }

            $subscriptionsXmls = Invoke-Command -ComputerName $Name -ScriptBlock $scriptBlock -ArgumentList $SubscriptionName -Credential $Credential

            foreach ($subscriptionsXml in $subscriptionsXmls) {
                if ($null -ne $subscriptionsXml) {
                    New-SubscriptionObject -SubscriptionXml $subscriptionsXml
                }
            }

        } catch { $_ }
    }
}

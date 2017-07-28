using module ..\PSWecutil.classes.psm1

function Get-Subscription {

    [CmdletBinding()]
    [OutputType()]

    param (
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]
        $SubscriptionId = $null,

        [Parameter()]
        [Switch]
        $AsXml,

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
                    continue
                }
            }
        }
    }

    $subscriptions = Invoke-Command -ComputerName $Name -ScriptBlock $scriptBlock -ArgumentList $SubscriptionId -Credential $Credential

    foreach ($subscription in $subscriptions) {
        if ($null -ne $subscription) {
            if ($AsXml.IsPresent) {
                $output = Format-Xml -Xml $subscription.InnerXml
            } else {
                $output = [Subscription]$subscription

                $output.PSObject.TypeNames.Insert(
                    0, "PSWecutil.Subscription"
                )
            }

            Add-Member -InputObject $output -NotePropertyName PSComputerName -NotePropertyValue $Name
            
            Write-Output -InputObject $output
        }
    }
}

function New-SubscriptionObject {
    
    [CmdletBinding()]
    [OutputType(
        [PSCustomObject]
    )]

    param (
        [Parameter(
            Mandatory = $true
        )]
        [Object]
        $SubscriptionXml
    )

    $subscription = ConvertFrom-Xml $SubscriptionXml.Subscription
    $query = $SubscriptionXml.Subscription.Query."#cdata-section"

    $subscription.Query = $query

    $output = [PSCustomObject]$subscription

    $output.PSObject.Properties.Remove(
        "xmlns"
    )

    Write-Output -InputObject $output
}

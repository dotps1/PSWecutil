using module ..\PSWecutil.classes.psm1

function New-Subscription {

    [CmdletBinding()]
    [OutputType(
        [Subscription]
    )]

    param (
        [Parameter(
            Mandatory = $true
        )]
        [Alias(
            "SubscriptionName"
        )]
        [String]
        $SubscriptionId,

        [Parameter(
            Mandatory = $true
        )]
        [ValidateSet(
            "CollectorInitiated", "SourceInitiated"
        )]
        [System.String]
        $SubscriptionType,

        [Parameter()]
        [String]
        $Description,

        [Parameter()]
        [Bool]
        $Enabled = $true,

        [Parameter()]
        [ValidateSet(
            "Push", "Pull"
        )]
        [String]
        $DeliveryMode = "Push",

        [Parameter()]
        [Int]
        $MaxItems = 1,

        [Parameter()]
        [Int]
        $MaxLatencyTime = 20000,

        [Parameter()]
        [Int]
        $HeartbeatInterval = 20000,

        [Parameter()]
        [Bool]
        $ReadExistingEvents = $false,

        [Parameter()]
        [ValidateSet(
            "Http", "Https"
        )]
        [String]
        $TransportName = "Http",

        [Parameter()]
        [Int]
        $TransportPort = 5985,

        [Parameter()]
        [String]
        $ContentFormat = "RenderedText",

        [Parameter()]
        [String]
        $Locale = "en-US",

        [Parameter()]
        [String]
        $LogFile = "ForwardedEvents",

        [Parameter()]
        [ValidateSet(
            "Default", "Basic", "Negotiate", "Digest"
        )]
        [String]
        $CredentialsType = "Default"
    )

    [Xml]$xml = Get-Content -Path $PSScriptRoot\..\bin\Subscription.Template.xml

    $xml.Subscription.SubscriptionId = $SubscriptionId
    $xml.Subscription.SubscriptionType = $SubscriptionType
    $xml.Subscription.Description = $Description
    $xml.Subscription.Enabled = [String]$Enabled
    $xml.Subscription.Delivery.Mode = $DeliveryMode
    $xml.Subscription.Delivery.Batching.MaxItems = [String]$MaxItems
    $xml.Subscription.Delivery.Batching.MaxLatencyTime = [String]$MaxLatencyTime
    $xml.Subscription.Delivery.PushSettings.Heartbeat.Interval = [String]$HeartbeatInterval
    $xml.Subscription.ReadExistingEvents = [String]$ReadExistingEvents
    $xml.Subscription.TransportName = $TransportName
    $xml.Subscription.TransportPort = [String]$TransportPort
    $xml.Subscription.ContentFormat = $ContentFormat
    $xml.Subscription.Locale.Language = $Locale
    $xml.Subscription.LogFile = $LogFile

    if ($SubscriptionType -eq "CollectorInitiated") {
        $element = $xml.CreateElement(
            "CredentialsType", $xml.DocumentElement.NamespaceURI
        )
        
        [Void]$element.set_InnerText(
            $CredentialsType
        )

        $xml.Subscription.AppendChild(
            $element
        )
    }

    Format-Xml -Xml $xml.InnerXml
}

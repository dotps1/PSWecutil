class Subscription {

    [String]$SubscriptionId
    [String]$SubscriptionType
    [String]$Description
    [Bool]$Enabled
    [Uri]$Uri
    [String]$ConfigurationMode
    [Delivery]$Delivery
    [String[]]$QueryList
    [Bool]$ReadExistingEvents
    [String]$TransportName
    [String]$ContentFormat
    [Locale]$Locale
    [String]$LogFile
    [String]$PublisherName
    [AllowedSourceNonDomainComputers[]]$AllowedSourceNonDomainComputers
    [String]$AllowedSourceDomainComputers


    Subscription ([Object]$Object) {
        $this.SubscriptionId = $Object.Subscription.SubscriptionId
        $this.SubscriptionType = $Object.Subscription.SubscriptionType
        $this.Description = $Object.Subscription.Description
        $this.Enabled = $Object.Subscription.Enabled
        $this.Uri = $Object.Subscription.Uri
        $this.ConfigurationMode = $Object.Subscription.ConfigurationMode
        $this.Delivery = $Object.Subscription.Delivery
        $this.QueryList = $Object.Subscription.Query."#cdata-section"
        $this.ReadExistingEvents = $Object.Subscription.ReadExistingEvents
        $this.TransportName = $Object.Subscription.TransportName
        $this.ContentFormat = $Object.Subscription.ContentFormat
        $this.Locale = $Object.Subscription.Locale
        $this.LogFile = $Object.Subscription.LogFile
        $this.PublisherName = $Object.Subscription.PublisherName
        $this.AllowedSourceNonDomainComputers = $Object.Subscription.AllowedSourceNonDomainComputers
        $this.AllowedSourceDomainComputers = $Object.Subscription.AllowedSourceDomainComputers
    }
}

class Delivery {

    [String]$Mode
    [Batching]$Batching
    [PushSettings]$PushSettings

    Delivery ([Object]$Object) {
        $this.Mode = $Object.Mode
        $this.Batching = $Object.Batching
        $this.PushSettings = $Object.PushSettings
    }
}

class Batching {

    [Int]$MaxItems
    [Int]$MaxLatencyTime

    Batching ([Object]$Object) {
        $this.MaxItems = $Object.MaxItems
        $this.MaxLatencyTime = $Object.MaxLatencyTime
    }
}

class PushSettings {

    [Heartbeat]$Heartbeat
    
    PushSettings ([Object]$Object) {
        $this.Heartbeat = $Object.Heartbeat
    }
}

class Heartbeat {

    [Int]$Interval

    Heartbeat ([Object]$Object) {
        $this.Interval = $Object.Interval
    }
}

class Locale {

    [String]$Language

    Locale ([Object]$Object) {
        $this.Language = $Object.Language
    }
}

class AllowedSourceNonDomainComputers {

    [String[]]$AllowedIssuerCAList

    AllowedSourceNonDomainComputers ([Object]$Object) {
        $this.AllowedIssuerCAList = $Object.AllowedIssuerCAList
    }
}

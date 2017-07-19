# PowerShell wrapper for Wecutil.exe
This is a PowerShell project to wrapper the wecutil.exe with powershell cmdlets.  Still has a ways to go, but here is a start.  Feel free to contribute.

## Current functions

```
GitHub:\PSWecutil> Get-Command -Module PSWecutil | Sort-Object Name

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Get-Subscription                                   0.0.0.3    PSWecutil
Function        Get-SubscriptionRunTimeStatus                      0.0.0.3    PSWecutil
Function        Invoke-WindowsEventCollectorQuickConfig            0.0.0.3    PSWecutil
Function        Remove-Subscription                                0.0.0.3    PSWecutil
```

## Examples

### Example 1
List all subscriptions on a given server:

```
PS C:\> Get-Subscription -ComputerName eventcollector.dotps1.github.io

SubscriptionId                  : ForwadedAppLockerEvents-Win10
SubscriptionType                : SourceInitiated
Description                     :
Enabled                         : True
Uri                             : http://schemas.microsoft.com/wbem/wsman/1/windows/EventLog
ConfigurationMode               : Normal
Delivery                        : Delivery
Query                           : {Query, Query, Query, Query}
ReadExistingEvents              : True
TransportName                   : HTTP
ContentFormat                   : RenderedText
Locale                          : Locale
LogFile                         : ForwardedEvents
PublisherName                   : Microsoft-Windows-EventCollector
AllowedSourceNonDomainComputers : {AllowedSourceNonDomainComputers}
AllowedSourceDomainComputers    : O:NSG:BAD:P(A;;GA;;;DC)S:
```

### Example 2
Examine the queries in the subscription:

```
PS C:\> Get-Subscription -ComputerName eventcollector.dotps1.github.io | Select-Object -ExpandProperty Query

Path                                                Text
----                                                ----
Microsoft-Windows-AppLocker/EXE and DLL             *[System[(Level=1  or Level=2 or Level=3)]]
Microsoft-Windows-AppLocker/MSI and Script          *[System[(Level=1  or Level=2 or Level=3)]]
Microsoft-Windows-AppLocker/Packaged app-Deployment *[System[(Level=1  or Level=2 or Level=3)]]
Microsoft-Windows-AppLocker/Packaged app-Execution  *[System[(Level=1  or Level=2 or Level=3)]]
```

### Example 3
List the Subscription RunTime Status for a given event source:

```
PS C:> Get-SubscriptionRunTimeStatus -ComputerName eventcollector.dotps1.github.io -SubscriptionId AppLockerEvents -EventSource workstation.dotps1.github.io


Subscription            LastError RunTimeStatus EventSources                                                                                   
------------            --------- ------------- ------------                                                                                   
ForwadedAppLockerEvents 0         Active        {@{LastError=0; RunTimeStatus=Active; EventSource=workstation.dotps1.github.io; LastHeartbeat...
```

# PowerShell wrapper for Wecutil.exe
This is a PowerShell project to wrapper the wecutil.exe with powershell cmdlets and replace the following:

```
wecutil es => Get-Subscription
wecutil gs => Get-Subscription
wecutil gr => Get-SubscriptionRunTimeStatus
wecutil ss => Set-Subscription
wecutil cs => New-Subscription
wecutil ds => Remove-Subscription
wecutil rs => Restart-Subscription
wecutil qc => Invoke-WindowsEventCollectorQuickConfiguration
```

This module will output PSCustomObjects or custom class objects so the input/output will be easier to work with, especially the New and Set subscription functions.
Rather then working with string parsing and/or xml.

## Current functions

```
GitHub:\PSWecutil> Get-Command -Module PSWecutil | Sort-Object Name

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Get-Subscription                                   0.0.0.4    PSWecutil
Function        Get-SubscriptionRunTimeStatus                      0.0.0.4    PSWecutil
Function        Invoke-WindowsEventCollectorQuickConfiguration     0.0.0.4    PSWecutil
Function        Remove-Subscription                                0.0.0.4    PSWecutil
Function        Restart-Subscription                               0.0.0.4    PSWecutil
```

## Examples

### Example 1
List all subscriptions on a given server:

```
PS C:\> Get-Subscription -ComputerName eventcollector.dotps1.github.io


PSComputerName   : eventcollector.dotps1.github.io
SubscriptionId   : ForwardedAppLockerEvents
SubscriptionType : SourceInitiated
Enabled          : True
LogFile          : ForwardedEvents
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
PS C:> Get-SubscriptionRunTimeStatus -ComputerName eventcollector.dotps1.github.io -SubscriptionId ForwardedAppLockerEvents -EventSource workstation.dotps1.github.io


Subscription   : ForwardedAppLockerEvents
LastError      : 0
RunTimeStatus  : Active
EventSources   : {@{LastError=0; RunTimeStatus=Active; EventSource=workstation.dotps1.github.io; LastHeartbeatTime=2017-07-21T11:27:56.745}}
PSComputerName : eventcollector.dotps1.github.io
```

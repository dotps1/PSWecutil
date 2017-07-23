# PowerShell wrapper for Wecutil.exe
This is a PowerShell project to wrapper the wecutil.exe with powershell cmdlets.  Replacing the following:

```
Windows Event Collector Utility

Enables you to create and manage subscriptions to events forwarded from remote
event sources that support WS-Management protocol.

Usage:

You can use either the short (i.e. es, /f) or long (i.e. enum-subscription, /format)
version of the command and option names. Commands, options and option values are
case-insensitive.

(ALL UPPER-CASE = VARIABLE)

wecutil COMMAND [ARGUMENT [ARGUMENT] ...] [/OPTION:VALUE [/OPTION:VALUE] ...]

Commands:

es (enum-subscription)               List existent subscriptions.
gs (get-subscription)                Get subscription configuration.
gr (get-subscriptionruntimestatus)   Get subscription runtime status.
ss (set-subscription)                Set subscription configuration.
cs (create-subscription)             Create new subscription.
ds (delete-subscription)             Delete subscription.
rs (retry-subscription)              Retry subscription.
qc (quick-config)                    Configure Windows Event Collector service.

Common options:

/h|? (help)
Get general help for the wecutil program.

wecutil { -help | -h | -? }

For arguments and options, see usage of specific commands:

wecutil COMMAND -?
```

## Current functions

```
GitHub:\PSWecutil> Get-Command -Module PSWecutil | Sort-Object Name

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Get-Subscription                                   0.0.0.4    PSWecutil
Function        Get-SubscriptionRunTimeStatus                      0.0.0.4    PSWecutil
Function        Invoke-WindowsEventCollectorQuickConfig            0.0.0.4    PSWecutil
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

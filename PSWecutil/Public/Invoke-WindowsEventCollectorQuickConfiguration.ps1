function Invoke-WindowsEventCollectorQuickConfiguration {

    [CmdletBinding(
        ConfirmImpact = "High",
        SupportsShouldProcess = $true
    )]
    [OutputType(
        [Void]
    )]

    param (
        [Parameter()]
        [Switch]
        $Confirm,

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

    $shouldProcess = $PSCmdlet.ShouldProcess(
        $Name
    )
    if ($shouldProcess) {
        Invoke-Command -ScriptBlock { wecutil.exe quick-config /q:true } -ComputerName $name -Credential $Credential
    }
}

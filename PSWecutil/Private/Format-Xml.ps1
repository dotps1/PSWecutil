function Format-Xml {

    [CmdletBinding()]
    [OutputType()]

    param (
        [Parameter()]
        [Xml]
        $Xml
    )

    $stringWriter = New-Object -TypeName System.IO.StringWriter
    $xmlTextWriter = New-Object -TypeName System.Xml.XmlTextWriter $stringWriter -Property @{ Formatting = "Indented" }

    $Xml.WriteTo(
        $xmlTextWriter
    )

    $xmlTextWriter.Flush()
    $stringWriter.Flush()

    Write-Output $StringWriter.ToString();
}

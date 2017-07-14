function ConvertFrom-Xml {

    [CmdletBinding()]
    [OutputType(
        [PSCustomObject]
    )]

    param (
        [Parameter(
            Mandatory = $true
        )]
        [Object]
        $Xml
    )

    $hashTable = [HashTable]::new()
    $properties = $xml |
        Get-Member -MemberType Property

    foreach ($property in $properties) {
        $name = $property.Name

        $propertryType = $property.Definition.SubString(
            0, $property.Definition.IndexOf(
                [Char]" "
            )
        )
        switch ($propertryType) {
            "String" {
                $hashTable.$name = $xml.$name
            }

            "System.Xml.XmlElement" {
                $object = $xml.$name
                $hashTable.$name = [HashTable]::new()

                if ($object.HasAttributes) {
                    $object.Attributes.ForEach({
                        $hashTable.$name = ConvertFrom-Xml -Xml $object 
                    })
                }

                if ($object.HasChildNodes) {
                    $object.ChildNodes.ForEach({ 
                        $hashTable.$name.$( $_.Name ) = ConvertFrom-Xml -Xml $object.$( $_.Name )
                    })
                }
            }
        }
    }

    Write-Output -InputObject $hashTable
}

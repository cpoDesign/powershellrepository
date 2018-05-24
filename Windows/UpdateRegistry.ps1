  <#
    .DESCRIPTION
        Add/update the value in the registry
    .PARAMETER path
        The registry key path to add/update
    .PARAMETER name
        The name of the key to add a value to
    .PARAMETER value
        The value to insert
    .PARAMETER type
        The type of regsitry node
    .NOTES
    #>
    function UpdateRegistry() {
        param (
            [string]$path,
            [string]$name,
            [object]$value,
            [string]$type = "String"
        )
        # Create Key if required
        if (!(Test-Path $path))
        {
            New-Item -Path $path -Force
        }

        # Add/Update value
        New-ItemProperty -Path $path -Name $name -Value $value -PropertyType $type -Force
    }

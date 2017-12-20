function Copy-Files {
    <#
    .SYNOPSIS
    Copies specified files and directories to each specified destination using Robocopy.

    .DESCRIPTION
    Specified sources, destinations, and robocopy options will be used to make copy operations.
    Both files and directories can be used as sources.
    Sources and destinations paths can either be local (e.g. 'C:\Folder'), network (e.g. '\\ServerName\Folder'), or relative from the working directory (e.g. 'Folder\Subfolder').

    Fill in the sources, destinations, and robocopy options within a Copy-Files standalone or configuration script. Then manually run the script, or set it to run on a schedule.
    To copy in batches, repeat the same steps for each batch of files and directories to be copied, giving each script a unique name of your choice.

    .PARAMETER Config
    The configuration hashtable containing sources, destinations, and robocopy options to be used by Copy-Files.

    .EXAMPLE
    .\Copy-Files-Batch-001.ps1
    Runs script within the working directory named Copy-Files-Batch-001.ps1 in the current instance of Powershell.

    .EXAMPLE
    Powershell "C:\scripts\Copy-Files\Copy-Files-Batch-001.ps1"
    Runs script named Copy-Files-Batch-001.ps1 in a separate instance of Powershell.

    .EXAMPLE
    Copy-Files -Config $batch001
    Runs the Copy-Files module with the configuration hashtable named $batch001.

    .NOTES
    Copy-Files serves as a wrapper around the Robocopy as a convenient and automatable file and directory copying solution.
    Robocopy, otherwise known as Robust File Copy, is a command-line directory and/or file replication command in Windows.
    It is recommended you have some knowledge about and experience with Robocopy before using Copy-Files.
    For more information on Robocopy, refer to Microsoft's documentation on the command, or run 'robocopy /?'.

    .LINK
    https://github.com/joeltimothyoh/Copy-Files
    #>

    [CmdletBinding()]
	Param(
        [Parameter(Mandatory=$True)]
        [alias("c")]
        [hashtable[]]$Config
    )

    # Retrieve the respective arrays from the config hashtable
    $sources = $Config.Sources
    $destinations = $Config.Destinations
    $robocopy_options = $Config.Robocopy_options

    # Signal Start
    Write-Output "-------------  Copy-Files Started: $(Get-Date)  -------------"

    # Return if sources or destinations are null
    if ($sources.count -eq 0) {
        Write-Output "No sources were specified. Exiting."
        return
    } elseif ($destinations.count -eq 0) {
        Write-Output "No destinations were specified. Exiting."
        return
    }

    # Trim config arrays
    $sources = $sources.Trim()
    $destinations = $destinations.Trim()
    if ($robocopy_options.count -gt 0) {
        $robocopy_options = $robocopy_options.Trim()
    }

    # Initialize source variables
    $sources_valid = @()
    $sources_invalid = @()
    $sources_empty_cnt = 0

    # Store valid and invalid sources into separate arrays, and count the number of empty strings
    foreach ($source in $sources)
    {
        try {
            $source_valid = Get-Item $source -Force -ErrorAction Stop
            $sources_valid += $source_valid
        }
        catch {
            $e = $_.Exception.Gettype().Name
            if ($e -eq 'ItemNotFoundException') {
                $sources_invalid += $source
            }
            if ($e -eq 'ParameterBindingValidationException') {
                $sources_empty_cnt++
            }
        }
    }

    # Return if all sources are invalid
    if ($sources_valid.count -eq 0) {
        Write-Output "All the sources specified either cannot be found or are empty strings. Exiting."
        return
    }

    # Initialize destination variables
    $destinations_valid = @()
    $destinations_empty_cnt = 0

    # Store valid destinations into separate array, and count the number of empty strings
    foreach ($destination in $destinations) {
        if ($destination -ne '') {
            $destinations_valid += $destination
        }
        if ($destination -eq '') {
            $destinations_empty_cnt++
        }
    }

    # Return if all destinations are empty strings
    if ($destinations_valid.count -eq 0) {
        Write-Output "All destinations specified are empty strings. Exiting."
        return
    }

    # Define command variable
    $cmd = 'robocopy'

    # Signal Summary
    Write-Host "`n- - - - -`n SUMMARY`n- - - - -" -ForegroundColor Cyan

    # Print Summary
    Write-Output "`nSources:" $sources_valid.FullName
    if ($sources_invalid.count -gt 0) {
        Write-Output "`nSources (Not Found):" $sources_invalid
    }
    if ($sources_empty_cnt -gt 0) {
        Write-Output "`nSources (Empty Strings): $sources_empty_cnt"
    }
    Write-Output "`nDestinations:" $destinations_valid
    if ($destinations_empty_cnt -gt 0) {
        Write-Output "`nDestinations (Empty Strings): $destinations_empty_cnt"
    }
    if ($robocopy_options.count -gt 0) {
        Write-Output "`nRobocopy Options: `n$robocopy_options"
    }

    # Signal start copy
    Write-Host "`n`n- - - -`n START`n- - - -" -ForegroundColor Green

    # Make a copy of valid sources to each valid destination
    foreach ($destination_valid in $destinations_valid) {
        Write-Host "`nDestination: $destination_valid" -ForegroundColor Green -BackgroundColor Black

        foreach ($source_valid in $sources_valid) {
            Write-Host "`nSource: $($source_valid.FullName)" -ForegroundColor Yellow -BackgroundColor Black
            Write-Host "Type: $($source_valid.Attributes)" -ForegroundColor Yellow

            # Define parameters depending on whether source is a file or directory
            if ($source_valid.Attributes -match 'Archive') {        # match is used as .Attributes property returns as a string of attributes
                $prm = $source_valid.DirectoryName, $destination_valid, $source_valid.Name + ($robocopy_options | Where-Object { ($_ -ne '/MIR') -and ($_ -ne '/E') -and ($_ -ne '/S') } )      # /MIR, /E, /S will be ignored for file sources
            }
            elseif ($source_valid.Attributes -match 'Directory') {
                $prm = $source_valid.FullName, "$($destination_valid)\$($source_valid.Name)" + $robocopy_options
            }

            # Execute Robocopy with set parameters
            Write-Host "Command: $($cmd) $($prm)" -ForegroundColor Yellow
            & $cmd $prm
        }

    }

    # Signal end copy
    Write-Host "`n- - -`n END`n- - -" -ForegroundColor Magenta

    # Signal End
    Write-Output "-------------   Copy-Files Ended: $(Get-Date)   -------------"

}

# Export the members of the module
Export-ModuleMember -Function Copy-Files
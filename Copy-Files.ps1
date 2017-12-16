<#
.SYNOPSIS
Copies specified files and directories to each specified destination using Robocopy.

.DESCRIPTION
Specified sources, destinations, and robocopy options will be used to make copy operations.
Both files and directories can be used as sources.
Sources and destinations can be local or network paths (e.g. 'C:\Folder' or '\\ServerName\Folder'). If neither is used (e.g. 'Folder'), the specified path will be taken to be a relative path from the working directory.

For more information on robocopy options, run 'robocopy /?'

.EXAMPLE
.\Copy-Files-Batch-001.ps1

#>

########################   Files and directories to copy   ########################

$sources = @(
    # 'C:\Users\username\Documents\Project 1\example folder'
    # 'C:\Users\username\Documents\Project 1\example.docx'
    # 'D:\Git\Project 1\repository2'
)

###########################   Destination directories   ###########################

$destinations = @(
    # 'E:\Backup\Projects\Project 1'
    # '\\SERVER1\Projects\Project 1'
    # '\\SERVER2\Shared\Projects\Project 1'
)

##############################   Robocopy options   ###############################

# Refer to Robocopy's documentation for more options
$robocopy_options = @(
      '/E'                       # Copy subdirectories including empty ones
    # '/S'                       # Copy subdirectories excluding empty ones
    # '/PURGE'                   # Remove files or directories in destination no longer existing in source
    # '/MIR'                     # Mirrored copy. Equivalent to /E plus /PURGE
    # '/IF'                      # Only copy files with matching names or wildcards
    # '*.jpg'
    # '*.docx'
    # '/XF'                      # Exclude files with matching names or wildcards from all operations
    # 'readme.txt'
    # '*.log'
    # '/XD'                      # Exclude directories with matching names or wildcards from all operations
    # 'misc'
    # '*.git'
    # '/SL'                      # Copy symbolic links instead of targets
    # '/XL'                      # Exclude copying of files only present in source
    # '/XX'                      # Exclude removal of files only present in destination. A safety switch when used with /PURGE or /MIR
    # '/XA:SH'                   # Exclude copying of system and hidden files
    # '/SEC'                     # Include security info
    # '/COPY:DAT'                # Include specified file info. Default is /COPY:DAT (D=Data, A=Attributes, T=Timestamps)
    # '/COPYALL'                 # Include all file info. Equivalent to /COPY:DATSOU (S=Security=NTFS ACLs, O=Owner info, U=Auditing info)
    # '/L'                       # List-only mode, no copying, deleting, or timestamping
    # '/V'                       # Show verbose output
    # '/NJH'                     # No job header
    # '/NJS'                     # No job summary
    # '/LOG+:C:\pathto\log.txt'  # Append output to log file. Directory of log file must already exist
    # '/TEE'                     # Output both to the console window and log file
)

###################################################################################

function Copy-Files {

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
    if ($robocopy_options.count -ne 0) {
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

# Call function
Copy-Files
<#
.SYNOPSIS
Copies specified files and directories to each specified destination using Robocopy.

.DESCRIPTION
Specified sources, destinations, and robocopy options will be used to make copy operations.
Both files and directories can be used as sources.
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
    # '/IF'                      # Only copy the following files with matching names or wildcards
    # '*.jpg'
    # '*.docx'
    # '/XF'                      # Exclude the following files with matching names or wildcards from all operations
    # 'readme.txt'
    # '*.log'
    # '/XD'                      # Exclude the following directories with matching names or wildcards from all operations
    # 'misc'
    # '*.git'
    # '/SL'                      # Copy symbolic links instead of targets
    # '/XL'                      # Exclude copying of files only present in source
    # '/XX'                      # Exclude removal of files only present in destination. A safety switch when used with /PURGE or /MIR
    # '/XA:SH'                   # Exclude copying of system and hidden files
    # '/SEC'                     # Include security info
    # '/COPY:DAT'                # Include specified file info. Default is /COPY:DAT (D=Data, A=Attributes, T=Timestamps)
    # '/COPYALL'                 # Include all file info. Equivalent to /COPY:DATSOU (S=Security=NTFS ACLs, O=Owner info, U=Auditing info)
    # '/L'                       # List only mode, no copying, deleting, or timestamping
    # '/V'                       # Show verbose output
    # '/NJH'                     # No job header
    # '/NJS'                     # No job summary
    # '/LOG+:C:\pathto\log.txt'  # Append output to log file
)

###################################################################################

function Copy-Files {
    
    # Signal Start
    Write-Output "-------------  Copy-Files Started: $(Get-Date)  -------------"

    # Return if sources or destinations are not specified
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

    # Initialize arrays
    $items = @()
    $invalid_items = @()

    # Check if each source specified exists. Store properties if they exist
    foreach ($source in $sources)
    {
        try {
            $valid_item = Get-Item $source -Force -ErrorAction Stop
            $items += $valid_item
        }
        catch {
            $e = $_.Exception.Gettype().Name
            if ($e -eq 'ItemNotFoundException') {
                $invalid_items += $source
            }
        }
    }

    # Return if all sources are invalid
    if ($items.count -eq 0) {
        Write-Output "All the sources specified do not exist. Exiting."
        return
    }

    # Define command variable
    $cmd = 'robocopy'

    # Print variables to stdout
    Write-Output "`nSources:" $items.FullName
    if ($invalid_items.count -gt 0) {
        Write-Output "`nSources (Invalid):" $invalid_items
    }
    Write-Output "`nDestinations:" $destinations
    if ($robocopy_options.count -gt 0) {
        Write-Output "`nRobocopy Options: `n$robocopy_options"
    }

    # Signal start copy
    Write-Output "`n- - - -`n START`n- - - -"

    # Make a copy of all sources to each destination specified
    foreach ($destination in $destinations) {
        Write-Output "`n> Destination: $($destination)"

        foreach ($item in $items) {
            Write-Output "`nSource: $($item.FullName)"
            Write-Output "Item Attributes: $($item.Attributes)"

            # Define parameters depending on whether source is a file or directory
            if ($item.Attributes -match 'Archive') {        # match is used as $item.Attributes returns a string of attributes
                $prm = $item.DirectoryName, $destination, $item.Name + ($robocopy_options | Where-Object { ($_ -ne '/MIR') -and ($_ -ne '/E') -and ($_ -ne '/S') } )      # /MIR, /E, /S will be ignored for file sources
            }
            elseif ($item.Attributes -match 'Directory') {
                $prm = $item.FullName, "$($destination)\$($item.Name)" + $robocopy_options
            }

            # Execute Robocopy with set parameters
            Write-Output "Command: $($cmd) $($prm)"
            & $cmd $prm
        }
    }

    # Signal end copy
    Write-Output "`n- - -`n END`n- - -"

    # Signal End
    Write-Output "-------------   Copy-Files Ended: $(Get-Date)   -------------"

}

# Call function
Copy-Files
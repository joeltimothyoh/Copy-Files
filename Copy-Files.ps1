<#
.SYNOPSIS
Copies files and directories to specified destination(s) using Robocopy.

.DESCRIPTION
Specified sources, destinations, and robocopy options will be used to make copy operations.
Both files and directories can be used as sources.
For more information on robocopy options, run 'robocopy /?'

.EXAMPLE
.\Copy-Files-Batch-001.ps1

#>

########################   Files and directories to copy   ########################

$sources = @(
    # 'C:\Users\username\Documents\Project1'
    # 'C:\Users\username\Documents\report.doc'
    # 'D:\Git\Project1\Repository3'
)

###########################   Destination directories   ###########################

$destinations = @(
    # 'E:\Backup\AllProjects'
    # 'G:\backupfolder\scripts'
    # '\\SERVER1\projects\project1'
)

##############################   Robocopy options   ###############################

# Refer to Robocopy's documentation for more options
$robocopy_options = @(
    # '/E'                       # Copy subdirectories including empty ones
    # '/S'                       # Copy subdirectories excluding empty ones
    # '/PURGE'                   # Remove files or directories in destination no longer existing in source
    # '/MIR'                     # Mirrored copy. Equivalent to /E plus /PURGE
    # '/IF'                      # Copy files with matching names or wildcards
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
    # '/XX'                      # Exclude removal of files only present in destination
    # '/XA:SH'                   # Exclude copying of system and hidden files
    # '/L'                       # List only mode, no copying, deleting, or timestamping
    # '/V'                       # Show verbose output
    # '/NJH'                     # No job header
    # '/NJS'                     # No job summary
    # '/LOG+:C:\pathto\log.txt'  # Append output to log file
)

###################################################################################

function Copy-Files {

    # Return if sources or destinations are not specified
    if ($sources.count -eq 0) {
        Write-Output "No sources were specified. Exiting."
        return
    } elseif ($destinations.count -eq 0) {
        Write-Output "No destinations were specified. Exiting."
        return
    } 
    
    # Initialize arrays
    $items = @()
    $invalid_sources = @()
    
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
                $invalid_sources += $source
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
    Write-Output "- - - - - - -  Started: $(Get-Date)  - - - - - - -"
    Write-Output "`nSources:" $items.FullName
    if ($invalid_sources.count -gt 0) {
        Write-Output "`nSources (Invalid):" $invalid_sources
    }
    Write-Output "`nDestinations:" $destinations
    if ($robocopy_options.count -gt 0) {
        Write-Output "`nRobocopy Options: `n$robocopy_options"
    }

    # Signal Start
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

    # Signal End
    Write-Output "`n- - -`n END`n- - -"
    Write-Output "- - - - - - -  Ended: $(Get-Date)  - - - - - - -"

}

# Call function
Copy-Files
# Copy-Files. 

function Copy-Files {
    <#
    .SYNOPSIS
    Copy-Files will copy select files and directories to specified destination(s).
    
    .DESCRIPTION
    Copy-Files will copy select files and directories to specified destination(s) using Robocopy.
    The Robocopy /E parameter is enabled by default. /E specifies robocopy to copy all subdirectories, including empty ones.
    The Robocopy /MIR parameter is left out by default. /MIR specifies robocopy to make a mirror copy of the source directory in the destination directory. Use /MIR with caution as it will delete files in the destination not present in the source.
    Files that are specified as sources will not have /MIR, /E or /S passed along with them, so as to prevent directories within the same directory from being copied as well, a behavior of Robocopy when specific files are copied with any one of those parameters passed.
    Run 'robocopy /?' for usage information.
      
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>

    Param()

    # Files and directories to copy
    $sources = @( 
       # 'C:\Users\username\Documents\Project1'
       # 'C:\Users\username\Documents\report.doc'
       # 'D:\Git\Project1\Repository3'  
    )

    # Destination directories
    $destinations = @(
       # 'E:\Backup\AllProjects'
       # 'G:\backupfolder\scripts'
       # '\\SERVER1\projects\project1'
    )

    # Robocopy copy options. Run 'robocopy /?' for usage information.
    $robocopy_options = @(
        '/E'                        # Copy subdirectories including empty ones
        #'/S'                       # Copy subdirectories excluding empty ones
        #'/MIR'                     # Mirror copy, equivalent to /E plus /PURGE
        #'/XL'                      # Exclude copying of lonely files only present in source
        #'/XX'                      # Exclude deleting of extra files only present in destination
        #'/XA:H'                    # Exclude hidden files from all operations
        #'/SL'                      # Copy symbolic links instead of targets
        #'/XF'                      # Exclude files with matching names or wildcards from all operations
        #'readme.txt'
        #'*.log'
        #'/XD'                      # Exclude directories with matching names or wildcards from all operations
        #'subfolder1'
        #'misc'
        #'*.git'
        #'/L'                       # List only, no copying, deleting, or timestamping (Mock mode)        
        #'/V'                       # Show verbose output
        #'/NJH'                     # No job header
        #'/NJS'                     # No job summary
    )

    # Get properties of each source specified
    $items = Get-Item $sources -Force

    # Return if either sources or destinations are not specified, or if all sources are invalid
    if ($sources.count -eq 0) {
        Write-Output "Sources are not set. Exiting."
        return
    } elseif ($destinations.count -eq 0) {
        Write-Output "Destinations are not set. Exiting."
        return
    } elseif ($items.count -eq 0) {
        Write-Output "All sources are invalid. Exiting."
        return
    }

    # Define command variable
    $cmd = 'robocopy'

    # Debug     
    Write-Output "Sources:" $sources ""
    Write-Output "Destinations:" $destinations ""
    Write-Output "Items:" $items.Name ""

    # Signal Start
    Write-Host "START`n" -ForegroundColor Cyan

    # Make a copy of all sources to each destination specified
    foreach ($destination in $destinations) {
        Write-Host "Destination: $($destination)" -ForegroundColor Green
        Write-Host "Robocopy Options: $($robocopy_options)`n" -ForegroundColor Magenta
        
        foreach ($item in $items) {
            Write-Host "Item: $($item.Name)" -ForegroundColor Yellow
            Write-Host "Item Attributes: $($item.Attributes)" -ForegroundColor Yellow
            Write-Host "Source: $($item.FullName)" -ForegroundColor Yellow
            
            # Define parameters depending on whether source is a file or directory
            if ($item.Attributes -match 'Archive') {    # match is used as $item.Attributes returns a string of attributes
                $prm = $item.DirectoryName, $destination, $item.Name + ($robocopy_options | Where-Object { ($_ -ne '/MIR') -and ($_ -ne '/E') -and ($_ -ne '/S')})    # /MIR, /E, /S will be ignored for file sources
            } 
            elseif ($item.Attributes -match 'Directory') {
                $prm = $item.FullName, "$($destination)\$($item.Name)" + $robocopy_options
            }

            # Execute Robocopy with set parameters
            Write-Host "Executing:" $cmd $prm -ForegroundColor DarkGray
            & $cmd $prm            
        }
    }  

    # Signal End
    Write-Host "END" -ForegroundColor Red
}

# Call function
Copy-Files
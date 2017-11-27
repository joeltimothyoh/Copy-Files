# Copy-Files. 

function Copy-Files {
    <#
    .SYNOPSIS
    Copy-Files will copy the select folder(s) to specified destination(s).
    
    .DESCRIPTION
    Copy-Files will copy the contents of each specified folder to the destination using Robocopy.
    The Robocopy /MIR parameter is left out by default. Use /MIR to mirror copy, which includes purging of the files in destination not found in source.
    The Robocopy /XF parameter excludes copying of files with a matching name or extension after the parameter.
    The Robocopy /XD parameter excludes copying of directories with a matching directory name or extension after the parameter.
    Run 'robocopy /?' for usage information.
      
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>

    Param()

    # Batch of files / folders to copy
    $sources = @( 
        #'C:\Users\username\Documents\Project1',
        #'C:\Users\username\Documents\report.doc',
        # 'D:\Git\Project1\Repository3'  
    )

    # Destination(s) to copy the batch of files / folders to
    $destinations = @(
        #'E:\Backup\AllProjects',
        #'G:\backupfolder\scripts',
        #'\\SERVER1\projects\project1'
    )

    # Robocopy copy options
    $robocopy_options = @(
        #'/MIR', 
        #'/XF',
        #'Examplefile.doc',
        #'*.log'
        '/XD',              
        #'nameoffolderstoexclude',
        #'subfolder1',
        '*.git'
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
    Write-Host "START`n"  -ForegroundColor Cyan

    # Make a copy of all sources to each destination specified
    foreach ($destination in $destinations)
    {    
        Write-Host "Destination: $($destination)" -ForegroundColor Green   
        Write-Host "Robocopy Options: $($robocopy_options)`n" -ForegroundColor Magenta
        foreach ($item in $items)
        {                            
            Write-Host "Item: $($item.Name)" -ForegroundColor Yellow  
            Write-Host "Item Attributes: $($item.Attributes)" -ForegroundColor Yellow      
            
            # Define parameters depending on whether source is a file or folder 
            if ($item.Attributes -match 'Archive') {    # match is used as $item.Attributes returns a string of attributes
                Write-Host "Source: $($item.DirectoryName)" -ForegroundColor Yellow     
                $prm = $($item.DirectoryName), $destination, $item.Name + $robocopy_options          
            } 
            elseif ($item.Attributes -match 'Directory') {
                Write-Host "Source: $($item.FullName)" -ForegroundColor Yellow 
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
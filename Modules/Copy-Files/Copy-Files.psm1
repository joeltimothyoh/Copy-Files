function Copy-Files {
    <#
    .SYNOPSIS
    Copies specified files and directories to each specified destination using Robocopy.

    .DESCRIPTION
    Specified sources, destinations, and robocopy options will be used to make copy operations.
    Both files and directories can be used as sources.
    Sources and destinations paths can either be local (e.g. 'C:\Folder'), network (e.g. '\\ServerName\Folder'), or relative from the working directory (e.g. 'Folder\Subfolder').

    Specify the sources, destinations, and robocopy options within a Copy-Files standalone or configuration script. Then manually run the script, or set it to run on a schedule.
    To copy in batches, repeat the same steps for each batch of files and directories to be copied, giving each script a unique name of your choice.

    .PARAMETER Sources
    Files or directories to copy.

    .PARAMETER Destinations
    Destination directories to copy sources to.

    .PARAMETER RobocopyOptions
    Robocopy options to use for copy operations.

    .EXAMPLE
    .\Copy-Files-Project1.ps1
    Runs the script Copy-Files-Project1.ps1 within the working directory in the current instance of Powershell.

    .EXAMPLE
    Copy-Files -Sources 'C:\Files\File.txt','C:\Folder' -Destinations 'D:\BackupFolder' -RobocopyOptions '/E','/PURGE'
    Runs the Copy-Files module to copy file 'C:\Files\File.txt' and directory 'C:\Folder' into directory 'D:\BackupFolder' with robocopy options /E and /PURGE.

    .NOTES
    Copy-Files serves as a wrapper around Robocopy as a convenient and automatable file and directory copying solution.
    Robocopy, otherwise known as Robust File Copy, is a command-line directory and/or file replication command in Windows.
    It is recommended you have some knowledge about and experience with Robocopy before using Copy-Files.
    For more information on Robocopy, refer to Microsoft's documentation on the command, or run 'robocopy /?'.

    .LINK
    https://github.com/joeltimothyoh/Copy-Files
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, Position=0)]
        [ValidateNotNullOrEmpty()]
        [alias("s")]
        [string[]]$Sources
        ,
        [Parameter(Mandatory=$True, Position=1)]
        [ValidateNotNullOrEmpty()]
        [alias("d")]
        [string[]]$Destinations
        ,
        [Parameter(Mandatory=$False, Position=2)]
        [ValidateNotNullOrEmpty()]
        [alias("o")]
        [string[]]$RobocopyOptions
    )

    # Trim arrays
    $sourcesFiltered = $Sources | ForEach-Object {
        $item = $_.Trim()
        if ($item) { $item }
    }
    $destinationsFiltered = $Destinations | ForEach-Object {
        $item = $_.Trim()
        if ($item) { $item }
    }
    if ($RobocopyOptions) {
        $RobocopyOptionsFiltered = $RobocopyOptions | ForEach-Object {
            $item = $_.Trim()
            if ($item) { $item }
        }
    }

    # Initialize source variables
    $sourcesCollection = @()
    $sourcesInvalidCollection = @()

    # Gather sources
    $sourcesFiltered | ForEach-Object {
        try {
            $sourcesCollection += Get-Item $_ -Force -ErrorAction Stop
        } catch {
            $sourcesInvalidCollection += $_.TargetObject
        }
    }
    if ($sourcesCollection.Count -eq 0) { Write-Output "All sources specified cannot be found or are empty strings. Exiting."; return }

    # Gather destinations
    $destinationsCollection = $destinationsFiltered
    if ($destinationsCollection.Count -eq 0) { Write-Output "All destinations specified are empty strings. Exiting."; return }

    # Gather robocopy options
    $RobocopyOptionsCollection = $RobocopyOptionsFiltered

    # Signal Start
    Write-Output "-------------  Copy-Files Started: $(Get-Date)  -------------"

    # Signal Summary
    Write-Host "`n- - - - -`n SUMMARY`n- - - - -" -ForegroundColor Cyan

    # Print summary
    Write-Output "`nSources:"
    Write-Output $sourcesCollection.FullName
    if ($sourcesInvalidCollection.Count -gt 0) {
        Write-Output "`nSources (Invalid):"
        Write-Output $sourcesInvalidCollection
    }
    Write-Output "`nDestinations:"
    Write-Output $destinationsCollection
    if ($RobocopyOptionsCollection.Count -gt 0) {
        Write-Output "`nRobocopy Options:"
        Write-Output $RobocopyOptionsCollection
    }

    # Define constants
    Set-Variable -Name 'ROBOCOPY_BIN' -Value 'robocopy' -Option Constant

    # Signal start copy
    Write-Host "`n- - - -`n START`n- - - -" -ForegroundColor Green

    # Perform for each destination
    $destinationsCollection | ForEach-Object {
        $_destination = $_
        Write-Host "`nDestination: $_destination" -ForegroundColor Green

        # Perform for each source
        $sourcesCollection | ForEach-Object {
            $_source = $_
            Write-Host "`nSource: $($_source.FullName)" -ForegroundColor Yellow
            Write-Host "Type: $($_source.Attributes)" -ForegroundColor Yellow

            # Define arguments depending on whether source is a file or directory
            if ($_source.PSIsContainer -eq $false) {
                $robocopyArgs = @(
                    $_source.DirectoryName
                    $_destination
                    $_source.Name
                    $RobocopyOptionsCollection | Where-Object { ($_ -ne '/MIR') -and ($_ -ne '/E') -and ($_ -ne '/S') }       # /MIR, /E, /S will be ignored for file sources
                )
            } else {
                $robocopyArgs = @(
                    $_source.FullName
                    "$($_destination)\$($_source.Name)"
                    $RobocopyOptionsCollection
                )
            }

            # Execute Robocopy with set arguments
            Write-Host "Command: $($ROBOCOPY_BIN) $($robocopyArgs)" -ForegroundColor Yellow
            & $ROBOCOPY_BIN $robocopyArgs
        }

    }

    # Signal end copy
    Write-Host "`n- - -`n END`n- - -" -ForegroundColor Magenta

    # Signal End
    Write-Output "-------------   Copy-Files Ended: $(Get-Date)   -------------"

}

# Export the members of the module
Export-ModuleMember -Function Copy-Files

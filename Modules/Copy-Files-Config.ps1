<#
## This script works together with the Copy-Files module.
## Ensure the Copy-Files module is correctly installed. Refer to Microsoft's documentation on installing Powershell modules.
## Specify the sources, destinations, and robocopy options within this script.
## Run this script to make copies of the specified files and directories.
#>

$Config = @{
########################   Files and directories to copy   ########################

Sources = @(
    # 'C:\Users\username\Documents\Project 1\example folder'
    # 'C:\Users\username\Documents\Project 1\example.docx'
    # 'D:\Git\Project 1\repository2'
)

###########################   Destination directories   ###########################

Destinations = @(
    # 'E:\Backup\Projects\Project 1'
    # '\\SERVER1\Projects\Project 1'
    # '\\SERVER2\Shared\Projects\Project 1'
)

##############################   Robocopy options   ###############################

# Refer to Robocopy's documentation for more options
Robocopy_options = @(
      '/E'                       # Copy subdirectories including empty ones
    # '/S'                       # Copy subdirectories excluding empty ones
    # '/PURGE'                   # Remove files or directories present in destination but not in source
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

}

# Import the Copy-Files module
Import-Module Copy-Files

# Run Copy-Files with the following configuration hashtable
Copy-Files @Config

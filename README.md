# Copy-Files
Copies specified files and directories to each specified destination using Robocopy.

## Description
* Specified sources, destinations, and robocopy options will be used to make copy operations.
* Both files and directories can be used as sources.
* Sources and destinations paths can either be local (e.g. `'C:\Folder'`), network (e.g. `'\\ServerName\Folder'`), or relative from the working directory (e.g. `'Folder\Subfolder'`).
* Copy-Files can be used as a script or module.

## Usage
Copy-Files can either be used as a standalone script, or as a module together with a separate config script.

#### Standalone Script
* Fill in the sources, destinations, and robocopy options within the `Copy-Files.ps1` script.
* Run the script to copy the files and directories.

```
# Runs the standalone script
Powershell "C:\scripts\Copy-Files\Copy-Files.ps1"
```

#### Module
* Install the `Copy-Files.psm1` module. Refer to Microsoft's documentation on installing Powershell modules.
* Fill in the sources, destinations, and robocopy options within the Copy-Files-Config.ps1` script.
* Run the script to copy the files and directories.

```
# Runs the configuration script together with the module
Powershell "C:\scripts\Copy-Files\Copy-Files-Config.ps1"
```

## Copying
#### Batches
* Make multiple copies of the standalone script or configuration script
* Give each script a unique name.
* Fill in the sources, destinations, and robocopy options within batch of files and directories to be copied.

```
# Example of batches to be copied
Copy-Files-Batch001.ps1
Copy-Files-Batch002.ps1
Copy-Files-Batch003.ps1
```

#### Scheduling
* Set up the scripts to be run.
* Create a task in Task Scheduler, setting a schedule for each script to be run.

### Command Line
```
Copy-Files [-Config] <Hashtable[]> [<CommonParameters>]

PARAMETERS
    -Config <Hashtable[]>
        The configuration hashtable containing sources, destinations, and robocopy options to be used by Copy-Files.

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).
```
## Examples
##### Example 1
Runs the Copy-Files script in the working directory named `Copy-Files-Batch-001.ps1` in the current instance of Powershell.
```
.\Copy-Files-Batch-001.ps1
```
##### Example 2
Runs script named Copy-Files-Batch-001.ps1 in a separate instance of Powershell.
```
Powershell "C:\scripts\Copy-Files\Copy-Files-Batch-001.ps1"
```
##### Example 3
Runs the Copy-Files module with the configuration hashtable named $batch001.
```
Copy-Files -Config $batch001
```

## Security
Unverified scripts are disallowed to be run by default. To run Copy-Files, you will need to allow the execution of unverified scripts.

To do so, open PowerShell as an Administrator. Then simply run the  command:
`Set-ExecutionPolicy Unrestricted -Force`

To revert the policy, simply run the command:
`Set-ExecutionPolicy Undefined -Force`


## Notes
* Copy-Files serves as a wrapper around the Robocopy as a convenient and automatable file and directory copying solution.
* Robocopy, otherwise known as Robust File Copy, is a command-line directory and/or file replication command in Windows.
* It is recommended you have some knowledge about and experience with Robocopy before using Copy-Files.
* For more information on Robocopy, refer to Microsoft's documentation on the command, or run 'robocopy /?'.

## Compatibility
Windows with <a href="https://github.com/PowerShell/PowerShell#get-powershell" target="_blank" title="Powershell">Powershell v3</a>.
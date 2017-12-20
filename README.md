# Copy-Files
Copies specified files and directories to each specified destination using Robocopy.

## Description
* Specified sources, destinations, and robocopy options will be used to make copy operations.
* Both files and directories can be used as sources.
* Sources and destinations paths can either be local (e.g. `'C:\Folder'`), network (e.g. `'\\ServerName\Folder'`), or relative from the working directory (e.g. `'Folder\Subfolder'`).
* Copy-Files can be used as a script or module.

## Usage
Copy-Files can either be used as a standalone script, or as a module together with separate configuration scripts. The Standalone script allows for greater portability and isolation, while the module allows for greater accessibility, scalability and upgradability.

### Standalone Script
* Fill in the sources, destinations, and robocopy options within the `Copy-Files.ps1` script.
* Run the standalone script to copy the files and directories.


### Module
* Install the `Copy-Files.psm1` module. Refer to Microsoft's documentation on installing PowerShell modules.
* Fill in the sources, destinations, and robocopy options within the `Copy-Files-Config.ps1` script.
* Run the config script to copy the files and directories.

## Copying

### via File Explorer
* Right-click the script, and choose 'Run with PowerShell'.

### via Command line
* Run the script as a command line in a PowerShell console.

```
Powershell "C:\scripts\Copy-Files\Copy-Files-Batch001.ps1"
```

### Managing Batches
* Make as many copies of the standalone script or configuration script as desired.
* Give each script a unique name.
* Fill in the sources, destinations, and robocopy options within each script.
* Run each script to copy the respective files and directories.

```
# Example of batches to be copied
Copy-Files-Batch001.ps1
Copy-Files-Batch002.ps1
Copy-Files-Batch003.ps1
```

## Scheduling
* Set up the script to be run.
* Create a task in *Task Scheduler*, giving the task a name, configuring the user account to run the script on, and defining a schedule for the script.
* Add an *Action* with the following settings:

```
Action: Start a program
Program/script: Powershell
Add arguments (optional): C:\scripts\Copy-Files\Copy-Files-Batch001.ps1
```

* Repeat the steps for each script that is to be scheduled.
* If unsure, refer to official documentation or guides on using *Task Scheduler*.

## Parameters

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

#### Example 1
Runs the script within the working directory named `Copy-Files-Batch-001.ps1` in the current instance of PowerShell.

```
.\Copy-Files-Batch-001.ps1
```

#### Example 2
Runs script named `Copy-Files-Batch-001.ps1` in a separate instance of Powershell.

```
Powershell "C:\scripts\Copy-Files\Copy-Files-Batch-001.ps1"
```

#### Example 3
Runs the Copy-Files module with the configuration hashtable named `$batch001`.

```
Copy-Files -Config $batch001
```

## Security
Unverified scripts are restricted from being run by default. To run Copy-Files, you will need to allow the execution of unverified scripts. To do so, open PowerShell as an *Administrator*. Then simply run the command:

```
Set-ExecutionPolicy Unrestricted -Force
```

To revert the policy, simply run the command:

```
Set-ExecutionPolicy Undefined -Force
```

## Notes
* Copy-Files serves as a wrapper around the Robocopy as a convenient and automatable file and directory copying solution.
* Robocopy, otherwise known as Robust File Copy, is a command-line directory and/or file replication command in Windows.
* It is recommended you have some knowledge about and experience with Robocopy before using Copy-Files.
* For more information on Robocopy, refer to Microsoft's documentation on the command, or run `'robocopy /?'`.

### Tips
* To quickly copy paths in File Explorer, simply *Shift + Right-Click* on a file or directory and select 'Copy as path'.

## Requirements
* Windows with <a href="https://github.com/PowerShell/PowerShell#get-powershell" target="_blank" title="PowerShell">PowerShell v3</a> or higher.
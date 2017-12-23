# Copy-Files
Copies specified files and directories to each specified destination using Robocopy.

## Description
* Specified sources, destinations, and robocopy options will be used to make copy operations.
* Both files and directories can be used as sources.
* Sources and destinations paths can either be local (e.g. `'C:\Folder'`), network (e.g. `'\\ServerName\Folder'`), or relative from the working directory (e.g. `'Folder\Subfolder'`).

## Usage
Copy-Files can either be used as a standalone script, or as a module together with separate configuration scripts. The Standalone script allows for greater portability and isolation, while the module allows for greater accessibility, scalability and upgradability.

### Standalone Script
* Specify the sources, destinations, and robocopy options within the `Copy-Files.ps1` script.
* Give the script a unique name.
* Run the script to copy the files and directories.

### Module with config scripts
* Install the `Copy-Files.psm1` module. Refer to Microsoft's documentation on installing PowerShell modules.
* Specify the sources, destinations, and robocopy options within the `Copy-Files-Config.ps1` script.
* Give the configuration script a unique name.
* Run the script to copy the files and directories.

## Batches
Multiple standalone or configuration scripts can be used to organize copying, with each script representing a batch of files and directories.
* Make as many copies of the standalone or configuration script as required.
* Give each script a unique name.
* Specify the sources, destinations, and robocopy options within each script.
* Run each script to copy their respective files and directories.

Example use of several scripts, each representing a separate batch of files and directories:

```
Copy-Files-Project1.ps1
Copy-Files-Project2.ps1
Copy-Files-Data1.ps1
Copy-Files-Data2.ps1
Copy-Files-Update.ps1
Copy-Files-Backup.ps1
```

## Copying

### via File Explorer
* Right-click the script, and choose 'Run with PowerShell'.

### via Command line
* Run the script via a command line.

```
Powershell "C:\path\to\script.ps1"
```

### Scheduling
Copy-Files scripts can be scheduled to automatically make copies of files and directories.
* Set up the script to be run.
* In *Task Scheduler*, create a task with the following *Action*:
  * *Action*: `Start a program`
  * *Program/script*: `Powershell`
  * *Add arguments (optional)*: `C:\path\to\script.ps1`
* Repeat the steps for each script that is to be scheduled.

Refer to Microsoft's documentation or guides for further help on using *Task Scheduler*.

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

### Examples

#### Example 1
Runs the script `Copy-Files-Project1.ps1` within the working directory in the current instance of Powershell.

```
.\Copy-Files-Project1.ps1
```

#### Example 2
Runs the script `Copy-Files-Project1.ps1` within the specified path in an instance of Powershell.

```
Powershell "C:\scripts\Copy-Files\Copy-Files-Project1.ps1"
```

#### Example 3
Runs the `Copy-Files` module with the configuration hashtable named `$myconfig`.

```
Copy-Files -Config $myconfig
```

## Security
Unverified scripts are restricted from running on Windows by default. In order to use Copy-Files, you will need to allow the execution of unverified scripts. To do so, open PowerShell as an *Administrator*. Then run the command:

```
Set-ExecutionPolicy Unrestricted -Force
```

If you wish to revert the policy, run the command:

```
Set-ExecutionPolicy Undefined -Force
```

## Notes
* Copy-Files serves as a wrapper around Robocopy as a convenient and automatable file and directory copying solution.
* Robocopy, otherwise known as Robust File Copy, is a command-line directory and/or file replication command in Windows.
* It is recommended you have some knowledge about and experience with Robocopy before using Copy-Files.
* For more information on Robocopy, refer to Microsoft's documentation on the command, or run `'robocopy /?'`.

### Tips
* To quickly get the full path of a file or directory in File Explorer, simply *Shift + Right-Click* on the item and select 'Copy as path'.
* To quickly open a PowerShell instance from File Explorer, simply *Shift + Right-Click* on a directory or anywhere within it and select 'Open PowerShell window here'.

## Requirements
* Windows with <a href="https://github.com/PowerShell/PowerShell#get-powershell" target="_blank" title="PowerShell">PowerShell v3</a> or higher.
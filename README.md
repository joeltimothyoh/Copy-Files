# Copy-Files
Copies specified files and directories to each specified destination using Robocopy.

Specified sources, destinations, and robocopy options will be used to make copy operations.

Both files and directories can be used as sources.

Paths can be LFS-type (e.g. 'C:\folder') or UNC-type (e.g. '\\Servername\folder'). If neither of is used (e.g. 'folder'), the specified path will be taken to be a relative path from the working directory.

## Usage
Fill in the sources, destinations, and robocopy options within the .ps1 script. Then manually run, or set the script to run on a schedule.

To copy in batches, repeat the above steps for each batch of files and directories to be copied, giving each script a unique name of your choice.

## Example
`.\Copy-Files-Batch-001.ps1`

## Compatibility
Copy-Files currently only works with Windows.
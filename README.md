# dwg2nwc
Create nwc files from dwg files under the specified folder.

## Features
Like the "make" command,
this program compares the timestamps of the dwg file and the nwc file
with the same name and creates the nwc file if the dwg file is newer
or the nwc file is not exist.

## Requirements
- AutoCAD
- Object Enabler

## Install
Download/Save the following files
- poweshell script file: dwg2nwc.ps1
- AutoCAD script file : dwg2nwc.scr

Have the files in the same directory

## Usage
```
powershell.exe  -ExecutionPolicy RemoteSigned .\meg-nwc.PS1 -dwgDir "C:\PROJECT\Plant 3D Models"
```

|Switch   |Description   |Notes   |
|:---|:---|:---|
| -dwgDir|full path of DWG dirs ( , -separated)|Mandatory|
| -acad|full path of acad.exe|default: "C:\Program Files\Autodesk\AutoCAD 2022\acad.exe"|
| -nwcDir|full path of NWC dir|default: ".\nwc"|
| -srcFile|full path of src file|default: ".\dwg2nwc.scr"|
| -includeFiles|include file name ( , -separated)|default: "*.dwg"|
| -excludeFiles|exclude file name ( , -separated)|default: "\*recover\*"|
| -excludeDirs|exclude dir name ( , -separated)||
| -maxProcess|maxmum Number of processes|default: 10|
| -sleepTime|sleep time (second) when the number of processes reaches the limit|default: 15|
| -test|Show only messages. Do not Run autocad.||

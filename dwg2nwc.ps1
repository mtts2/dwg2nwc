<#
    .SYNOPSIS
        Create nwc files from dwg files under the specified folder.
    .DESCRIPTION
        Like the "make" command,
        this program compares the timestamps of the dwg file and the nwc file with the same name
        and creates the nwc file if the dwg file is newer.
#>
param (
    [Parameter(Mandatory,
        HelpMessage = "enter full path of DWG dirs (`,`-separated)")]
    [string[]]
    $dwgDir,

    [Parameter()]
    #enter full path of acad.exe
    [string]
    $acad = "C:\Program Files\Autodesk\AutoCAD 2022\acad.exe",

    [Parameter()]
    #enter full path of NWC dir
    [string]
    $nwcDir = "$(Get-Location)\nwc",

    [Parameter()]
    #enter full path of src file
    [string]
    $srcFile = "$(Get-Location)\dwg2nwc.scr",

    [Parameter()]
    #enter include file name (`,`-separated)
    [string[]]
    $includeFiles  = "*.dwg",

    [Parameter()]
    #enter exclude file name
    [string[]]
    $excludeFiles  = "*recover*",

    [Parameter()]
    #enter exclude dir name (`,`-separated)
    [string[]]
    $excludeDirs,

    [Parameter()]
    #enter maxmum Number of processes
    [int]
    $maxProcess = 10,

    [Parameter()]
    #enter sleep time (second) when the number of processes reaches the limit
    [int]
    $sleepTime = 15,

    [Parameter()]
    #"Show only messages. Do not Run autocad.
    [switch]
    $test

)


function Main {

    $files = Get-ChildItem  -Recurse -path $dwgDir -Include $includeFiles -Exclude $excludeFiles 
    $files = $files | Where-Object Name -Like "*.dwg"

    if($excludeDirs.Count -ne 0)
    {
        foreach($excludeDir in $excludeDirs )
        {
            $excludeDir = "*$excludeDir*"
            $files = $files | Where-Object FullName -NotLike $excludeDir
        }
    }

    foreach ($dwgfilepath  in $files) {
        Write-Host("dwg to nwc :$dwgfilepath ")

        $acadArg = "`"$dwgfilepath`"  /nologo /nossm /b $srcFile"
        $basename = [System.IO.Path]::GetFileNameWithoutExtension($dwgfilepath)
        $nwcFileName = "$basename.nwc"
        $nwcfilepath = "$nwcDir\$nwcFileName"
        
        if (Test-Path $nwcfilepath) {
            $dwgFileDATE = $(Get-ItemProperty $dwgfilepath).LastWriteTime
            $nwcFileDATE = $(Get-ItemProperty $nwcfilepath).LastWriteTime
            Write-Host("$dwgFileDATE  $dwgfilepath")
            Write-Host("$nwcFileDATE  $nwcfilepath")

            if ($dwgFileDATE -gt $nwcFileDATE) {
                Start-Acad -acad $acad -acadArg $acadArg -WorkingDirectory $nwcDir
            }
            else {
                Write-Host("SKIP: NWC file is newer than DWG file")
            }
        }
        else {
            Start-Acad -acad $acad -acadArg $acadArg -WorkingDirectory $nwcDir
        }
        Write-Host("--------------")

        while (Confirm-AcadProccesMax) {
            Write-Output("sleep $sleepTime sec")
            Start-Sleep -s $sleepTime
        }
    
    }
}

function Start-Acad {
    param (
        [Parameter(Mandatory)]
        $acad,
        $acadArg,
        $WorkingDirectory
    )

    Write-Host ("$acad $acadArg")
    Write-Host ("WorkingDirectory :$WorkingDirectory")

    if($test){return}
    Start-Process -FilePath $acad -ArgumentList $acadArg -WorkingDirectory $WorkingDirectory
}

function Confirm-AcadProccesMax {
    $ProcessCount = (Get-Process -Name acad -ErrorAction SilentlyContinue).count
    #Write-Host($ProcessCount)
    if ($ProcessCount -ge $maxProcess ) {
        return $true
    }
    else {
        return $false
    }
}

. Main
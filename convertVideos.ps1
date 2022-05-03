<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    author: Martin Pucovski (martinautomates.com)
#>

# initials
$scriptLocation = Split-Path -Parent $MyInvocation.MyCommand.Definition
$scriptName = $MyInvocation.MyCommand.Name
$host.ui.RawUI.WindowTitle = $scriptName

# read config file
$configPath = Join-Path -Path $scriptLocation -ChildPath "config\config.psd1"
$configFile = Import-PowerShellDataFile -Path $configPath

# INPUT CODE HERE

# ffmpeg location
$ffmpegLocation = [System.IO.Path]::Combine($scriptLocation, "dependencies", "ffmpeg.exe")

$filesToConvert = Get-ChildItem -Path $configFile['inputDirectory'] -Filter $configFile['fileExtension'] -File
foreach ($oneFile in $filesToConvert) {
    $outputFile = [System.IO.Path]::GetFileNameWithoutExtension($oneFile) + ".mp4"
    $outputPath = Join-Path -Path $oneFile.DirectoryName -ChildPath $outputFile
    
    # set process info
    $processInfo = New-Object System.Diagnostics.ProcessStartInfo
    $processInfo.FileName = $ffmpegLocation
    $processInfo.Arguments = " -y -i " + $oneFile.FullName + " -vcodec " +  $configFile["encodeVideoCodec"] + " -crf " + $configFile["encodeCrf"] + " -preset " + $configFile["encodePreset"] + " " + $outputPath

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $processInfo
    $process.Start() | Out-Null

    # set processor affinity / cores to use
    $setAffinity = [Convert]::ToInt32($configFile["processorAffinity"], 2)
    $process.ProcessorAffinity = $setAffinity

    # set process priority
    $process.PriorityClass = $configFile["priorityClass"]

    $process.WaitForExit()

    $exitCode = $process.ExitCode
    Write-Host "exit code: $exitCode"
}

Read-Host "Script finished. Press ENTER to exit..."

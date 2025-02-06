#trade2charts
#
#
#
#load windows forms
Add-Type -AssemblyName System.Windows.Forms

#file select dialog
$fileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    Multiselect      = $true
    InitialDirectory = [Environment]::GetFolderPath('MyComputer') 
    Filter           = 'Comma-seperated values (*.csv)|*.csv'
}

#folder select dialog
$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
    Description = "Select save file location:"
}

#Import PScriboCharts
'..\modules\PScriboCharts\0.9.0\PScriboCharts.psd1' | Import-Module

#Import csvFunctions
'..\modules\csvFunctions\csvConversion.psm1' | Import-Module
'..\modules\csvFunctions\csvLineChart.psm1' | Import-Module

#format for csv header check
$csvFormat = @("Action", "Current Price", "Date", "Direction", "Enter/Exit", "Quantity", "Sent Price", "Slip from TV", "Symbol", "Time")

#loop for file input from user
while ($true) {
    Write-Host "Please select a .csv file:"
    $fileSelect = $fileBrowser.ShowDialog((New-Object System.Windows.Forms.Form -Property @{TopMost = $true }))
    $fileBrowser.Dispose()
    if ($fileSelect -eq "Cancel") {
        Write-Host "Cancelling..."
        return
    }
    elseif ($fileBrowser.FileNames | Where-Object {$_ -like ".csv"}) {
        Write-Host "The file selected is not a .csv filetype. Press ENTER to continue. Press Ctrl+C to exit." -ForegroundColor Red
        Read-host
        continue
    }
    elseif ($fileBrowser.FileNames | Where-Object {$null -ne (Compare-Object -ReferenceObject $csvFormat -DifferenceObject (Import-Csv -Path $_ | Get-Member -MemberType NoteProperty).Name)}) {
        Write-Host "The .csv file selected has an incorrect header format, Headers must include the following:[" $csvFormat "]Press ENTER to continue. Press Ctrl+C to exit." -ForegroundColor Red
        Read-Host
        continue
    }
    else {
        break
    }
    Write-Host "Error. Please try again. Press ENTER to continue. Press Ctrl+C to exit." -ForegroundColor Red
    Read-Host
}

#csv cleaning
#reassign readonly values of fileBrowser
$filePaths = [System.Collections.ArrayList]@($fileBrowser.FileNames)
$fileNames = $fileBrowser.SafeFileNames
$errorFiles = @()
#check all csv files for empty data
for($i=0;$i -lt $filePaths.Count; $i++){
    Write-Host "Checking data..." $fileNames[$i] -NoNewline
    Write-Host
    $importFile = Import-Csv -Path $filePaths[$i]
    if($importFile.Symbol -eq ""){
        Write-host "Error with file >>>>" $fileNames[$i] -ForegroundColor Red
        Start-Sleep -Milliseconds 2000
        #add to error files
        $errorFiles+= $fileNames[$i]
        #remove from filepaths
        $filePaths.Remove($filePAths[$i])
        
    }
}
#if there are no files left to process stop
if($filePaths.Count -eq 0){
    Write-Host "The file(s) provided contained no data:" -ForegroundColor Red
    $errorFiles | ForEach-Object {Write-host $_ -ForegroundColor Red}
    Write-Host "There are no other files to process. Exiting..." -ForegroundColor Red
    Start-Sleep -Milliseconds 2000
    return
} else {
    Write-Host "File(s) accepted..." -ForegroundColor Green
}

#set output object
$outputCSVs = @()
$outputCharts = @()
##run function
for ($i = 0; $i -lt $filePaths.Count; $i++) {
    #set file paths
    $filePath = $filePaths[$i]
    #set file name
    $fileName = $fileNames[$i]
    #output csvs
    Write-Host "Converting:" $filePath $fileName
    $outputCSVs += [PSCustomObject]@(Start-csvConversion -filePath $filePath -fileName $fileName)
    #output charts
    $outputCharts += [PSCustomObject]@(Start-csvLineChart -fileName $fileName -convertedTrade $outputCSVs[$i]) 
}
#sort output csvs
$outputCSVs | Sort-Object -Property 'tradeNumber'

Write-Host "Please select your export location:"
#show export location selection window
$folderBrowser.ShowDialog((New-Object System.Windows.Forms.Form -Property @{TopMost = $true }))
#export to output location as csv and png
try {
    $outputCharts | ForEach-Object {
        $chartFileItem = Export-Chart -Chart $_ -Path $folderBrowser.SelectedPath -Format "png" -PassThru
        if ($PassThru) { Write-Output -InputObject $chartFileItem }
    }
}
catch {
    Write-Host "Failed to export chart(s) to location..." $folderBrowser.SelectedPath -ForegroundColor Red
    return
}
try {
    for ($i = 0; $i -lt $filePaths.Count; $i++) {
        $outputCSVs[$i] | Export-Csv -NoTypeInformation -Path ($folderBrowser.SelectedPath + "\" + $fileBrowser.SafeFileNames[$i].replace(".csv", "") + "_converted.csv").ToString() -Delimiter ","
    }
}
catch {
    Write-Host "Failed to export csv(s) to location..." $folderBrowser.SelectedPath -ForegroundColor Red
    return
}
#feedback of failed files
if($errorFiles.Count -ne 0){
    Write-Host "The following items failed to process due to missing data:" -ForegroundColor Red
    $errorFiles | ForEach-Object {Write-Host ">>>>"$_ -ForegroundColor Red}
    Start-Sleep -Milliseconds 3000
}
#open output folder in explorer
Start-Process $folderBrowser.SelectedPath
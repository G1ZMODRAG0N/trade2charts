####NOTES####
<#
bulk ie 5 in 5 out
#>
#
#
#load windows forms
Add-Type -AssemblyName System.Windows.Forms

#file select dialog
$fileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = [Environment]::GetFolderPath('MyComputer') 
    Filter           = 'Comma-seperated values (*.csv)|*.csv'
}

#save select dialog
#$saveBrowser = New-Object System.Windows.Forms.SaveFileDialog

#folder select dialog
$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
    Description = "Select save file location:"
}


#Import the module PScriboCharts
'..\modules\PScriboCharts\0.9.0\PScriboCharts.psd1' | Import-Module
#format for csv header check
$csvFormat = @("Action", "Current Price", "Date", "Direction", "Enter/Exit", "Quantity", "Sent Price", "Slip from TV", "Symbol", "Time")

#user input
while ($true) {
    Write-Host "Please select a .csv file:"

    $fileSelect = $fileBrowser.ShowDialog()
    if ($fileSelect -eq "Cancel") {
        Write-Host "Cancelling..."
    
        return
    }
    elseif ($fileBrowser.FileName -notmatch ".csv") {
        Write-Host "The file selected is not a .csv filetype. Press ENTER to continue. Press Ctrl+C to exit." -ForegroundColor Red
    
        Read-host
        continue
    }
    elseif ($null -ne (Compare-Object -ReferenceObject $csvFormat -DifferenceObject (Import-Csv -Path $fileBrowser.FileName | Get-Member -MemberType NoteProperty).Name)) {
        Write-Host "The .csv file selected has an incorrect header format, Headers must include the following:[" $csvFormat "]Press ENTER to continue. Press Ctrl+C to exit." -ForegroundColor Red
    
        Read-Host
        continue
    }
    else {
        Write-Host "File accepted..." -ForegroundColor Green
        break
    }
    Write-Host "Error. Please try again. Press ENTER to continue. Press Ctrl+C to exit." -ForegroundColor Red
    
    Read-Host
}

#data csv
$csvData = Import-Csv -Path $fileBrowser.FileName

#symbol json
$symbolList = Get-Content -Path '..\data\symbols.json' | ConvertFrom-Json

#MATH SECTION
$csvCount = $csvData.Count
$tradeNumber = 0

$convertedTrade = @()
$total = 0

#$csvConvert
for ($i = 0; $i -lt $csvCount; $i++) {
    #progress bar
    $percentageComplete = $i / $csvCount * 100
    Write-Progress -Activity "Converting "$fileBrowser.SafeFileName -PercentComplete $percentageComplete
    #entry/exit trade data
    $entryTrade = $csvData[$i]
    $exitTrade = $csvData[$i + 1]
    #only perform data conversion on entry trades
    if (($entryTrade | Select-Object -ExpandProperty 'Enter/Exit') -eq 'entry') {

        #trade number
        $tradeNumber = $tradeNumber + 1

        #symbol
        $symbol = $entryTrade.Symbol.Substring(0, $entryTrade.Symbol.Length - 2)

        #tick size
        $symbolValue = $symbolList | Select-Object -ExpandProperty $symbol

        #PNL sum
        $entryPrice = [int]($entryTrade | Select-Object -ExpandProperty 'Current Price')
        $exitPrice = [int]($exitTrade | Select-Object -ExpandProperty 'Current Price')
        #Write-Host $entryPrice
        #determine action for +/-
        if ($entryTrade.Action -eq "buy") {
            $pnl = ($exitPrice - $entryPrice) / $symbolValue.tickValue * $symbolValue.valuePer
        }
        else {
            $pnl = ($entryPrice - $exitPrice) / $symbolValue.tickValue * $symbolValue.valuePer
        }

        #total additve if not first trade
        if ($i -eq 0) {
            $total = $pnl
        }
        else {
            $total += $pnl
        }

        #bought timestamp
        $boughtDate = $entryTrade | Select-Object -ExpandProperty 'Date'
        $boughtTime = $entryTrade | Select-Object -ExpandProperty 'Time'
        $boughtTimestamp = $boughtDate + " " + $boughtTime.Substring(0, $boughtTime.Length - 3)

        #sould timestamp
        $soldDate = $exitTrade | Select-Object -ExpandProperty 'Date'
        $soldTime = $exitTrade | Select-Object -ExpandProperty 'Time'
        $soldTimestamp = $soldDate + " " + $soldTime.Substring(0, $soldTime.Length - 3)

        #duration
        $duration = ([datetime]$soldDate + $soldTime).Subtract(([datetime]$boughtDate + $boughtTime))
        $durationFormatted = ([string]$duration.Days + "day(s)" + [string]$duration.Hours + "hr(s)" + [string]$duration.Minutes + "min(s)" + [string]$duration.Seconds + "sec(s)")
        
        #add converted data to object
        $convertedTrade += [PSCustomObject]@{
            tradeNumber     = $tradeNumber.ToString()
            symbol          = $symbol.ToString()
            tickSize        = $symbolValue.tickValue.ToString()
            qty             = $entryTrade.Quantity.ToString()
            buyPrice        = $entryPrice.ToString()
            sellPrice       = $exitPrice.ToString()
            boughtTimestamp = $boughtTimestamp.ToString()
            soldTimestamp   = $soldTimestamp.ToString()
            duration        = $durationFormatted.ToString()
            pnl             = $pnl.ToString()
            total           = $total.ToString()
        }

    }
    else {
        #Write-Host "Exit trade skipped"
    }
}
#percentage completion 100 at end of loop
Write-Progress -Activity "Converting "$fileBrowser.SafeFileName -PercentComplete 100
Write-Host "COMPLETE" -ForegroundColor Green

#$convertedTrade | Out-GridView

####CHARTING####

#Creates a new chart. The name given to the chart is used when exporting the graphic.
$tradeChart = New-Chart -Name $fileBrowser.SafeFileName.replace(".csv", "_chart") -Width 1920 -Height 1080
#cystom fonts
$customLabelFont = New-ChartFont -Name 'Arial' -Size 16
$customTitleFont = New-ChartFont -Name 'Arial' -Size 16 -Bold

#area parameters
$addChartAreaParams = @{
    Chart                 = $tradeChart
    Name                  = 'tradeChartArea'
    AxisXTitle            = 'Trade Count'
    AxisYTitle            = 'Cumulative PNL ($)'
    AxisXTitleFont        = $customTitleFont
    AxisXLabelFont        = $customLabelFont
    AxisYTitleFont        = $customTitleFont
    AxisYLabelFont        = $customLabelFont
    AxisXLabelMinFontSize = 12
    AxisYLabelMinFontSize = 12
    NoAxisXMajorGridLines = $true
    #NoAxisYMajorGridLines = $true
}
$tradeChartArea = Add-ChartArea @addChartAreaParams -PassThru

#title parameters
$addChartTitleParams = @{
    Chart     = $tradeChart
    ChartArea = $tradeChartArea
    Name      = 'trade title'
    Text      = $fileBrowser.SafeFileName.replace(".csv", "")
    Font      = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial', '16', [System.Drawing.FontStyle]::Bold)
}
Add-ChartTitle @addChartTitleParams

#custom palette parameters
$tradeCustomPalette = @(
    [System.Drawing.ColorTranslator]::FromHtml('#008cd6')
    [System.Drawing.ColorTranslator]::FromHtml('#009aeb')
)

#series parameters
$addChartSeriesParams = @{
    Chart             = $tradeChart
    ChartArea         = $tradeChartArea
    Name              = 'tradeChartSeries'
    XField            = 'tradeNumber'
    YField            = 'total'
    Label             = ''
    ColorPerDataPoint = $true
    CustomPalette     = $tradeCustomPalette
}
$convertedTrade | Add-LineChartSeries @addChartSeriesParams

Write-Host "Please select your export location:" -ForegroundColor Green
#show export location selection window
$folderBrowser.ShowDialog()
#export to output location as csv and png
try {
    $chartFileItem = Export-Chart -Chart $tradeChart -Path $folderBrowser.SelectedPath -Format "png" -PassThru
}
catch {
    Write-Host "Failed to export to location..." $folderBrowser.SelectedPath -ForegroundColor Red
    return
}
try {
    $convertedTrade | Export-Csv -NoTypeInformation -Path ($folderBrowser.SelectedPath + "\" + $fileBrowser.SafeFileName.replace(".csv", "") + "_converted.csv").ToString() -Delimiter ","
}
catch {
    Write-Host "Failed to export to location..." $folderBrowser.SelectedPath -ForegroundColor Red
    return
}
#pass thru pipe
if ($PassThru) {
    Write-Output -InputObject $chartFileItem
}
#open output folder in explorer
Start-Process $folderBrowser.SelectedPath
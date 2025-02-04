####NOTES####
#title reflection of the import csv itself
#png is just fine
#bulk ie 5 in 5 out

#load windows forms
Add-Type -AssemblyName System.Windows.Forms

#file select dialog
$fileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
InitialDirectory = [Environment]::GetFolderPath('MyComputer') 
Filter = 'Comma-seperated values (*.csv)|*.csv'
}

#save select dialog
#$saveBrowser = New-Object System.Windows.Forms.SaveFileDialog

#folder select dialog
$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
Description = "Save File"}


#Import the module PScriboCharts
'.\modules*' | Get-ChildItem -include '*.psm1', '*.ps1' | Import-Module

$csvFormat = @("Action","Current Price","Date","Direction","Enter/Exit","Quantity","Sent Price","Slip from TV","Symbol","Time")

#user input
while ($true) {
Write-Host "Please select a .csv file:"
$fileSelect = $fileBrowser.ShowDialog()
    if($fileSelect -eq "Cancel"){
    Write-Host "Cancelling..."
    return
    } elseif($fileBrowser.FileName -notmatch ".csv"){
    Write-host "The file selected is not a .csv filetype. Press ENTER to continue. Press Ctrl+C to exit."
    Read-host
    continue
    } elseif($null -ne (Compare-Object -ReferenceObject $csvFormat -DifferenceObject (Import-Csv -Path $fileBrowser.FileName | Get-Member -MemberType NoteProperty).Name)){
    Write-Host "The .csv file selected has an incorrect header format, Headers must include the following:[" $csvFormat "]Press ENTER to continue. Press Ctrl+C to exit."
    Read-Host
    continue
    }else {
    Write-Host "Converting..."
    break
    }
    Write-Host "Error. Please try again. Press ENTER to continue. Press Ctrl+C to exit."
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
    $entryTrade = $csvData[$i]
    $exitTrade = $csvData[$i + 1]
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

$convertedTrade #| Out-GridView

##CHARTING

#Creates a new chart. The name given to the chart is used when exporting the graphic.
$tradeChart = New-Chart -Name $fileBrowser.SafeFileName.replace(".csv","_chart") -Width 1920 -Height 1080

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
    #NoAxisXMajorGridLines = $true
    #NoAxisYMajorGridLines = $true
}
$tradeChartArea = Add-ChartArea @addChartAreaParams -PassThru

#title parameters
$addChartTitleParams = @{
    Chart     = $tradeChart
    ChartArea = $tradeChartArea
    Name      = 'trade title'
    Text      = $fileBrowser.SafeFileName.replace(".csv","")
    Font      = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial', '16', [System.Drawing.FontStyle]::Bold)
}
Add-ChartTitle @addChartTitleParams

#custom palette parameters
$tradeCustomPalette = @(
    [System.Drawing.ColorTranslator]::FromHtml('#6741D9')
    [System.Drawing.ColorTranslator]::FromHtml('#9C36B5')
    [System.Drawing.ColorTranslator]::FromHtml('#C2255C')
    [System.Drawing.ColorTranslator]::FromHtml('#E03130')
    [System.Drawing.ColorTranslator]::FromHtml('#E8580B')
    [System.Drawing.ColorTranslator]::FromHtml('#F08C00')
    [System.Drawing.ColorTranslator]::FromHtml('#2F9E44')
    [System.Drawing.ColorTranslator]::FromHtml('#1B6EC2')
    [System.Drawing.ColorTranslator]::FromHtml('#343A40')
)

#series parameters
$addChartSeriesParams = @{
    Chart     = $tradeChart
    ChartArea = $tradeChartArea
    Name      = 'tradeChartSeries'
    XField    = 'tradeNumber'
    YField    = 'total'
    ColorPerDataPoint = $true
    CustomPalette     = $tradeCustomPalette
}
$convertedTrade | Add-spLineChartSeries @addChartSeriesParams

<#
    Export the chart to a .png (by default) file.
#>

$folderBrowser.ShowDialog()

$chartFileItem = Export-Chart -Chart $tradeChart -Path $folderBrowser.SelectedPath -Format "png" -PassThru
$convertedTrade | Export-Csv -NoTypeInformation -Path ($folderBrowser.SelectedPath+"\"+$fileBrowser.SafeFileName.replace(".csv","")+"_converted.csv").ToString() -Delimiter ","

if ($PassThru)
{
    Write-Output -InputObject $chartFileItem
}

Start-Process $folderBrowser.SelectedPath
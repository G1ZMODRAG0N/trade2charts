function Start-csvConversion {
    #set function parameters
    param (
        [Parameter(Mandatory)][object] $filePath,
        [Parameter(Mandatory)][object] $fileName
    )

    #symbol json
    $symbolList = Get-Content -Path '..\data\symbols.json' | ConvertFrom-Json

    #data csv
    $csvData = Import-Csv -Path $filePath
    $tradeNumber = 0
    $convertedTrade = @()
    $total = 0

    #$csvConvert
    for ($i = 0; $i -lt $csvData.Count; $i++) {

        #progress bar
        $percentageComplete = $i / $csvData.Count * 100
        Write-Progress -Activity "Converting "$fileName -PercentComplete $percentageComplete
        
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
    }
    return , $convertedTrade | Out-Null
}


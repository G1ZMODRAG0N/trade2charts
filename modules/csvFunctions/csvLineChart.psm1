function Start-csvLineChart {
    #set function parameters
    param (
        [Parameter(Mandatory)][object] $fileName,
        [Parameter(Mandatory)][object] $convertedTrade
    )

    #Creates a new chart. The name given to the chart is used when exporting the graphic.
    $tradeChart = New-Chart -Name $fileName.replace(".csv", "_chart") -Width 1920 -Height 1080
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
        Text      = $fileName.replace(".csv", "")
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

    return , $tradeChart
}
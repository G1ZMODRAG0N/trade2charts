function Add-ChartArea
{
<#
    .SYNOPSIS
        Adds a chart area to an existing chart.

    .DESCRIPTION
        A chart area is the rectangular area that encompasses the plot position, the tick marks, the axis labels and
        the axis titles on the chart. The plot position is the rectangular area that encompasses the inner plot
        position, the tick marks, and the axis labels. The inner plot position is the rectangular area, inside the x
        and y-axis lines, where the data points are drawn.

    .LINK
        https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.datavisualization.charting.chartarea
#>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType([System.Windows.Forms.DataVisualization.Charting.ChartArea])]
    param
    (
        ## Chart object to add the chart area
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.Windows.Forms.DataVisualization.Charting.Chart] $Chart,

        ## Name of the chart area to add to the chart
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String] $Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Color] $AxisXMajorGridLineColor,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Dash','DashDot','DashDotDot','Dot','NotSet','Solid')]
        [System.String] $AxisXMajorGridLineDashStyle,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Font] $AxisXLabelFont = (Get-DefaultFont),

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Font] $AxisXTitleFont = (Get-DefaultFont),

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Color] $AxisYMajorGridLineColor,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Dash','DashDot','DashDotDot','Dot','NotSet','Solid')]
        [System.String] $AxisYMajorGridLineDashStyle,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Font] $AxisYLabelFont = (Get-DefaultFont),

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Font] $AxisYTitleFont = (Get-DefaultFont),

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Int32] $AxisXLabelMinFontSize = 6,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Int32] $AxisXLabelMaxFontSize = 10,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Int32] $AxisYLabelMinFontSize = 6,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Int32] $AxisYLabelMaxFontSize = 10,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $Enable3d,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Int32] $Inclination = 25,

        ## The relative X-coordinate of the top-left corner of the chart area
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Position')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'PositionAndInnerPosition')]
        [ValidateRange(0, 100)]
        [System.Int32] $X,

        ## The relative Y-coordinate of the top-left corner of the chart area
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Position')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'PositionAndInnerPosition')]
        [ValidateRange(0, 100)]
        [System.Int32] $Y,

        ## The relative height of the chart area
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Position')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'PositionAndInnerPosition')]
        [ValidateRange(0, 100)]
        [System.Int32] $Height,

        ## The relative width of the chart area
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Position')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'PositionAndInnerPosition')]
        [ValidateRange(0, 100)]
        [System.Int32] $Width,

        ## The relative X-coordinate of the top-left corner of the inner plot position
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'InnerPosition')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'PositionAndInnerPosition')]
        [ValidateRange(0, 100)]
        [System.Int32] $InnerX,

        ## The relative Y-coordinate of the top-left corner of the inner plot position
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'InnerPosition')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'PositionAndInnerPosition')]
        [ValidateRange(0, 100)]
        [System.Int32] $InnerY,

        ## The relative height of the inner plot position
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'InnerPosition')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'PositionAndInnerPosition')]
        [ValidateRange(0, 100)]
        [System.Int32] $InnerHeight,

        ## The relative width of the inner plot position
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'InnerPosition')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'PositionAndInnerPosition')]
        [ValidateRange(0, 100)]
        [System.Int32] $InnerWidth,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String] $AxisXTitle,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Near','Center','Far')]
        [System.String] $AxisXTitleAlignment = 'Center',

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String] $AxisYTitle,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Near','Center','Far')]
        [System.String] $AxisYTitleAlignment = 'Center',

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Double] $AxisXInterval,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Double] $AxisYInterval,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Double] $AxisX2Interval,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Double] $AxisY2Interval,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $UseSameFontSizeForAllAxes,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $NoAxisXMajorGridLines,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $NoAxisYMajorGridLines,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $NoAxisXMargin,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $NoAxisYMargin,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Dash', 'DashDot', 'DashDotDot', 'Dot', 'NotSet', 'Solid')]
        [System.String] $BorderStyle = 'NotSet',

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Int32] $BorderWidth = 0,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Color] $BorderColor = [System.Drawing.Color]::Black,

        ## Pass the [System.Windows.Forms.DataVisualization.Charting.ChartArea] object down the pipeline
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $PassThru
    )
    process
    {
        $chartArea = New-Object -TypeName System.Windows.Forms.DataVisualization.Charting.ChartArea -ArgumentList $Name

        if ($PSCmdlet.ParameterSetName -in 'Position','PositionAndInnerPosition')
        {
            $chartArea.Position.Auto = $false
            $chartArea.Position.X = $X
            $chartArea.Position.Y = $Y
            $chartArea.Position.Width = $Width
            $chartArea.Position.Height= $Height
        }
        else
        {
            $chartArea.Position.Auto = $true
        }

        if ($PSCmdlet.ParameterSetName -in 'InnerPosition','PositionAndInnerPosition')
        {
            $chartArea.InnerPlotPosition.Auto = $false
            $chartArea.InnerPlotPosition.X = $InnerX
            $chartArea.InnerPlotPosition.Y = $InnerY
            $chartArea.InnerPlotPosition.Width = $InnerWidth
            $chartArea.InnerPlotPosition.Height= $InnerHeight
        }
        else
        {
            $chartArea.InnerPlotPosition.Auto = $true
        }

        $chartArea.AxisX.MajorGrid.Enabled = -not $NoAxisXMajorGridLines.ToBool()
        $chartArea.AxisX2.MajorGrid.Enabled = -not $NoAxisXMajorGridLines.ToBool()
        $chartArea.AxisY.MajorGrid.Enabled = -not $NoAxisYMajorGridLines.ToBool()
        $chartArea.AxisY2.MajorGrid.Enabled = -not $NoAxisYMajorGridLines.ToBool()

        $chartArea.AxisX.TitleFont = $AxisXTitleFont
        $chartArea.AxisX.LabelStyle.Font = $AxisXLabelFont
        $chartArea.AxisX2.LabelStyle.Font = $AxisXLabelFont
        $chartArea.AxisX.LabelAutoFitMinFontSize  = $AxisXLabelMinFontSize
        $chartArea.AxisX2.LabelAutoFitMinFontSize  = $AxisXLabelMinFontSize
        $chartArea.AxisX.LabelAutoFitMaxFontSize  = $AxisXLabelMaxFontSize
        $chartArea.AxisX2.LabelAutoFitMaxFontSize  = $AxisXLabelMaxFontSize
        $chartArea.AxisY.TitleFont = $AxisYTitleFont
        $chartArea.AxisY.LabelStyle.Font = $AxisYLabelFont
        $chartArea.AxisY2.LabelStyle.Font = $AxisYLabelFont
        $chartArea.AxisY.LabelAutoFitMinFontSize  = $AxisYLabelMinFontSize
        $chartArea.AxisY2.LabelAutoFitMinFontSize  = $AxisYLabelMinFontSize
        $chartArea.AxisY.LabelAutoFitMaxFontSize  = $AxisYLabelMaxFontSize
        $chartArea.AxisY2.LabelAutoFitMaxFontSize  = $AxisYLabelMaxFontSize

        $chartArea.IsSameFontSizeForAllAxes = $UseSameFontSizeForAllAxes.ToBool()
        $chartArea.BackColor = [System.Drawing.Color]::Empty
        $chartArea.BorderColor = $BorderColor
        $chartArea.BorderWidth = $BorderWidth
        $chartArea.BorderDashStyle = $BorderStyle
        $chartArea.AxisX.IsMarginVisible = -not $NoAxisXMargin.ToBool()
        $chartArea.AxisY.IsMarginVisible = -not $NoAxisYMargin.ToBool()

        if ($PSBoundParameters.ContainsKey('AxisXMajorGridLineColor'))
        {
            $chartArea.AxisX.MajorGrid.LineColor = $AxisXMajorGridLineColor
        }
        if ($PSBoundParameters.ContainsKey('AxisYMajorGridLineColor'))
        {
            $chartArea.AxisY.MajorGrid.LineColor = $AxisYMajorGridLineColor
        }

        if ($PSBoundParameters.ContainsKey('AxisXMajorGridLineDashStyle'))
        {
            $chartArea.AxisX.MajorGrid.LineDashStyle = $AxisXMajorGridLineDashStyle
        }
        if ($PSBoundParameters.ContainsKey('AxisYMajorGridLineDashStyle'))
        {
            $chartArea.AxisY.MajorGrid.LineDashStyle = $AxisYMajorGridLineDashStyle
        }

        if ($PSBoundParameters.ContainsKey('AxisXInterval'))
        {
            $chartArea.AxisX.Interval = $AxisXInterval
        }
        if ($PSBoundParameters.ContainsKey('AxisYInterval'))
        {
            $chartArea.AxisY.Interval = $AxisYInterval
        }
        if ($PSBoundParameters.ContainsKey('AxisX2Interval'))
        {
            $chartArea.AxisX2.Interval = $AxisX2Interval
        }
        if ($PSBoundParameters.ContainsKey('AxisY2Interval'))
        {
            $chartArea.AxisY2.Interval = $AxisY2Interval
        }
        if ($PSBoundParameters.ContainsKey('AxisXTitle'))
        {
            $chartArea.AxisX.Title = $AxisXTitle
            $chartArea.AxisX.TitleAlignment = $AxisXTitleAlignment
        }
        if ($PSBoundParameters.ContainsKey('AxisYTitle'))
        {
            $chartArea.AxisY.Title = $AxisYTitle
            $chartArea.AxisY.TitleAlignment = $AxisYTitleAlignment
        }

        if ($Enable3d)
        {
            $chartArea.Area3DStyle.Enable3D = $true
            $chartArea.Area3DStyle.Inclination = $Inclination
        }

        $Chart.ChartAreas.Add($chartArea)

        if ($PassThru)
        {
            Write-Output -InputObject $chartArea
        }
    }
}

# SIG # Begin signature block
# MIIcawYJKoZIhvcNAQcCoIIcXDCCHFgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUqVPhTBsad8Ld397HNfe8CB5z
# pVWggheaMIIFIzCCBAugAwIBAgIQAsbTxa4q6RSRmx0hkVyicTANBgkqhkiG9w0B
# AQsFADByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFz
# c3VyZWQgSUQgQ29kZSBTaWduaW5nIENBMB4XDTE5MDcwMzAwMDAwMFoXDTIxMTEw
# MzEyMDAwMFowYDELMAkGA1UEBhMCR0IxDzANBgNVBAcTBkxvbmRvbjEfMB0GA1UE
# ChMWVmlydHVhbCBFbmdpbmUgTGltaXRlZDEfMB0GA1UEAxMWVmlydHVhbCBFbmdp
# bmUgTGltaXRlZDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJ/s4NME
# JLA1Aji4EHJ85uwyEEAepndYn1X8pRnGkOlTzVHITAeH7BQnehjbNwCj7MHUPTSM
# zSucXhyfaMZthCNYtugyZ2uU4uVjB1f3xdmXXFX+aukMYgCk1ZQFbQMBqbzRY4Cl
# DwlLNGVEjDJeLBUL6ciIETqDc27YLg772WLpuvIXne13EYXN422Y83XRqEMf4v9S
# 398S8MRk5qdasRtxYZY6GciZZQnAL/XObpXDM3tDFgcQuyGcZttRuXVZXEj+mlY8
# gUIzkSJ0aJn1pVVTsa+tCvAZuJMJwdPhyM7NUa7Ysm7n9qdF7BvcrWBmaYRfDyya
# lLwRoOcI2HVodX8CAwEAAaOCAcUwggHBMB8GA1UdIwQYMBaAFFrEuXsqCqOl6nED
# wGD5LfZldQ5YMB0GA1UdDgQWBBSDFWXl70FjVfl8IBwATpE46qvGeDAOBgNVHQ8B
# Af8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwdwYDVR0fBHAwbjA1oDOgMYYv
# aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL3NoYTItYXNzdXJlZC1jcy1nMS5jcmww
# NaAzoDGGL2h0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9zaGEyLWFzc3VyZWQtY3Mt
# ZzEuY3JsMEwGA1UdIARFMEMwNwYJYIZIAYb9bAMBMCowKAYIKwYBBQUHAgEWHGh0
# dHBzOi8vd3d3LmRpZ2ljZXJ0LmNvbS9DUFMwCAYGZ4EMAQQBMIGEBggrBgEFBQcB
# AQR4MHYwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBOBggr
# BgEFBQcwAoZCaHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0U0hB
# MkFzc3VyZWRJRENvZGVTaWduaW5nQ0EuY3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZI
# hvcNAQELBQADggEBAJ1VZZNMAy8KyQLBqwRWAWDqcOxjVly6FTIeqO2/ul9rEYm8
# B9mNx60/AL+TbTbUwBzia2pwBuIin70eClZHFstvQcASBbB0k14R/rs+jestfFRm
# rsEz272POc6vsKce3TOlqBc2rtvVyuUPRvI2yQm1WYTpOgQnnp3ix2LBd+fgRANs
# P9yurvnGdEFFzToFDXFVkFHBQ9Pr5tAb4i7ZkSFC52BtB7NVuoiH83lx07SyjIxU
# 11ELEDZBpO3HiTsTzbhPAEw4CP++ONK8fieWZevDK9DFEiNIC0gWL/DH1+c7eihO
# oJdJqRAT9wkAMIjcskZ5LObGvMst/hqwBewpLzYwggUwMIIEGKADAgECAhAECRgb
# X9W7ZnVTQ7VvlVAIMA0GCSqGSIb3DQEBCwUAMGUxCzAJBgNVBAYTAlVTMRUwEwYD
# VQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAi
# BgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0xMzEwMjIxMjAw
# MDBaFw0yODEwMjIxMjAwMDBaMHIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdp
# Q2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xMTAvBgNVBAMTKERp
# Z2lDZXJ0IFNIQTIgQXNzdXJlZCBJRCBDb2RlIFNpZ25pbmcgQ0EwggEiMA0GCSqG
# SIb3DQEBAQUAA4IBDwAwggEKAoIBAQD407Mcfw4Rr2d3B9MLMUkZz9D7RZmxOttE
# 9X/lqJ3bMtdx6nadBS63j/qSQ8Cl+YnUNxnXtqrwnIal2CWsDnkoOn7p0WfTxvsp
# J8fTeyOU5JEjlpB3gvmhhCNmElQzUHSxKCa7JGnCwlLyFGeKiUXULaGj6YgsIJWu
# HEqHCN8M9eJNYBi+qsSyrnAxZjNxPqxwoqvOf+l8y5Kh5TsxHM/q8grkV7tKtel0
# 5iv+bMt+dDk2DZDv5LVOpKnqagqrhPOsZ061xPeM0SAlI+sIZD5SlsHyDxL0xY4P
# waLoLFH3c7y9hbFig3NBggfkOItqcyDQD2RzPJ6fpjOp/RnfJZPRAgMBAAGjggHN
# MIIByTASBgNVHRMBAf8ECDAGAQH/AgEAMA4GA1UdDwEB/wQEAwIBhjATBgNVHSUE
# DDAKBggrBgEFBQcDAzB5BggrBgEFBQcBAQRtMGswJAYIKwYBBQUHMAGGGGh0dHA6
# Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBDBggrBgEFBQcwAoY3aHR0cDovL2NhY2VydHMu
# ZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNydDCBgQYDVR0f
# BHoweDA6oDigNoY0aHR0cDovL2NybDQuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNz
# dXJlZElEUm9vdENBLmNybDA6oDigNoY0aHR0cDovL2NybDMuZGlnaWNlcnQuY29t
# L0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNybDBPBgNVHSAESDBGMDgGCmCGSAGG
# /WwAAgQwKjAoBggrBgEFBQcCARYcaHR0cHM6Ly93d3cuZGlnaWNlcnQuY29tL0NQ
# UzAKBghghkgBhv1sAzAdBgNVHQ4EFgQUWsS5eyoKo6XqcQPAYPkt9mV1DlgwHwYD
# VR0jBBgwFoAUReuir/SSy4IxLVGLp6chnfNtyA8wDQYJKoZIhvcNAQELBQADggEB
# AD7sDVoks/Mi0RXILHwlKXaoHV0cLToaxO8wYdd+C2D9wz0PxK+L/e8q3yBVN7Dh
# 9tGSdQ9RtG6ljlriXiSBThCk7j9xjmMOE0ut119EefM2FAaK95xGTlz/kLEbBw6R
# Ffu6r7VRwo0kriTGxycqoSkoGjpxKAI8LpGjwCUR4pwUR6F6aGivm6dcIFzZcbEM
# j7uo+MUSaJ/PQMtARKUT8OZkDCUIQjKyNookAv4vcn4c10lFluhZHen6dGRrsutm
# Q9qzsIzV6Q3d9gEgzpkxYz0IGhizgZtPxpMQBvwHgfqL2vmCSfdibqFT+hKUGIUu
# kpHqaGxEMrJmoecYpJpkUe8wggZqMIIFUqADAgECAhADAZoCOv9YsWvW1ermF/Bm
# MA0GCSqGSIb3DQEBBQUAMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2Vy
# dCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lD
# ZXJ0IEFzc3VyZWQgSUQgQ0EtMTAeFw0xNDEwMjIwMDAwMDBaFw0yNDEwMjIwMDAw
# MDBaMEcxCzAJBgNVBAYTAlVTMREwDwYDVQQKEwhEaWdpQ2VydDElMCMGA1UEAxMc
# RGlnaUNlcnQgVGltZXN0YW1wIFJlc3BvbmRlcjCCASIwDQYJKoZIhvcNAQEBBQAD
# ggEPADCCAQoCggEBAKNkXfx8s+CCNeDg9sYq5kl1O8xu4FOpnx9kWeZ8a39rjJ1V
# +JLjntVaY1sCSVDZg85vZu7dy4XpX6X51Id0iEQ7Gcnl9ZGfxhQ5rCTqqEsskYnM
# Xij0ZLZQt/USs3OWCmejvmGfrvP9Enh1DqZbFP1FI46GRFV9GIYFjFWHeUhG98oO
# jafeTl/iqLYtWQJhiGFyGGi5uHzu5uc0LzF3gTAfuzYBje8n4/ea8EwxZI3j6/oZ
# h6h+z+yMDDZbesF6uHjHyQYuRhDIjegEYNu8c3T6Ttj+qkDxss5wRoPp2kChWTrZ
# FQlXmVYwk/PJYczQCMxr7GJCkawCwO+k8IkRj3cCAwEAAaOCAzUwggMxMA4GA1Ud
# DwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMI
# MIIBvwYDVR0gBIIBtjCCAbIwggGhBglghkgBhv1sBwEwggGSMCgGCCsGAQUFBwIB
# FhxodHRwczovL3d3dy5kaWdpY2VydC5jb20vQ1BTMIIBZAYIKwYBBQUHAgIwggFW
# HoIBUgBBAG4AeQAgAHUAcwBlACAAbwBmACAAdABoAGkAcwAgAEMAZQByAHQAaQBm
# AGkAYwBhAHQAZQAgAGMAbwBuAHMAdABpAHQAdQB0AGUAcwAgAGEAYwBjAGUAcAB0
# AGEAbgBjAGUAIABvAGYAIAB0AGgAZQAgAEQAaQBnAGkAQwBlAHIAdAAgAEMAUAAv
# AEMAUABTACAAYQBuAGQAIAB0AGgAZQAgAFIAZQBsAHkAaQBuAGcAIABQAGEAcgB0
# AHkAIABBAGcAcgBlAGUAbQBlAG4AdAAgAHcAaABpAGMAaAAgAGwAaQBtAGkAdAAg
# AGwAaQBhAGIAaQBsAGkAdAB5ACAAYQBuAGQAIABhAHIAZQAgAGkAbgBjAG8AcgBw
# AG8AcgBhAHQAZQBkACAAaABlAHIAZQBpAG4AIABiAHkAIAByAGUAZgBlAHIAZQBu
# AGMAZQAuMAsGCWCGSAGG/WwDFTAfBgNVHSMEGDAWgBQVABIrE5iymQftHt+ivlcN
# K2cCzTAdBgNVHQ4EFgQUYVpNJLZJMp1KKnkag0v0HonByn0wfQYDVR0fBHYwdDA4
# oDagNIYyaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElE
# Q0EtMS5jcmwwOKA2oDSGMmh0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9EaWdpQ2Vy
# dEFzc3VyZWRJRENBLTEuY3JsMHcGCCsGAQUFBwEBBGswaTAkBggrBgEFBQcwAYYY
# aHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEEGCCsGAQUFBzAChjVodHRwOi8vY2Fj
# ZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURDQS0xLmNydDANBgkq
# hkiG9w0BAQUFAAOCAQEAnSV+GzNNsiaBXJuGziMgD4CH5Yj//7HUaiwx7ToXGXEX
# zakbvFoWOQCd42yE5FpA+94GAYw3+puxnSR+/iCkV61bt5qwYCbqaVchXTQvH3Gw
# g5QZBWs1kBCge5fH9j/n4hFBpr1i2fAnPTgdKG86Ugnw7HBi02JLsOBzppLA044x
# 2C/jbRcTBu7kA7YUq/OPQ6dxnSHdFMoVXZJB2vkPgdGZdA0mxA5/G7X1oPHGdwYo
# FenYk+VVFvC7Cqsc21xIJ2bIo4sKHOWV2q7ELlmgYd3a822iYemKC23sEhi991VU
# QAOSK2vCUcIKSK+w1G7g9BQKOhvjjz3Kr2qNe9zYRDCCBs0wggW1oAMCAQICEAb9
# +QOWA63qAArrPye7uhswDQYJKoZIhvcNAQEFBQAwZTELMAkGA1UEBhMCVVMxFTAT
# BgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEk
# MCIGA1UEAxMbRGlnaUNlcnQgQXNzdXJlZCBJRCBSb290IENBMB4XDTA2MTExMDAw
# MDAwMFoXDTIxMTExMDAwMDAwMFowYjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERp
# Z2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEhMB8GA1UEAxMY
# RGlnaUNlcnQgQXNzdXJlZCBJRCBDQS0xMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
# MIIBCgKCAQEA6IItmfnKwkKVpYBzQHDSnlZUXKnE0kEGj8kz/E1FkVyBn+0snPgW
# Wd+etSQVwpi5tHdJ3InECtqvy15r7a2wcTHrzzpADEZNk+yLejYIA6sMNP4YSYL+
# x8cxSIB8HqIPkg5QycaH6zY/2DDD/6b3+6LNb3Mj/qxWBZDwMiEWicZwiPkFl32j
# x0PdAug7Pe2xQaPtP77blUjE7h6z8rwMK5nQxl0SQoHhg26Ccz8mSxSQrllmCsSN
# vtLOBq6thG9IhJtPQLnxTPKvmPv2zkBdXPao8S+v7Iki8msYZbHBc63X8djPHgp0
# XEK4aH631XcKJ1Z8D2KkPzIUYJX9BwSiCQIDAQABo4IDejCCA3YwDgYDVR0PAQH/
# BAQDAgGGMDsGA1UdJQQ0MDIGCCsGAQUFBwMBBggrBgEFBQcDAgYIKwYBBQUHAwMG
# CCsGAQUFBwMEBggrBgEFBQcDCDCCAdIGA1UdIASCAckwggHFMIIBtAYKYIZIAYb9
# bAABBDCCAaQwOgYIKwYBBQUHAgEWLmh0dHA6Ly93d3cuZGlnaWNlcnQuY29tL3Nz
# bC1jcHMtcmVwb3NpdG9yeS5odG0wggFkBggrBgEFBQcCAjCCAVYeggFSAEEAbgB5
# ACAAdQBzAGUAIABvAGYAIAB0AGgAaQBzACAAQwBlAHIAdABpAGYAaQBjAGEAdABl
# ACAAYwBvAG4AcwB0AGkAdAB1AHQAZQBzACAAYQBjAGMAZQBwAHQAYQBuAGMAZQAg
# AG8AZgAgAHQAaABlACAARABpAGcAaQBDAGUAcgB0ACAAQwBQAC8AQwBQAFMAIABh
# AG4AZAAgAHQAaABlACAAUgBlAGwAeQBpAG4AZwAgAFAAYQByAHQAeQAgAEEAZwBy
# AGUAZQBtAGUAbgB0ACAAdwBoAGkAYwBoACAAbABpAG0AaQB0ACAAbABpAGEAYgBp
# AGwAaQB0AHkAIABhAG4AZAAgAGEAcgBlACAAaQBuAGMAbwByAHAAbwByAGEAdABl
# AGQAIABoAGUAcgBlAGkAbgAgAGIAeQAgAHIAZQBmAGUAcgBlAG4AYwBlAC4wCwYJ
# YIZIAYb9bAMVMBIGA1UdEwEB/wQIMAYBAf8CAQAweQYIKwYBBQUHAQEEbTBrMCQG
# CCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQwYIKwYBBQUHMAKG
# N2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJv
# b3RDQS5jcnQwgYEGA1UdHwR6MHgwOqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0
# LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwOqA4oDaGNGh0dHA6Ly9j
# cmw0LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwHQYD
# VR0OBBYEFBUAEisTmLKZB+0e36K+Vw0rZwLNMB8GA1UdIwQYMBaAFEXroq/0ksuC
# MS1Ri6enIZ3zbcgPMA0GCSqGSIb3DQEBBQUAA4IBAQBGUD7Jtygkpzgdtlspr1LP
# UukxR6tWXHvVDQtBs+/sdR90OPKyXGGinJXDUOSCuSPRujqGcq04eKx1XRcXNHJH
# hZRW0eu7NoR3zCSl8wQZVann4+erYs37iy2QwsDStZS9Xk+xBdIOPRqpFFumhjFi
# qKgz5Js5p8T1zh14dpQlc+Qqq8+cdkvtX8JLFuRLcEwAiR78xXm8TBJX/l/hHrwC
# Xaj++wc4Tw3GXZG5D2dFzdaD7eeSDY2xaYxP+1ngIw/Sqq4AfO6cQg7Pkdcntxbu
# D8O9fAqg7iwIVYUiuOsYGk38KiGtSTGDR5V3cdyxG0tLHBCcdxTBnU8vWpUIKRAm
# MYIEOzCCBDcCAQEwgYYwcjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0
# IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTExMC8GA1UEAxMoRGlnaUNl
# cnQgU0hBMiBBc3N1cmVkIElEIENvZGUgU2lnbmluZyBDQQIQAsbTxa4q6RSRmx0h
# kVyicTAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkq
# hkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGC
# NwIBFTAjBgkqhkiG9w0BCQQxFgQUpK4x34cILBuysvSdeapjSFLwp0gwDQYJKoZI
# hvcNAQEBBQAEggEAd/qdIP3O+B7g3/qWi3X4VBOjjTpB8qSKfS8Ef1zW+9gBwdmD
# pcTVmzrMZ2jyCAqvp+6csEIV5gef4Mrg7v6qqFcIj1paMQzxoL44xT507oECmO/w
# l+bqWSmQEtlZ8pe+nPGT5GW393fRy/754TPMT36NEHhSz5M569FRuBGbfjAxBnMZ
# roy2YV1yFyKsqgj3kph11txFnYzqs9+jVV63WEaQHb7pzkBWddTp6g7GukidJRW0
# QXIjDHFOvTTWhKvMq7ekxg2KGNt6SwzU7PlPjBGc5sRewtXeb3/cCWSvhNkOat9q
# lHbaD60eOjXgP4R18s6LfuLtpZQW8gCtNwAGmqGCAg8wggILBgkqhkiG9w0BCQYx
# ggH8MIIB+AIBATB2MGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJ
# bmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0
# IEFzc3VyZWQgSUQgQ0EtMQIQAwGaAjr/WLFr1tXq5hfwZjAJBgUrDgMCGgUAoF0w
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAwNTA3
# MTUzNDE2WjAjBgkqhkiG9w0BCQQxFgQU6JOWNFtGu1YwfcsyyrdUduai69kwDQYJ
# KoZIhvcNAQEBBQAEggEAncYBMrmNqFWJiutN5qLs9/4Ar2PqRNze4kcOtP9mPA1g
# rNuTkIbT2H1SLcfz5z8BVeWMc1zvoQzrVIJttQrpakP77U4K9qwMiyH4c/dq64H+
# snlTRPsyQi3raR6tYdTW59fdsoZDMY9h2ZrpG+gA70CDas8xQ2fiQ0Z4Nr1kFOGt
# CkeGEVy5NWEeBTzda22vQ30NGuhyotRhUxxjaBIq3XzOHUocAtfo4sd4WOsAKoNG
# eQmYUkaSxilw3matvNMcDB9d+k47KZD4LoYbn1qkBCvree8sMEhO5m9sGtVbjb7k
# Ft9BKE0TJFczh4LctOUJqronI6FtZ2YyJfxzPG86aA==
# SIG # End signature block

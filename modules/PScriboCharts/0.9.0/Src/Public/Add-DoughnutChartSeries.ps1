function Add-DoughnutChartSeries
{
<#
    .SYNOPSIS
        Adds a doughnut Series to an existing ChartArea.
#>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType([System.Windows.Forms.DataVisualization.Charting.Series])]
    param
    (
        ## Source objects used to plot data points on the chart.
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.Object[]] $InputObject,

        ## Series name
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String] $Name,

        ## Chart to add the data series to.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.Windows.Forms.DataVisualization.Charting.Chart] $Chart,

        ## ChartArea to add the series to.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.Windows.Forms.DataVisualization.Charting.ChartArea] $ChartArea,

        ## InputObject property name to bind to the X axis.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String] $XField,

        ## InputObject property name to bind to the Y axis.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String] $YField,

        ## Built-in color palette to apply to the data series.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Palette')]
        [System.String] $Palette,

        ## Custom color palette to apply to the data series.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'CustomPalette')]
        [System.Drawing.Color[]] $CustomPalette,

        ## Apply a specific color to the data series.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Color')]
        [System.Drawing.Color] $Color,

        ## Apply an seperate color from the palette per data point.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $ColorPerDataPoint,

        ## Reverse the color palette.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $ReversePalette,

        ## Hide zero value data point labels.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $HideZeroValueLabels,

        ## Sort the series.
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Ascending','Descending')]
        [System.String] $Sort,

        ## Series data point label.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String] $Label = '#VALY',

        ## Axis label text for the series.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String] $AxisLabel,

        ## Label for the data series that is displayed in a legend.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String] $LegendText = '#VALX',

        ## Data point (border) width.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Int32] $BorderWidth = 1,

        ## Data point border color.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Color] $BorderColor,

        ## Data label font.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Font] $Font = (Get-DefaultFont),

        ## Data label text color.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Color] $LabelForeColor = [System.Drawing.Color]::FromName('Black'),

        ## Data label back color.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Color] $LabelBackColor = [System.Drawing.Color]::FromName('Empty'),

        ## X axis type.
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Primary', 'Secondary')]
        [System.String] $XAxisType = 'Primary',

        ## Y axis type.
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Primary', 'Secondary')]
        [System.String] $YAxisType = 'Primary',

        ## Hide the data series from any legend.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $HideFromLegend,

        ## Pass the [System.Windows.Forms.DataVisualization.Charting.Series] object down the pipeline.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $PassThru,

        <# Chart type specific parameters #>

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Inside', 'Outside', 'Disabled')]
        [System.String] $LabelPosition,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Color] $LineColor,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Int32] $StartAngle,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Int32] $Radius
    )
    begin
    {
        $dataPoints = New-Object -TypeName System.Collections.ArrayList -ArgumentList @()
    }
    process
    {
        foreach ($object in $InputObject)
        {
            [ref] $null = $dataPoints.Add($object)
        }
    }
    end
    {
        $chartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Doughnut
        $dataPointCollection = $dataPoints | Convert-ToOrderedDictionary -Key $XField -Value $YField
        $chartSeries = Add-ChartSeries @PSBoundParameters -DataPointCollection $dataPointCollection -ChartType $chartType

        <# Chart type specific parameters #>

        if ($PSBoundParameters.ContainsKey('Radius'))
        {
            $chartSeries['DoughnutRadius'] = $Radius
        }

        if ($PSBoundParameters.ContainsKey('LabelPosition'))
        {
            $chartSeries['PieLabelStyle'] = $LabelPosition
        }

        if ($PSBoundParameters.ContainsKey('LineColor'))
        {
            $chartSeries['PieLineColor'] = $LineColor
        }

        if ($PSBoundParameters.ContainsKey('StartAngle'))
        {
            $chartSeries['PieStartAngle'] = $StartAngle.ToString()
        }

        if ($PassThru)
        {
            Write-Output -InputObject $chartSeries
        }
    }
}

# SIG # Begin signature block
# MIIcawYJKoZIhvcNAQcCoIIcXDCCHFgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQULnDS4mOxKFymvX4j7U8lDl/S
# cFaggheaMIIFIzCCBAugAwIBAgIQAsbTxa4q6RSRmx0hkVyicTANBgkqhkiG9w0B
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
# NwIBFTAjBgkqhkiG9w0BCQQxFgQUT3DCa4YHSPnADGGJOc+F9rmFEeowDQYJKoZI
# hvcNAQEBBQAEggEAcWPU8eDHVGxJEIUbjHBtqAl+kcXr4zenRF7FzAzYBy+BGOAt
# L8fEEc9E54DniD3yjkVgqpRgXQjyGYyTboKx/33/k5LhEdoJcSm8Aul+YYBISdrn
# 7UijeQ++VIcYjh3imvzjOTc3jisJ4fgky6EGrLzyaCGP1g9UCcmubWOihJNGdqKg
# r4vAT6ZaYuKMBFH6F0T89F/8i0b5ofWPZD0vsStBNkXaWFPyK65oH0rdG+BgPPpw
# 7lbZE8ni2A6MZKhHdplvuVbzxV+sCBnK08/DU109PGCQ3EwvDKbxXVtyVZweDJPs
# Zb+ZruGYArSuyzhTATBf1yemnRVy5cPWat77f6GCAg8wggILBgkqhkiG9w0BCQYx
# ggH8MIIB+AIBATB2MGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJ
# bmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0
# IEFzc3VyZWQgSUQgQ0EtMQIQAwGaAjr/WLFr1tXq5hfwZjAJBgUrDgMCGgUAoF0w
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAwNTA3
# MTUzNDE3WjAjBgkqhkiG9w0BCQQxFgQUYGio3rF8xkhJ97oAIMNoRngGL1UwDQYJ
# KoZIhvcNAQEBBQAEggEAomNj0xjB/rXqrD6rfAVeOjqBZKtTw7xoWFzhjEIRQPoN
# StwMlOgx91h26DdAXbyEaFCMq5xrnon8G+cNccJx3vFJrIBfH9S7waO3DQ9F9qra
# 7UcAfaXTenMsaCVOQAuQ79ji7wh43/0y2BMULKwtYLrQGYrz9NFqeFVjmvToMEt2
# 1PnvEfMBwfA4azxYJ3db4SRe5wv9oA7REa0oEkkw7BzdlPDLo2T5JqB2nFps/N82
# ZvAQlh4ZuINlPqB0RxUW08oB2nMpOfcyXWJpewmVhf/YQVs+crAJ5L197qgi5smA
# KDvaU4vGg4JF1AgfemUDhVC8fkWzRxCMOelWOTb3UA==
# SIG # End signature block

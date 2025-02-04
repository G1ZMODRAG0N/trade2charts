function New-Chart
{
<#
    .SYNOPSIS
        Creates a new [System.Windows.Forms.DataVisualization.Charting.Chart] object.

    .DESCRIPTION
        A chart is a container for collections of series data and chart areas. Each chart can hold multiple
        chart areas so that multiple charts can be displayed. Each chart area can contain one or more series
        of data that are used to render the chart.

    .LINK
        https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.datavisualization.charting.chart
#>
    [CmdletBinding(DefaultParameterSetName = 'Palette')]
    [OutputType([System.Windows.Forms.DataVisualization.Charting.Chart])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions','')]
    param
    (
        ## Internal chart name. This name is used when exporting a chart.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Palette')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'CustomPalette')]
        [System.String] $Name,

        ## The width of the chart in pixels. If not specified, defaults to 200.
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'Palette')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'CustomPalette')]
        [System.Int32] $Width = 200,

        ## The height of the chart in pixels. If not specified, defaults to 150.
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'Palette')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'CustomPalette')]
        [System.Int32] $Height = 150,

        ## Background color of the chart.
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'Palette')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'CustomPalette')]
        $BackColor = [System.Drawing.Color]::Empty,

        ## Chart border width.
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'Palette')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'CustomPalette')]
        [System.Int32] $BorderWidth = 1,

        ## Chart border color.
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'Palette')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'CustomPalette')]
        [System.Drawing.Color] $BorderColor = [System.Drawing.Color]::Black,

        ## Chart border style. If not specified, defaults to 'NotSet'.
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'Palette')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'CustomPalette')]
        [ValidateSet('NotSet','Dash','DashDot','DashDotDot','Dot','Solid')]
        [System.String] $BorderStyle = 'NotSet',

        ## Custom chart palette.
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'CustomPalette')]
        [System.Drawing.Color[]] $CustomPalette,

        ## Built-in chart palette.
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'Palette')]
        [ValidateSet('Amber','Berry','Blue','BlueGrey','Bright','BrightPastel','Brown','Chocolate','Cyan','DeepOrange',
                     'DeepPurple','EarthTones','Excel','Fire','Grayscale','Green','Grey','Indigo','Light','LightBlue',
                     'LightGreen','Lime','Orange','Pastel','Pink','Purple','Red','SeaGreen','SemiTransparent','Teal',
                     'Yellow')]
        [System.String] $Palette = 'Pastel',

        ## Apply the palette colors in reverse order.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $ReversePalette
    )
    process
    {
        Write-Verbose -Message ($localized.CreatingChart -f $Name)
        $chart = New-object System.Windows.Forms.DataVisualization.Charting.Chart
        $chart.Name = $Name
        $chart.Width = $Width
        $chart.Height = $Height
        $chart.BackColor = $BackColor
        $chart.BorderColor = $BorderColor
        $chart.BorderDashStyle = $BorderStyle
        $chart.BorderWidth = $BorderWidth

        $chart.RenderingDpiX = 600.0
        $chart.RenderingDpiY = 600.0

        if (-not $PSBoundParameters.ContainsKey('CustomPalette'))
        {
            $CustomPalette = Get-ColorPalette -Palette $Palette
        }

        ## We don't want to reverse the array passed in
        $paletteCopy = $CustomPalette.Clone()
        if ($ReversePalette)
        {
            [System.Array]::Reverse($paletteCopy)
        }

        $chart.Palette = [System.Windows.Forms.DataVisualization.Charting.ChartColorPalette]::None
        $chart.PaletteCustomColors = $paletteCopy
        Write-Output -InputObject $chart
    }
}

# SIG # Begin signature block
# MIIcawYJKoZIhvcNAQcCoIIcXDCCHFgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUQomTu/eEWTMxZy4bAe9FcAMQ
# 4lmggheaMIIFIzCCBAugAwIBAgIQAsbTxa4q6RSRmx0hkVyicTANBgkqhkiG9w0B
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
# NwIBFTAjBgkqhkiG9w0BCQQxFgQUE5y4odqldNaxhggjXjmI+CwY6qQwDQYJKoZI
# hvcNAQEBBQAEggEAU+8G/FiWVABaNlNTJoUgvQVjPa3RC5ll7fgKRjcB6be1ren2
# ncHpA3UiahPHxIzM7uW9bSZTGNXEEwOqbUlx/J8yKjz032eXLpEzhUaUI4m9AoUT
# 58ImRmKHh+jx6c/kaclLYz4CpVqOJc0J7hIy0xW2W9ZuUU9NlIzTjmksMGUx4KvB
# rpld+4daxx5mKiIE8mALvgS7lhaL86PhucTJ1zpTwTArVL5ALR2dHKu84XJDpFee
# lAQMImd6CiGPGnOQaDOWwANg8iwUjn7ElVJrDCuCKDtDaZDrldySJlHGs7gW+g4W
# acofKFmV6FcZDkvVYNX6J6K061MM1pIWqcU8/6GCAg8wggILBgkqhkiG9w0BCQYx
# ggH8MIIB+AIBATB2MGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJ
# bmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0
# IEFzc3VyZWQgSUQgQ0EtMQIQAwGaAjr/WLFr1tXq5hfwZjAJBgUrDgMCGgUAoF0w
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAwNTA3
# MTUzNDE4WjAjBgkqhkiG9w0BCQQxFgQUJwkgKnQ0o+d/3wTjEfzh9m39aw4wDQYJ
# KoZIhvcNAQEBBQAEggEAJ8T7+meUevnQDxwP78dycrTfv8VjmtyOUwVzLtxLgsQo
# 4yWERAIMmymC6t6Yvu+aCo/erSnwmh3ypQ3gvCbVcjtb+vxuO85e54oWWBdcOGkR
# D1CGLJUGxKqtu9EwJLX59We0OChQz75FmYpArOc4dqvZWvPJF7+8EsxLjdrxyi/w
# B6TVUb380hGWX4UoF1ko5bukE40HkftrQ9eRUHbEPMGzIusVcHj/FEMIej/2W3Y+
# CcX25W1voLgajsNOYvfnLpVtm1ELyhPQ9EI52uq+NE9m1QwnJsW/bGqJh+QUNRxO
# otc2mBDclwjkNa2eV4Gc+TRbqJOTo8wXksPQtl4ffg==
# SIG # End signature block

function Get-ColorPalette
{
    [CmdletBinding()]
    [OutputType([System.Drawing.Color[]])]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateSet('Amber','Berry','Blue','BlueGrey','Bright','BrightPastel','Brown','Chocolate','Cyan','DeepOrange',
                     'DeepPurple','EarthTones','Excel','Fire','Grayscale','Green','Grey','Indigo','Light','LightBlue',
                     'LightGreen','Lime','Orange','Pastel','Pink','Purple','Red','SeaGreen','SemiTransparent','Teal',
                     'Yellow')]
        [System.String] $Palette
    )
    begin
    {
        $colorMap = @{
            Amber           = '#FFF8E1', '#FFECB3', '#FFE082', '#FFD54F', '#FFCA28', '#FFC107', '#FFB300', '#FFA000', '#FF8F00', '#FF6F00'
            Berry           = '#8A2BE2', '#BA55D3', '#4169E1', '#C71585', '#0000FF', '#8A2BE2', '#DA70D6', '#7B68EE', '#C000C0', '#0000CD', '#800080'
            Blue            = '#E3F2FD', '#BBDEFB', '#90CAF9', '#64B5F6', '#42A5F5', '#2196F3', '#1E88E5', '#1976D2', '#1565C0', '#0D47A1'
            BlueGrey        = '#ECEFF1', '#CFD8DC', '#B0BEC5', '#90A4AE', '#78909C', '#607D8B', '#546E7A', '#455A64', '#37474F', '#263238'
            Bright          = '#008000', '#0000FF', '#800080', '#00FF00', '#FF00FF', '#008080', '#FFFF00', '#808080', '#00FFFF', '#000080', '#800000', '#FF0000', '#808000', '#C0C0C0', '#FF6347', '#FFE4B5'
            BrightPastel    = '#418CF0', '#FCB441', '#E0400A', '#056492', '#BFBFBF', '#1A3B69', '#FFE382', '#129CDD', '#CA6B4B', '#005CDB', '#F3D288', '#506381', '#F1B9A8', '#E0830A', '#7893BE'
            Brown           = '#EFEBE9', '#D7CCC8', '#BCAAA4', '#A1887F', '#8D6E63', '#795548', '#6D4C41', '#5D4037', '#4E342E', '#3E2723'
            Chocolate       = '#A0522D', '#D2691E', '#8B0000', '#CD853F', '#A52A2A', '#F4A460', '#8B4513', '#C04000', '#B22222', '#B65C3A'
            Cyan            = '#E0F7FA', '#B2EBF2', '#80DEEA', '#4DD0E1', '#26C6DA', '#00BCD4', '#00ACC1', '#0097A7', '#00838F', '#006064'
            DeepOrange      = '#FBE9E7', '#FFCCBC', '#FFAB91', '#FF8A65', '#FF7043', '#FF5722', '#F4511E', '#E64A19', '#D84315', '#BF360C'
            DeepPurple      = '#EDE7F6', '#D1C4E9', '#B39DDB', '#9575CD', '#7E57C2', '#673AB7', '#5E35B1', '#512DA8', '#4527A0', '#311B92'
            EarthTones      = '#FF8000', '#B8860B', '#C04000', '#6B8E23', '#CD853F', '#C0C000', '#228B22', '#D2691E', '#808000', '#20B2AA', '#F4A460', '#00C000', '#8FBC8B', '#B22222', '#8B4513', '#C00000'
            Excel           = '#9999FF', '#993366', '#FFFFCC', '#CCFFFF', '#660066', '#FF8080', '#0066CC', '#CCCCFF', '#000080', '#FF00FF', '#FFFF00', '#00FFFF', '#800080', '#800000', '#008080', '#0000FF'
            Fire            = '#FFD700', '#FF0000', '#FF1493', '#DC143C', '#FF8C00', '#FF00FF', '#FFFF00', '#FF4500', '#C71585', '#DDE221'
            Grayscale       = '#C8C8C8', '#BDBDBD', '#B2B2B2', '#A7A7A7', '#9C9C9C', '#919191', '#868686', '#7B7B7B', '#707070', '#656565', '#5A5A5A', '#4F4F4F', '#444444', '#393939', '#2E2E2E', '#232323'
            Green           = '#E8F5E9', '#C8E6C9', '#A5D6A7', '#81C784', '#66BB6A', '#4CAF50', '#43A047', '#388E3C', '#2E7D32', '#1B5E20'
            Grey            = '#FAFAFA', '#F5F5F5', '#EEEEEE', '#E0E0E0', '#BDBDBD', '#9E9E9E', '#757575', '#616161', '#424242', '#212121'
            Indigo          = '#E8EAF6', '#C5CAE9', '#9FA8DA', '#7986CB', '#5C6BC0', '#3F51B5', '#3949AB', '#303F9F', '#283593', '#1A237E'
            Light           = '#E6E6FA', '#FFF0F5', '#FFDAB9', '#FFFACD', '#FFE4E1', '#F0FFF0', '#F0F8FF', '#F5F5F5', '#FAEBD7', '#E0FFFF'
            LightBlue       = '#E1F5FE', '#B3E5FC', '#81D4FA', '#4FC3F7', '#29B6F6', '#03A9F4', '#039BE5', '#0288D1', '#0277BD', '#01579B'
            LightGreen      = '#F1F8E9', '#DCEDC8', '#C5E1A5', '#AED581', '#9CCC65', '#8BC34A', '#7CB342', '#689F38', '#558B2F', '#33691E'
            Lime            = '#F9FBE7', '#F0F4C3', '#E6EE9C', '#DCE775', '#D4E157', '#CDDC39', '#C0CA33', '#AFB42B', '#9E9D24', '#827717'
            Orange          = '#FFF3E0', '#FFE0B2', '#FFCC80', '#FFB74D', '#FFA726', '#FF9800', '#FB8C00', '#F57C00', '#EF6C00', '#E65100'
            Pastel          = '#87CEEB', '#32CD32', '#BA55D3', '#F08080', '#4682B4', '#9ACD32', '#40E0D0', '#FF69B4', '#F0E68C', '#D2B48C', '#8FBC8B', '#6495ED', '#DDA0DD', '#5F9EA0', '#FFDAB9', '#FFA07A'
            Pink            = '#FCE4EC', '#F8BBD0', '#F48FB1', '#F06292', '#EC407A', '#E91E63', '#D81B60', '#C2185B', '#AD1457', '#880E4F'
            Purple          = '#F3E5F5', '#E1BEE7', '#CE93D8', '#BA68C8', '#AB47BC', '#9C27B0', '#8E24AA', '#7B1FA2', '#6A1B9A', '#4A148C'
            Red             = '#FFEBEE', '#FFCDD2', '#EF9A9A', '#E57373', '#EF5350', '#F44336', '#E53935', '#D32F2F', '#C62828', '#B71C1C'
            SeaGreen        = '#2E8B57', '#66CDAA', '#4682B4', '#008B8B', '#5F9EA0', '#3CB371', '#48D1CC', '#B0C4DE', '#8FBC8B', '#87CEEB'
            SemiTransparent = '#FF0000', '#00FF00', '#0000FF', '#FFFF00', '#00FFFF', '#FF00FF', '#AA7814', '#FF0000', '#00FF00', '#0000FF', '#FFFF00', '#00FFFF', '#FF00FF', '#AA7814', '#647832', '#285A96'
            Teal            = '#E0F2F1', '#B2DFDB', '#80CBC4', '#4DB6AC', '#26A69A', '#009688', '#00897B', '#00796B', '#00695C', '#004D40'
            Yellow          = '#FFFDE7', '#FFF9C4', '#FFF59D', '#FFF176', '#FFEE58', '#FFEB3B', '#FDD835', '#FBC02D', '#F9A825', '#F57F17'
        }
    }
    process
    {
        $colorPalette = New-Object -TypeName System.Collections.ArrayList
        foreach ($color in $colorMap[$Palette])
        {
            [ref] $null = $colorPalette.Add([System.Drawing.ColorTranslator]::FromHtml($color))
        }
        return $colorPalette.ToArray()
    }
}

# SIG # Begin signature block
# MIIcawYJKoZIhvcNAQcCoIIcXDCCHFgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU8nyYPQ772e44ZTS37UEiWx8w
# zJyggheaMIIFIzCCBAugAwIBAgIQAsbTxa4q6RSRmx0hkVyicTANBgkqhkiG9w0B
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
# NwIBFTAjBgkqhkiG9w0BCQQxFgQUYdlDH02rvpdNa8zmdnHgSkFfiR8wDQYJKoZI
# hvcNAQEBBQAEggEAi7pI3K5wM9nGH6AGaWppqAz5qzvH+96ACI0gGQN6JXvIJStE
# YKzUZfpqg//2tEScIMNd5J7GdIdgi4165W7/nVzbGY0rJgZL2/zJ82zzWJtOrtbo
# apou7NR3XuivrlIgg380ehIwzKu91Qv8L0wJNXR/hrgs6rqY8GfGq/MJdIpIA9cl
# oFW9HtK1pQhvruZybKeSoMixKaZruCYDDRB7yYRwapbpQsBAWac0ff3GTbK8o5jy
# zdcXCKoNm1xHPWYprc3+CDIdKjQ52DdEBKTHHi3KbZhKQfq3wSWDoUs2nYjrQXp7
# yMG1ctpRRucXUqXaX0Mzrj00q1dNO77JRCH1DaGCAg8wggILBgkqhkiG9w0BCQYx
# ggH8MIIB+AIBATB2MGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJ
# bmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0
# IEFzc3VyZWQgSUQgQ0EtMQIQAwGaAjr/WLFr1tXq5hfwZjAJBgUrDgMCGgUAoF0w
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAwNTA3
# MTUzNDE2WjAjBgkqhkiG9w0BCQQxFgQUghKZ3rORtNG0k2EAtcnpm/KyFDkwDQYJ
# KoZIhvcNAQEBBQAEggEAgt8fynZufmiHH0f+CdkDyirXvEVq6Vv1Q4+PrSpyX9wk
# Daq4fXY2w67+BmJ+vXvYM2e2orHZtOp2x3ueKyU7YEc5a0vHg6pFxUOrf/T7vLnD
# lKaUYPBIRKMxI165Fa8soOpZBpM7BzjxeZou8s7yfHqyno28YApK3/Q/5awWy5nP
# SKqUeWFysIw0ujN8NbLWc4NSjeq/5O+2olMn/5Z5sPQVEo4pdDnSKbH5BEv1FbRI
# /gqgwVTCiYqLI83OL6OW1WUfOnUHmaj8RRa83aKd0q2LYZMdzmgr4Vqp6ZYcb1rw
# B8w7c75FY1xsbjuA5Jn3PYUDy7RVPJWUjGdEz7dFDQ==
# SIG # End signature block

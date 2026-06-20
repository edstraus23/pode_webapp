$newObject = [PSCustomObject]@{
    Name  = "object2"
    Value = 2
}

$anotherNewObject = [PSCustomObject]@{
    Name  = "object3"
    Value = 3
}

$filePath = "data.json"
$jsonData = Get-Content -Path $filePath -Raw | ConvertFrom-Json

# Append a single object
[array]$jsonData += $newObject

# Append multiple objects (using an array subexpression)
$jsonData += @($anotherNewObject, [PSCustomObject]@{Name = "object4"; Value = 4})

$jsonData | ConvertTo-Json -Depth 99 | Set-Content -Path $filePath -Encoding UTF8


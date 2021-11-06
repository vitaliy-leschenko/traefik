param(
    [string] $image = "vleschenko/traefik",
    [string] $output = "registry"
)

Import-Module "./buildx.psm1"

Set-Builder
$config = Get-Content .\buildconfig.json | ConvertFrom-Json

foreach ($traefik in $config.traefik)
{
    Write-Host "Build images for traefik version: $traefik"

    [string[]]$items = @()
    [string[]]$bases = @()
    foreach($tag in $config.tagsMap) 
    {
        $base = "$($config.baseimage):$($tag.source)"
        $current = "$($image):v$($traefik)-$($tag.target)"
        $bases += $base
        $items += $current
        New-Build -name $current -output $output -args @("BASE=$base", "TRAEFIKVERSION=v$traefik")
    }

    Push-Manifest -name "$($image):v$traefik" -items $items -bases $bases
}

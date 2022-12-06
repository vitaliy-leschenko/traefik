param(
    [string] $image = "vleschenko/traefik",
    [string] $output = "registry",
    [version] $minTraefikVersion = "2.5.0"
)

Import-Module "./buildx.psm1"

Set-Builder
$config = Get-Content .\buildconfig.json | ConvertFrom-Json

$traefiks = (curl -L https://api.github.com/repos/traefik/traefik/releases | ConvertFrom-Json) | % tag_name

foreach ($traefik in $traefiks)
{
    if ($traefik -match "^v(\d+\.\d+\.\d+)$")
    {
        $testVersion = [version]$Matches[1]
        if ($testVersion -ge $minTraefikVersion)
        {
            Write-Host "Build images for traefik version: $traefik"
            
            [string[]]$items = @()
            [string[]]$bases = @()
            foreach($tag in $config.tagsMap) 
            {
                $base = "$($config.baseimage):$($tag.source)"
                $current = "$($image):$($traefik)-$($tag.target)"
                $netapi = $tag.netapi32image
                $bases += $base
                $items += $current
                New-Build -name $current -output $output -args @("BASE=$base", "TRAEFIKVERSION=$traefik", "NETAPI=$netapi")
            }
            
            Push-Manifest -name "$($image):$traefik" -items $items -bases $bases -extras @("amd64/traefik:$traefik")
        }
    }
}

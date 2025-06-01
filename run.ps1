#!/usr/bin/env pwsh
#
# shell script to run the Mattermost containerized application in windows using podman
#
#
$thisDir = Get-Location

$volumes = @("config","data","logs","plugins","client/plugins","bleve-indexes")
$volumes | ForEach-Object {
    New-Item -ItemType Directory -Path ./volumes/app/mattermost/$_ -Force
}

podman compose version

# set DB_PW
$env:DB_PW = "your_password_here"

# check if $DB_PW is defined
if (-not $env:DB_PW) {
    Write-Output "DB_PW is not defined"
    exit 1
}

Write-Output "Starting Mattermost containerized application..."
podman compose -f docker-compose.yaml up --remove-orphans --detach

Write-Output "Mattermost containerized application started"
Write-Output "To stop the application, run 'podman compose -f docker-compose.yaml down'"

# open browser
Start-Process "http://localhost:16020"

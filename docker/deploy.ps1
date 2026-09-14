param(
    [string]$Version
)

$Image = "darwin642/my-web:$Version"
$Container = "my-web-deployed"

Write-Host "Pulling $Image..."
docker pull $Image

Write-Host "Stopping old container..."
docker rm -f $Container 2>$null

Write-Host "Starting new container..."
docker run -d `
    --name $Container `
    -p 8100:80 `
    $Image

Write-Host "Deployment completed: $Image"
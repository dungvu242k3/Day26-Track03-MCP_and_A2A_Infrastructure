# Start all Legal Multi-Agent System services (Windows PowerShell)
# Registry must be first, then leaf agents, then orchestrators

Write-Host "Starting Registry service on port 10000..." -ForegroundColor Cyan
$registry = Start-Process -FilePath "uv" -ArgumentList "run python -m registry" -PassThru -NoNewWindow
Start-Sleep -Seconds 3

Write-Host "Starting Tax Agent on port 10102..." -ForegroundColor Cyan
$tax = Start-Process -FilePath "uv" -ArgumentList "run python -m tax_agent" -PassThru -NoNewWindow

Write-Host "Starting Compliance Agent on port 10103..." -ForegroundColor Cyan
$compliance = Start-Process -FilePath "uv" -ArgumentList "run python -m compliance_agent" -PassThru -NoNewWindow
Start-Sleep -Seconds 3

Write-Host "Starting Law Agent on port 10101..." -ForegroundColor Cyan
$law = Start-Process -FilePath "uv" -ArgumentList "run python -m law_agent" -PassThru -NoNewWindow
Start-Sleep -Seconds 3

Write-Host "Starting Customer Agent on port 10100..." -ForegroundColor Cyan
$customer = Start-Process -FilePath "uv" -ArgumentList "run python -m customer_agent" -PassThru -NoNewWindow

Write-Host ""
Write-Host "All services started:" -ForegroundColor Green
Write-Host "  Registry:         http://localhost:10000"
Write-Host "  Customer Agent:   http://localhost:10100"
Write-Host "  Law Agent:        http://localhost:10101"
Write-Host "  Tax Agent:        http://localhost:10102"
Write-Host "  Compliance Agent: http://localhost:10103"
Write-Host ""
Write-Host "Run test_client.py to send a query:" -ForegroundColor Yellow
Write-Host "  uv run python test_client.py"
Write-Host ""
Write-Host "Press Ctrl+C then run 'stop_all.ps1' to stop all services." -ForegroundColor Yellow

try {
    Wait-Process -Id $registry.Id, $tax.Id, $compliance.Id, $law.Id, $customer.Id
}
catch {
    Write-Host "Stopping all services..." -ForegroundColor Red
    @($registry, $tax, $compliance, $law, $customer) | ForEach-Object {
        if ($_ -and !$_.HasExited) { Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue }
    }
}

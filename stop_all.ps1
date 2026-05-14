# Stop all Legal Multi-Agent System services (Windows PowerShell)

Write-Host "Stopping all agent services..." -ForegroundColor Yellow

# Find and kill processes listening on the agent ports
$ports = @(10000, 10100, 10101, 10102, 10103)

foreach ($port in $ports) {
    $connections = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
    if ($connections) {
        foreach ($conn in $connections) {
            $proc = Get-Process -Id $conn.OwningProcess -ErrorAction SilentlyContinue
            if ($proc) {
                Write-Host "  Stopping $($proc.ProcessName) (PID: $($proc.Id)) on port $port" -ForegroundColor Red
                Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
            }
        }
    }
}

Write-Host "All services stopped." -ForegroundColor Green

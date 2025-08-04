# Ruta de los scripts Python
$transferScript = "C:\Mondayapp\facturasmh\transferfmh.py"
$syncScript = "C:\Mondayapp\facturasmh\sync_scriptfmh.py"
$logFile = "C:\Logs\facturasfmh.log"
$transferOut = "C:\Logs\transferfmh_salida.log"
$transferErr = "C:\Logs\transferfmh_error.log"
$syncOut = "C:\Logs\syncfmh_salida.log"
$syncErr = "C:\Logs\syncfmh_error.log"

# Ruta completa a python.exe (ajusta si usas entorno virtual)
$pythonPath = "python.exe"

# Funcion para escribir logs
function Write-Log {
    param ([string]$message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $message" | Out-File -FilePath $logFile -Append
    Write-Host "$timestamp - $message"
}

# Iniciar registro
Write-Log "==== Inicio de la ejecucion automatica ===="

# 1. Ejecutar transferfmh.py
try {
    Write-Log "Ejecutando transferfmh.py..."
    $transferProcess = Start-Process -FilePath $pythonPath `
        -ArgumentList $transferScript `
        -RedirectStandardOutput $transferOut `
        -RedirectStandardError $transferErr `
        -Wait -PassThru -NoNewWindow

    if ($transferProcess.ExitCode -eq 0) {
        Write-Log "transferfmh.py se ejecuto correctamente (ExitCode: 0)."
    } else {
        Write-Log "ERROR: transferfmh.py fallo (ExitCode: $($transferProcess.ExitCode))."
        exit 1
    }
} catch {
    Write-Log "ERROR al ejecutar transferfmh.py: $_"
    exit 1
}

# 2. Esperar 60 segundos antes de ejecutar sync_scriptfmh.py
Write-Log "Esperando 60 segundos antes de ejecutar sync_scriptfmh.py..."
Start-Sleep -Seconds 60

# 3. Ejecutar sync_scriptfmh.py
try {
    Write-Log "Ejecutando sync_scriptfmh.py..."
    $syncProcess = Start-Process -FilePath $pythonPath `
        -ArgumentList $syncScript `
        -RedirectStandardOutput $syncOut `
        -RedirectStandardError $syncErr `
        -Wait -PassThru -NoNewWindow

    if ($syncProcess.ExitCode -eq 0) {
        Write-Log "sync_scriptfmh.py se ejecuto correctamente (ExitCode: 0)."
    } else {
        Write-Log "ERROR: sync_scriptfmh.py fallo (ExitCode: $($syncProcess.ExitCode))."
        exit 1
    }
} catch {
    Write-Log "ERROR al ejecutar sync_scriptfmh.py: $_"
    exit 1
}

Write-Log "==== Ejecucion completada ===="

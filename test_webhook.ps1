# Teste de comunicacao HTTP com o Webhook do n8n via PowerShell
$WebhookUrl = "http://localhost:5678/webhook/chat"

$Body = @{
    message    = "Olá! O que os artigos da base de conhecimento explicam sobre Agentes de IA?"
    session_id = "sessao-powershell-001"
} | ConvertTo-Json -Compress

$Headers = @{
    "Content-Type" = "application/json"
}

Write-Host "[*] Enviando requisicao POST para $WebhookUrl..." -ForegroundColor Cyan
Write-Host "[*] Payload: $Body" -ForegroundColor Gray

try {
    $Response = Invoke-RestMethod -Uri $WebhookUrl -Method Post -Headers $Headers -Body $Body -TimeoutSec 60
    Write-Host "[+] Resposta recebida:" -ForegroundColor Green
    $Response | ConvertTo-Json -Depth 5
}
catch {
    Write-Host "[-] Erro ao chamar o webhook: $_" -ForegroundColor Red
}


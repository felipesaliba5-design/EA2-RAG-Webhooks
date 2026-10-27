"""
Script de teste de comunicação HTTP com o Webhook do n8n
Agente: EduBot EA3 (EA2 - RAG e Webhooks)
"""

import requests
import json
import uuid

# Substitua pela URL da sua instância do n8n:
# Para webhook de produção: http://localhost:5678/webhook/chat
# Para webhook de teste no editor n8n: http://localhost:5678/webhook-test/chat
WEBHOOK_URL = "http://localhost:5678/webhook/chat"

def send_message(message: str, session_id: str = None):
    if session_id is None:
        session_id = str(uuid.uuid4())
    
    payload = {
        "message": message,
        "session_id": session_id
    }
    
    headers = {
        "Content-Type": "application/json"
    }
    
    print(f"[*] Enviando requisição para: {WEBHOOK_URL}")
    print(f"[*] Payload de entrada: {json.dumps(payload, ensure_ascii=False, indent=2)}")
    
    try:
        response = requests.post(WEBHOOK_URL, json=payload, headers=headers, timeout=60)
        print(f"[*] Status HTTP: {response.status_code}")
        
        if response.status_code == 200:
            print("[+] Resposta do Agente:")
            print(json.dumps(response.json(), ensure_ascii=False, indent=2))
        else:
            print(f"[-] Erro retornado: {response.text}")
            
    except requests.exceptions.RequestException as e:
        print(f"[-] Falha na requisição HTTP: {e}")

if __name__ == "__main__":
    test_session = "aluno_demo_101"
    
    print("=== TESTE 1: Pergunta sobre conteúdo dos artigos da base RAG ===")
    send_message(
        message="Olá! O que os artigos da base de conhecimento explicam sobre Agentes de IA?",
        session_id=test_session
    )
    
    print("\n=== TESTE 2: Pergunta operacional (DevAcademy) ===")
    send_message(
        message="Qual o prazo para envio do projeto final do bootcamp?",
        session_id=test_session
    )


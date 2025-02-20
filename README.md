# hsc-linux-set-ip
## Introdução
Neste projeto está o Script de Ajuste de IPs para migração de Servidores Linux.

O script contorna a limitação atual do `veeam` que ainda não consegue trocar os IPs de Servidores Linux.

## Validação
Testado em servidores:
- família Redhat

Pendetente de testes:
- familia Debian

## Usabilidade
Deve-se baixar o script no servidor, ajustar os IPs (ORIGEM/DESTINO) conforme o planejamento da migração.

### Ativando RC.LOCAL
Ativar o `rc.local`, tanto para família `redhat`quanto para família `debian`.

```bash
if [ ! -f /etc/rc.local ]; then
    cat <<EOF > /etc/rc.local
#!/bin/bash
# rc.local customizado

exit 0
EOF
    chmod +x /etc/rc.local
else
    chmod +x /etc/rc.local
fi
```

```bash
if [ ! -f /etc/systemd/system/rc-local.service ]; then
    if command -v wget &>/dev/null; then
        wget -O /etc/systemd/system/rc-local.service https://raw.githubusercontent.com/hospitalsaocamilo/hsc-linux-set-ip/refs/heads/main/file/rc-local.service
        systemctl daemon-reload
        systemctl enable rc-local
    elif command -v curl &>/dev/null; then
        curl -o /etc/systemd/system/rc-local.service https://raw.githubusercontent.com/hospitalsaocamilo/hsc-linux-set-ip/refs/heads/main/file/rc-local.service
        systemctl daemon-reload
        systemctl enable rc-local        
    else
        echo "Erro: wget ou curl não encontrado. Instale um dos dois."
        exit 1
    fi
fi
```

Incluir o script no `rc.local`.

```bash
SCRIPT_PATH="/usr/local/scripts/set-ip.sh"

# Verifica se /etc/rc.local contém "exit 0"
if grep -q "exit 0" /etc/rc.local; then
    # Insere a execução do script acima do 'exit 0' se ainda não estiver lá
    if ! grep -q "$SCRIPT_PATH" /etc/rc.local; then
        sed -i "/exit 0/i $SCRIPT_PATH" /etc/rc.local
    fi
else
    # Caso não tenha "exit 0", adiciona no final com seu script antes
    echo "$SCRIPT_PATH" >> /etc/rc.local
    echo "exit 0" >> /etc/rc.local
fi
```
### Ativando 'SET IP'

Baixando o script que executará a troca de IP na migração, é importante informar os dados da troca de IP, sem isso o script finalizará com falha.

```bash
mkdir -p /usr/local/scripts

SCRIPT_PATH="/usr/local/scripts/set-ip.sh"

if [ ! -f "$SCRIPT_PATH" ]; then
    if command -v wget &>/dev/null; then
        wget -O $SCRIPT_PATH https://raw.githubusercontent.com/hospitalsaocamilo/hsc-linux-set-ip/refs/heads/main/file/set-ip.sh
    elif command -v curl &>/dev/null; then
        curl -o $SCRIPT_PATH https://raw.githubusercontent.com/hospitalsaocamilo/hsc-linux-set-ip/refs/heads/main/file/set-ip.sh
    else
        echo "Erro: wget ou curl não encontrado. Instale um dos dois."
        exit 1
    fi
fi

chmod 750 $SCRIPT_PATH
```

> **:warning: ATENÇÃO :warning:**  
Se o script de troca de IPs não for ajustado, ao ser executado, ele finalizará com falha e não afetará o sistema... 



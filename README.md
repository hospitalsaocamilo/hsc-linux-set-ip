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

Ativar o `rc.local`. 

```bash
chmod +x /etc/rc.local
```

Incluir o script no `rc.local`.

```bash
export CAMINHO_SCRIPT='/usr/local/scripts/set-ip.sh'

if [ "$(grep -c set-ip.sh /etc/rc.local)" -eq "0" ] ; then
 echo "Adicionando $CAMINHO_SCRIPT em /etc/rc.local"
 echo "$CAMINHO_SCRIPT" >> /etc/rc.local
fi
```

> **:warning: ATENÇÃO :warning:**  
O script possuim valores de exemplo preechidos e finalizará com falha caso algum deles não seja ajustado... 

## Baixando o Script
Este repositório é público para facilitar o Download do script, não há nenhuma informação sensível aqui.

```bash
mkdir -p /usr/local/scripts
wget -O /usr/local/scripts/set-ip.sh https://raw.githubusercontent.com/hospitalsaocamilo/hsc-linux-set-ip/refs/heads/main/file/set-ip.sh
chmod +x /usr/local/scripts/set-ip.sh
```

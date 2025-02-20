#!/bin/bash
# Para uso interno, não use sem autorização

# Para o funcionamento deste script, deve-se ativar como executável o script `rc.local` e este script 
# também incluir este script no `rc.local`
# chmod +x /etc/rc.local 
# chmod +x [ caminho script ]
# echo "[ caminho script ]" >> /etc/rc.local 


# Os valores devem ser ajustados conforme planejamento

# Configuração das interfaces
INTERFACE="dummy"
# IPs das duas localidades
IP1="10.10.10.10/24"  # IP/MASK na localidade A
GATEWAY1="10.10.10.1"

IP2="20.20.20.20/24"  # IP/MASK na localidade B
GATEWAY2="20.20.20.1"

# Validação de alterações para uso, finaliza com erro e se algum item não for ajustado.

if [ "$INTERFACE" == "dummy" ] ; then
        echo "ERR: INTERFACE não ajustada..."
        exit 1
fi

if [ "$IP1" == "10.10.10.10/24" ] ; then
        echo "ERR: IP1 não ajustado..."
        exit 1
fi

if [ "$GATEWAY1" == "10.10.10.1" ] ; then
        echo "ERR: GATEWAY1 não ajustado..."
        exit 1
fi

if [ "$IP2" == '20.20.20.20/24' ] ; then
        echo "ERR: IP2 não ajustado..."
        exit 1
fi

if [ "$GATEWAY2" == "20.20.20.1" ] ; then
        echo "ERR: GATEWAY2 não ajustado..."
        exit 1
fi

# Aguarda a rede estabilizar no boot
sleep 10

# Verifica conectividade com o gateway atual
GATEWAY=$(ip r | grep ^default | awk '{ print $3 } ')
ping -c 3 -W 2 $GATEWAY > /dev/null
if [ $? -eq 0 ]; then
    echo "Gateway $GATEWAY está acessível. Saindo sem alterar..."
    exit 0
fi

# Verifica conectividade com os gateways em caso de falha da configuração atual
ping -c 3 -W 2 $GATEWAY1 > /dev/null
if [ $? -eq 0 ]; then
    echo "Gateway $GATEWAY1 está acessível. Mantendo IP $IP1."
    nmcli connection modify $INTERFACE ipv4.addresses $IP1
    nmcli connection modify $INTERFACE ipv4.gateway $GATEWAY1
else
    echo "Gateway $GATEWAY1 não responde. Trocando para IP $IP2."
    nmcli connection modify $INTERFACE ipv4.addresses $IP2
    nmcli connection modify $INTERFACE ipv4.gateway $GATEWAY2
fi

# Reinicia a interface para aplicar a configuração
nmcli connection down $INTERFACE
nmcli connection up $INTERFACE


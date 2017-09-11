#!/usr/bin/env bash
#Usted es libre de editar y/o distribuir este programa bajo los terminos de la licencia GPL v3 o posterior.

printf "\nEste script está diseñado para que te conectes a internet sin necesidad de un gestor gráfico de red
          haciendo uso de software como wpa_supplicant, dhcpcd/dhclient e iptools desde la línea de comandos.
                                Programador: Eduard Eliecer Tolosa Toloza 
                                    XMPP/Email: tolosaeduard@cock.lu
               Contacto y sala de chat: https://riot.im/app/#/room/#securityhacklabs:matrix.org
                                  Security Hack Labs Team. @SecHackLabs
                              Blog: https://securityhacklabs.blogspot.com\n
"
iface=$(ls /sys/class/net/ | grep w)

if [ -f /usr/bin/wpa_supplicant ] ; then
    echo -e "\nwpa_supplicant está instalado."
else
    if [ -f /etc/pacman.conf ] ; then
        pacman -S wpa_supplicant
    elif [ -f /etc/apt/sources.list ] ; then
        apt install wpa_supplicant
    fi
fi
if [ -f /usr/bin/dhcpcd ] ; then
    echo -e "dhcpcd está instalado.\n"
else
    if [ -f /etc/pacman.conf ] ; then
        pacman -S dhcpcd
    elif [ -f /etc/apt/sources.list ] ; then
        apt install dhcpcd
    fi
fi
function connect(){
    dhcpcd -k $iface
    killall dhcpcd
    killall dhclient
    killall wpa_supplicant
    ip link set dev $iface up
    wpa_supplicant -B -i $iface -D nl80211 -c /etc/wpa.conf
    dhcpcd -4 --noarp $iface
}

if [ -f /etc/wpa.conf ] ; then
    connect
else
    echo -e "\nNecesitas configurar tu archivo de conexión, por favor ingrese los datos cuando sean solicitados.\n"
    echo -e "Ingresa el nombre de tu red (ESSID): " ; read nombre
    echo "Introduce tu contraseña." ; read password
    wpa_passphrase $nombre $password > /etc/wpa.conf
    connect
    echo -e "\nConexión establecida."
fi



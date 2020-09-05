#!/bin/bash

#Variaveis
Forge="Forge.jar"
Fabric="Fabric.jar"
Vanilla="Vanilla.jar"

Help="Help Me"
About="About"

Ram2="2G"
Ram4="4G"
Ram8="8G"

Start_Option="Start"
Setup_Option="Setup"

arquivo=""

#Funções

function Recapitulando {
    #Reconhecimento de arquivo
    arquivo=$(find settings.txt)

    while IFS=: read Ignore Mine Xms Xmx
    do
    echo -e "$Ignore $Mine $Xms $Xmx"
    done < $arquivo

    Start_Server
}

function Start_Server {
    $(java -Xms$Xms -Xmx$Xmx $Mine)
}

function Setup_configs {
    $(echo > settings.txt)
    arquivo=$(find settings.txt)

    Mine=$(zenity --forms --title="Setup Configs" --add-combo="Versão Minecraft" --combo-values="$Forge|$Fabric|$Vanilla")
    zenity --info --ellipsize --text="Versão $Mine escolhida com sucesso!"

    Xms=$(zenity --forms --title="Setup Configs" --add-combo="Minimo RAM" --combo-values="$Ram2|$Ram4|$Ram8")

    Xmx=$(zenity --forms --title="Setup Configs" --add-combo="Máximo RAM padrão" --combo-values="$Ram2|$Ram4|$Ram8")

    zenity --info --ellipsize --text="Setup concluido. Guardando informações em $arquivo..."

    #Armazenando informações
    echo "$Mine" >> $arquivo
    echo "$Xms" >> $arquivo
    echo "$Xmx" >> $arquivo

    zenity --info --ellipsize --text="Informações guardadas, Iniciando Servidor..."    
    Start_Server
}

function Setup_or_Start {
    Opcao=$(zenity --forms --title="Setup or Start" --add-combo="Decida a ação a seguir:" --combo-values="$Start_Option|$Setup_Option|$Help|$About")
    if [ "$Opcao" = "$Start_Option" ]
        then
            zenity --question --ellipsize --text="Deseja iniciar com o ultimo Setup?"
            Recapitulando
    fi

    if [ "$Opcao" = "$Setup_Option" ]
        then
            Setup_configs
    fi

    if [ "$Opcao" = "$Help" ]
        then
            zenity --info --ellipsize --text="1. Renomeie respectivamente o arquivo inicializador do server (Fabric = Fabric.jar - Forge = Forge.jar - Vanilla = Vanilla.jar)"
            zenity --info --ellipsize --text="2. Execute o setup para decidir as informações do computador/servidor"
            zenity --info --ellipsize --text="3. Inicie o servidor escolhendo a opção $Start_Option"
    fi

    if [ "$Opcao" = "$About" ]
        then
            zenity --info --ellipsize --text="Feito por Rochedo - Tag do Discord: Rochedo#8898"
    fi
}

#Inicialização do Script
Setup_or_Start

#!/bin/bash

# Actualiza el sistema y los paquetes a la última versión
if ! sudo apt update; then
    echo "Error: no se pudo actualizar el sistema." >&2
    exit 1
fi

if ! sudo apt upgrade -y; then
    echo "Error: no se pudieron actualizar los paquetes." >&2
    exit 1
fi

# Instala los paquetes necesarios para compilar y construir software en Linux
if ! sudo apt-get install -y build-essential bc; then
    echo "Error: no se pudieron instalar los paquetes necesarios para compilar y construir software." >&2
    exit 1
fi

# Instala los encabezados del kernel de Linux y las herramientas necesarias para compilar los controladores del adaptador WiFi
if ! sudo apt-get install -y linux-headers-$(uname -r); then
    echo "Error: no se pudieron instalar los encabezados del kernel de Linux y las herramientas necesarias para compilar los controladores del adaptador WiFi." >&2
    exit 1
fi

# Remueve cualquier instancia del controlador del adaptador WiFi que ya esté cargada en el sistema.
sudo rmmod r8188eu.ko


# Clona el repositorio de GitHub donde se encuentra el código fuente del controlador del adaptador WiFi
git clone https://github.com/aircrack-ng/rtl8188eus.git

# Cambia al directorio del código fuente del controlador
cd rtl8188eus

# Agrega dos líneas al archivo de configuración de modprobe que impiden que se cargue automáticamente el controlador del adaptador WiFi que viene con el kernel de Linux

echo "blacklist r8188eu" | sudo tee -a /etc/modprobe.d/blacklist.conf
echo "blacklist r8188eu.ko" | sudo tee -a /etc/modprobe.d/blacklist.conf

# Compila el código fuente del controlador
make

# Instala el controlador compilado
sudo make install

# Carga el controlador del adaptador WiFi en el kernel de Linux
sudo modprobe 8188eu

# Limpia los archivos temporales y de compilación
make clean

# Informa al usuario que la instalación ha finalizado con éxito
echo "La instalación del controlador del adaptador WiFi ha finalizado con éxito."

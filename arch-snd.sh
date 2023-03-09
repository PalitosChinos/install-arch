#!/bin/bash

ln -s /usr/share/zoneinfo/America/Argentina/Buenos_Aires /etc/localtime
# hwclock --systohc --utc
hwclock --systohc
# hwclock --show

echo -n ">>> Ingrese el nombre del host: "
read -s host_name
echo $host_name
echo $host_name > /etc/hostname
echo -n ">>> Ingrese la contraseña para el host: "
passwd 

echo -n ">>> Instalando sudo packages"
pacman -Sy sudo

echo -n ">>> Ingrese el nombre del usuario: "
read -s usr_name
echo $usr_name

# useradd -m -G storage,power,wheel -s /bin/bash $usr_name
useradd --create-home --groups wheel $usr_name

sed -i 's/# %wheel ALL=(ALL=ALL) ALL/%wheel ALL=(ALL=ALL) ALL/' /etc/sudoers
sed -i 's/# %sudo ALL=(ALL) ALL/%sudo ALL=(ALL) ALL/' /etc/sudoers
# sed -i 's/root ALL=(ALL) ALL/root ALL=(ALL) ALL\n$usr_name ALL=(ALL) ALL/' /etc/sudoers

echo -n ">>> Ingrese la contraseña para del usuario: "
passwd $usr_name

echo "LANG=es_AR.UTF-8" > /etc/locale.conf
echo "KEYMAP=es" > /etc/vconsole.conf
locale-gen

echo $host_name > /etc/hostname
echo -e "127.0.0.1\tlocalhost" > /etc/hosts
echo -e "::1\t\tlocalhost" >> /etc/hosts
echo -e "127.0.1.1\t$host_name.$usr_name $host_name" >> /etc/hosts
cat /etc/hosts

sed -i 's/#es_AR ISO-8859-1/es_AR ISO-8859-1/' /etc/locale.gen
# sed -i 's/#es_AR.UTF-8 UTF-8/es_AR.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

mkinitcpio -p linux

# echo -n "Ingrese el nombre de la etiqueta de la instalacion en para el bootloader: "
# read -s id_name
# echo $id_name

# pacman -S grub
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB

grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable dhcpcd

echo -n ">>> bye bye\n"

exit
# umount -R /mnt
# swapoff -a
# reboot

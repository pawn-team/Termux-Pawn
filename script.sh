mkdir uniquefolder
cd uniquefolder/
wget https://github.com/pawn-team/Termux-Pawn/raw/refs/heads/DeviceWhite/release.zip
unzip release.zip
rm release.zip
chmod +x *
mv pawn* /data/data/com.termux/files/usr/bin
mv libpawnc.a /data/data/com.termux/files/usr/lib
cd /data/data/com.termux/files/home
echo "Instalado! tente usar os comandos!"

#!/usr/bin/env bash
set -ex
mkdir -p /opt/ankama-launcher
cd /opt/ankama-launcher
wget 'https://launcher.cdn.ankama.com/installers/production/Ankama%20Launcher-Setup-x86_64.AppImage'
chmod +x 'Ankama Launcher-Setup-x86_64.AppImage'
./'Ankama Launcher-Setup-x86_64.AppImage' --appimage-extract
rm 'Ankama Launcher-Setup-x86_64.AppImage'
chown  -R 1000:1000 /opt/ankama-launcher

cat >/opt/ankama-launcher/squashfs-root/launcher <<EOL
#!/usr/bin/env bash
export APPDIR=/opt/ankama-launcher/squashfs-root/
/opt/ankama-launcher/squashfs-root/AppRun --no-sandbox "$@"
EOL

chmod +x /opt/ankama-launcher/squashfs-root/launcher

ed -i 's@^Exec=.*@Exec=/opt/ankama-launcher/squashfs-root/launcher@g' /opt/ankama-launcher/squashfs-root/zaap.desktop
sed -i 's@^Icon=.*@Icon=/opt/ankama-launcher/squashfs-root/zaap.png@g' /opt/ankama-launcher/squashfs-root/zaap.desktop
cp /opt/ankama-launcher/squashfs-root/zaap.desktop  $HOME/Desktop
cp /opt/ankama-launcher/squashfs-root/zaap.desktop /usr/share/applications/
chmod +x $HOME/Desktop/zaap.desktop
chmod +x /usr/share/applications/zaap.desktop

# Pawn Compiler for Termux
> Method by DeviceBlack and BeerlID

# Requisitos
- Android 7+ (Testado com: armv7, armv8 e aarch64)
- [Termux:App_v118.0 from F-Droid](https://f-droid.org/repo/com.termux_118.apk)

## Como Instalar?
Siga os passos abaixo.

### Configurando
atualizar os repositórios e permitir acesso a memória interna.
```sh
yes | pkg update -y && yes | pkg upgrade -y
termux-setup-storage
```

### Instalando
armazenar o arquivo virtual em cache e executa-lo.
```sh
curl https://raw.githubusercontent.com/Device-Black/Termux-Pawn/DeviceBlack/install.sh | sh
```

## Como Desinstalar?
Siga os passos abaixo.

### Desinstalando
remover os arquivos do compilador.
```sh
rm $PATH/pawn* && rm $PREFIX/lib/libpawnc.so && exit
```

# Termux-Pawn

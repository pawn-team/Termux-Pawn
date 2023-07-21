# Pawn Compiler for Termux
## Method by DeviceBlack and BeerlID

### 1- Passo
permitir acesso a memória interna e atualizar os repositórios
```bsh
yes | pkg upd -y && yes | pkg upg -y
termux-setup-storage
```

## 2- Passo
clonar esse repositorio e construír o compilador
```bsh
pkg i git -y
git clone https://github.com/device-black/termux-pawn
mv termux-pawn/pawn-lang /sdcard/
pkg i x11-repo tur-repo -y
pkg upd -y && pkg upg -y
pkg i gcc-9 make cmake -y
pkg uninstall clang -y
git clone https://github.com/pawn-lang/compiler
mkdir -p build && cd build && cmake ../compiler/source/compiler -DCMAKE_C_FLAGS=-mbe32 -DCMAKE_C_COMPILER="/data/data/com.termux/files/usr/bin/gcc-9" -DCMAKE_BUILD_TYPE=Release && make && mv pawn* ~/..usr/bin && mv lib* ~/../usr/lib
cd $HOME && rm -rf termux-pawn build compiler
clear
echo -e "\033[32mCompilador instalado com sucesso!"
echo -e "\n\033[0m1: Observe que há uma pasta chamada \033[33m\"pawn-lang\" \033[0mna memoria interna!"
echo -e "\033[0m2: Utilize \033[33mcd /sdcard/pawn-lang \033[0mpara navegar para essa pasta!"
echo -e "\033[0m3: Utilize \033[33mpawncc <arquivo.pwn> \033[0mpara compilar um novo script!"
echo -e "\n\033[32mExemplo de Uso:\n\033[0mcd /sdcard/pawn-lang\n\033[0mpawncc gamemodes/new.pwn"
```

## Baixe aqui o Termux, e SEJA FELIZ 😁
[Termux:App](https://f-droid.org/repo/com.termux_118.apk)
# Termux-Pawn

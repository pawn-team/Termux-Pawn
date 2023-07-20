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
pkg i x11-repo tur-repo -y && pkg upd -y && pkg upg -y
pkg i gcc-9 make cmake -y

```

## Seja feliz 😁
# Termux-Pawn

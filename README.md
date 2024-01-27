# Pawn Compiler for Termux
> Method by DeviceWhite and BeerlID

# Requisitos
- Android 7+ (Testado com: armv7, armv8 e aarch64)
- [Termux:App_v118.0 from F-Droid](https://f-droid.org/repo/com.termux_118.apk)

## Como Instalar?
Siga os passos abaixo.

### Configurando
atualizar os repositórios e permitir acesso a memória interna.
```sh
yes | pkg update -y && yes | pkg upgrade -y && termux-setup-storage
```

### Instalando
armazenar o arquivo virtual em cache e executa-lo.
```sh
curl -s https://raw.githubusercontent.com/Device-Black/Termux-Pawn/DeviceBlack/install.sh -o install.sh
bash install.sh
```

## Como Desinstalar?
Siga os passos abaixo.

### Desinstalando
remover os arquivos do compilador.
```sh
rm $PREFIX/bin/pawn* && rm $PREFIX/lib/libpawnc.so && exit
```

# Termux-Pawn

### Português

**Instruções de Instalação:**

Para instalar o compilador Pawn no Termux, execute o seguinte comando no terminal:

```bash
curl https://raw.githubusercontent.com/pawn-team/Termux-Pawn/DeviceBlack/quick-install.sh -s -o quick-install.sh && bash quick-install.sh
```

| Features | armhf | armv7l | armv8l | aarch64 |
| -------- | ----- | ------ | ------ | ------- |
| compilador | sim | sim | sim | sim |

**Créditos:**
- Criador: CompuPhase
- Versão 3.X.X: Zeex
- Portador para Termux: DeviceWhite

---

### English

**Installation Instructions:**

To install the Pawn compiler on Termux, run the following command in the terminal:

```bash
curl https://raw.githubusercontent.com/pawn-team/Termux-Pawn/DeviceBlack/quick-install.sh -s -o quick-install.sh && bash quick-install.sh
```

**Credits:**
- Creator: CompuPhase
- Version 3.X.X: Zeex
- Port to Termux: DeviceWhite

---
**Note:** Feel free to customize the titles or content as needed.
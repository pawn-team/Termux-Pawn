# Pawn Compiler for Termux
> [!Note]
> Method by DeviceWhite and BeerlID
> Updated on: 2024/02/11 02:43:37 BRT

### Português

**Instruções de Instalação:**

Para instalar o compilador Pawn no Termux, execute o seguinte comando no terminal:

```bash
# Atualizar os pacotes atuais e instalar novos pacotes
yes | pkg upd -y && yes | pkg upg -y
pkg i -y wget git

# Baixar o script de instalaçao rapida
wget https://raw.githubusercontent.com/pawn-team/Termux-Pawn/DeviceWhite/quick-install.sh

# Executar o script e instalaar o compilador
bash quick-install.sh ptBR
```

| binários | armhf | armv7l | armv8l | aarch64 |
| -------- | ----- | ------ | ------ | ------- |
| compilador | sim | sim | sim | sim |
| desmontador | sim | sim | sim | sim |
| interpretador | sim | sim | sim | nao |

**Créditos:**
- Criador: CompuPhase
- Versão Usada: Zeex 3.10.10
- Portado Por: DeviceWhite e BeerlID


> [!Warning]
> [Instale o Termux aqui](https://f-droid.org/repo/com.termux_118.apk) <br/>

**Tutorial em Video (Atualizado):**
[![Video Tutorial](https://i.ibb.co/tqVTpq5/20240130-193938.jpg)](https://youtu.be/DzKnOgNabJ4 "Termux Pawn: Compilador traduzido em PTBR!")

---

### English

**Installation Instructions:**

To install the Pawn compiler on Termux, run the following command in the terminal:

```bash
# Update current packages and install new packages
yes | pkg upd -y && yes | pkg upg -y && pkg i -y wget git

# Download the quick installation script
wget https://raw.githubusercontent.com/pawn-team/Termux-Pawn/DeviceWhite/quick-install.sh

# Run the script and install the compiler
bash quick-install.sh enUS
```

| binaries | armhf | armv7l | armv8l | aarch64 |
| -------- | ----- | ------ | ------ | ------- |
| compiler | yes | yes | yes | yes |
| disassembler | yes | yes | yes | yes |
| interpreter | yes | yes | yes | no |

**Credits:**
- Creator: CompuPhase
- Used version: Zeex 3.10.10
- Ported By: DeviceWhite & BeerlID


> [!Warning]
> [Install Termux here](https://f-droid.org/repo/com.termux_118.apk) <br/>

---

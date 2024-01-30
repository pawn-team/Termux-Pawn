# Pawn Compiler for Termux
> Method by DeviceWhite and BeerlID

### Português

**Instruções de Instalação:**

Para instalar o compilador Pawn no Termux, execute o seguinte comando no terminal:

```bash
curl https://raw.githubusercontent.com/pawn-team/Termux-Pawn/DeviceWhite/quick-install.sh -s -o quick-install.sh && bash quick-install.sh && rm quick-install.sh
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
> Antes de instalar o compilador, certifique-se de atualizar os pacotes:

```bash
yes | pkg upd -y && yes | pkg upg -y
```

**Tutorial em Video:**
[![Video Tutorial](https://i.ibb.co/tqVTpq5/20240130-193938.jpg)](http://www.youtube.com/watch?v=GKRI3ec9z2Y "Termux Pawn: Compilador traduzido em PTBR!")

---

### English

**Installation Instructions:**

To install the Pawn compiler on Termux, run the following command in the terminal:

```bash
curl https://raw.githubusercontent.com/pawn-team/Termux-Pawn/DeviceWhite/quick-install.sh -s -o quick-install.sh && bash quick-install.sh && rm quick-install.sh
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
> Before installing the compiler, be sure to update the packages:
>
> ```bash
>  yes | pkg upd -y && yes | pkg upg -y
> ```

---
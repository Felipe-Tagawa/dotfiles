# Documentação da Configuração de Dotfiles

Este documento descreve a configuração de dotfiles do usuário, gerenciada através do **GNU Stow** para facilitar a sincronização e manutenção de arquivos de configuração em diferentes sistemas.

## 📁 Estrutura de Diretórios

```
dotfiles/
├── autostart/          # Aplicativos que iniciam automaticamente
├── bash/               # Configurações do Bash
├── fonts/              # Fontes personalizadas
├── git/                # Configurações do Git
├── gtk-3.0/            # Configurações do GTK3
├── icons/              # Ícones personalizados
├── kitty/              # Configurações do terminal Kitty
├── meta/               # Metadados e listas de pacotes
├── nvim/               # Configurações do Neovim
├── scripts/            # Scripts utilitários
├── system/             # Configurações do sistema
├── Wallpaper/          # Papéis de parede
├── .icons/             # Ícones do sistema
├── .themes/            # Temas do sistema
└── bootstrap-fedora.sh          # Script de instalação automatizada
```

## 🔧 Módulos Configurados

### 1. **bash**
- **Arquivo principal**: `.bashrc`
- **Descrição**: Configurações do shell Bash, incluindo aliases, funções e variáveis de ambiente

### 2. **git**
- **Arquivos**: `.gitconfig`, `.gitignore`
- **Descrição**: Configurações globais do Git
- **Configurações atuais**:
  - Branch padrão: `main`
  - Usuário: Felipe Tagawa
  - Email: felipereisbkp@gmail.com

### 4. **kitty**
- **Descrição**: Configurações do terminal moderno Kitty
- **Caminho**: `.config/kitty/`

### 5. **nvim**
- **Descrição**: Configurações do editor Neovim
- **Caminho**: `.config/nvim/`

### 6. **system**
- **Arquivo**: `.profile`
- **Descrição**: Configurações de perfil do sistema

### 7. **autostart**
- **Descrição**: Aplicativos configurados para iniciar automaticamente
- **Caminho**: `.config/autostart/`

### 8. **fonts**
- **Descrição**: Fontes personalizadas do usuário
- **Caminho**: `.local/share/fonts/`

### 9. **icons**
- **Descrição**: Ícones personalizados do usuário
- **Caminho**: `.local/share/icons/`

### 10. **gtk-3.0**
- **Descrição**: Configurações do ambiente GTK3
- **Caminho**: `.config/gtk-3.0/`

### 11. **scripts**
- **Descrição**: Scripts utilitários pessoais
- **Caminho**: `.local/bin/`

### 12. **meta**
- **Arquivo**: `packages.txt`
- **Descrição**: Lista de pacotes instalados no sistema para replicação

## 📦 GNU Stow

O **GNU Stow** é um gerenciador de symlink que facilita o gerenciamento de dotfiles. Ele cria links simbólicos dos arquivos dentro dos diretórios do dotfiles para os locais apropriados no home do usuário.

### Como o Stow Funciona

1. **Estrutura de diretórios**: Cada subdiretório em `dotfiles/` representa um pacote
2. **Criação de symlinks**: O Stow cria links simbólicos mantendo a estrutura de diretórios
3. **Gerenciamento fácil**: Permite adicionar/remover configurações sem afetar os arquivos originais

### Exemplo de Funcionamento

```
dotfiles/bash/.bashrc → ~/.bashrc
dotfiles/git/.gitconfig → ~/.gitconfig
dotfiles/kitty/.config/kitty/kitty.conf → ~/.config/kitty/kitty.conf
```

## 🚀 Instalação e Uso

### Instalação Automatizada

O script `install.sh` automatiza todo o processo de configuração:

```bash
cd ~/dotfiles
./install.sh
```

### O que o script faz:

1. **Verifica o Stow**: Instala o GNU Stow se não estiver presente
2. **Navega para o diretório**: Move-se para o diretório do dotfiles
3. **Processa os módulos**: Para cada módulo na lista:
   - Verifica se o diretório existe
   - Executa `stow -R -t "$HOME" "$module"` para criar/atualizar os symlinks
4. **Aplica configurações**: Carrega configurações do dconf para o Cinnamon

### Módulos gerenciados pelo script:

- `bash` - Configurações do shell
- `autostart` - Aplicativos de inicialização automática
- `cinnamon` - Ambiente desktop
- `fonts` - Fontes personalizadas
- `git` - Controle de versão
- `gtk-3.0` - Interface GTK3
- `icons` - Ícones personalizados
- `kitty` - Terminal moderno
- `meta` - Metadados do sistema
- `nvim` - Editor Neovim
- `scripts` - Scripts utilitários
- `system` - Configurações do sistema
- `Wallpaper` - Papéis de parede

### Uso Manual do Stow

#### Instalar um módulo específico:
```bash
cd ~/dotfiles
stow -t ~ bash
```

#### Reinstalar um módulo (atualizar symlinks):
```bash
stow -R -t ~ bash
```

#### Remover um módulo:
```bash
stow -D -t ~ bash
```

#### Verificar o que seria instalado (modo seco):
```bash
stow -n -t ~ bash
```

## 🛠️ Manutenção

### Adicionar nova configuração

1. **Crie o diretório do módulo** (se não existir):
```bash
mkdir -p ~/dotfiles/novo-modulo
```

2. **Copie o arquivo de configuração** mantendo a estrutura:
```bash
# Para arquivos no home
cp ~/.config/arquivo.conf ~/dotfiles/novo-modulo/.config/arquivo.conf

# Para arquivos diretamente no home
cp ~/.arquivo ~/dotfiles/novo-modulo/.arquivo
```

3. **Adicione o módulo ao install.sh** (se desejar automação):
```bash
modules=("bash" "autostart" "novo-modulo" ...)
```

4. **Aplique com Stow**:
```bash
cd ~/dotfiles
stow -R -t ~ novo-modulo
```

### Sincronizar com Git

```bash
cd ~/dotfiles
git add .
git commit -m "Adiciona nova configuração"
git push
```

### Restaurar em nova máquina

```bash
# Clone o repositório
git clone <seu-repo> ~/dotfiles
cd ~/dotfiles

# Execute o script de instalação
./install.sh
```

## 📋 Lista de Pacotes

O arquivo `meta/packages.txt` contém uma lista completa de pacotes instalados no sistema, útil para:

- Replicar a configuração em novas instalações
- Documentar o software utilizado
- Facilitar a reinstalação do sistema

### Instalar pacotes a partir da lista:

```bash
sudo xargs -a ~/dotfiles/meta/packages.txt apt install
```

## 🔍 Estrutura de Links Simbólicos

Após a instalação, os seguintes links simbólicos são criados no diretório home:

```bash
~/.bashrc → dotfiles/bash/.bashrc
~/.gitconfig → dotfiles/git/.gitconfig
~/.gitignore → dotfiles/git/.gitignore
~/.profile → dotfiles/system/.profile
~/.config/kitty → dotfiles/kitty/.config/kitty
~/.config/nvim → dotfiles/nvim/.config/nvim
~/.config/autostart → dotfiles/autostart/.config/autostart
~/.local/share/fonts → dotfiles/fonts/.local/share/fonts
~/.local/share/icons → dotfiles/icons/.local/share/icons
~/.local/bin → dotfiles/scripts/.local/bin
~/.config/gtk-3.0 → dotfiles/gtk-3.0/.config/gtk-3.0
```

## ⚙️ Configurações Específicas

### Cinnamon Desktop
- **Arquivo de configuração**: `dconf-settings.ini`
- **Aplicação automática**: O script carrega as configurações após criar os symlinks
- **Componentes**: Applets, desklets, extensões, temas e papéis de parede

### Git
- **Branch padrão**: `main`
- **Usuário configurado**: Felipe Tagawa
- **Email**: felipereisbkp@gmail.com

### Terminal Kitty
- **Configurações**: Armazenadas em `.config/kitty/`
- **Backup**: Existe um arquivo `kitty.conf.bak` como referência

## 🎯 Benefícios desta Abordagem

1. **Versionamento**: Todas as configurações são versionadas via Git
2. **Portabilidade**: Fácil replicação em diferentes máquinas
3. **Organização**: Configurações separadas por módulo/funcionalidade
4. **Segurança**: Arquivos originais permanecem no diretório dotfiles
5. **Flexibilidade**: Possível habilitar/desabilitar módulos individualmente
6. **Backup**: Configurações backup automaticamente no Git

## 📝 Notas Importantes

- O script de instalação requer permissões de superusuário para instalar o Stow se necessário
- Algumas configurações podem exigir logout/login ou reinicialização para serem aplicadas
- O arquivo `dconf-settings.ini` do Cinnamon é aplicado automaticamente pelo script
- Certifique-se de não ter conflitos de arquivos antes de executar a instalação
- É recomendável fazer backup das configurações atuais antes da primeira instalação

## 🔗 Recursos Adicionais

- **GNU Stow Documentation**: https://www.gnu.org/software/stow/manual/
- **Cinnamon Spices**: https://cinnamon-spices.linuxmint.com/
- **Kitty Terminal**: https://sw.kovidgoyal.net/kitty/
- **Neovim**: https://neovim.io/

---

**Última atualização**: Maio 2026  
**Versão**: 1.0  
**Mantenedor**: Felipe Tagawa

# Documentação da Configuração de Dotfiles

Este documento descreve a arquitetura, modularização e manutenção dos **dotfiles** do usuário, adaptados para o **Fedora 44 Workstation** sob o servidor de exibição **Wayland** e compositor **Hyprland 0.56+** (arquitetura nativa em **Lua**).

O gerenciamento de links simbólicos é realizado de forma idempotente e declarativa através do **GNU Stow**.

---

## 📁 Estrutura de Diretórios

```text
dotfiles/
├── bash/               # Shell Bash modular (.bashrc e .bashrc.d/)
│   ├── .bashrc
│   └── .bashrc.d/
│       ├── 00-env.sh          # Variáveis de ambiente, $PATH (Flutter, Cargo, etc.) e XDG
│       ├── 10-aliases.sh      # Atalhos do sistema e comandos rápidos
│       ├── 20-wayland.sh      # Flags Wayland e suporte a teclado
│       └── 30-integrations.sh # Miniconda, Oh-My-Posh, Brew, Antigravity CLI e Fastfetch
├── fastfetch/          # Informações do sistema moderno (.config/fastfetch/config.jsonc)
├── fonts/              # Fontes do usuário (.local/share/fonts/)
├── git/                # Configurações globais do Git (.gitconfig, .gitignore)
├── gtk-3.0/            # Configurações GTK3 (.config/gtk-3.0/)
├── gtk-4.0/            # Configurações GTK4 (.config/gtk-4.0/)
├── hyprland/           # Compositor Hyprland 0.56+ (arquitetura 100% Lua)
│   └── .config/hypr/
│       ├── hyprland.lua       # Ponto de entrada principal
│       ├── mocha.lua          # Paleta Catppuccin Mocha em Lua nativo
│       ├── conf/              # Submódulos especializados
│       │   ├── env.lua        # Variáveis de ambiente Wayland nativas
│       │   ├── input.lua      # Monitores, layout ABNT2/US, touchpad e gestos
│       │   ├── appearance.lua # Gaps, bordas, blur, sombras, animações Bezier
│       │   ├── rules.lua      # Regras de janelas e camadas (layers)
│       │   ├── keybinds.lua   # Atalhos de teclado, multimídia, brilho e binds de mouse
│       │   └── startup.lua    # Autostart de serviços e daemons (KF6 Polkit, etc.)
│       ├── scripts/           # Scripts de suporte ao ambiente Hyprland
│       │   ├── battery_notification.sh    # Monitor de nível crítico de bateria
│       │   ├── border-animate.sh          # Efeito degradê animado nas bordas ativas
│       │   ├── brightness_notification.sh # Controle de brilho com SwayOSD e fallback
│       │   ├── check_updates              # Checagem de atualizações com suporte a DNF5/DNF
│       │   ├── clipboard_clear.sh         # Limpeza do histórico do Cliphist
│       │   ├── clipboard_daemon.sh        # Daemon de captura de texto e imagem
│       │   ├── clipboard_history.sh       # Menu Rofi com previews de miniaturas de imagens
│       │   ├── lock.sh                    # Bloqueio de tela inteligente (hyprlock/gtklock/swaylock)
│       │   ├── lock-status.sh             # Helper de status de bateria e sessão para o Hyprlock
│       │   ├── shader-menu.sh             # Seletor interativo de shaders de tela (Vibrance, Zen, Night Light)
│       │   ├── theme-switcher.sh          # Orquestrador global de temas com transição circular (swww grow)
│       │   ├── toggle-projetor.sh         # Alternância estendido/espelhado via hl.monitor
│       │   ├── volume_notification.sh     # Notificações e controle de volume com SwayOSD e fallback
│       │   ├── wifi_disconnect.sh         # Desconexão rápida de rede Wi-Fi
│       │   ├── wifi_menu.sh               # Lançador do menu de rede Wi-Fi (Ronema)
│       │   ├── wifi_status.sh             # Exibição do status atual da conexão
│       │   └── wifi_toggle.sh             # Alternância de ativação do rádio Wi-Fi
│       ├── shaders/           # Shaders GLSL de pós-processamento (Hyprshade nativo)
│       │   ├── blue-light-filter.glsl     # Filtro noturno quente (3400K)
│       │   ├── crt.glsl                   # Scanlines retrô arcade
│       │   ├── grayscale.glsl             # Modo monocromático E-Ink Zen
│       │   ├── invert.glsl                # Inversão de cores
│       │   └── vibrance.glsl              # Boost dinâmico de cores e saturação
│       ├── current_theme.lua  # Cores do tema ativo persistidas para o Hyprland
│       ├── hypridle.conf      # Configuração de ociosidade e economia de energia
│       ├── hyprlock.conf      # Tela de bloqueio estilizada com frosted glass e Material You
│       ├── hyprlock-colors.conf # Paleta dinâmica gerada pelo Matugen para o Hyprlock
│       └── hyprpaper.conf     # Gerenciamento de wallpapers estáticos
├── icons/              # Ícones do usuário (.icons/)
├── kitty/              # Terminal Kitty (.config/kitty/)
├── matugen/            # Motor Material You para temas dinâmicos a partir de papéis de parede (.config/matugen/)
├── nvim/               # Neovim modular em Lua (.config/nvim/)
│   └── .config/nvim/
│       ├── init.lua
│       └── lua/config/
│           ├── options.lua    # Opções do editor (indentação, números relativos, clipboard)
│           ├── keymaps.lua    # Mapeamentos e atalhos (correção de cedilha, navegação)
│           ├── autocmds.lua   # Destaque de yank e restauração de posição do cursor
│           └── theme.lua      # Carregamento resiliente do tema Gruvbox/Catppuccin
├── rofi/               # Lançador de aplicativos e powermenu (.config/rofi/)
├── scripts/            # Scripts utilitários de usuário (.local/bin/)
├── system/             # Perfil do sistema (.profile) e MIME (.config/mimeapps.list)
├── themes/             # Temas GTK do sistema (.themes/)
├── Wallpaper/          # Papéis de parede organizados (.config e Pictures/Wallpapers/)
├── waybar/             # Barra de status modular com múltiplos temas (.config/waybar/)
├── wlogout/            # Menu de saída cinematográfico com blur e Material You (.config/wlogout/)
├── swaync/             # Central de controle e notificações moderna (.config/swaync/)
├── swayosd/            # OSD cinematográfico de volume/brilho estilizado com Material You (.config/swayosd/)
├── jarvis/             # Orquestrador agêntico autônomo e assistente de desktop com IA (.config/jarvis/)
├── bootstrap-fedora.sh # Instalação de dependências e configuração inicial no Fedora 44
└── install.sh          # Script idempotente para aplicação de symlinks com GNU Stow
```

---

## 🔧 Detalhamento dos Módulos

### 1. Hyprland 0.56+ (Arquitetura Nativa em Lua)

O Fedora 44 com Hyprland 0.56+ utiliza a **API nativa em Lua** (`hl.*`), substituindo completamente a sintaxe legada do Hyprlang baseada em arquivos `.conf`.

* **Carregamento modular**: O arquivo principal `hyprland.lua` atua como agregador limpo carregando a paleta de cores `mocha.lua` e os módulos sob o diretório `conf/`:
  * `conf/env.lua`: Configura o ecossistema Wayland puro (`GDK_BACKEND=wayland,x11,*`, `QT_QPA_PLATFORM=wayland;xcb`, `SDL_VIDEODRIVER=wayland`, `ELECTRON_OZONE_PLATFORM_HINT=wayland`) e tamanhos de cursor.
  * `conf/input.lua`: Configura teclado duplo (`br,us` com variantes `abnt2,intl`), parâmetros de touchpad (rolagem natural, tap-to-click), gestos de 3 dedos para alternância fluida de workspaces (`hl.gesture`) e regras de monitores para o monitor principal (eDP-1 a 144Hz), saída HDMI-A-1 e fallback dinâmico para novos monitores.
  * `conf/appearance.lua`: Bordas arredondadas (12px), gaps (interno 4px, externo 8px), paleta Catppuccin Mocha, blur dual-kawase otimizado, dimming sutil de janelas inativas (0.12), glow atmosférico estendido (range 22, render power 4) e física cinematográfica com curvas Bezier `md3_decel` e `md3_accel` (popin 82% nas janelas e slidefade 25% nas workspaces).
  * `conf/rules.lua`: Regras de janelas automáticas (modo flutuante para `pavucontrol`, `blueman-manager`, `nm-connection-editor`, `qalculate-gtk` e diálogos do `dolphin`; foco permanente para `steam`) e regras de blur para camadas (`waybar`, `rofi`, `swaync`).
  * `conf/keybinds.lua`: Atalhos de produtividade, gerenciamento de janelas Vim-style (`h/j/k/l`), atalhos de mídia com repetição (`repeating = true`, `locked = true`), captura de tela com `grim + slurp` e integração com a área de transferência.
  * `conf/startup.lua`: Inicialização dos serviços fundamentais: agente de autenticação Polkit do Fedora 44 KF6 (`/usr/libexec/kf6/polkit-kde-authentication-agent-1`), sincronização de variáveis com DBus/systemd, applets de bandeja (`nm-applet`, `blueman-applet`), daemons de wallpaper (`hyprpaper`), barra de status (`waybar`), daemon de clipboard em segundo plano e scripts de monitoramento.

### 2. Seletor Global de Temas e Material You Dinâmico (`swww grow` + `matugen`)

O script `~/.config/hypr/scripts/theme-switcher.sh` gerencia a troca simultânea e atômica de todo o ecossistema visual da área de trabalho:
* **Efeito Visual Circular**: Utiliza o motor `swww` com `--transition-type grow` e rastreamento dinâmico da posição do mouse (`hyprctl cursorpos | tr -d ' '` e `--invert-y`), fazendo com que o novo tema "exploda" suavemente em círculo a partir do cursor a 144Hz.
* **Componentes Sincronizados**:
  1. **Wallpaper**: Transição circular via `swww`.
  2. **Hyprland (Bordas e Sombras)**: Atualização ao vivo das cores das bordas ativas (degradê triplo rotativo), bordas inativas e sombras atmosféricas (`decoration.shadow.color` ativo e inativo) via `hyprctl eval` e persistência em `current_theme.lua`. O daemon `border-animate.sh` sincroniza dinamicamente as cores ativas rotacionando o degradê a cada ciclo.
  3. **Waybar**: Troca de tema via symlink `~/.config/waybar/current` (ou uso do `dynamic.css` no modo Material You) e recarregamento automático.
  4. **Kitty**: Atualização de `current-theme.conf` e sinal `pkill -SIGUSR1 kitty` para troca de cores ao vivo em todos os terminais abertos.
  5. **Rofi**: Atualização do symlink/cores em `colors/current.rasi` para que o menu de aplicativos e histórico de clipboard mudem de cor.
  6. **SwayNC**: Recarregamento automático ao vivo (`swaync-client -rs`) com paleta harmonizada para sliders de volume/brilho, DND e player MPRIS.
  7. **Spotify (Spicetify)**: Injeção de paleta dinâmica via template `color.ini` e atualização instantânea com `spicetify apply`.
  8. **GTK & Ícones**: Atualização instantânea via `gsettings`.
  9. **Neovim**: Registro do tema ativo em `current_theme.txt` para novas sessões do editor.
* **Modos de Operação**:
  * **Presets Prontos**: Catppuccin Mocha, Gruvbox Retro, Rose Pine Moon, Tokyo Night / Cyber, Minimal Zen, Dark Hunter.
  * **Material You Dinâmico (Matugen)**: Extrai harmonicamente as cores primárias, secundárias, superfície e acentos a partir de qualquer imagem selecionada, gerando na hora paletas personalizadas para Hyprland, Waybar, Kitty e Rofi.
* **Atalhos de Teclado**:
  * `SUPER + S`: Abre o menu interativo no Rofi para escolher qualquer tema (presets ou Material You).
  * `SUPER + ALT + S`: Cicla instantaneamente para o próximo preset da lista sem abrir menu.
  * `SUPER + T`: Abre a **Galeria Visual de Wallpapers** no Rofi (com grade de miniaturas 16:9 de alta definição geradas em cache e títulos elegantes); ao selecionar uma paisagem, dispara a explosão circular com `swww` e gera automaticamente o tema Material You correspondente.

### 3. Barra de Status Waybar

A configuração do Waybar é dinâmica e permite a troca de temas sem necessidade de reconfiguração manual:
* O script de inicialização `~/.config/waybar/start.sh` detecta o tema ativo através do link simbólico `~/.config/waybar/current`.
* O repositório inclui temas pré-configurados prontos para uso: `CatMat` (ativo por padrão), `MaterialYou` (com pílulas inteligentes que exibem workspaces ativas em evidência com gradiente vibrante, workspaces vazias discretas e compactas ao lado, relógio minimalista e paleta dinâmica gerada via Matugen), `Bocchi`, `Zen`, `MinimalCatppuccin`, `Omarchy`, `Pills`, entre outros.

### 4. Rofi (Lançador de Aplicativos e Menus)

O Rofi opera no Wayland gerenciando múltiplos menus do sistema:
* **Lançador principal**: Localizado em `~/.config/rofi/launchers/type-3/launcher.sh` e mapeado para o atalho `SUPER + D`.
* **Menu de Área de Transferência**: Integrado ao `cliphist` através do tema dedicado `~/.config/rofi/clipboard.rasi` (acionado via `SUPER + V`).
* **Powermenu**: Menus de desligamento, reinicialização e bloqueio em `~/.config/rofi/powermenu/`.

### 5. Neovim Modular (Lua)

Configuração leve, rápida e autocontida sob `~/.config/nvim/lua/config/`:
* `options.lua`: Indentação padronizada em 4 espaços, números relativos, histórico persistente de desfazer (`undofile`), integração nativa com o clipboard Wayland (`opt.clipboard = "unnamedplus"`).
* `keymaps.lua`: Tecla líder definida como `<Espaço>`, atalhos rápidos para salvar e fechar (`<leader>w`, `<leader>q`), movimentação entre divisões com `Ctrl + h/j/k/l`, indentação sem perda de seleção no modo visual e correção automática da cedilha (`ć` -> `ç`) para layouts internacionais.
* `autocmds.lua`: Feedback visual ao copiar texto (`yank`) e retorno automático à última linha editada ao reabrir arquivos.
* `theme.lua`: Carregamento defensivo com `pcall` do tema Gruvbox (contraste *hard*) com fallback inteligente para Catppuccin Mocha ou temas nativos caso o plugin não esteja presente.

### 6. JARVIS - Desktop AI Assistant & Orchestrator

O JARVIS é um orquestrador agêntico autônomo projetado para o Hyprland, acionado sob demanda pelo usuário:
* **Context Awareness (Hyprland IPC)**: Inspeciona a janela em foco (`hyprctl activewindow`) e descobre o diretório real do projeto ativo via `/proc/<pid>/cwd`.
* **Motor Híbrido Triplo**: Executa via `agy` (Google DeepMind) com raciocínio profundo, com fallback para `ollama` local (Llama 3.1) e API direta do Gemini.
* **Memória Persistente**: Carrega preferências e stacks do usuário a partir de `~/.config/jarvis/memory.json`.
* **Atalhos Globais**:
  * `SUPER + A`: Abre o **Jarvis Spotlight HUD** (tema `jarvis.rasi`) para perguntas livres ou seleção de ações.
  * `SUPER + SHIFT + A`: **Auto-Fix Instantâneo** — diagnostica erros ou tracebacks no clipboard e copia a solução.
  * `SUPER + CTRL + A`: **Pair-Programmer Scratchpad** — abre terminal flutuante do Kitty com o agente de IA posicionado na pasta do projeto ativo.
* **CLI Unificado**: Disponível globalmente no terminal através do comando `jarvis [menu|autofix|refactor|test|explain|pair|prompt]`.

### 7. Terminal Kitty

* Fonte principal: `JetBrains Mono` com suporte completo a ligaduras e ícones Nerd Font.
* Tema de cores: `Catppuccin-Mocha` com opacidade ajustada para 70% (`background_opacity 0.70`).
* Cursor em formato de barra (`beam`) e esquemas de seleção contrastantes.

### 7. Fastfetch Estilizado

Configurado em `fastfetch/.config/fastfetch/config.jsonc`, atua como gerador moderno e informativo das métricas do sistema estruturado em módulos coloridos (OS, Kernel, Uptime, Hyprland, Kitty, Shell, CPU, Memória com percentual e status de bateria) acompanhado de paleta em círculos de cor (`symbol: circle`).

### 8. Bash Modular (`.bashrc.d/`)

O arquivo `~/.bashrc` é mantido enxuto, carregando em sequência ordenada os submódulos da pasta `~/.bashrc.d/`:
* `00-env.sh`: Exporta caminhos para executáveis (`~/.local/bin`, `~/.cargo/bin`, `~/.nimble/bin`, `~/.spicetify`, Flutter SDK) e redireciona os arquivos de histórico (`bash`, `less`, `wget`) para os padrões do XDG State Directory.
* `10-aliases.sh`: Atalhos cotidianos (`ll`, `la`, `desligar`, `reiniciar`, `copiar`, `colar`, `alert`, `tablet`).
* `20-wayland.sh`: Garante que aplicações baseadas em Chromium/Electron e navegadores utilizem backend Wayland nativo.
* `30-integrations.sh`: Hooks e inicializadores para Miniconda, Linuxbrew, Antigravity CLI e Oh-My-Posh (com fallback elegante de prompt caso não esteja instalado).

### 9. GTK 3.0, GTK 4.0, Temas e Ícones

* Resolução completa dos symlinks via GNU Stow: `themes/.themes/` e `icons/.icons/`.
* Padronização em esquema escuro (`prefer-dark`), compatibilidade com decorações de janela e realce de seleção.

### 10. Menu de Saída e Bloqueio Cinematográfico (`wlogout`)

Configurado sob `wlogout/.config/wlogout/` e acionado pelo atalho `SUPER + X`:
* **Efeito Frosted Glass**: Integração com a camada `logout_dialog` do Hyprland com desfoque de fundo (`layer_rule blur`).
* **Botões em Cápsula Glassmorphism**: Layout estilizado com botões translúcidos (`border-radius: 26px`), sombras profundas e transição fluida com amortecimento cúbico ao passar o cursor (*hover scale*).
* **Sincronização com Material You**: Importa dinamicamente a folha de estilos de cores do tema ativo, reagindo com bordas e iluminação nas cores do papel de parede.

### 11. Central de Controle e Notificações Moderna (`SwayNC`)

Configurada em `swaync/.config/swaync/` e acionada por `SUPER + N` ou pelo ícone de sino na Waybar:
* **Widgets Integrados**:
  * Cabeçalho com botão para limpar todas as notificações.
  * Interruptor *Não Perturbe* (DND).
  * Widget de mídia MPRIS com capa do álbum/música e botões de reprodução.
  * Sliders táteis de volume e brilho com gradiente Material You.
  * Central com histórico persistente de notificações.
* **Estilização e Desfoque**: Painel translúcido em estilo *frosted glass* com bordas arredondadas e efeito blur da camada `swaync` no Hyprland.

### 12. Automações de Produtividade, Energia e IA

* **AI Scratchpad Flutuante (`SUPER + A`)**: Janela flutuante dedicada do Kitty configurada em `conf/rules.lua` (`class = ai-scratchpad`) executando o Antigravity CLI (`agy`) para assistência interativa instantânea.
* **Explicação de Clipboard com IA (`SUPER + SHIFT + A`)**: Script `ai_explain_clipboard.sh` que captura o texto ou erro no clipboard Wayland (`wl-paste`), consulta o modelo Gemini de forma sucinta e exibe o parecer/solução diretamente em uma notificação rica do SwayNC.
* **Conventional Commits com IA (`git-aicommit`)**: Utilitário em `~/.local/bin/git-aicommit` que analisa o `git diff --cached` e gera mensagens padronizadas de commit (`feat:`, `fix:`, `refactor:`) com confirmação interativa antes do commit.
* **Gestão Dinâmica de Energia (144Hz ↔ 60Hz)**: Daemon `battery_notification.sh` aprimorado que detecta transição de alimentação em tempo real:
  * **Na Bateria**: Alterna display `eDP-1` para 60Hz, define perfil econômico e notifica no SwayNC.
  * **Na Tomada AC**: Restaura display para 144Hz, ativa perfil de alta performance e notifica no SwayNC.
* **Manutenção Preventiva do Fedora (`fedora-maintenance.sh`)**: Script executado via Systemd User Timer (`fedora-maintenance.timer`) que limpa runtimes órfãos do Flatpak (`flatpak uninstall --unused`), esvazia pacotes em cache do DNF5 e executa a limpeza profilática de ServiceWorkers corrompidos do Microsoft Teams no Firefox.
* **Validação de Dotfiles e Hooks Git (`pre-push`)**: Hook em `dotfiles/.git/hooks/pre-push` que executa automaticamente o teste a seco do GNU Stow (`./install.sh -n`), impedindo o envio de configurações com symlinks quebrados ou inconsistentes.

---

## 🧹 Relatório de Inconsistências Corrigidas e Ferramentas Inutilizadas

Durante a auditoria completa do repositório, foram identificadas e saneadas ferramentas descontinuadas, inconsistências de dependências e redundâncias:

| Componente | Inconsistência / Ferramenta Inutilizada | Ação Corretiva Realizada |
| :--- | :--- | :--- |
| **Área de Transferência** | O `startup.lua` e o `rules.lua` referenciavam o `copyq`, mas ele não estava instalado nem é o padrão utilizado pelo ecossistema. | Removida a referência inútil ao `copyq`. A gestão de clipboard é 100% unificada no `cliphist` integrado ao Rofi. |
| **Daemon de Clipboard** | No script `clipboard_daemon.sh`, o primeiro watcher (`wl-paste --type text`) rodava de forma síncrona, travando a inicialização e impedindo o watcher de imagens de ser executado. | O script foi corrigido para executar ambos os processos em background (`&`) com proteção contra duplicatas via `pgrep`. |
| **Notificações** | O autostart chamava `swaync`, mas o daemon de notificação instalado pelo Fedora era o `dunst`. | O `startup.lua` foi atualizado para inicialização resiliente com fallback automático: utiliza `swaync` se disponível, caindo de volta para o `dunst`. |
| **Scripts de Notificação Legados** | Existiam scripts como `enable_notifications.sh` e a documentação `NOTIFICACOES.md` que tentavam habilitar unidades inexistentes de systemd (`battery-notification.service`, `disk-notification.service`). | Documentação atualizada e arquitetura corrigida para execução direta dos scripts em background através do autostart do Hyprland. |
| **Gerenciamento de Papéis de Parede** | Havia arquivos legados do `swww` (`hyprland/.config/swww/scripts/init-swww.sh`) e pacotes redundantes no bootstrap (`nitrogen`, `feh`, `swaybg`), enquanto o Hyprland utiliza exclusivamente o `hyprpaper`. | O `hyprpaper` foi estabelecido como ferramenta oficial de papel de parede. Os pacotes inúteis foram removidos do `bootstrap-fedora.sh`. |
| **Lançadores de Aplicativos** | O script de bootstrap instalava tanto o `wofi` quanto o `rofi`, criando redundância de ferramentas no sistema. | O `wofi` foi removido das dependências principais do script de bootstrap, mantendo o `rofi` como padrão. |
| **System Info** | Scripts utilitários (`abrir_drive.sh`) ainda invocavam a ferramenta descontinuada `nitch`. | Atualizado para utilizar o `fastfetch`, padrão moderno estabelecido nos dotfiles. |
| **Navegador Padrão & Remoção do Vivaldi** | Havia referências ao navegador descontinuado `vivaldi` em scripts auxiliares e falta de padronização do navegador padrão do sistema. | O `Firefox` foi oficializado como navegador exclusivo (`BROWSER="firefox"` no `00-env.sh`, `alias browser`, e scripts `abrir_drive.sh` e `abrir_teams.sh` atualizados). Todas as menções ao Vivaldi foram removidas. |
| **Microsoft Teams no Firefox (Crash de Cache)** | O Teams frequentemente entrava em loop de login ou tela branca devido à corrupção crônica do ServiceWorker CacheStorage e IndexedDB no Firefox. | O script `abrir_teams.sh` agora realiza a limpeza preventiva e transparente desses caches a cada inicialização (preservando cookies de login), e foi criado o alias `teams-clean` para manutenção direta. |
| **Atalho Super + V quebrando** | O atalho de histórico de clipboard quebrava por ausência do arquivo de tema (`clipboard.rasi`) e tentativa de repassar saída vazia ou truncada ao `cliphist decode`. | Criado o tema nativo `rofi/.config/rofi/clipboard.rasi` (Catppuccin Mocha) e o script `clipboard_history.sh` foi reescrito com checagem segura de seleção antes do decoding. |
| **Backup de Configuração do Kitty** | O arquivo `kitty.conf.bak` estava na raiz do módulo `kitty/`, fazendo com que o GNU Stow criasse um link `~/kitty.conf.bak` indesejado na home do usuário. | O arquivo de backup foi movido para dentro de `kitty/.config/kitty/` e o link órfão na raiz foi eliminado. |
| **Organização do Shell Bash** | O caminho do Flutter SDK estava inserido manualmente ao final de `.bashrc` em vez de seguir o padrão modular da pasta `.bashrc.d/`. | A variável foi movida para `bash/.bashrc.d/00-env.sh`, mantendo o `~/.bashrc` estritamente modular. |

---

## 🚀 Instalação e Uso com GNU Stow

O script `install.sh` é idempotente e automatiza a criação, atualização ou remoção dos links simbólicos:

```bash
cd ~/dotfiles
./install.sh -r
```

### Opções do instalador:
* `./install.sh -r` ou `./install.sh --restow` — Recria e atualiza os symlinks de todos os módulos (padrão).
* `./install.sh -d` ou `./install.sh --delete` — Remove os symlinks gerenciados pelo Stow.
* `./install.sh -n` ou `./install.sh --dry-run` — Simula a execução sem fazer alterações reais no disco.
* `./install.sh -m <modulo>` — Executa o processo apenas para um módulo específico (ex: `./install.sh -m hyprland`).

---

## 🔍 Comandos de Validação e Diagnóstico

* **Validar integridade da configuração do Hyprland**:
  ```bash
  Hyprland --verify-config
  ```
* **Recarregar a barra de status Waybar**:
  ```bash
  ~/.config/waybar/start.sh
  ```
* **Testar histórico de clipboard**:
  ```bash
  cliphist list | rofi -dmenu
  ```
* **Verificar atualizações do sistema**:
  ```bash
  ~/.config/hypr/scripts/check_updates
  ```

# Sistema de Notificações Hyprland

## Tema Rose-Pine-Moon configurado

As notificações agora usam o tema Rose-Pine-Moon com as cores:
- Background principal: `#232136`
- Background secundário: `#393552`
- Texto: `#e0def4`
- Destaques: `#c4a7e7`
- Alertas críticos: `#eb6f92`

## Scripts de Notificação Disponíveis

### 1. **Bateria Baixa** (`battery_notification.sh`)
- Avisa quando a bateria está em 20%, 10% e 5%
- Só avisa quando estiver descarregando
- Checa a cada 5 minutos

### 2. **Uso de Disco** (`disk_usage_notification.sh`)
- Avisa quando qualquer partição atingir 80% de uso
- Checa a cada hora

### 3. **Atualizações do Sistema** (`system_updates_notification.sh`)
- Avisa quando há atualizações disponíveis
- Funciona com Arch (checkupdates) e Debian/Ubuntu (apt-get)

### 4. **Volume** (`volume_notification.sh`)
- Notifica mudanças de volume com barra de progresso
- Integra com atalhos XF86Audio

### 5. **Brilho** (`brightness_notification.sh`)
- Notifica mudanças de brilho com barra de progresso
- Integra com atalhos XF86MonBrightness

## Como Ativar

### Opção 1: Usar Systemd (Recomendado)
```bash
~/.config/hypr/scripts/enable_notifications.sh
```

### Opção 2: Usar o Script de Inicializacao (Ja configurado no Hyprland)
Os scripts de bateria e disco já estão configurados para iniciar automaticamente.

### Opcao 3: Adicionar ao Crontab
```bash
# Adicionar ao crontab (crontab -e)
*/5 * * * * ~/.config/hypr/scripts/battery_notification.sh
0 * * * * ~/.config/hypr/scripts/system_updates_notification.sh
*/30 * * * * ~/.config/hypr/scripts/disk_usage_notification.sh
```

## Atalhos de Teclado Configurados

- `XF86AudioMute` - Mute/unmute com notificação
- `XF86AudioLowerVolume` - Diminuir volume com notificação
- `XF86AudioRaiseVolume` - Aumentar volume com notificação
- `XF86MonBrightnessDown` - Diminuir brilho com notificação
- `XF86MonBrightnessUp` - Aumentar brilho com notificação

## Testar Notificacoes

### Testar bateria manualmente:
```bash
notify-send -u critical "Bateria Crítica" "Bateria em 5%! Conecte o carregador imediatamente."
```

### Testar notificação normal:
```bash
notify-send -u normal "Teste" "Esta é uma notificação de teste normal."
```

### Testar notificação de baixa urgência:
```bash
notify-send -u low "Info" "Esta é uma notificação de baixa urgência."
```

## Arquivos Criados

1. `~/.config/dunst/dunstrc` - Configuração do Dunst com tema Rose-Pine-Moon
2. `~/.config/hypr/scripts/battery_notification.sh` - Notificações de bateria
3. `~/.config/hypr/scripts/disk_usage_notification.sh` - Notificações de disco
4. `~/.config/hypr/scripts/system_updates_notification.sh` - Notificações de atualizações
5. `~/.config/hypr/scripts/volume_notification.sh` - Notificações de volume
6. `~/.config/hypr/scripts/brightness_notification.sh` - Notificações de brilho
7. `~/.config/hypr/scripts/start_notifications.sh` - Inicializador de serviços
8. `~/.config/hypr/scripts/enable_notifications.sh` - Habilitar serviços systemd
9. `~/.config/systemd/user/battery-notification.service` - Serviço systemd de bateria
10. `~/.config/systemd/user/disk-notification.service` - Serviço systemd de disco

## Notas Importantes

- Para ver as mudanças no tema, recarregue o Dunst: `killall dunst && dunst &`
- Os scripts de bateria e disco rodam em loops infinitos
- As notificações de volume e brilho são ativadas pelos atalhos de teclado
- As notificações críticas não desaparecem automaticamente (timeout = 0)

## Personalizar Cores

Se quiser ajustar as cores, edite `~/.config/dunst/dunstrc`:
- `urgency_low` - Notificações de baixa importância
- `urgency_normal` - Notificações normais  
- `urgency_critical` - Alertas críticos

## Recarregar Configuracao

Para recarregar o Hyprland com as novas configurações:
```bash
hyprctl reload
```

Ou use o atalho: `$mod + Shift + R`
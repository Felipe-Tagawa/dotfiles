#!/bin/bash
# Script de emergência para restaurar arquivos do backup
# Uso: ./restore-from-backup.sh

BACKUP_DIR=~/cleanup-backup-20260502/

if [ ! -d "$BACKUP_DIR" ]; then
    echo "ERRO: Diretório de backup não encontrado: $BACKUP_DIR"
    exit 1
fi

echo "Iniciando restauração do backup..."
echo "Diretório de backup: $BACKUP_DIR"
echo "---"

# Remover links simbólicos e arquivos atuais
echo "1. Removendo links simbólicos e arquivos atuais..."
rm -f ~/.bash_history ~/.lesshst ~/.wget-hsts
rm -f ~/.xsession-errors ~/.xsession-errors.old
rm -f ~/.gtkrc-2.0 ~/.gtkrc-xfce ~/.XCompose
rm -f ~/.steampath

# Restaurar arquivos originais
echo "2. Restaurando arquivos originais..."
cp -p "$BACKUP_DIR/.bash_history" ~/
cp -p "$BACKUP_DIR/.lesshst" ~/
cp -p "$BACKUP_DIR/.wget-hsts" ~/
cp -p "$BACKUP_DIR/.xsession-errors" ~/
cp -p "$BACKUP_DIR/.xsession-errors.old" ~/
cp -p "$BACKUP_DIR/.gtkrc-2.0" ~/
cp -p "$BACKUP_DIR/.gtkrc-xfce" ~/
cp -p "$BACKUP_DIR/.XCompose" ~/

# Restaurar link do Steam
echo "3. Restaurando link do Steam..."
if [ -f "$BACKUP_DIR/steampath_link_info.txt" ]; then
    # O link original estava quebrado, então vamos deixar sem link
    echo "Link original do Steam estava quebrado, não será restaurado"
fi

# Remover configurações do .bashrc
echo "4. Removendo configurações do .bashrc..."
sed -i '/export HISTFILE=/d' ~/.bashrc
sed -i '/export LESSHISTFILE=/d' ~/.bashrc
sed -i '/export WGET_HSTS_FILE=/d' ~/.bashrc

# Remover script de limpeza e cron
echo "5. Removendo automação de limpeza..."
rm -f ~/.local/bin/cleanup-old-logs.sh
(crontab -l 2>/dev/null | grep -v "cleanup-old-logs") | crontab -

echo "---"
echo "Restauração concluída!"
echo "Por favor, recarregue seu shell: source ~/.bashrc"

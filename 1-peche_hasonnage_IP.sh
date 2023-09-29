#!/bin/bash

# Définition du fichier de log du jour
log_file="/var/log/attaques/fichier_de_log_$(date +%Y-%m-%d).txt"

# Exécution de la commande et enregistrement de la sortie dans le fichier de log
cat /var/log/fail2ban.log | awk '{print $8}' | uniq > "$log_file"

#!/bin/bash

# Définition du fichier de log du jour
log_file="/var/log/attaques/fichier_de_log_$(date +%Y-%m-%d).txt"

# Exécution de la commande et enregistrement de la sortie dans le fichier de log
cat /var/log/fail2ban.log | awk '{print $8}' | uniq > "$log_file"
root@vps-e051c992:~# cat 2-jeter-fillet-par-dessusbord.sh
#!/bin/bash

# Trouver le dernier fichier .txt généré dans /var/log/attaques/
DERNIER_FICHIER=$(ls -t /var/log/attaques/*.txt | head -n 1)

# Vérifier si un fichier a été trouvé
if [[ -z "$DERNIER_FICHIER" ]]; then
    echo "Aucun fichier .txt trouvé dans /var/log/attaques/"
    exit 1
fi

# Lire chaque ligne du fichier et bannir les adresses IP
while read -r IPABANNIR; do
    # Vérifier si l'adresse IP est valide (optionnel)
    if ! [[ $IPABANNIR =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "L'adresse IP $IPABANNIR dans le fichier $DERNIER_FICHIER n'est pas valide."
        continue
    fi

    # Ajouter la règle iptables pour bloquer l'adresse IP
    iptables -A INPUT -s $IPABANNIR -j DROP

    # Confirmer que la règle a été ajoutée
    echo "La règle iptables pour bloquer l'adresse IP $IPABANNIR a été ajoutée avec succès."

done < "$DERNIER_FICHIER"

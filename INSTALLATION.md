# Guide d'Installation OpenEtude

Ce guide détaille les différentes méthodes d'installation d'OpenEtude pour les études notariales marocaines.

## 📋 Table des Matières

1. [Prérequis](#prérequis)
2. [Installation avec Docker](#installation-avec-docker)
3. [Installation sur AWS Lightsail](#installation-sur-aws-lightsail)
4. [Installation sur VPS Standard](#installation-sur-vps-standard)
5. [Configuration PostgreSQL](#configuration-postgresql)
6. [Configuration de l'Application](#configuration-de-lapplication)
7. [Sécurisation de l'Installation](#sécurisation-de-linstallation)
8. [Maintenance et Sauvegardes](#maintenance-et-sauvegardes)
9. [Dépannage](#dépannage)

## Prérequis

### Configuration Minimale

#### Serveur VPS
- **CPU** : 2 vCPU
- **RAM** : 2 GB (4 GB recommandé pour production)
- **Stockage** : 20 GB SSD minimum
- **Bande passante** : 2 TB/mois minimum
- **OS** : Linux (Ubuntu 20.04 LTS / Ubuntu 22.04 LTS recommandé)

#### Logiciels
- **Java** : OpenJDK 7 ou supérieur
- **PostgreSQL** : Version 13.x ou supérieure
- **Apache Tomcat** : Version 7.x
- **Git** : Pour cloner le dépôt

### Configuration Recommandée pour Production

#### Serveur VPS
- **CPU** : 4 vCPU
- **RAM** : 8 GB
- **Stockage** : 50 GB SSD
- **OS** : Ubuntu 22.04 LTS

#### Base de Données
- **PostgreSQL Managé** : Lightsail Database ou AWS RDS
- **Stockage** : 20 GB minimum
- **Sauvegardes automatiques** : Activées

## Installation avec Docker

### Méthode la Plus Simple

Docker permet de déployer rapidement OpenEtude sans configuration complexe.

#### 1. Installation de Docker

**Sur Ubuntu/Debian :**
```bash
# Mise à jour du système
sudo apt update
sudo apt upgrade -y

# Installation de Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Ajouter l'utilisateur au groupe docker
sudo usermod -aG docker $USER

# Redémarrer la session ou exécuter
newgrp docker
```

**Vérifier l'installation :**
```bash
docker --version
docker run hello-world
```

#### 2. Installation de Docker Compose

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
```

#### 3. Cloner le Dépôt

```bash
git clone https://github.com/OpenEtude/Webapp.git
cd Webapp
```

#### 4. Configuration de l'Environnement

Créer un fichier `.env` à la racine du projet :

```bash
nano .env
```

Contenu du fichier `.env` :
```env
# Configuration de la base de données
RDS_DB_NAME=etude
RDS_USERNAME=etude
RDS_PASSWORD=MotDePasseSecurise123!
RDS_HOSTNAME=postgres
RDS_PORT=5432

# Configuration de l'application
JAVA_OPTS=-Xms512m -Xmx512m
```

⚠️ **Important** : Remplacez `MotDePasseSecurise123!` par un mot de passe fort.

#### 5. Lancer l'Application

**Pour le développement :**
```bash
docker-compose up -d
```

**Pour la production :**
```bash
docker-compose -f docker-compose-prod.yml up -d
```

#### 6. Vérifier le Déploiement

```bash
# Voir les logs
docker-compose logs -f

# Vérifier les conteneurs en cours d'exécution
docker-compose ps
```

L'application sera accessible sur `http://votre-serveur:8080`

#### 7. Premiers Pas

- **URL** : `http://localhost:8080` ou `http://votre-ip:8080`
- **Utilisateur par défaut** : (à configurer lors du premier démarrage)

## Installation sur AWS Lightsail

### Solution Recommandée pour la Production

AWS Lightsail offre le meilleur rapport qualité/prix pour déployer OpenEtude.

#### Avantages
- 💰 Coût prévisible et économique
- 🔐 PostgreSQL managé avec sauvegardes automatiques
- 🌐 IP statique incluse
- 📊 Monitoring intégré
- 🔄 Snapshots faciles
- 🚀 Déploiement rapide

### Étape 1 : Créer une Instance Lightsail

1. **Connexion à AWS Lightsail**
   - Aller sur https://lightsail.aws.amazon.com/
   - Se connecter avec votre compte AWS

2. **Créer une instance**
   - Cliquer sur "Create instance"
   - **Plateforme** : Linux/Unix
   - **Blueprint** : OS Only → Ubuntu 20.04 LTS
   - **Plan** : $10/mois (2 GB RAM, 1 vCPU, 60 GB SSD)
     - Pour production : $20/mois (4 GB RAM, 2 vCPU, 80 GB SSD)
   - **Nom** : `openetude-app`
   - Cliquer sur "Create instance"

3. **Attendre le démarrage** (2-3 minutes)

### Étape 2 : Créer une Base de Données PostgreSQL

1. **Dans Lightsail, aller dans "Databases"**
2. **Cliquer sur "Create database"**
   - **Blueprint** : PostgreSQL 13
   - **Plan** : $15/mois (Standard, 1 GB RAM, 40 GB SSD)
     - Pour production : $30/mois (2 GB RAM, 80 GB SSD)
   - **Nom** : `openetude-db`
   - **Master database name** : `etude`
   - **Master username** : `etude`
   - **Master password** : Générer ou saisir un mot de passe fort
   - ⚠️ **Noter les identifiants** dans un endroit sûr
3. **Cliquer sur "Create database"**
4. **Attendre la création** (5-10 minutes)

### Étape 3 : Configurer le Networking

1. **Aller dans votre instance `openetude-app`**
2. **Onglet "Networking"**
   - Ajouter une règle pour le port 8080 (temporaire)
   - Plus tard : configurer un reverse proxy nginx sur le port 80/443

3. **Créer une IP statique**
   - Dans la section "Networking" de l'instance
   - Cliquer sur "Create static IP"
   - Nom : `openetude-static-ip`
   - Attacher à l'instance `openetude-app`

### Étape 4 : Connexion et Configuration

1. **Se connecter via SSH**
   - Dans Lightsail, cliquer sur votre instance
   - Cliquer sur "Connect using SSH" (bouton orange)
   - Ou utiliser un client SSH avec la clé téléchargée

2. **Mise à jour du système**
```bash
sudo apt update
sudo apt upgrade -y
```

3. **Installation de Docker**
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ubuntu
```

4. **Installation de Docker Compose**
```bash
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

5. **Se déconnecter et reconnecter** pour appliquer les changements de groupe

### Étape 5 : Déploiement de l'Application

1. **Cloner le dépôt**
```bash
cd ~
git clone https://github.com/OpenEtude/Webapp.git
cd Webapp
```

2. **Configurer la connexion à la base de données**
```bash
nano .env
```

Contenu (remplacer par vos vraies valeurs) :
```env
RDS_DB_NAME=etude
RDS_USERNAME=etude
RDS_PASSWORD=VotreMotDePasseDatabase
RDS_HOSTNAME=ls-xxxxxxxxxxxxx.xxxxxxxxxx.us-east-1.rds.amazonaws.com
RDS_PORT=5432
```

Pour obtenir `RDS_HOSTNAME` :
- Dans Lightsail → Databases → openetude-db
- Copier l'"Endpoint" (ex: `ls-xxxxx...rds.amazonaws.com`)

3. **Construire l'application**
```bash
chmod +x build.sh
./build.sh
```

4. **Lancer avec Docker Compose**
```bash
docker-compose -f docker-compose-prod.yml up -d
```

5. **Vérifier les logs**
```bash
docker-compose logs -f
```

### Étape 6 : Accéder à l'Application

Votre application est maintenant accessible sur :
```
http://VOTRE-IP-STATIQUE:8080
```

## Installation sur VPS Standard

Pour un VPS chez un autre fournisseur (OVH, DigitalOcean, Linode, etc.)

### 1. Préparer le Serveur

```bash
# Connexion SSH
ssh root@votre-ip-vps

# Mise à jour
apt update && apt upgrade -y

# Installation des dépendances
apt install -y git curl wget openjdk-11-jdk postgresql postgresql-contrib
```

### 2. Configuration PostgreSQL

```bash
# Démarrer PostgreSQL
systemctl start postgresql
systemctl enable postgresql

# Créer l'utilisateur et la base de données
sudo -u postgres psql <<EOF
CREATE USER etude WITH PASSWORD 'MotDePasseSecurise123!';
CREATE DATABASE etude OWNER etude;
GRANT ALL PRIVILEGES ON DATABASE etude TO etude;
\q
EOF
```

### 3. Configuration PostgreSQL pour Accès Local

```bash
# Éditer pg_hba.conf
sudo nano /etc/postgresql/13/main/pg_hba.conf
```

Ajouter cette ligne :
```
local   etude           etude                                   md5
```

Redémarrer PostgreSQL :
```bash
sudo systemctl restart postgresql
```

### 4. Installation de Tomcat

```bash
# Créer un utilisateur tomcat
sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat

# Télécharger Tomcat 7
cd /tmp
wget https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.109/bin/apache-tomcat-7.0.109.tar.gz

# Extraire
sudo tar xzf apache-tomcat-7.0.109.tar.gz -C /opt/tomcat --strip-components=1

# Permissions
sudo chown -R tomcat: /opt/tomcat
sudo chmod +x /opt/tomcat/bin/*.sh
```

### 5. Déploiement de l'Application

```bash
# Cloner le dépôt
cd /home/openetude
git clone https://github.com/OpenEtude/Webapp.git
cd Webapp

# Configuration de la base de données
export RDS_DB_NAME=etude
export RDS_USERNAME=etude
export RDS_PASSWORD=MotDePasseSecurise123!
export RDS_HOSTNAME=localhost
export RDS_PORT=5432

# Construction (si Gradle est installé)
./gradlew war

# Copier le WAR vers Tomcat
sudo cp target/etude.war /opt/tomcat/webapps/ROOT.war

# Démarrer Tomcat
sudo /opt/tomcat/bin/startup.sh
```

### 6. Service Systemd pour Tomcat

Créer `/etc/systemd/system/tomcat.service` :

```bash
sudo nano /etc/systemd/system/tomcat.service
```

Contenu :
```ini
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64"
Environment="JAVA_OPTS=-Djava.awt.headless=true -Duser.language=fr -Duser.country=FR -Xms512m -Xmx512m"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512m -Xmx1024m -server -XX:+UseParallelGC"

Environment="RDS_DB_NAME=etude"
Environment="RDS_USERNAME=etude"
Environment="RDS_PASSWORD=MotDePasseSecurise123!"
Environment="RDS_HOSTNAME=localhost"
Environment="RDS_PORT=5432"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
```

Activer et démarrer :
```bash
sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat
sudo systemctl status tomcat
```

## Configuration PostgreSQL

### Optimisation pour OpenEtude

Éditer `/etc/postgresql/13/main/postgresql.conf` :

```bash
sudo nano /etc/postgresql/13/main/postgresql.conf
```

Paramètres recommandés pour 4GB RAM :
```ini
# Connexions
max_connections = 100

# Mémoire
shared_buffers = 1GB
effective_cache_size = 3GB
maintenance_work_mem = 256MB
work_mem = 10MB

# WAL
wal_buffers = 16MB
checkpoint_completion_target = 0.9

# Planificateur de requêtes
random_page_cost = 1.1
effective_io_concurrency = 200
```

Redémarrer PostgreSQL :
```bash
sudo systemctl restart postgresql
```

## Configuration de l'Application

### Variables d'Environnement

L'application utilise les variables d'environnement suivantes :

| Variable | Description | Défaut |
|----------|-------------|--------|
| `RDS_DB_NAME` | Nom de la base de données | `etude` |
| `RDS_USERNAME` | Utilisateur PostgreSQL | `etude` |
| `RDS_PASSWORD` | Mot de passe PostgreSQL | `etude` |
| `RDS_HOSTNAME` | Hôte PostgreSQL | `localhost` |
| `RDS_PORT` | Port PostgreSQL | `5432` |

### Configuration Avancée

Pour modifier d'autres paramètres, éditer :
- `grails-app/conf/DataSource.groovy` - Configuration de la base de données
- `grails-app/conf/Config.groovy` - Configuration générale

## Sécurisation de l'Installation

### 1. Firewall

**Avec UFW (Ubuntu) :**
```bash
# Installer UFW
sudo apt install ufw

# Autoriser SSH
sudo ufw allow 22/tcp

# Autoriser HTTP/HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Autoriser le port applicatif (si nécessaire)
sudo ufw allow 8080/tcp

# Activer le firewall
sudo ufw enable
sudo ufw status
```

### 2. SSL/TLS avec Nginx

```bash
# Installation de Nginx
sudo apt install nginx certbot python3-certbot-nginx

# Configuration du reverse proxy
sudo nano /etc/nginx/sites-available/openetude
```

Contenu :
```nginx
server {
    listen 80;
    server_name votre-domaine.ma;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Activer et obtenir un certificat SSL :
```bash
sudo ln -s /etc/nginx/sites-available/openetude /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

# Obtenir un certificat SSL gratuit
sudo certbot --nginx -d votre-domaine.ma
```

### 3. Sécurisation PostgreSQL

```bash
# Limiter l'accès à localhost uniquement
sudo nano /etc/postgresql/13/main/pg_hba.conf
```

S'assurer que seules ces lignes sont présentes :
```
local   all             postgres                                peer
local   etude           etude                                   md5
host    etude           etude           127.0.0.1/32            md5
```

### 4. Mises à Jour de Sécurité

```bash
# Configuration des mises à jour automatiques
sudo apt install unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

## Maintenance et Sauvegardes

### Sauvegardes PostgreSQL

#### Script de Sauvegarde Automatique

Créer `/home/openetude/backup-db.sh` :

```bash
#!/bin/bash

# Configuration
BACKUP_DIR="/home/openetude/backups"
DB_NAME="etude"
DB_USER="etude"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/etude_backup_$DATE.sql.gz"

# Créer le répertoire de sauvegarde
mkdir -p $BACKUP_DIR

# Exporter la variable d'environnement
export PGPASSWORD='MotDePasseSecurise123!'

# Sauvegarde
pg_dump -U $DB_USER -h localhost $DB_NAME | gzip > $BACKUP_FILE

# Nettoyage (garder les 30 derniers jours)
find $BACKUP_DIR -name "etude_backup_*.sql.gz" -mtime +30 -delete

echo "Sauvegarde terminée : $BACKUP_FILE"
```

Rendre exécutable :
```bash
chmod +x /home/openetude/backup-db.sh
```

#### Automatisation avec Cron

```bash
crontab -e
```

Ajouter :
```
# Sauvegarde quotidienne à 2h du matin
0 2 * * * /home/openetude/backup-db.sh >> /home/openetude/backup.log 2>&1
```

### Restauration d'une Sauvegarde

```bash
# Décompresser et restaurer
gunzip -c /home/openetude/backups/etude_backup_YYYYMMDD_HHMMSS.sql.gz | psql -U etude -d etude
```

### Monitoring

#### Vérifier l'État de l'Application

```bash
# Avec Docker
docker-compose ps
docker-compose logs --tail=50

# Avec Tomcat
sudo systemctl status tomcat
tail -f /opt/tomcat/logs/catalina.out
```

#### Monitoring des Ressources

```bash
# CPU et Mémoire
htop

# Espace disque
df -h

# PostgreSQL
sudo -u postgres psql -c "SELECT datname, numbackends FROM pg_stat_database;"
```

## Dépannage

### L'application ne démarre pas

**Vérifier les logs :**
```bash
# Docker
docker-compose logs

# Tomcat
tail -f /opt/tomcat/logs/catalina.out
```

**Erreurs communes :**
- Port 8080 déjà utilisé : `sudo lsof -i :8080`
- Mémoire insuffisante : augmenter `-Xmx` dans JAVA_OPTS
- Base de données inaccessible : vérifier les identifiants

### Erreur de connexion à PostgreSQL

**Tester la connexion :**
```bash
psql -U etude -h localhost -d etude
```

**Vérifier que PostgreSQL est démarré :**
```bash
sudo systemctl status postgresql
```

**Vérifier les logs :**
```bash
sudo tail -f /var/log/postgresql/postgresql-13-main.log
```

### Performance lente

1. **Vérifier les ressources** : `htop`, `free -h`
2. **Optimiser PostgreSQL** : voir section Configuration PostgreSQL
3. **Augmenter la mémoire Java** : modifier JAVA_OPTS
4. **Analyser les requêtes lentes** :
```sql
-- Dans PostgreSQL
SELECT * FROM pg_stat_statements ORDER BY total_time DESC LIMIT 10;
```

### Erreur "Out of Memory"

**Augmenter la mémoire allouée :**
```bash
# Dans .env ou dans les variables d'environnement
JAVA_OPTS=-Xms1024m -Xmx2048m
```

Redémarrer l'application.

## Support

Pour toute question ou problème d'installation :

➡️ **[Ouvrir une issue sur GitHub](https://github.com/OpenEtude/Webapp/issues)**

Inclure :
- Version du système d'exploitation
- Méthode d'installation utilisée
- Logs d'erreur complets
- Étapes pour reproduire le problème

---

**Bonne installation ! 🚀**

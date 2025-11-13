# OpenEtude - Solution de Gestion pour Études Notariales

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker Package](https://github.com/OpenEtude/Webapp/actions/workflows/main.yml/badge.svg)](https://github.com/OpenEtude/Webapp/actions/workflows/main.yml)

**OpenEtude** est une application web complète de gestion pour les études notariales marocaines. Développée avec Grails, elle offre une solution moderne et open source pour gérer les dossiers, clients, actes notariés, comptabilité et bien plus encore.

---

## 🎯 Public Cible

- **Notaires Marocains** : Solution clé en main pour la gestion quotidienne de votre étude
- **SSII Marocaines** : Plateforme open source pour intégration, personnalisation et support client

---

## ✨ Fonctionnalités Principales

### 📁 Gestion des Dossiers
- Création et suivi des dossiers notariés
- Organisation par opération et client
- Système de numérotation unique (format: numéro/année)
- Gestion de l'état (ouvert/clôturé)
- Support des modèles de dossiers réutilisables
- Recherche avancée et filtrage

### 👥 Gestion des Clients
- Fiche complète client (identité, coordonnées)
- Support des pièces d'identité
- Gestion des civilités
- Association aux opérations
- Historique des interactions

### 📜 Gestion des Actes Notariés
- Enregistrement des actes au répertoire
- Numérotation automatique
- Liaison aux dossiers
- Recherche par numéro de répertoire ou libellé
- Téléchargement et stockage de documents

### 💼 Gestion des Opérations
- Regroupement de dossiers par opération
- Suivi des biens immobiliers concernés
- Association client-opération
- Description et commentaires

### 🏘️ Gestion des Biens Immobiliers
- Catalogue des types de biens
- Fiches descriptives détaillées
- Association aux opérations et dossiers
- Gestion des valeurs et caractéristiques

### 💰 Comptabilité & Écritures
- Plan comptable complet
- Écritures comptables par dossier
- Gestion des débits/crédits
- Support des comptes bancaires
- Moyens de paiement variés
- Pièces comptables et justificatifs
- États et validation des écritures

### 🔐 Sécurité & Permissions
- Authentification utilisateur (JSecurity)
- Gestion des rôles et permissions granulaires
- Contrôle d'accès par fonction (CRUD)
- Journal d'activité (Activity log)

### 🛠️ Administration
- Gestion des utilisateurs
- Configuration des paramètres système
- Traductions et internationalisation
- Gestion des groupements comptables
- Import/Export de données

### 📊 Reporting
- Rapports détaillés sur les dossiers
- Synthèses comptables
- Exports Excel
- Calendrier et planification

---

## 📋 Prérequis Système

### Logiciels Requis
- **Java** : JDK 7 ou supérieur
- **PostgreSQL** : Version 13.x ou supérieure
- **Apache Tomcat** : Version 7.x
- **Grails** : Version 1.3.8

### Ressources Recommandées (VPS)
- **CPU** : 2 vCPUs minimum
- **RAM** : 4 GB recommandé (2 GB minimum)
- **Stockage** : 20 GB SSD minimum
- **OS** : Linux (Ubuntu 20.04+ / Debian 10+ recommandé)

---

## 🚀 Installation

### Option 1 : Installation avec Docker (Recommandée)

#### Étape 1 : Cloner le dépôt
```bash
git clone https://github.com/OpenEtude/Webapp.git
cd Webapp
```

#### Étape 2 : Configuration de l'environnement
Créer un fichier `.env` avec vos paramètres :
```env
RDS_DB_NAME=etude
RDS_USERNAME=etude
RDS_PASSWORD=votre_mot_de_passe_securise
RDS_HOSTNAME=localhost
RDS_PORT=5432
```

#### Étape 3 : Lancer avec Docker Compose
```bash
docker-compose up -d
```

L'application sera accessible sur `http://localhost:8080`

---

### Option 2 : Déploiement sur AWS Lightsail (Production)

AWS Lightsail est la **meilleure option** pour déployer OpenEtude en production.

#### ✅ Avantages AWS Lightsail
- Coût prévisible et économique
- PostgreSQL managé inclus
- Snapshots et sauvegardes automatiques
- Réseau privé sécurisé
- Support IPv6
- Interface simple et intuitive
- Certificats SSL gratuits et gérés automatiquement

#### 📦 Étapes de Déploiement

**1. Créer une instance Lightsail**
   - OS : Ubuntu 20.04 LTS
   - Plan recommandé : 4 GB RAM ($24/mois)

**2. Créer une base de données PostgreSQL managée**
   - Plan : Standard 1 GB ($15/mois)
   - Version : PostgreSQL 13.x
   - Noter les identifiants de connexion

**3. Configurer l'instance**

Connexion SSH à l'instance :
```bash
ssh ubuntu@votre-instance-lightsail
```

Installation de Docker :
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ubuntu
```

Installation de Docker Compose :
```bash
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

**4. Déployer l'application**
```bash
git clone https://github.com/OpenEtude/Webapp.git
cd Webapp

# Configurer les variables d'environnement
nano .env
# Renseigner les paramètres de connexion à la base PostgreSQL Lightsail

# Construction et démarrage
./build.sh
docker-compose -f docker-compose-prod.yml up -d
```

**5. Configuration réseau et sécurité**
   - Ouvrir les ports 80 et 443 dans le firewall Lightsail
   - Attacher une IP statique (gratuite si attachée)
   - Configurer un nom de domaine (optionnel)
   - Configurer SSL/HTTPS avec Let's Encrypt (automatique et gratuit)

---

## 💰 Coûts AWS Lightsail

*Novembre 2025*

### Infrastructure Mensuelle

| Composant | Spécifications | Prix |
|-----------|----------------|------|
| **Instance 4GB** | 4 GB RAM, 2 vCPUs, 80 GB SSD, 4 TB Transfer | $24/mois |
| **PostgreSQL Standard** | 1 GB RAM, 1 core, 40 GB SSD, 100 GB Transfer | $15/mois |
| **IP Statique** | Incluse (gratuite si attachée à l'instance) | Inclus |
| **Certificats SSL** | Let's Encrypt, renouvelé automatiquement | Gratuit |
| **Nom de domaine** | .com/.net ou .ma | $1.25-1.67/mois |

**Total mensuel : ~$40-41/mois**

### Coûts Annuels

| Scénario | Infrastructure |
|----------|---------------|
| **Avec .com/.net** | ~$483/an |
| **Avec .ma** | ~$488/an |


### Notes Importantes
- **IP Statique** : Gratuite tant qu'elle reste attachée à une instance active
- **SSL/HTTPS** : Certificats Let's Encrypt configurés et renouvelés automatiquement sans frais
- **IPv4** : Le coût de l'adresse IPv4 publique est inclus dans le prix de l'instance (depuis mai 2024)

---

### Option 3 : Installation Manuelle

#### 1. Installation de PostgreSQL
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo -u postgres createuser etude
sudo -u postgres createdb etude
sudo -u postgres psql -c "ALTER USER etude WITH PASSWORD 'votre_mot_de_passe';"
```

#### 2. Configuration de l'application
Modifier `grails-app/conf/DataSource.groovy` selon votre environnement.

#### 3. Construction
```bash
./gradlew war
```

#### 4. Déploiement
Copier le fichier `target/etude.war` dans le répertoire webapps de Tomcat.

---

## 🏗️ Architecture Technique

### Contrôleurs (26 au total)

#### Gestion des Entités Principales
- **DossierController** : CRUD dossiers, recherche, exports
- **ClientController** : Gestion clients, associations
- **ActeController** : Actes notariés, recherche par répertoire
- **OperationController** : Opérations commerciales/immobilières
- **BienController** : Biens immobiliers et caractéristiques

#### Comptabilité & Finance
- **CompteController** : Plan comptable
- **CompteBancaireController** : Comptes bancaires
- **EcritureController** : Écritures comptables globales
- **EcritureDossierController** : Écritures par dossier

#### Paramétrage
- **ParamController** : Paramètres système
- **SettingController** : Configuration application
- **TypeDeBienController** : Types de biens
- **TypeEcritureController** : Types d'écritures
- **GroupementController** : Groupements comptables

#### Sécurité & Administration
- **AuthController** : Authentification
- **JsecUserController** : Gestion utilisateurs
- **JsecRoleController** : Gestion rôles
- **AdminController** : Administration système

#### Utilitaires
- **HomeController** : Tableau de bord
- **CalendarController** : Calendrier
- **ActivityController** : Journal d'activité
- **TraductionController** : Traductions

### Modèles de Domaine (32 au total)

#### Entités Métier
Dossier • Client • Operation • Acte • Bien

#### Comptabilité
Compte • CompteBancaire • EcritureDossier • TypeEcriture • MoyenPaiement • EtatEcriture

#### Référentiels
TypeDeBien • Civilite • PieceIdentite • CategorieEcriture

#### Sécurité
JsecUser • JsecRole • JsecPermission • JsecUserPermissionRel • JsecRolePermissionRel

#### Système
Activity • Setting • Groupement

### Relations Entre Entités

```
Client --> Operation --> Dossier --> EcritureDossier
              |            |              |
              v            v              v
            Bien         Acte          Compte
```

---

## 🔧 Stack Technique

| Composant | Technologie |
|-----------|-------------|
| **Framework** | Grails 1.3.8 |
| **Langages** | Groovy, Java |
| **Base de données** | PostgreSQL 13+ |
| **ORM** | Hibernate |
| **Serveur** | Apache Tomcat 7 |
| **Frontend** | JavaScript, CSS3 |
| **Sécurité** | JSecurity |
| **Build** | Gradle |
| **Conteneurisation** | Docker |

Pour plus de détails, voir [techstack.md](./techstack.md)

---

## 📖 Documentation

| Document | Description |
|----------|-------------|
| [ARCHITECTURE.md](./ARCHITECTURE.md) | Architecture technique détaillée |
| [INSTALLATION.md](./INSTALLATION.md) | Guide d'installation complet |
| [SUPPORT.md](./SUPPORT.md) | Support et assistance |
| [CONTRIBUTING.md](./CONTRIBUTING.md) | Guide de contribution |

---

## 🤝 Support & Contribution

### Obtenir de l'aide

Pour toute question, problème ou demande de fonctionnalité :

➡️ **[Créer une issue sur GitHub](https://github.com/OpenEtude/Webapp/issues)**

**Avant de créer une issue :**
1. ✅ Vérifiez que le problème n'a pas déjà été signalé
2. 📝 Fournissez les informations suivantes :
   - Version de l'application
   - Environnement (OS, Java, PostgreSQL)
   - Logs d'erreur complets
   - Étapes pour reproduire le problème

### Contribuer au projet

Les contributions sont les bienvenues ! Consultez [CONTRIBUTING.md](./CONTRIBUTING.md) pour commencer.

---

## 📜 Licence

Ce projet est sous licence **MIT**. Voir [LICENSE](./LICENSE) pour plus de détails.

### Permissions
- ✅ Utilisation commerciale
- ✅ Modification
- ✅ Distribution
- ✅ Utilisation privée

### Conditions
- ℹ️ Fourni "tel quel", sans garantie
- ℹ️ Conservation de la notice de licence

---

## 🏆 Contributeurs

Merci à tous les contributeurs qui ont participé au développement d'OpenEtude !

---

## 🔗 Liens Utiles

- **GitHub** : [https://github.com/OpenEtude/Webapp](https://github.com/OpenEtude/Webapp)
- **Issues** : [https://github.com/OpenEtude/Webapp/issues](https://github.com/OpenEtude/Webapp/issues)
- **Releases** : [https://github.com/OpenEtude/Webapp/releases](https://github.com/OpenEtude/Webapp/releases)

---

**OpenEtude** - La solution open source pour notaires 2.0 🇲🇦

*Propulsé par la communauté open source marocaine*

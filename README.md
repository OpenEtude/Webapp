# OpenEtude - Solution de Gestion pour Études Notariales

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**OpenEtude** est une application web complète de gestion pour les études notariales marocaines. Développée avec Grails, elle offre une solution moderne pour gérer les dossiers, clients, actes notariés, comptabilité et bien plus encore.

## 🎯 Public Cible

- **Notaires Marocains** : Solution clé en main pour la gestion quotidienne de votre étude
- **Entreprises IT Marocaines** : Plateforme open source pour intégration, personnalisation et support

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

## 🏗️ Architecture Technique

### Contrôleurs Principaux

L'application s'articule autour de **26 contrôleurs** gérant les différentes fonctionnalités :

#### Gestion des Entités Principales (CRUD Complet)
- **DossierController** : Opérations CRUD sur les dossiers, recherche, exports
- **ClientController** : Gestion des clients, association aux opérations
- **ActeController** : Actes notariés, recherche par répertoire
- **OperationController** : Opérations commerciales/immobilières
- **BienController** : Biens immobiliers et leurs caractéristiques

#### Comptabilité & Finance
- **CompteController** : Plan comptable, standardisation
- **CompteBancaireController** : Comptes bancaires de l'étude
- **EcritureController** : Écritures comptables globales
- **EcritureDossierController** : Écritures par dossier

#### Paramétrage & Configuration
- **ParamController** : Paramètres système
- **SettingController** : Configuration de l'application
- **TypeDeBienController** : Types de biens
- **TypeEcritureController** : Types d'écritures comptables
- **GroupementController** : Groupements comptables

#### Sécurité & Utilisateurs
- **AuthController** : Authentification
- **JsecUserController** : Gestion des utilisateurs
- **JsecRoleController** : Gestion des rôles
- **AdminController** : Administration système

#### Utilitaires
- **HomeController** : Page d'accueil et tableau de bord
- **CalendarController** : Gestion du calendrier
- **ActivityController** : Journal d'activité
- **TraductionController** : Gestion des traductions

### Modèles de Domaine

L'application utilise **32 modèles de domaine** principaux :

#### Entités Métier
- **Dossier** : Dossier notarié (numéro, libellé, état, modèle)
- **Client** : Client (nom, coordonnées, identité)
- **Operation** : Opération commerciale
- **Acte** : Acte notarié répertorié
- **Bien** : Bien immobilier

#### Comptabilité
- **Compte** : Compte du plan comptable
- **CompteBancaire** : Compte bancaire
- **EcritureDossier** : Écriture comptable d'un dossier
- **TypeEcriture** : Type d'écriture (recette, dépense)
- **MoyenPaiement** : Moyen de paiement
- **EtatEcriture** : État de l'écriture (brouillon, validé)

#### Référentiels
- **TypeDeBien** : Types de biens (terrain, appartement, etc.)
- **Civilite** : Civilités (M., Mme, etc.)
- **PieceIdentite** : Types de pièces d'identité
- **CategorieEcriture** : Catégories d'écritures

#### Sécurité
- **JsecUser** : Utilisateur
- **JsecRole** : Rôle
- **JsecPermission** : Permission
- Relations : **JsecUserPermissionRel**, **JsecRolePermissionRel**

#### Système
- **Activity** : Journal d'activité
- **Setting** : Paramètres système
- **Groupement** : Groupements comptables

### Relations Entre Modèles

```
Client --> Operation --> Dossier --> EcritureDossier
                   |         |            |
                   v         v            v
                 Bien      Acte        Compte
```

## 📋 Prérequis Système

### Logiciels Requis
- **Java** : JDK 7 ou supérieur
- **PostgreSQL** : Version 13.x ou supérieure
- **Apache Tomcat** : Version 7.x
- **Grails** : Version 1.3.8

### Ressources Recommandées (VPS)
- **CPU** : 2 vCPU minimum
- **RAM** : 2 GB minimum (4 GB recommandé)
- **Stockage** : 20 GB SSD minimum
- **OS** : Linux (Ubuntu 20.04+ / Debian 10+ recommandé)

## 🚀 Installation

### Option 1 : Installation avec Docker (Recommandée)

#### 1. Cloner le dépôt
```bash
git clone https://github.com/OpenEtude/Webapp.git
cd Webapp
```

#### 2. Configuration de l'environnement
Créer un fichier `.env` avec vos paramètres :
```env
RDS_DB_NAME=etude
RDS_USERNAME=etude
RDS_PASSWORD=votre_mot_de_passe_securise
RDS_HOSTNAME=localhost
RDS_PORT=5432
```

#### 3. Lancer avec Docker Compose
```bash
docker-compose up -d
```

L'application sera accessible sur `http://localhost:8080`

### Option 2 : Installation sur AWS Lightsail (Recommandé pour Production)

AWS Lightsail est la **meilleure option** pour déployer OpenEtude en production :

#### Avantages
- ✅ Coût prévisible et économique (à partir de $5/mois)
- ✅ PostgreSQL managé inclus
- ✅ Snapshots et sauvegardes automatiques
- ✅ Réseau privé sécurisé
- ✅ Support IPv6
- ✅ Interface simple et intuitive

#### Étapes de Déploiement

1. **Créer une instance Lightsail**
   - OS : Ubuntu 20.04 LTS
   - Plan : 2 GB RAM minimum ($10/mois)

2. **Créer une base de données PostgreSQL managée**
   - Plan : Standard ($15/mois)
   - Version : PostgreSQL 13.x
   - Noter les identifiants de connexion

3. **Configurer l'instance**
```bash
# Connexion SSH à l'instance
ssh ubuntu@votre-instance-lightsail

# Installation de Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ubuntu

# Installation de Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

4. **Déployer l'application**
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

5. **Configuration réseau Lightsail**
   - Ouvrir les ports 80 et 443 dans le firewall
   - Attacher une IP statique
   - Configurer un domaine (optionnel)

#### Coût Estimé AWS Lightsail
- Instance 2GB : $10/mois
- PostgreSQL Standard : $15/mois
- IP statique : Gratuite
- **Total : ~$25/mois**

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

## 📖 Documentation Complémentaire

Pour plus d'informations détaillées, consultez :
- [**ARCHITECTURE.md**](./ARCHITECTURE.md) - Architecture technique détaillée
- [**INSTALLATION.md**](./INSTALLATION.md) - Guide d'installation complet
- [**SUPPORT.md**](./SUPPORT.md) - Comment obtenir de l'aide

## 🤝 Support

Pour toute question, problème ou demande de fonctionnalité :

➡️ **Utilisez exclusivement [GitHub Issues](https://github.com/OpenEtude/Webapp/issues)**

### Avant de créer une issue
1. Vérifiez que votre problème n'a pas déjà été signalé
2. Fournissez un maximum d'informations :
   - Version de l'application
   - Environnement (OS, Java, PostgreSQL)
   - Logs d'erreur
   - Étapes pour reproduire le problème

## 📜 Licence

Ce projet est sous licence **MIT**. Voir le fichier [LICENSE](./LICENSE) pour plus de détails.

### En bref
- ✅ Utilisation commerciale autorisée
- ✅ Modification autorisée
- ✅ Distribution autorisée
- ✅ Utilisation privée autorisée
- ℹ️ Fourni "tel quel", sans garantie

## 🏆 Contributeurs

Merci à tous les contributeurs qui ont participé à ce projet !

Pour contribuer, consultez [CONTRIBUTING.md](./CONTRIBUTING.md).

## 🔧 Stack Technique

- **Framework** : Grails 1.3.8
- **Langage** : Groovy, Java
- **Base de données** : PostgreSQL 13+
- **ORM** : Hibernate
- **Serveur** : Apache Tomcat 7
- **Frontend** : JavaScript, CSS3
- **Sécurité** : JSecurity
- **Build** : Gradle
- **Conteneurisation** : Docker

Pour la stack technique complète, voir [techstack.md](./techstack.md).

---

**OpenEtude** - La solution open source pour notaires 2.0 🇲🇦
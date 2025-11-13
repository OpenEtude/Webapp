# Architecture Technique d'OpenEtude

Ce document décrit l'architecture technique détaillée de l'application OpenEtude.

## 📋 Table des Matières

1. [Vue d'Ensemble](#vue-densemble)
2. [Architecture Applicative](#architecture-applicative)
3. [Contrôleurs (Controllers)](#contrôleurs-controllers)
4. [Modèles de Domaine (Domain Models)](#modèles-de-domaine-domain-models)
5. [Services Métier](#services-métier)
6. [Sécurité et Permissions](#sécurité-et-permissions)
7. [Base de Données](#base-de-données)
8. [Stack Technique](#stack-technique)

## Vue d'Ensemble

OpenEtude est une application web Grails qui suit le pattern **MVC (Model-View-Controller)**. Elle est conçue spécifiquement pour répondre aux besoins des études notariales marocaines.

### Architecture Générale

```
┌─────────────────────────────────────────────────────────┐
│                    Navigateur Web                        │
│                  (Chrome, Firefox, etc.)                 │
└────────────────────────┬────────────────────────────────┘
                         │ HTTP/HTTPS
                         ▼
┌─────────────────────────────────────────────────────────┐
│                   Serveur Web (Tomcat)                   │
│  ┌─────────────────────────────────────────────────┐   │
│  │          Application Grails 1.3.8                │   │
│  │  ┌──────────────┐  ┌──────────────┐            │   │
│  │  │ Controllers  │  │   Services    │            │   │
│  │  │  (26 ctrl)   │  │   (Métier)    │            │   │
│  │  └──────┬───────┘  └───────┬───────┘            │   │
│  │         │                   │                     │   │
│  │         ▼                   ▼                     │   │
│  │  ┌──────────────────────────────────┐           │   │
│  │  │   Modèles de Domaine (32)         │           │   │
│  │  │   (Hibernate/GORM ORM)            │           │   │
│  │  └──────────────┬────────────────────┘           │   │
│  └─────────────────┼──────────────────────────────── │   │
└────────────────────┼────────────────────────────────────┘
                     │ JDBC
                     ▼
┌─────────────────────────────────────────────────────────┐
│              PostgreSQL Database 13+                     │
│            (Tables, Indexes, Constraints)                │
└─────────────────────────────────────────────────────────┘
```

### Principes de Conception

- **Convention over Configuration** : Grails minimise la configuration
- **DRY (Don't Repeat Yourself)** : Réutilisation maximale du code
- **Separation of Concerns** : Séparation claire MVC
- **Domain-Driven Design** : Modèle métier au centre

## Architecture Applicative

### Structure des Répertoires

```
Webapp/
├── grails-app/
│   ├── conf/                    # Configuration
│   │   ├── Config.groovy
│   │   ├── DataSource.groovy
│   │   ├── UrlMappings.groovy
│   │   └── SecurityFilters.groovy
│   ├── controllers/             # Contrôleurs (26)
│   │   ├── DossierController.groovy
│   │   ├── ClientController.groovy
│   │   ├── ActeController.groovy
│   │   └── ...
│   ├── domain/                  # Modèles (32)
│   │   ├── Dossier.groovy
│   │   ├── Client.groovy
│   │   ├── Operation.groovy
│   │   └── ...
│   ├── services/                # Services métier
│   │   ├── DossierService.groovy
│   │   ├── CompteService.groovy
│   │   └── ...
│   ├── views/                   # Vues GSP
│   │   ├── dossier/
│   │   ├── client/
│   │   └── ...
│   ├── taglib/                  # Tags personnalisés
│   ├── i18n/                    # Internationalisation
│   └── jobs/                    # Tâches planifiées
├── src/
│   ├── groovy/                  # Code Groovy additionnel
│   └── java/                    # Code Java additionnel
├── web-app/
│   ├── css/                     # Feuilles de style
│   ├── js/                      # JavaScript
│   └── images/                  # Images
├── test/                        # Tests
└── lib/                         # Bibliothèques externes
```

## Contrôleurs (Controllers)

Les contrôleurs gèrent la logique de présentation et coordonnent les interactions entre les vues et les modèles.

### Liste Complète des Contrôleurs

#### 1. Gestion des Entités Principales

##### DossierController
**Responsabilité** : Gestion complète des dossiers notariés

**Actions CRUD** :
- `list()` - Liste paginée des dossiers
- `show(id)` - Affichage détaillé d'un dossier
- `create()` - Formulaire de création
- `save()` - Enregistrement d'un nouveau dossier
- `edit(id)` - Formulaire d'édition
- `update(id)` - Mise à jour d'un dossier
- `delete(id)` - Suppression d'un dossier

**Actions Spéciales** :
- `search(q)` - Recherche par libellé ou numéro
- `lookup(query)` - Recherche Ajax pour autocomplétion
- `advSearch()` - Recherche avancée avec filtres
- `xlsTemplate()` - Téléchargement du modèle Excel
- `upload()` - Page d'import
- `doUpload()` - Traitement de l'import Excel
- `export()` - Export des dossiers

**Permissions** :
- `Dossier:Liste` - Consulter la liste
- `Dossier:Consultation` - Voir les détails
- `Dossier:Modification` - Modifier
- `Dossier:Creation` - Créer
- `Dossier:Suppression` - Supprimer
- `Dossier:RapportDetail` - Rapports détaillés
- `Dossier:ModificationMasse` - Import/Export

##### ClientController
**Responsabilité** : Gestion des clients

**Actions CRUD** : Standard (list, show, create, save, edit, update, delete)

**Actions Spéciales** :
- `addOperation(clientId, operationId)` - Associer une opération
- `addManyOperation()` - Association multiple
- `removeOperation(operationId)` - Dissocier une opération
- `lookup(query)` - Recherche Ajax

**Modèle** : Client (nom, coordonnées, identité)

##### ActeController
**Responsabilité** : Gestion des actes notariés

**Actions CRUD** : Standard

**Actions Spéciales** :
- `upload(id)` - Télécharger un document
- `doUpload()` - Traitement du téléchargement
- Recherche par numéro de répertoire ou libellé

##### OperationController
**Responsabilité** : Gestion des opérations commerciales/immobilières

**Actions CRUD** : Standard

**Relations** :
- Client (propriétaire de l'opération)
- Dossiers (multiples)
- Biens (multiples)

##### BienController
**Responsabilité** : Gestion des biens immobiliers

**Actions CRUD** : Standard

**Actions Spéciales** :
- `addValeur()` - Ajouter une caractéristique
- `addManyValeur()` - Ajout multiple
- `removeValeur()` - Supprimer une caractéristique

#### 2. Comptabilité & Finance

##### CompteController
**Responsabilité** : Gestion du plan comptable

**Actions CRUD** : Standard

**Actions Spéciales** :
- `synthese()` - Vue synthétique du plan comptable
- `standardize()` - Standardisation des comptes
- `uniformiser()` - Uniformisation
- Import/Export Excel

**Hiérarchie** : Les comptes peuvent avoir des sous-comptes (rattachement)

##### CompteBancaireController
**Responsabilité** : Gestion des comptes bancaires de l'étude

**Actions CRUD** : Standard

##### EcritureController
**Responsabilité** : Gestion globale des écritures comptables

**Actions** :
- Consultation des écritures
- Validation
- Rapports

##### EcritureDossierController
**Responsabilité** : Écritures comptables spécifiques à un dossier

**Actions CRUD** : Standard

**Validations** :
- Montant positif
- Association au dossier
- Vérification de l'état (verrouillage)

#### 3. Paramétrage & Configuration

##### TypeEcritureController
**Responsabilité** : Types d'écritures comptables (recettes, dépenses)

**Actions CRUD** : Standard

**Propriétés** :
- Libellé
- Nature (débit/crédit)
- Comptes associés
- Affectable ou non

##### TypeDeBienController
**Responsabilité** : Types de biens immobiliers

**Actions CRUD** : Standard

**Exemples** : Terrain, Appartement, Villa, Local commercial, etc.

##### GroupementController
**Responsabilité** : Groupements comptables

**Actions CRUD** : Standard

**Usage** : Organiser les types d'écritures en catégories

##### ParamController
**Responsabilité** : Paramètres système généraux

##### SettingController
**Responsabilité** : Configuration de l'application

#### 4. Sécurité & Utilisateurs

##### AuthController
**Responsabilité** : Authentification

**Actions** :
- `login()` - Page de connexion
- `signIn()` - Traitement de la connexion
- `logout()` - Déconnexion

##### JsecUserController
**Responsabilité** : Gestion des utilisateurs

**Actions CRUD** : Standard

**Propriétés Utilisateur** :
- Login (username)
- Mot de passe (hashé)
- Nom complet
- Email

##### JsecRoleController
**Responsabilité** : Gestion des rôles

**Actions CRUD** : Standard

**Exemples de rôles** : Administrateur, Notaire, Assistant, Comptable

##### JsecUserRoleRelController
**Responsabilité** : Association utilisateurs-rôles

##### AdminController
**Responsabilité** : Administration système

**Actions** :
- Gestion des permissions
- Configuration avancée
- Maintenance

#### 5. Utilitaires

##### HomeController
**Responsabilité** : Page d'accueil et tableau de bord

**Actions** :
- `index()` - Tableau de bord
- Statistiques
- Raccourcis

##### CalendarController
**Responsabilité** : Calendrier et planification

**Actions** :
- Vue calendrier
- Gestion d'événements
- Rappels

##### ActivityController
**Responsabilité** : Journal d'activité (audit log)

**Informations Enregistrées** :
- Utilisateur
- Action effectuée
- Date et heure
- Entité concernée

##### TraductionController
**Responsabilité** : Gestion des traductions

**Usage** : Internationalisation de l'interface

##### ChampController, ValeurController
**Responsabilité** : Champs personnalisés et leurs valeurs

**Usage** : Extension du modèle de données

## Modèles de Domaine (Domain Models)

Les modèles de domaine représentent la structure de données de l'application.

### Hiérarchie et Relations

```
┌─────────────────────────────────────────────────────────┐
│                    Client                                │
│  - nom, téléphone, email                                │
│  - civilite, pieceIdentite                              │
└────────────────┬────────────────────────────────────────┘
                 │ 1:N
                 ▼
┌─────────────────────────────────────────────────────────┐
│                  Operation                               │
│  - libelle, description                                  │
│  - dateCreation                                          │
└──────────────┬──────────────────┬───────────────────────┘
               │ 1:N              │ M:N
               ▼                  ▼
    ┌──────────────────┐   ┌──────────────────┐
    │     Dossier       │   │      Bien         │
    │ - numeroDossier   │   │ - libelle         │
    │ - libelle         │   │ - description     │
    │ - cloture         │   │ - typeDeBien      │
    └────────┬──────────┘   └───────────────────┘
             │ 1:N
             ▼
    ┌──────────────────────────┐
    │   EcritureDossier         │
    │ - typeEcriture            │
    │ - montant                 │
    │ - dateValeur              │
    │ - etat                    │
    └───────────────────────────┘
```

### 1. Entités Métier Principales

#### Client
**Fichier** : `grails-app/domain/Client.groovy`

**Propriétés** :
```groovy
String nom              // Nom complet (obligatoire, max 50 char)
String telephone        // Téléphone fixe (max 30 char)
String mobile           // Téléphone mobile (max 30 char)
String fax              // Fax (max 30 char)
String email            // Email (validé)
String addresse1        // Adresse ligne 1
String addresse2        // Adresse ligne 2
String ville            // Ville (max 50 char)
String commentaire      // Commentaire (max 255 char)
Civilite civilite       // M., Mme, Mlle, etc. (obligatoire)
String numIdentite      // Numéro de pièce d'identité
PieceIdentite pieceIdentite  // Type de pièce (CIN, Passeport, etc.)
```

**Relations** :
- `hasMany = [operations:Operation]` - Un client peut avoir plusieurs opérations

**Contraintes** :
- Nom obligatoire
- Email validé (format email)
- Civilité obligatoire

#### Operation
**Fichier** : `grails-app/domain/Operation.groovy`

**Propriétés** :
```groovy
String libelle          // Libellé (obligatoire)
Date dateCreation       // Date de création
Client client           // Client propriétaire (obligatoire)
String description      // Description détaillée
```

**Relations** :
- `belongsTo = [Client]` - Appartient à un client
- `hasMany = [dossiers:Dossier, biens:Bien]` - Plusieurs dossiers et biens

#### Dossier
**Fichier** : `grails-app/domain/Dossier.groovy`

**Propriétés** :
```groovy
String numeroDossier    // Format: 123/2024 (unique, obligatoire)
String libelle          // Libellé (obligatoire)
String description      // Description
Operation operation     // Opération parente
Date dateCreation       // Date de création
Boolean cloture         // Dossier clôturé ?
Boolean modele          // Est un modèle ?
String nomModele        // Nom du modèle
EtatEcriture etatModele // État du modèle
Boolean keepMontant     // Conserver les montants ?
```

**Relations** :
- `belongsTo = [Operation]` - Appartient à une opération
- `hasMany = [ecritures:EcritureDossier, actes:Acte, biens:Bien]`

**Contraintes** :
- `numeroDossier` : unique, format `[0-9]+/[0-9]+` (ex: 42/2024)
- Tags supportés (interface `Taggable`)

**Méthodes** :
- `getNumero()` : Calcul d'un numéro unique pour tri
- `toString()` : Affichage formaté

#### Acte
**Propriétés** (estimation basée sur le contrôleur) :
```groovy
String libelle
Integer numRepertoire   // Numéro au répertoire
Date dateCreation
Dossier dossier        // Dossier associé
// Possiblement : fichiers attachés
```

**Relations** :
- `belongsTo = [Dossier]`

#### Bien
**Propriétés** :
```groovy
String libelle
String description
TypeDeBien typeDeBien
```

**Relations** :
- Association avec Operation et Dossier

### 2. Comptabilité

#### Compte
**Fichier** : `grails-app/domain/Compte.groovy`

**Propriétés** :
```groovy
String code             // Code comptable (unique, obligatoire)
String libelle          // Libellé (obligatoire)
String description      // Description
Compte compteDeRattachement  // Compte parent (hiérarchie)
```

**Relations** :
- `belongsTo = [compteDeRattachement:Compte]` - Hiérarchie
- `hasMany = [debiteurs:TypeEcriture, crediteurs:TypeEcriture, comptes:Compte]`
- `mappedBy = [debiteurs:"compteADebiter", crediteurs:"compteACrediter"]`

**Contraintes** :
- Code unique
- Libellé unique par compte de rattachement
- Implémente `Comparable` (tri par code)

#### EcritureDossier
**Fichier** : `grails-app/domain/EcritureDossier.groovy`

**Hérite de** : `Ecriture`

**Propriétés** :
```groovy
Dossier dossier             // Dossier concerné (obligatoire)
Acte acte                   // Acte associé (optionnel)
TypeEcriture typeEcriture   // Type d'écriture (obligatoire)
BigDecimal montant          // Montant (>= 0, 2 décimales)
Date dateValeur             // Date de valeur (obligatoire)
Date dateMouvement          // Date du mouvement
EtatEcriture etat           // État (obligatoire)
CompteBancaire compteBancaire  // Compte bancaire (si affectable)
MoyenPaiement moyenPaiement    // Moyen de paiement
String commentaire          // Commentaire
String pieceComptable       // Référence pièce comptable
Boolean marked              // Marquée ?
Boolean modele              // Est un modèle ?
```

**Relations** :
- `belongsTo = [Dossier]`

**Contraintes Spéciales** :
- Montant minimum 0
- Si `compteBancaire` renseigné, le `typeEcriture` doit être affectable
- Si `acte` renseigné, il doit appartenir au même dossier
- État validé par `checkLocked()` (vérification verrouillage)

**Affichage** :
```
"TypeEcriture : 1,234.56 DH"
```

#### TypeEcriture
**Propriétés** :
```groovy
String libelle
String nature              // "DEBIT" ou "CREDIT"
Compte compteADebiter
Compte compteACrediter
Boolean affectable         // Peut être affecté à un compte bancaire ?
Groupement groupement      // Groupement comptable
```

**Relations** :
- `belongsTo = [Compte, Groupement]`

#### CompteBancaire
**Propriétés** :
```groovy
String numero              // Numéro de compte
String banque              // Nom de la banque
String agence              // Agence
String titulaire           // Titulaire du compte
BigDecimal soldeInitial    // Solde initial
```

#### MoyenPaiement
**Référentiel des moyens de paiement** :
- Espèces
- Chèque
- Virement
- Carte bancaire
- etc.

#### EtatEcriture
**États possibles pour une écriture** :
- Brouillon
- Validée
- Comptabilisée
- Annulée

#### CategorieEcriture
**Catégorisation des écritures** pour reporting

### 3. Référentiels

#### TypeDeBien
**Types de biens immobiliers** :
- Terrain
- Appartement
- Villa
- Local commercial
- Bureau
- etc.

#### Civilite
**Civilités** :
- M. (Monsieur)
- Mme (Madame)
- Mlle (Mademoiselle)
- Autres...

#### PieceIdentite
**Types de pièces d'identité** :
- CIN (Carte d'Identité Nationale)
- Passeport
- Carte de séjour
- etc.

### 4. Sécurité

#### JsecUser
**Utilisateur du système**

**Propriétés** :
```groovy
String username            // Login (unique)
String passwordHash        // Mot de passe hashé
String fullName            // Nom complet
String email               // Email
Boolean enabled            // Compte actif ?
```

**Relations** :
- Rôles via `JsecUserRoleRel`
- Permissions directes via `JsecUserPermissionRel`

#### JsecRole
**Rôle de sécurité**

**Propriétés** :
```groovy
String name                // Nom du rôle (unique)
String description         // Description
```

**Relations** :
- Permissions via `JsecRolePermissionRel`

#### JsecPermission
**Permission granulaire**

**Format** : `Entite:Action`
**Exemples** :
- `Dossier:Liste`
- `Dossier:Creation`
- `Client:Modification`
- `Compte:Suppression`

**Relations** :
- Peut être attachée à un rôle ou directement à un utilisateur

#### Tables de Liaison
- **JsecUserPermissionRel** : User ↔ Permission
- **JsecRolePermissionRel** : Role ↔ Permission
- **JsecUserRoleRel** : User ↔ Role (estimation)

### 5. Système

#### Activity
**Journal d'activité (audit log)**

**Propriétés** :
```groovy
String username            // Utilisateur
String action              // Action effectuée
String entityName          // Entité concernée
Long entityId              // ID de l'entité
Date dateCreated           // Date/heure
String details             // Détails supplémentaires
```

**Usage** : Traçabilité et audit

#### Setting
**Paramètres de l'application**

**Propriétés** :
```groovy
String key                 // Clé (unique)
String value               // Valeur
String type                // Type de donnée
String description         // Description
```

**Exemples** :
- Nom de l'étude
- Logo
- Paramètres d'affichage
- Configuration email

#### Groupement
**Groupement comptable**

**Propriétés** :
```groovy
String libelle
String description
```

**Relations** :
- `hasMany = [typesEcriture:TypeEcriture]`

**Usage** : Organiser les types d'écritures pour reporting

## Services Métier

Les services encapsulent la logique métier complexe.

### Services Principaux

#### DossierService
**Responsabilités** :
- Création de dossiers à partir de modèles
- Calcul du prochain numéro de dossier
- Gestion de la clôture
- Statistiques sur les dossiers

#### CompteService
**Responsabilités** :
- Standardisation du plan comptable
- Uniformisation des codes
- Calcul des soldes
- Validation des comptes

#### WordService
**Responsabilités** :
- Génération de documents Word
- Fusion de modèles
- Export de rapports

#### AdminService
**Responsabilités** :
- Gestion des utilisateurs et permissions
- Configuration système
- Maintenance

#### SmbService
**Responsabilités** :
- Intégration avec partages réseau (SMB/CIFS)
- Stockage de documents

## Sécurité et Permissions

### Système de Permissions (JSecurity)

OpenEtude utilise **JSecurity** (Apache Shiro) pour la sécurité.

#### Modèle de Permissions

**Format** : `Entite:Action`

**Actions Standard** :
- `Liste` - Voir la liste
- `Consultation` - Voir les détails
- `Creation` - Créer
- `Modification` - Modifier
- `Suppression` - Supprimer
- `ModificationMasse` - Import/Export
- `RapportDetail` - Rapports avancés

#### Exemple de Configuration (dans un contrôleur)

```groovy
static accessControl = {
    permission(perm: new EtudePerm('Dossier', ['Liste']), 
               only: ['list', 'search', 'lookup'])
    permission(perm: new EtudePerm('Dossier', ['Consultation']), 
               action: 'show')
    permission(perm: new EtudePerm('Dossier', ['Modification']), 
               only: ['edit', 'update'])
    permission(perm: new EtudePerm('Dossier', ['Creation']), 
               only: ['create', 'save'])
    permission(perm: new EtudePerm('Dossier', ['Suppression']), 
               only: ['delete'])
}
```

#### Filtres de Sécurité

**Fichier** : `grails-app/conf/SecurityFilters.groovy`

**Fonctionnalités** :
- Vérification de l'authentification
- Contrôle des permissions
- Redirection vers login si nécessaire

## Base de Données

### Configuration

**Fichier** : `grails-app/conf/DataSource.groovy`

**Dialecte** : PostgreSQL personnalisé (`TableNameSequencePostgresDialect`)

**Environnements** :
- **development** : localhost:5438, base `etude`
- **test** : localhost:5432, base `etudetest`
- **production** : Configuration via variables d'environnement

### Stratégie de Schéma

**`dbCreate`** : `"update"`
- Mise à jour automatique du schéma à partir des modèles de domaine
- Hibernate génère les tables, colonnes, index
- **Attention** : Pas de suppression automatique

### Tables Principales

Environ **35 tables** générées automatiquement depuis les 32 modèles + tables de liaison.

**Exemples** :
- `client`
- `operation`
- `dossier`
- `acte`
- `bien`
- `compte`
- `ecriture_dossier`
- `type_ecriture`
- `compte_bancaire`
- `jsec_user`
- `jsec_role`
- `jsec_permission`
- `jsec_user_role_rel`
- `jsec_user_permission_rel`
- `jsec_role_permission_rel`
- `activity`
- `setting`
- etc.

### Indexes et Contraintes

**Contraintes d'Unicité** :
- `client.email`
- `dossier.numero_dossier`
- `compte.code`
- `jsec_user.username`
- etc.

**Clés Étrangères** :
- Toutes les relations `belongsTo` et `hasMany` génèrent des FK
- Cascade défini par les relations

### Sauvegarde

Voir [INSTALLATION.md](./INSTALLATION.md#maintenance-et-sauvegardes) pour les scripts de sauvegarde.

## Stack Technique

### Backend

| Composant | Version | Rôle |
|-----------|---------|------|
| **Grails** | 1.3.8 | Framework MVC |
| **Groovy** | 1.7.x | Langage de programmation |
| **Java** | 7+ | JVM |
| **Hibernate** | 3.6.x | ORM |
| **Spring** | 3.0.x | Injection de dépendances |
| **JSecurity** | 0.3 | Sécurité |
| **Quartz** | 0.4.1 | Planification de tâches |

### Base de Données

| Composant | Version | Rôle |
|-----------|---------|------|
| **PostgreSQL** | 13+ | SGBD |
| **JDBC Driver** | postgresql | Connecteur |

### Serveur Web

| Composant | Version | Rôle |
|-----------|---------|------|
| **Apache Tomcat** | 7.0 | Conteneur de servlets |

### Frontend

| Composant | Rôle |
|-----------|------|
| **GSP** | Vues (Groovy Server Pages) |
| **JavaScript** | Interactivité client |
| **CSS3** | Styles |
| **JAWR** | Bundling et minification JS/CSS |

### Build & Déploiement

| Composant | Version | Rôle |
|-----------|---------|------|
| **Gradle** | 1.x | Build tool |
| **Docker** | 20+ | Conteneurisation |
| **Git** | - | Contrôle de version |

### Intégrations

- **Apache POI** : Génération/lecture Excel
- **Apache PDFBox** : Génération PDF (estimation)
- **SMB/CIFS** : Partage de fichiers réseau

### Monitoring & Logs

- **Log4j** : Logging
- **Console Grails** : Debugging
- **PostgreSQL logs** : Logs de la base

## Flux de Données Typique

### Exemple : Création d'un Dossier

```
1. Utilisateur : Clic sur "Nouveau Dossier"
   ↓
2. Browser → DossierController.create()
   ↓
3. Controller : Instancie new Dossier()
   ↓
4. Controller → Vue GSP (dossier/create.gsp)
   ↓
5. Utilisateur : Remplit le formulaire, soumet
   ↓
6. Browser → DossierController.save()
   ↓
7. Controller : Valide les données
   ↓
8. Controller : dossier.save(flush: true)
   ↓
9. GORM/Hibernate : INSERT INTO dossier ...
   ↓
10. PostgreSQL : Enregistrement
    ↓
11. Controller : redirect(action: "show", id: dossier.id)
    ↓
12. Browser → DossierController.show(id)
    ↓
13. Controller : Charge le dossier
    ↓
14. Controller → Vue GSP (dossier/show.gsp)
    ↓
15. Browser : Affiche le dossier créé
```

### Exemple : Recherche de Client

```
1. Utilisateur : Tape dans le champ de recherche
   ↓
2. JavaScript : Envoie requête Ajax
   ↓
3. Browser → ClientController.lookup(query="dupon")
   ↓
4. Controller : Client.findAllByNomIlike("%dupon%")
   ↓
5. GORM : SELECT * FROM client WHERE nom ILIKE '%dupon%'
   ↓
6. PostgreSQL : Retourne résultats
   ↓
7. Controller : Génère XML/JSON
   ↓
8. Browser reçoit : <clients><client><id>...</client></clients>
   ↓
9. JavaScript : Parse et affiche autocomplétion
   ↓
10. Utilisateur : Sélectionne un client
```

## Patterns et Bonnes Pratiques

### Patterns Utilisés

- **MVC** : Séparation Model-View-Controller
- **Active Record** : Modèles de domaine avec méthodes CRUD
- **DAO** : Services comme couche d'accès aux données
- **Dependency Injection** : Spring injecte les services
- **Convention over Configuration** : Minimisation de la config
- **DRY** : Réutilisation du code

### Bonnes Pratiques

#### Dans les Contrôleurs
- Actions légères, déléguer aux services
- Validation des paramètres
- Gestion des erreurs avec `flash.message`
- Permissions via `accessControl`

#### Dans les Modèles
- Contraintes dans le bloc `constraints`
- Méthodes métier dans le domaine
- `toString()` lisible
- Relations explicites

#### Dans les Services
- Logique métier complexe
- Transactions gérées automatiquement
- Réutilisabilité
- Testabilité

## Évolutivité

### Points d'Extension

1. **Nouveaux Modèles** : Ajouter dans `grails-app/domain/`
2. **Nouveaux Contrôleurs** : Ajouter dans `grails-app/controllers/`
3. **Nouveaux Services** : Ajouter dans `grails-app/services/`
4. **Champs Personnalisés** : Via `ChampController` et `ValeurController`
5. **Traductions** : Via `TraductionController` et fichiers i18n

### Limites Actuelles

- Grails 1.3.8 est une version ancienne (2011)
- Java 7 est obsolète
- Certaines dépendances peuvent avoir des failles de sécurité

### Recommandations pour Évolution

1. **Migration vers Grails 5+** : Version moderne avec Groovy 3
2. **Upgrade Java** : Java 17 LTS minimum
3. **Tests** : Ajouter une couverture de tests complète
4. **API REST** : Exposer une API pour intégrations
5. **Frontend moderne** : React/Vue.js pour l'interface

---

Pour toute question sur l'architecture :

➡️ **[GitHub Issues](https://github.com/OpenEtude/Webapp/issues)**

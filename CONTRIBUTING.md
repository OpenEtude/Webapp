# Guide de Contribution à OpenEtude

Merci de votre intérêt pour contribuer à OpenEtude ! Ce guide vous aidera à commencer.

## 🎯 Public

Ce guide s'adresse à :
- 🇲🇦 **Notaires Marocains** : Utilisateurs finaux qui souhaitent proposer des améliorations
- 💻 **Entreprises IT Marocaines** : Développeurs souhaitant contribuer au code
- 🌍 **Communauté Open Source** : Tous les contributeurs intéressés

## 📋 Table des Matières

1. [Types de Contributions](#types-de-contributions)
2. [Comment Contribuer](#comment-contribuer)
3. [Configuration de l'Environnement de Développement](#configuration-de-lenvironnement-de-développement)
4. [Standards de Code](#standards-de-code)
5. [Processus de Pull Request](#processus-de-pull-request)
6. [Code de Conduite](#code-de-conduite)

## Types de Contributions

### 🐛 Corrections de Bugs

Vous avez trouvé un bug ? Vous pouvez :
1. Signaler le bug via une [Issue](https://github.com/OpenEtude/Webapp/issues/new)
2. Corriger le bug vous-même et soumettre une Pull Request

### ✨ Nouvelles Fonctionnalités

Proposer ou développer de nouvelles fonctionnalités :
1. Créer une Issue "Feature Request" pour discussion
2. Attendre validation de la communauté/mainteneurs
3. Développer et soumettre une Pull Request

### 📚 Documentation

La documentation peut toujours être améliorée :
- Corriger des erreurs
- Ajouter des exemples
- Traduire en d'autres langues (arabe, anglais)
- Créer des tutoriels vidéo
- Améliorer les commentaires dans le code

### 🌍 Traductions

L'interface peut être traduite :
- Arabe (dialecte marocain)
- Anglais
- Autres langues

### 🧪 Tests

Ajouter des tests pour améliorer la qualité :
- Tests unitaires
- Tests d'intégration
- Tests fonctionnels

### 🎨 Design et UX

Améliorer l'expérience utilisateur :
- Interface plus moderne
- Meilleure ergonomie
- Accessibilité

## Comment Contribuer

### Pour les Non-Développeurs (Notaires)

#### 1. Signaler des Problèmes
- Utilisez [GitHub Issues](https://github.com/OpenEtude/Webapp/issues)
- Décrivez clairement le problème
- Ajoutez des captures d'écran si possible

#### 2. Proposer des Améliorations
- Créez une Issue "Feature Request"
- Expliquez le besoin métier
- Décrivez le flux de travail souhaité

#### 3. Tester les Nouvelles Versions
- Installer les versions beta
- Rapporter les problèmes
- Valider les nouvelles fonctionnalités

#### 4. Participer aux Discussions
- Commenter les Issues
- Voter pour les fonctionnalités importantes
- Partager votre expérience

### Pour les Développeurs (Entreprises IT)

#### 1. Fork du Projet

```bash
# Sur GitHub, cliquer sur "Fork"
# Puis cloner votre fork
git clone https://github.com/VOTRE-USERNAME/Webapp.git
cd Webapp

# Ajouter le dépôt upstream
git remote add upstream https://github.com/OpenEtude/Webapp.git
```

#### 2. Créer une Branche

```bash
# Mettre à jour main
git checkout main
git pull upstream main

# Créer une branche pour votre contribution
git checkout -b feature/ma-nouvelle-fonctionnalite
# ou
git checkout -b bugfix/correction-du-bug
```

#### 3. Développer

- Écrire du code propre et testé
- Suivre les standards du projet
- Commenter le code si nécessaire
- Tester localement

#### 4. Commit

```bash
# Ajouter les fichiers modifiés
git add .

# Commit avec un message descriptif
git commit -m "feat: ajoute la fonctionnalité X

- Implémente la fonctionnalité Y
- Ajoute les tests pour Z
- Met à jour la documentation

Fixes #123"
```

**Format des messages de commit** :
- `feat:` - Nouvelle fonctionnalité
- `fix:` - Correction de bug
- `docs:` - Documentation
- `style:` - Formatage, point-virgules, etc.
- `refactor:` - Refactoring du code
- `test:` - Ajout de tests
- `chore:` - Maintenance, dépendances

#### 5. Push

```bash
git push origin feature/ma-nouvelle-fonctionnalite
```

#### 6. Créer une Pull Request

1. Aller sur votre fork sur GitHub
2. Cliquer sur "New Pull Request"
3. Remplir le template de PR
4. Attendre la revue de code

## Configuration de l'Environnement de Développement

### Prérequis

- **Git** : Pour le contrôle de version
- **Java JDK 7+** : OpenJDK 11 recommandé
- **PostgreSQL 13+** : Base de données
- **Docker** (optionnel) : Pour environnement isolé
- **IDE** : IntelliJ IDEA ou Eclipse avec Groovy/Grails

### Installation

#### 1. Cloner le Projet

```bash
git clone https://github.com/OpenEtude/Webapp.git
cd Webapp
```

#### 2. Configurer PostgreSQL

```bash
# Créer la base de données
sudo -u postgres psql <<EOF
CREATE USER etude WITH PASSWORD 'etude';
CREATE DATABASE etude OWNER etude;
GRANT ALL PRIVILEGES ON DATABASE etude TO etude;
\q
EOF
```

#### 3. Configurer l'Application

Éditer `grails-app/conf/DataSource.groovy` pour l'environnement development.

#### 4. Lancer avec Docker (Recommandé)

```bash
docker-compose up -d
```

#### 5. Ou Lancer Manuellement

```bash
# Si Grails est installé localement
grails run-app

# Ou avec Gradle
./gradlew bootRun
```

#### 6. Accéder à l'Application

```
http://localhost:8080
```

### Structure du Projet

```
Webapp/
├── grails-app/
│   ├── conf/           # Configuration
│   ├── controllers/    # Contrôleurs MVC
│   ├── domain/         # Modèles de domaine
│   ├── services/       # Logique métier
│   ├── views/          # Vues GSP
│   ├── taglib/         # Tags personnalisés
│   └── i18n/           # Fichiers de traduction
├── src/
│   ├── groovy/         # Code Groovy supplémentaire
│   └── java/           # Code Java supplémentaire
├── test/               # Tests
├── web-app/
│   ├── css/            # Styles
│   ├── js/             # JavaScript
│   └── images/         # Images
└── lib/                # Bibliothèques externes
```

## Standards de Code

### Style Groovy/Grails

#### Conventions de Nommage

- **Classes** : PascalCase (`DossierController`, `ClientService`)
- **Méthodes** : camelCase (`save()`, `findByNom()`)
- **Variables** : camelCase (`numeroDossier`, `dateCreation`)
- **Constantes** : UPPER_SNAKE_CASE (`MAX_RESULTS`)

#### Exemple de Contrôleur

```groovy
class ExempleController {
    
    def exempleService  // Injection de service
    
    static allowedMethods = [save: 'POST', update: 'POST', delete: 'POST']
    
    static accessControl = {
        permission(perm: new EtudePerm('Exemple', ['Liste']), only: ['list'])
        permission(perm: new EtudePerm('Exemple', ['Creation']), only: ['create', 'save'])
    }
    
    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [exempleList: Exemple.list(params), exempleCount: Exemple.count()]
    }
    
    def save() {
        def exemple = new Exemple(params)
        if (exemple.save(flush: true)) {
            flash.message = "Exemple créé avec succès"
            redirect(action: 'show', id: exemple.id)
        } else {
            render(view: 'create', model: [exemple: exemple])
        }
    }
}
```

#### Exemple de Modèle de Domaine

```groovy
class Exemple {
    String nom
    String description
    Date dateCreation = new Date()
    
    static constraints = {
        nom(blank: false, maxSize: 100, unique: true)
        description(nullable: true, maxSize: 500)
        dateCreation()
    }
    
    String toString() {
        "${nom}"
    }
}
```

#### Exemple de Service

```groovy
class ExempleService {
    
    static transactional = true
    
    def creerExemple(String nom, String description) {
        def exemple = new Exemple(nom: nom, description: description)
        
        if (exemple.save(flush: true)) {
            log.info("Exemple créé : ${exemple.id}")
            return exemple
        } else {
            log.error("Erreur création exemple : ${exemple.errors}")
            throw new RuntimeException("Impossible de créer l'exemple")
        }
    }
    
    def rechercherExemples(String mot) {
        Exemple.findAllByNomIlike("%${mot}%", [max: 10, sort: 'nom'])
    }
}
```

### Bonnes Pratiques

#### ✅ À Faire

- Valider les données dans les contraintes du domaine
- Utiliser les services pour la logique métier complexe
- Gérer les erreurs et les cas limites
- Écrire des messages flash clairs pour l'utilisateur
- Logger les actions importantes
- Commenter le code complexe
- Écrire des tests unitaires
- Suivre les conventions Grails

#### ❌ À Éviter

- Logique métier dans les contrôleurs
- Requêtes SQL en dur (utiliser GORM)
- Ignorer la validation
- Laisser des `println` de debug
- Hardcoder des valeurs (utiliser Config.groovy)
- Dupliquer du code
- Ignorer les exceptions

### Sécurité

#### Points à Vérifier

1. **Validation des Entrées**
   ```groovy
   static constraints = {
       email(email: true)
       montant(min: 0.0)
       code(matches: /[A-Z0-9]{3,10}/)
   }
   ```

2. **Permissions**
   ```groovy
   static accessControl = {
       permission(perm: new EtudePerm('Entity', ['Action']))
   }
   ```

3. **Échappement dans les Vues**
   ```gsp
   <g:fieldValue bean="${instance}" field="description"/>
   <!-- Au lieu de ${instance.description} -->
   ```

4. **Prévention SQL Injection**
   ```groovy
   // BON
   Client.findAllByNom(params.nom)
   
   // MAUVAIS
   Client.executeQuery("SELECT * FROM client WHERE nom = '${params.nom}'")
   ```

## Processus de Pull Request

### Template de Pull Request

Utilisez ce template pour vos PR :

```markdown
## Description
Brève description des changements apportés.

## Type de Changement
- [ ] 🐛 Bug fix (correction de bug)
- [ ] ✨ Nouvelle fonctionnalité
- [ ] 📚 Documentation
- [ ] 🎨 Style/UI
- [ ] ♻️ Refactoring
- [ ] 🧪 Tests
- [ ] 🔧 Configuration

## Motivation et Contexte
Pourquoi ce changement est-il nécessaire ? Quel problème résout-il ?

Fixes #(numéro de l'issue)

## Comment Tester
Étapes pour tester les changements :
1. ...
2. ...
3. ...

## Captures d'Écran (si applicable)
Ajoutez des captures d'écran pour les changements UI.

## Checklist
- [ ] Mon code suit les standards du projet
- [ ] J'ai effectué une auto-revue de mon code
- [ ] J'ai commenté les parties complexes
- [ ] J'ai mis à jour la documentation
- [ ] Mes changements ne génèrent pas de nouveaux warnings
- [ ] J'ai ajouté des tests qui prouvent que ma correction fonctionne
- [ ] Les tests unitaires passent localement
- [ ] J'ai vérifié qu'il n'y a pas de régressions

## Environnement de Test
- OS: Ubuntu 20.04
- Java: OpenJDK 11
- PostgreSQL: 13.8
- Navigateur: Chrome 120
```

### Processus de Revue

1. **Soumission de la PR**
   - Remplir le template
   - Lier l'issue concernée
   - Assigner des reviewers

2. **Revue de Code**
   - Un ou plusieurs mainteneurs examineront le code
   - Des commentaires/suggestions seront faits
   - Des modifications peuvent être demandées

3. **Modifications**
   - Apporter les changements demandés
   - Répondre aux commentaires
   - Push les commits additionnels

4. **Approbation**
   - La PR est approuvée par les mainteneurs
   - Les tests CI passent (quand configurés)

5. **Merge**
   - La PR est fusionnée dans main
   - Votre contribution est intégrée !

## Tests

### Écrire des Tests

#### Test Unitaire d'un Service

```groovy
// test/unit/ExempleServiceTests.groovy
@TestFor(ExempleService)
@Mock([Exemple])
class ExempleServiceTests {
    
    void testCreerExemple() {
        def result = service.creerExemple("Test", "Description test")
        
        assertNotNull(result)
        assertEquals("Test", result.nom)
        assertEquals(1, Exemple.count())
    }
    
    void testRechercherExemples() {
        new Exemple(nom: "Test 1", description: "Desc 1").save()
        new Exemple(nom: "Test 2", description: "Desc 2").save()
        new Exemple(nom: "Autre", description: "Desc 3").save()
        
        def resultats = service.rechercherExemples("Test")
        
        assertEquals(2, resultats.size())
    }
}
```

#### Test d'Intégration

```groovy
// test/integration/ExempleIntegrationTests.groovy
class ExempleIntegrationTests extends GroovyTestCase {
    
    def exempleService
    
    void testCreationEtRecherche() {
        def exemple = exempleService.creerExemple("Integration Test", "Test")
        
        assertNotNull(exemple.id)
        
        def resultats = exempleService.rechercherExemples("Integration")
        assertTrue(resultats.contains(exemple))
    }
}
```

### Lancer les Tests

```bash
# Tous les tests
grails test-app

# Tests unitaires seulement
grails test-app unit:

# Tests d'intégration seulement
grails test-app integration:

# Tests d'un contrôleur spécifique
grails test-app DossierController
```

## Documentation

### Documenter le Code

#### Commentaires de Classe

```groovy
/**
 * Service de gestion des dossiers notariés.
 * 
 * Gère la création, modification et recherche de dossiers.
 * Implémente la logique métier complexe liée aux dossiers.
 * 
 * @author Votre Nom
 * @since 1.0
 */
class DossierService {
    // ...
}
```

#### Commentaires de Méthode

```groovy
/**
 * Crée un nouveau dossier à partir d'un modèle.
 * 
 * @param modeleId ID du dossier modèle
 * @param libelle Libellé du nouveau dossier
 * @param operation Opération parente
 * @return Le nouveau dossier créé
 * @throws IllegalArgumentException si le modèle n'existe pas
 */
def creerDepuisModele(Long modeleId, String libelle, Operation operation) {
    // ...
}
```

### Documenter les API

Si vous créez des endpoints REST :

```groovy
/**
 * API REST pour la gestion des clients.
 * 
 * GET /api/clients - Liste tous les clients
 * GET /api/clients/{id} - Récupère un client
 * POST /api/clients - Crée un client
 * PUT /api/clients/{id} - Met à jour un client
 * DELETE /api/clients/{id} - Supprime un client
 */
```

## Code de Conduite

### Nos Engagements

En tant que contributeurs et mainteneurs, nous nous engageons à :
- Créer un environnement accueillant et inclusif
- Respecter les points de vue différents
- Accepter les critiques constructives
- Se concentrer sur ce qui est meilleur pour la communauté
- Faire preuve d'empathie envers les autres

### Standards

#### Comportements Encouragés ✅

- Langage accueillant et inclusif
- Respect des points de vue différents
- Acceptation gracieuse des critiques
- Focus sur ce qui est bon pour la communauté
- Empathie envers les autres membres

#### Comportements Inacceptables ❌

- Langage ou images sexualisés
- Commentaires insultants ou dérogatoires
- Harcèlement public ou privé
- Publication d'informations privées sans permission
- Tout comportement inapproprié en milieu professionnel

### Application

Les mainteneurs ont le droit de :
- Retirer, éditer ou rejeter des contributions
- Bannir temporairement ou définitivement tout contributeur

## Reconnaissance

### Contributeurs

Tous les contributeurs seront mentionnés dans :
- Le fichier CONTRIBUTORS.md (à créer)
- Les release notes
- La page GitHub du projet

### Entreprises Partenaires

Les entreprises IT contributrices peuvent être listées comme :
- Partenaires officiels
- Support providers
- Services d'intégration

## Questions ?

Pour toute question sur la contribution :

➡️ **[Ouvrir une Issue](https://github.com/OpenEtude/Webapp/issues/new)** avec le label `question`

ou consulter **[SUPPORT.md](./SUPPORT.md)**

---

**Merci de contribuer à OpenEtude ! Ensemble, construisons la meilleure solution pour les notaires marocains. 🇲🇦**

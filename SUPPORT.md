# Support et Aide OpenEtude

Ce document explique comment obtenir de l'aide et du support pour OpenEtude.

## 🎯 Canal de Support Officiel

### GitHub Issues - Canal Exclusif

**OpenEtude utilise exclusivement GitHub Issues pour le support.**

➡️ **[Créer une Issue](https://github.com/OpenEtude/Webapp/issues/new)**

➡️ **[Voir les Issues Existantes](https://github.com/OpenEtude/Webapp/issues)**

### Pourquoi GitHub Issues ?

✅ **Transparence** : Toutes les questions et réponses sont publiques et consultables par tous

✅ **Traçabilité** : Historique complet des problèmes et solutions

✅ **Collaboration** : La communauté peut participer aux discussions et solutions

✅ **Documentation** : Les issues résolues servent de documentation

✅ **Recherche** : Moteur de recherche intégré pour trouver des solutions existantes

✅ **Notifications** : Système de notification automatique

## 📝 Avant de Créer une Issue

### 1. Rechercher les Issues Existantes

Votre problème a peut-être déjà été résolu :

1. Aller sur [Issues](https://github.com/OpenEtude/Webapp/issues)
2. Utiliser la barre de recherche
3. Essayer différents mots-clés
4. Vérifier les issues fermées aussi (`is:closed`)

**Exemple de recherches** :
- `installation postgres` - Problèmes d'installation PostgreSQL
- `erreur connexion` - Erreurs de connexion
- `label:bug` - Tous les bugs signalés
- `label:question` - Toutes les questions

### 2. Vérifier la Documentation

Consultez d'abord la documentation :
- [README.md](./README.md) - Vue d'ensemble et fonctionnalités
- [INSTALLATION.md](./INSTALLATION.md) - Guide d'installation complet
- [ARCHITECTURE.md](./ARCHITECTURE.md) - Architecture technique

## 🎫 Créer une Issue

### Types d'Issues

#### 🐛 Bug Report (Rapport de Bug)

Pour signaler un dysfonctionnement de l'application.

**Modèle** :

```markdown
**Description du Bug**
Une description claire et concise du bug.

**Étapes pour Reproduire**
1. Aller sur '...'
2. Cliquer sur '...'
3. Scroller jusqu'à '...'
4. Voir l'erreur

**Comportement Attendu**
Ce qui devrait normalement se passer.

**Comportement Actuel**
Ce qui se passe réellement.

**Captures d'Écran**
Si applicable, ajouter des captures d'écran.

**Environnement**
 - OS: [ex: Ubuntu 22.04]
 - Version Java: [ex: OpenJDK 11]
 - Version PostgreSQL: [ex: 13.8]
 - Version OpenEtude: [ex: v22]
 - Navigateur: [ex: Chrome 120]

**Logs**
```
Coller ici les logs d'erreur pertinents
```

**Informations Additionnelles**
Tout autre contexte utile.
```

#### ✨ Feature Request (Demande de Fonctionnalité)

Pour proposer une nouvelle fonctionnalité.

**Modèle** :

```markdown
**Description de la Fonctionnalité**
Une description claire de la fonctionnalité souhaitée.

**Problème à Résoudre**
Quel problème cette fonctionnalité résout-elle ?

**Solution Proposée**
Comment imaginez-vous cette fonctionnalité ?

**Alternatives Considérées**
Avez-vous pensé à d'autres solutions ?

**Public Cible**
Qui bénéficierait de cette fonctionnalité ?
- [ ] Notaires
- [ ] Assistants
- [ ] Comptables
- [ ] Administrateurs IT

**Priorité Estimée**
- [ ] Critique
- [ ] Haute
- [ ] Moyenne
- [ ] Basse

**Informations Additionnelles**
Contexte, exemples, maquettes...
```

#### ❓ Question

Pour poser une question sur l'utilisation ou la configuration.

**Modèle** :

```markdown
**Votre Question**
Posez votre question de manière claire.

**Contexte**
Que tentez-vous de faire ?

**Ce que Vous Avez Essayé**
Quelles solutions avez-vous déjà tentées ?

**Environnement**
 - Type d'installation: [Docker / VPS / AWS Lightsail]
 - OS: [ex: Ubuntu 20.04]
 - Version OpenEtude: [ex: v22]

**Documentation Consultée**
Quelles pages de documentation avez-vous consultées ?
```

#### 📚 Documentation

Pour signaler un problème ou proposer une amélioration de la documentation.

**Modèle** :

```markdown
**Type**
- [ ] Erreur dans la documentation
- [ ] Documentation manquante
- [ ] Amélioration de la documentation
- [ ] Traduction

**Page Concernée**
Lien ou nom de la page de documentation.

**Problème / Suggestion**
Décrivez le problème ou la suggestion.

**Correction Proposée** (optionnel)
Si vous savez comment corriger ou améliorer.
```

### Labels

Les mainteneurs ajouteront des labels appropriés :

| Label | Description |
|-------|-------------|
| `bug` | Dysfonctionnement confirmé |
| `enhancement` | Nouvelle fonctionnalité |
| `question` | Question d'utilisation |
| `documentation` | Concerne la documentation |
| `help wanted` | Aide bienvenue de la communauté |
| `good first issue` | Bon pour débuter la contribution |
| `installation` | Problème d'installation |
| `performance` | Problème de performance |
| `security` | Problème de sécurité |
| `duplicate` | Issue dupliquée |
| `wontfix` | Ne sera pas corrigé |
| `invalid` | Issue invalide |

## 🚨 Problèmes de Sécurité

### Signalement Responsable

**Pour les failles de sécurité, ne créez PAS d'issue publique.**

À la place :

1. **Envoyer un email privé** aux mainteneurs (adresse à définir)
2. **Inclure** :
   - Description de la vulnérabilité
   - Étapes pour la reproduire
   - Impact potentiel
   - Version affectée
3. **Attendre** une réponse avant de divulguer publiquement

### Mises à Jour de Sécurité

Les correctifs de sécurité seront :
- Publiés rapidement
- Documentés dans les release notes
- Annoncés dans les issues

## 💬 Communauté

### Bonnes Pratiques

#### ✅ À Faire

- 📝 Être clair et précis
- 🔍 Chercher avant de poser
- 📊 Fournir des détails (logs, captures d'écran)
- 🤝 Être respectueux et professionnel
- ✏️ Utiliser un français correct
- 🏷️ Proposer des labels appropriés
- 📌 Suivre votre issue (activer les notifications)
- ✔️ Fermer votre issue quand elle est résolue
- 👍 Remercier ceux qui vous aident

#### ❌ À Éviter

- 🚫 Créer des doublons sans chercher
- 😡 Être agressif ou irrespectueux
- 📧 Envoyer des emails privés pour du support
- 💬 Utiliser d'autres canaux (réseaux sociaux, forums externes)
- 🔴 Marquer tout en "urgent" ou "critique"
- 📝 Créer des issues vagues sans détails
- 🔄 Relancer toutes les heures
- 🌍 Mélanger plusieurs problèmes dans une seule issue

### Temps de Réponse

⏱️ **Estimation** :
- Questions simples : 24-48h
- Bugs : 2-7 jours
- Features : Variable

⚠️ **Note** : OpenEtude est un projet open source. Les temps de réponse dépendent de la disponibilité des contributeurs.

### Contribuer aux Réponses

Vous pouvez aider la communauté en :
- Répondant aux questions que vous connaissez
- Reproduisant des bugs signalés
- Proposant des solutions
- Améliorant la documentation

## 🔧 Support Commercial

### Pour les Entreprises IT Marocaines

Si vous êtes une entreprise IT marocaine et souhaitez :
- 🛠️ **Support prioritaire**
- 🎨 **Personnalisations spécifiques**
- 🏢 **Installation sur site**
- 📚 **Formation**
- 🔐 **Audit de sécurité**
- ⚙️ **Maintenance**

Vous pouvez :
1. Contribuer au projet (voir [CONTRIBUTING.md](./CONTRIBUTING.md))
2. Proposer vos services via une issue avec le label `service-provider`

## 📖 Ressources Utiles

### Documentation

- **[README.md](./README.md)** - Vue d'ensemble
- **[INSTALLATION.md](./INSTALLATION.md)** - Installation complète
- **[ARCHITECTURE.md](./ARCHITECTURE.md)** - Architecture technique
- **[CONTRIBUTING.md](./CONTRIBUTING.md)** - Guide de contribution

### Liens Externes

- **[Grails Documentation](https://grails.org/documentation.html)** - Framework Grails
- **[PostgreSQL Docs](https://www.postgresql.org/docs/)** - Documentation PostgreSQL
- **[Docker Docs](https://docs.docker.com/)** - Documentation Docker
- **[AWS Lightsail](https://aws.amazon.com/lightsail/)** - Hébergement recommandé

### Exemples d'Issues

Consultez ces issues pour voir des exemples :
- [#1](https://github.com/OpenEtude/Webapp/issues/1) - Exemple de bug report (à créer)
- [#2](https://github.com/OpenEtude/Webapp/issues/2) - Exemple de feature request (à créer)
- [#3](https://github.com/OpenEtude/Webapp/issues/3) - Exemple de question (à créer)

## 📊 Statistiques et Métriques

Vous pouvez suivre l'activité du projet :
- **Issues ouvertes** : [Issues actives](https://github.com/OpenEtude/Webapp/issues?q=is%3Aissue+is%3Aopen)
- **Issues fermées** : [Issues résolues](https://github.com/OpenEtude/Webapp/issues?q=is%3Aissue+is%3Aclosed)
- **Pull Requests** : [PRs](https://github.com/OpenEtude/Webapp/pulls)
- **Contributeurs** : [Contributors](https://github.com/OpenEtude/Webapp/graphs/contributors)

## 🤝 Contribuer

Au-delà du support, vous pouvez contribuer au projet :
- 🐛 Corriger des bugs
- ✨ Développer de nouvelles fonctionnalités
- 📚 Améliorer la documentation
- 🌍 Traduire l'interface
- 🧪 Écrire des tests
- 🎨 Améliorer l'UX/UI

Voir [CONTRIBUTING.md](./CONTRIBUTING.md) pour plus de détails.

## 📜 Code de Conduite

En participant aux discussions :
- Respectez les autres utilisateurs
- Restez professionnel
- Concentrez-vous sur les problèmes techniques
- Acceptez les critiques constructives
- Aidez à créer un environnement accueillant

## 🎓 Formation

### Pour les Notaires

Des ressources de formation sont en préparation :
- Guides d'utilisation par fonctionnalité
- Vidéos tutoriels
- FAQ par métier

### Pour les Développeurs

Pour contribuer au développement :
- Architecture détaillée : [ARCHITECTURE.md](./ARCHITECTURE.md)
- Guide de contribution : [CONTRIBUTING.md](./CONTRIBUTING.md)
- Documentation du code source

---

## Résumé

🎯 **Une seule règle** : Utilisez [GitHub Issues](https://github.com/OpenEtude/Webapp/issues) pour tout support !

📧 **Pas d'emails**
💬 **Pas de messages privés**
🌐 **Pas de forums externes**

✅ **Seulement GitHub Issues** ✅

---

**Merci de faire partie de la communauté OpenEtude ! 🇲🇦**

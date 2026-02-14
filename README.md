# Sujet Examen -- Application SwiftUI

## Informations

| Catégorie | Valeur |
|-----------|--------|
| **Auteurs** | MUHIRWA GABO Oreste |
| **Xcode** | 17.x |
| **Langage** | Swift 5 (SwiftUI) |
| **Architecture** | MVVM |

---

## Architecture

L'application suit le modèle **MVVM**, séparant clairement les différentes responsabilités :

- **Models** : structures de données (`Book.swift`)  
- **Services** : accès API Gutendex (`BookService.swift`)  
- **ViewModels** : gestion d'état et logique d'affichage (`BookViewModel`, `FavoritesViewModel`)  
- **Views** : interface utilisateur (`AllBooksView`, `BookDetailView`, `FavoritesView`, etc.)

Le flux de données est **unidirectionnel** :  
```
View → ViewModel → Service → ViewModel → View
```

---

## Filtrage par Bookshelves

L'application inclut une fonctionnalité de **filtrage avancé** permettant d'affiner l'affichage des livres selon leurs catégories (bookshelves).

### Fonctionnalités principales :

- Extraction automatique des catégories depuis les livres chargés  
- Sélection / désélection par catégorie  
- Bouton **Sélectionner Tout / Désélectionner Tout**  
- Indicateur du nombre de catégories actives  
- Filtrage appliqué en temps réel sur la liste des livres  
- Bouton **Reload Books** pour forcer un rechargement des données en cas d'erreur API  

> Cette amélioration rend la navigation plus rapide, claire et personnalisable.

---

## Usage

1. Ouvrir le projet dans **Xcode 17.x**  
2. Compiler et lancer l'application sur un simulateur ou un appareil réel  
3. Explorer les livres, appliquer des filtres et gérer vos favoris  

---

## Notes

- L'application utilise l'API **Gutendex** pour récupérer les livres  
- L'architecture MVVM garantit une séparation claire entre UI, logique métier et accès aux données  
- Le filtrage en temps réel améliore l'expérience utilisateur et permet une navigation intuitive


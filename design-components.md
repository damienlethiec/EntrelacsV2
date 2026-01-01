# Composants Tailwind UI - Entrelacs

Templates de référence pour le développement. Adapter les couleurs `indigo` vers `tisseurs-teal` et `tisseurs-coral`.

---

## Sign In Form (Authentication)

```html
<div class="flex min-h-full flex-col justify-center px-6 py-12 lg:px-8">
  <div class="sm:mx-auto sm:w-full sm:max-w-sm">
    <img src="/logo.png" alt="Entrelacs" class="mx-auto h-12 w-auto" />
    <h2 class="mt-10 text-center text-2xl/9 font-bold tracking-tight text-gray-900">Connexion</h2>
  </div>

  <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
    <form class="space-y-6">
      <div>
        <label for="email" class="block text-sm/6 font-medium text-gray-900">Email</label>
        <div class="mt-2">
          <input id="email" type="email" required autocomplete="email"
            class="block w-full rounded-md bg-white px-3 py-1.5 text-base text-gray-900 outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-tisseurs-teal sm:text-sm/6" />
        </div>
      </div>

      <div>
        <div class="flex items-center justify-between">
          <label for="password" class="block text-sm/6 font-medium text-gray-900">Mot de passe</label>
          <div class="text-sm">
            <a href="#" class="font-semibold text-tisseurs-teal hover:text-tisseurs-teal-dark">Mot de passe oublié ?</a>
          </div>
        </div>
        <div class="mt-2">
          <input id="password" type="password" required autocomplete="current-password"
            class="block w-full rounded-md bg-white px-3 py-1.5 text-base text-gray-900 outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-tisseurs-teal sm:text-sm/6" />
        </div>
      </div>

      <div>
        <button type="submit"
          class="flex w-full justify-center rounded-md bg-tisseurs-teal px-3 py-1.5 text-sm/6 font-semibold text-white shadow-xs hover:bg-tisseurs-teal-dark focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-tisseurs-teal">
          Se connecter
        </button>
      </div>
    </form>

    <p class="mt-10 text-center text-sm/6 text-gray-500">
      <a href="#" class="font-semibold text-tisseurs-teal hover:text-tisseurs-teal-dark">Retour à la connexion</a>
    </p>
  </div>
</div>
```

---

## Layout (Navbar)

```html
<div class="min-h-full">
  <nav class="border-b border-gray-200 bg-white dark:border-white/10 dark:bg-gray-900">
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
      <div class="flex h-16 justify-between">
        <div class="flex">
          <div class="flex shrink-0 items-center">
            <img src="/logo.png" alt="Entrelacs" class="h-8 w-auto" />
          </div>
          <div class="hidden sm:-my-px sm:ml-6 sm:flex sm:space-x-8">
            <!-- Current: "border-tisseurs-teal text-gray-900", Default: "border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700" -->
            <a href="#" class="inline-flex items-center border-b-2 border-tisseurs-teal px-1 pt-1 text-sm font-medium text-gray-900">Dashboard</a>
            <a href="#" class="inline-flex items-center border-b-2 border-transparent px-1 pt-1 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700">Résidences</a>
            <a href="#" class="inline-flex items-center border-b-2 border-transparent px-1 pt-1 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700">Utilisateurs</a>
          </div>
        </div>
        <div class="hidden sm:ml-6 sm:flex sm:items-center">
          <!-- Profile dropdown -->
          <div class="relative ml-3">
            <button class="relative flex max-w-xs items-center rounded-full focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-tisseurs-teal">
              <span class="sr-only">Open user menu</span>
              <span class="inline-flex size-8 items-center justify-center rounded-full bg-tisseurs-teal">
                <span class="text-sm font-medium text-white">JD</span>
              </span>
            </button>
          </div>
        </div>
      </div>
    </div>
  </nav>

  <div class="py-10">
    <header>
      <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <h1 class="text-3xl font-bold tracking-tight text-gray-900">Page Title</h1>
      </div>
    </header>
    <main>
      <div class="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
        <!-- Content -->
      </div>
    </main>
  </div>
</div>
```

---

## Formulaire

```html
<form>
  <div class="space-y-12">
    <div class="border-b border-gray-900/10 pb-12">
      <h2 class="text-base/7 font-semibold text-gray-900">Section Title</h2>
      <p class="mt-1 text-sm/6 text-gray-600">Description de la section.</p>

      <div class="mt-10 grid grid-cols-1 gap-x-6 gap-y-8 sm:grid-cols-6">
        <!-- Text input -->
        <div class="sm:col-span-3">
          <label for="first-name" class="block text-sm/6 font-medium text-gray-900">Prénom</label>
          <div class="mt-2">
            <input type="text" name="first-name" id="first-name" class="block w-full rounded-md bg-white px-3 py-1.5 text-base text-gray-900 outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-tisseurs-teal sm:text-sm/6" />
          </div>
        </div>

        <!-- Textarea -->
        <div class="col-span-full">
          <label for="description" class="block text-sm/6 font-medium text-gray-900">Description</label>
          <div class="mt-2">
            <textarea id="description" name="description" rows="3" class="block w-full rounded-md bg-white px-3 py-1.5 text-base text-gray-900 outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-tisseurs-teal sm:text-sm/6"></textarea>
          </div>
        </div>

        <!-- Select -->
        <div class="sm:col-span-3">
          <label for="role" class="block text-sm/6 font-medium text-gray-900">Rôle</label>
          <div class="mt-2 grid grid-cols-1">
            <select id="role" name="role" class="col-start-1 row-start-1 w-full appearance-none rounded-md bg-white py-1.5 pr-8 pl-3 text-base text-gray-900 outline-1 -outline-offset-1 outline-gray-300 focus:outline-2 focus:-outline-offset-2 focus:outline-tisseurs-teal sm:text-sm/6">
              <option>Admin</option>
              <option>Tisseur</option>
            </select>
          </div>
        </div>

        <!-- Checkbox -->
        <div class="col-span-full">
          <div class="flex gap-3">
            <div class="flex h-6 shrink-0 items-center">
              <input id="notify" type="checkbox" name="notify" class="size-4 rounded-sm border-gray-300 text-tisseurs-teal focus:ring-tisseurs-teal" />
            </div>
            <div class="text-sm/6">
              <label for="notify" class="font-medium text-gray-900">Informer les habitants</label>
              <p class="text-gray-500">Un email sera envoyé aux habitants de la résidence.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="mt-6 flex items-center justify-end gap-x-6">
    <button type="button" class="text-sm/6 font-semibold text-gray-900">Annuler</button>
    <button type="submit" class="rounded-md bg-tisseurs-teal px-3 py-2 text-sm font-semibold text-white shadow-xs hover:bg-tisseurs-teal-dark focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-tisseurs-teal">Enregistrer</button>
  </div>
</form>
```

---

## Show (Description List)

```html
<div>
  <div class="px-4 sm:px-0">
    <h3 class="text-base/7 font-semibold text-gray-900">Détails de l'activité</h3>
    <p class="mt-1 max-w-2xl text-sm/6 text-gray-500">Informations complètes.</p>
  </div>
  <div class="mt-6 border-t border-gray-100">
    <dl class="divide-y divide-gray-100">
      <div class="px-4 py-6 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-0">
        <dt class="text-sm/6 font-medium text-gray-900">Type</dt>
        <dd class="mt-1 text-sm/6 text-gray-700 sm:col-span-2 sm:mt-0">Repas partagé</dd>
      </div>
      <div class="px-4 py-6 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-0">
        <dt class="text-sm/6 font-medium text-gray-900">Description</dt>
        <dd class="mt-1 text-sm/6 text-gray-700 sm:col-span-2 sm:mt-0">Lorem ipsum dolor sit amet.</dd>
      </div>
      <div class="px-4 py-6 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-0">
        <dt class="text-sm/6 font-medium text-gray-900">Date</dt>
        <dd class="mt-1 text-sm/6 text-gray-700 sm:col-span-2 sm:mt-0">17 mars 2025, 12h00</dd>
      </div>
    </dl>
  </div>
</div>
```

---

## Stats Cards

```html
<div class="bg-white">
  <div class="mx-auto max-w-7xl">
    <div class="grid grid-cols-1 gap-px bg-gray-900/5 sm:grid-cols-2 lg:grid-cols-4">
      <div class="bg-white px-4 py-6 sm:px-6 lg:px-8">
        <p class="text-sm/6 font-medium text-gray-500">Activités complétées</p>
        <p class="mt-2 flex items-baseline gap-x-2">
          <span class="text-4xl font-semibold tracking-tight text-gray-900">42</span>
        </p>
      </div>
      <div class="bg-white px-4 py-6 sm:px-6 lg:px-8">
        <p class="text-sm/6 font-medium text-gray-500">Participants</p>
        <p class="mt-2 flex items-baseline gap-x-2">
          <span class="text-4xl font-semibold tracking-tight text-gray-900">328</span>
        </p>
      </div>
      <div class="bg-white px-4 py-6 sm:px-6 lg:px-8">
        <p class="text-sm/6 font-medium text-gray-500">Moyenne participants</p>
        <p class="mt-2 flex items-baseline gap-x-2">
          <span class="text-4xl font-semibold tracking-tight text-gray-900">7.8</span>
        </p>
      </div>
      <div class="bg-white px-4 py-6 sm:px-6 lg:px-8">
        <p class="text-sm/6 font-medium text-gray-500">Médiane</p>
        <p class="mt-2 flex items-baseline gap-x-2">
          <span class="text-4xl font-semibold tracking-tight text-gray-900">6</span>
        </p>
      </div>
    </div>
  </div>
</div>
```

---

## Boutons

```html
<!-- Primary -->
<button type="button" class="rounded-md bg-tisseurs-teal px-3 py-2 text-sm font-semibold text-white shadow-xs hover:bg-tisseurs-teal-dark focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-tisseurs-teal">
  Créer
</button>

<!-- Secondary -->
<button type="button" class="rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-xs ring-1 ring-inset ring-gray-300 hover:bg-gray-50">
  Annuler
</button>

<!-- Danger -->
<button type="button" class="rounded-md bg-tisseurs-coral px-3 py-2 text-sm font-semibold text-white shadow-xs hover:bg-tisseurs-coral-dark focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-tisseurs-coral">
  Supprimer
</button>

<!-- Small -->
<button type="button" class="rounded-sm bg-tisseurs-teal px-2 py-1 text-xs font-semibold text-white shadow-xs hover:bg-tisseurs-teal-dark">
  Petit
</button>
```

---

## Liste avec actions

```html
<ul role="list" class="divide-y divide-gray-100">
  <li class="flex items-center justify-between gap-x-6 py-5">
    <div class="min-w-0">
      <div class="flex items-start gap-x-3">
        <p class="text-sm/6 font-semibold text-gray-900">Repas partagé</p>
        <p class="mt-0.5 rounded-md bg-green-50 px-1.5 py-0.5 text-xs font-medium text-green-700 ring-1 ring-inset ring-green-600/20">Complété</p>
      </div>
      <div class="mt-1 flex items-center gap-x-2 text-xs/5 text-gray-500">
        <p class="whitespace-nowrap">17 mars 2025</p>
        <svg viewBox="0 0 2 2" class="size-0.5 fill-current">
          <circle r="1" cx="1" cy="1" />
        </svg>
        <p class="truncate">12 participants</p>
      </div>
    </div>
    <div class="flex flex-none items-center gap-x-4">
      <a href="#" class="hidden rounded-md bg-white px-2.5 py-1.5 text-sm font-semibold text-gray-900 shadow-xs ring-1 ring-inset ring-gray-300 hover:bg-gray-50 sm:block">
        Voir
      </a>
    </div>
  </li>
</ul>
```

---

## Badges de statut

```html
<!-- Planned -->
<span class="inline-flex items-center rounded-md bg-blue-50 px-2 py-1 text-xs font-medium text-blue-700 ring-1 ring-inset ring-blue-700/10">
  Planifié
</span>

<!-- Completed -->
<span class="inline-flex items-center rounded-md bg-green-50 px-2 py-1 text-xs font-medium text-green-700 ring-1 ring-inset ring-green-600/20">
  Complété
</span>

<!-- Canceled -->
<span class="inline-flex items-center rounded-md bg-red-50 px-2 py-1 text-xs font-medium text-red-700 ring-1 ring-inset ring-red-600/10">
  Annulé
</span>

<!-- In progress (for activities to complete) -->
<span class="inline-flex items-center rounded-md bg-yellow-50 px-2 py-1 text-xs font-medium text-yellow-800 ring-1 ring-inset ring-yellow-600/20">
  À compléter
</span>
```

---

## Formulaire inline (complétion activité)

```html
<div class="rounded-lg border border-yellow-200 bg-yellow-50 p-4">
  <div class="flex items-start justify-between">
    <div>
      <h4 class="text-sm font-medium text-gray-900">Repas partagé - 15 mars 2025</h4>
      <p class="mt-1 text-sm text-gray-500">Cette activité est passée et attend d'être complétée.</p>
    </div>
  </div>
  <form class="mt-4 flex flex-wrap items-end gap-4">
    <div>
      <label for="participants" class="block text-sm font-medium text-gray-700">Participants</label>
      <input type="number" name="participants" id="participants" min="0" class="mt-1 block w-24 rounded-md border-gray-300 shadow-sm focus:border-tisseurs-teal focus:ring-tisseurs-teal sm:text-sm" />
    </div>
    <div class="flex-1">
      <label for="review" class="block text-sm font-medium text-gray-700">Bilan</label>
      <input type="text" name="review" id="review" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-tisseurs-teal focus:ring-tisseurs-teal sm:text-sm" />
    </div>
    <button type="submit" class="rounded-md bg-tisseurs-teal px-3 py-2 text-sm font-semibold text-white shadow-xs hover:bg-tisseurs-teal-dark">
      Compléter
    </button>
  </form>
</div>
```

---

## Empty state

```html
<div class="text-center py-12">
  <svg class="mx-auto size-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
  </svg>
  <h3 class="mt-2 text-sm font-semibold text-gray-900">Aucune activité</h3>
  <p class="mt-1 text-sm text-gray-500">Commencez par créer une nouvelle activité.</p>
  <div class="mt-6">
    <a href="#" class="inline-flex items-center rounded-md bg-tisseurs-teal px-3 py-2 text-sm font-semibold text-white shadow-xs hover:bg-tisseurs-teal-dark">
      Nouvelle activité
    </a>
  </div>
</div>
```

---

## Header de page

```html
<div class="md:flex md:items-center md:justify-between">
  <div class="min-w-0 flex-1">
    <h2 class="text-2xl/7 font-bold text-gray-900 sm:truncate sm:text-3xl sm:tracking-tight">Activités</h2>
  </div>
  <div class="mt-4 flex md:mt-0 md:ml-4">
    <button type="button" class="inline-flex items-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-xs inset-ring inset-ring-gray-300 hover:bg-gray-50">Exporter</button>
    <a href="#" class="ml-3 inline-flex items-center rounded-md bg-tisseurs-teal px-3 py-2 text-sm font-semibold text-white shadow-xs hover:bg-tisseurs-teal-dark focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-tisseurs-teal">Nouvelle activité</a>
  </div>
</div>
```

---

## Tabs

```html
<div>
  <!-- Mobile -->
  <div class="grid grid-cols-1 sm:hidden">
    <select aria-label="Sélectionner un onglet" class="col-start-1 row-start-1 w-full appearance-none rounded-md bg-white py-2 pr-8 pl-3 text-base text-gray-900 outline-1 -outline-offset-1 outline-gray-300 focus:outline-2 focus:-outline-offset-2 focus:outline-tisseurs-teal">
      <option selected>À venir</option>
      <option>Passées</option>
    </select>
    <svg viewBox="0 0 16 16" fill="currentColor" aria-hidden="true" class="pointer-events-none col-start-1 row-start-1 mr-2 size-5 self-center justify-self-end fill-gray-500">
      <path d="M4.22 6.22a.75.75 0 0 1 1.06 0L8 8.94l2.72-2.72a.75.75 0 1 1 1.06 1.06l-3.25 3.25a.75.75 0 0 1-1.06 0L4.22 7.28a.75.75 0 0 1 0-1.06Z" clip-rule="evenodd" fill-rule="evenodd" />
    </svg>
  </div>
  <!-- Desktop -->
  <div class="hidden sm:block">
    <div class="border-b border-gray-200">
      <nav aria-label="Tabs" class="-mb-px flex space-x-8">
        <!-- Current: "border-tisseurs-teal text-tisseurs-teal", Default: "border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700" -->
        <a href="#" aria-current="page" class="border-b-2 border-tisseurs-teal px-1 py-4 text-sm font-medium whitespace-nowrap text-tisseurs-teal">À venir</a>
        <a href="#" class="border-b-2 border-transparent px-1 py-4 text-sm font-medium whitespace-nowrap text-gray-500 hover:border-gray-300 hover:text-gray-700">Passées</a>
      </nav>
    </div>
  </div>
</div>
```

---

## Pagination (Pagy)

```html
<div class="flex items-center justify-between border-t border-gray-200 bg-white px-4 py-3 sm:px-6">
  <!-- Mobile -->
  <div class="flex flex-1 justify-between sm:hidden">
    <a href="#" class="relative inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50">Précédent</a>
    <a href="#" class="relative ml-3 inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50">Suivant</a>
  </div>
  <!-- Desktop -->
  <div class="hidden sm:flex sm:flex-1 sm:items-center sm:justify-between">
    <div>
      <p class="text-sm text-gray-700">
        Affichage de <span class="font-medium">1</span> à <span class="font-medium">20</span> sur <span class="font-medium">97</span> résultats
      </p>
    </div>
    <div>
      <nav aria-label="Pagination" class="isolate inline-flex -space-x-px rounded-md shadow-xs">
        <a href="#" class="relative inline-flex items-center rounded-l-md px-2 py-2 text-gray-400 inset-ring inset-ring-gray-300 hover:bg-gray-50 focus:z-20 focus:outline-offset-0">
          <span class="sr-only">Précédent</span>
          <svg viewBox="0 0 20 20" fill="currentColor" aria-hidden="true" class="size-5">
            <path d="M11.78 5.22a.75.75 0 0 1 0 1.06L8.06 10l3.72 3.72a.75.75 0 1 1-1.06 1.06l-4.25-4.25a.75.75 0 0 1 0-1.06l4.25-4.25a.75.75 0 0 1 1.06 0Z" clip-rule="evenodd" fill-rule="evenodd" />
          </svg>
        </a>
        <!-- Current: "z-10 bg-tisseurs-teal text-white", Default: "text-gray-900 inset-ring inset-ring-gray-300 hover:bg-gray-50" -->
        <a href="#" aria-current="page" class="relative z-10 inline-flex items-center bg-tisseurs-teal px-4 py-2 text-sm font-semibold text-white focus:z-20 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-tisseurs-teal">1</a>
        <a href="#" class="relative inline-flex items-center px-4 py-2 text-sm font-semibold text-gray-900 inset-ring inset-ring-gray-300 hover:bg-gray-50 focus:z-20 focus:outline-offset-0">2</a>
        <a href="#" class="relative hidden items-center px-4 py-2 text-sm font-semibold text-gray-900 inset-ring inset-ring-gray-300 hover:bg-gray-50 focus:z-20 focus:outline-offset-0 md:inline-flex">3</a>
        <span class="relative inline-flex items-center px-4 py-2 text-sm font-semibold text-gray-700 inset-ring inset-ring-gray-300 focus:outline-offset-0">...</span>
        <a href="#" class="relative inline-flex items-center px-4 py-2 text-sm font-semibold text-gray-900 inset-ring inset-ring-gray-300 hover:bg-gray-50 focus:z-20 focus:outline-offset-0">5</a>
        <a href="#" class="relative inline-flex items-center rounded-r-md px-2 py-2 text-gray-400 inset-ring inset-ring-gray-300 hover:bg-gray-50 focus:z-20 focus:outline-offset-0">
          <span class="sr-only">Suivant</span>
          <svg viewBox="0 0 20 20" fill="currentColor" aria-hidden="true" class="size-5">
            <path d="M8.22 5.22a.75.75 0 0 1 1.06 0l4.25 4.25a.75.75 0 0 1 0 1.06l-4.25 4.25a.75.75 0 0 1-1.06-1.06L11.94 10 8.22 6.28a.75.75 0 0 1 0-1.06Z" clip-rule="evenodd" fill-rule="evenodd" />
          </svg>
        </a>
      </nav>
    </div>
  </div>
</div>
```

---

## Flash messages (Toast)

```html
<!-- Placer à la fin du body -->
<div aria-live="assertive" class="pointer-events-none fixed inset-0 flex items-end px-4 py-6 sm:items-start sm:p-6">
  <div class="flex w-full flex-col items-center space-y-4 sm:items-end">

    <!-- Success -->
    <div class="pointer-events-auto w-full max-w-sm rounded-lg bg-white shadow-lg outline-1 outline-black/5">
      <div class="p-4">
        <div class="flex items-start">
          <div class="shrink-0">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" aria-hidden="true" class="size-6 text-green-400">
              <path d="M9 12.75 11.25 15 15 9.75M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" stroke-linecap="round" stroke-linejoin="round" />
            </svg>
          </div>
          <div class="ml-3 w-0 flex-1 pt-0.5">
            <p class="text-sm font-medium text-gray-900">Enregistré avec succès</p>
            <p class="mt-1 text-sm text-gray-500">L'activité a été créée.</p>
          </div>
          <div class="ml-4 flex shrink-0">
            <button type="button" class="inline-flex rounded-md text-gray-400 hover:text-gray-500 focus:outline-2 focus:outline-offset-2 focus:outline-tisseurs-teal">
              <span class="sr-only">Fermer</span>
              <svg viewBox="0 0 20 20" fill="currentColor" aria-hidden="true" class="size-5">
                <path d="M6.28 5.22a.75.75 0 0 0-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 1 0 1.06 1.06L10 11.06l3.72 3.72a.75.75 0 1 0 1.06-1.06L11.06 10l3.72-3.72a.75.75 0 0 0-1.06-1.06L10 8.94 6.28 5.22Z" />
              </svg>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Error -->
    <div class="pointer-events-auto w-full max-w-sm rounded-lg bg-white shadow-lg outline-1 outline-black/5">
      <div class="p-4">
        <div class="flex items-start">
          <div class="shrink-0">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" aria-hidden="true" class="size-6 text-red-400">
              <path d="M12 9v3.75m9-.75a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9 3.75h.008v.008H12v-.008Z" stroke-linecap="round" stroke-linejoin="round" />
            </svg>
          </div>
          <div class="ml-3 w-0 flex-1 pt-0.5">
            <p class="text-sm font-medium text-gray-900">Erreur</p>
            <p class="mt-1 text-sm text-gray-500">Impossible de sauvegarder les modifications.</p>
          </div>
          <div class="ml-4 flex shrink-0">
            <button type="button" class="inline-flex rounded-md text-gray-400 hover:text-gray-500">
              <span class="sr-only">Fermer</span>
              <svg viewBox="0 0 20 20" fill="currentColor" aria-hidden="true" class="size-5">
                <path d="M6.28 5.22a.75.75 0 0 0-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 1 0 1.06 1.06L10 11.06l3.72 3.72a.75.75 0 1 0 1.06-1.06L11.06 10l3.72-3.72a.75.75 0 0 0-1.06-1.06L10 8.94 6.28 5.22Z" />
              </svg>
            </button>
          </div>
        </div>
      </div>
    </div>

  </div>
</div>
```

---

## Modal de confirmation

Utilise `@tailwindplus/elements` ou implémentation Stimulus.

```html
<button command="show-modal" commandfor="confirm-dialog" class="rounded-md bg-tisseurs-coral px-3 py-2 text-sm font-semibold text-white shadow-xs hover:bg-tisseurs-coral-dark">
  Supprimer
</button>

<el-dialog>
  <dialog id="confirm-dialog" aria-labelledby="dialog-title" class="fixed inset-0 size-auto max-h-none max-w-none overflow-y-auto bg-transparent backdrop:bg-transparent">
    <el-dialog-backdrop class="fixed inset-0 bg-gray-500/75 transition-opacity data-closed:opacity-0 data-enter:duration-300 data-enter:ease-out data-leave:duration-200 data-leave:ease-in"></el-dialog-backdrop>

    <div tabindex="0" class="flex min-h-full items-end justify-center p-4 text-center focus:outline-none sm:items-center sm:p-0">
      <el-dialog-panel class="relative transform overflow-hidden rounded-lg bg-white px-4 pt-5 pb-4 text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg sm:p-6">
        <div class="sm:flex sm:items-start">
          <div class="mx-auto flex size-12 shrink-0 items-center justify-center rounded-full bg-red-100 sm:mx-0 sm:size-10">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" aria-hidden="true" class="size-6 text-red-600">
              <path d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z" stroke-linecap="round" stroke-linejoin="round" />
            </svg>
          </div>
          <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
            <h3 id="dialog-title" class="text-base font-semibold text-gray-900">Supprimer l'activité</h3>
            <div class="mt-2">
              <p class="text-sm text-gray-500">Êtes-vous sûr de vouloir supprimer cette activité ? Cette action est irréversible.</p>
            </div>
          </div>
        </div>
        <div class="mt-5 sm:mt-4 sm:flex sm:flex-row-reverse">
          <button type="button" command="close" commandfor="confirm-dialog" class="inline-flex w-full justify-center rounded-md bg-tisseurs-coral px-3 py-2 text-sm font-semibold text-white shadow-xs hover:bg-tisseurs-coral-dark sm:ml-3 sm:w-auto">Supprimer</button>
          <button type="button" command="close" commandfor="confirm-dialog" class="mt-3 inline-flex w-full justify-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-xs inset-ring-1 inset-ring-gray-300 hover:bg-gray-50 sm:mt-0 sm:w-auto">Annuler</button>
        </div>
      </el-dialog-panel>
    </div>
  </dialog>
</el-dialog>
```

---

## Dropdown menu

```html
<el-dropdown class="inline-block">
  <button class="inline-flex w-full justify-center gap-x-1.5 rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-xs inset-ring-1 inset-ring-gray-300 hover:bg-gray-50">
    Actions
    <svg viewBox="0 0 20 20" fill="currentColor" aria-hidden="true" class="-mr-1 size-5 text-gray-400">
      <path d="M5.22 8.22a.75.75 0 0 1 1.06 0L10 11.94l3.72-3.72a.75.75 0 1 1 1.06 1.06l-4.25 4.25a.75.75 0 0 1-1.06 0L5.22 9.28a.75.75 0 0 1 0-1.06Z" clip-rule="evenodd" fill-rule="evenodd" />
    </svg>
  </button>

  <el-menu anchor="bottom end" popover class="w-56 origin-top-right rounded-md bg-white shadow-lg outline-1 outline-black/5 transition [--anchor-gap:--spacing(2)]">
    <div class="py-1">
      <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 focus:bg-gray-100 focus:outline-hidden">Modifier</a>
      <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 focus:bg-gray-100 focus:outline-hidden">Dupliquer</a>
      <a href="#" class="block px-4 py-2 text-sm text-tisseurs-coral hover:bg-gray-100 focus:bg-gray-100 focus:outline-hidden">Supprimer</a>
    </div>
  </el-menu>
</el-dropdown>
```

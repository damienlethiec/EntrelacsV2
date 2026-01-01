# Composants Tailwind UI - Entrelacs

Templates de référence pour le développement. Adapter les couleurs `indigo` vers `tisseurs-teal` et `tisseurs-coral`.

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

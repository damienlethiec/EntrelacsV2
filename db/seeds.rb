# frozen_string_literal: true

puts "🧹 Nettoyage des données..."
Activity.destroy_all
Resident.destroy_all
User.destroy_all
Residence.destroy_all
puts "✓ Données nettoyées"

# Create admin user
admin = User.create!(
  email: "admin@entrelacs.fr",
  first_name: "Admin",
  last_name: "Entrelacs",
  phone: "0600000000",
  password: "password123",
  role: :admin
)
puts "✓ Admin créé: #{admin.email}"

# Create residences
residences_data = [
  {name: "Les Music'Halles", address: "15 rue de la Musique, 75010 Paris"},
  {name: "Le Jardin Partagé", address: "42 avenue des Fleurs, 69003 Lyon"},
  {name: "La Maison Solidaire", address: "8 place de la République, 33000 Bordeaux"},
  {name: "L'Escale Verte", address: "23 boulevard du Parc, 44000 Nantes"},
  {name: "Les Toits Bleus", address: "7 rue des Artisans, 31000 Toulouse"}
]

residences = residences_data.map do |data|
  residence = Residence.create!(name: data[:name], address: data[:address])
  puts "✓ Résidence créée: #{residence.name}"
  residence
end

# Create weavers for each residence
weavers_data = [
  {first_name: "Marie", last_name: "Dupont", email: "marie@entrelacs.fr", phone: "0612345678", residence: residences[0]},
  {first_name: "Jean", last_name: "Martin", email: "jean@entrelacs.fr", phone: "0623456789", residence: residences[1]},
  {first_name: "Sophie", last_name: "Bernard", email: "sophie@entrelacs.fr", phone: "0634567890", residence: residences[2]},
  {first_name: "Pierre", last_name: "Moreau", email: "pierre@entrelacs.fr", phone: "0645678901", residence: residences[3]},
  {first_name: "Claire", last_name: "Petit", email: "claire@entrelacs.fr", phone: "0656789012", residence: residences[4]}
]

weavers_data.map do |data|
  weaver = User.create!(
    email: data[:email],
    first_name: data[:first_name],
    last_name: data[:last_name],
    phone: data[:phone],
    password: "password123",
    role: :weaver,
    residence: data[:residence]
  )
  puts "✓ Tisseur créé: #{weaver.email} (#{weaver.residence.name})"
  weaver
end

# Create residents for each residence
puts "\n📋 Création des résidents..."
resident_first_names = %w[Alice Bruno Camille David Emma Fabien Helene Hugo Iris Jules Karim Lea Marcel Nina Oscar]
resident_last_names = %w[Leroy Roux Simon Laurent Michel Garcia Thomas Robert Richard Durand Petit Martin Bernard Dubois]

resident_notes = [
  "Participe régulièrement aux activités collectives.",
  "Préfère les activités en petit comité.",
  "Disponible le week-end uniquement.",
  "Aime cuisiner, propose souvent des plats.",
  "Musicien amateur, peut animer des soirées.",
  "A des contraintes de mobilité, prévoir accessibilité.",
  "Nouveau résident, en cours d'intégration.",
  "Très impliqué dans la vie de la résidence.",
  "Travaille en horaires décalés.",
  "A un chien, vérifier compatibilité animaux.",
  "Végétarien, à prendre en compte pour les repas.",
  "Parle anglais et espagnol couramment.",
  "Retraité, disponible en journée.",
  "Étudiant, budget limité.",
  nil, nil, nil # Certains résidents n'ont pas de notes
]

residences.each do |residence|
  # Générer des numéros d'appartement uniques pour cette résidence
  floors = rand(3..5)
  apartments_per_floor = rand(3..6)
  available_apartments = (1..floors).flat_map do |floor|
    (1..apartments_per_floor).map { |apt| "#{floor}#{apt.to_s.rjust(2, "0")}" }
  end.shuffle

  rand(8..15).times do |i|
    apartment = available_apartments[i] || "#{rand(1..5)}#{rand(1..10).to_s.rjust(2, "0")}"

    # 70% des résidents ont un email
    email = (rand < 0.7) ? "#{resident_first_names.sample.downcase}.#{resident_last_names.sample.downcase}#{rand(1..99)}@example.com" : nil

    # 80% des résidents ont un téléphone
    phone = (rand < 0.8) ? "06#{rand(10_000_000..99_999_999)}" : nil

    Resident.create!(
      first_name: resident_first_names.sample,
      last_name: resident_last_names.sample,
      email: email,
      phone: phone,
      apartment: apartment,
      notes: resident_notes.sample,
      residence: residence
    )
  end
  puts "✓ #{residence.residents.count} résidents pour #{residence.name}"
end

# Create activities for the last 6 months
puts "\n🎭 Création des activités passées..."

# Descriptions additionnelles par type d'activité
activity_descriptions = {
  "Repas partagé" => [
    "Repas de quartier",
    "Dîner thématique italien",
    "Brunch du dimanche",
    "Barbecue estival",
    "Soirée crêpes"
  ],
  "Atelier cuisine" => [
    "Cours de pâtisserie",
    "Recettes du monde",
    "Cuisine végétarienne",
    "Atelier pain maison"
  ],
  "Jeux de société" => [
    "Soirée jeux classiques",
    "Tournoi de cartes",
    "Jeux coopératifs",
    "Soirée quiz"
  ],
  "Café/thé" => [
    "Café du matin entre voisins",
    "Goûter convivial",
    "Petit-déjeuner partagé",
    "Pause café de l'après-midi"
  ],
  "Jardinage" => [
    "Plantation de saison",
    "Entretien du potager",
    "Atelier semis",
    "Récolte collective"
  ],
  "Bricolage" => [
    "Atelier réparation",
    "Fabrication d'objets",
    "Petit bricolage",
    "Atelier bois"
  ],
  "Sortie culturelle" => [
    "Sortie au musée",
    "Visite du quartier",
    "Balade en ville",
    "Sortie cinéma"
  ],
  "Sport/bien-être" => [
    "Séance de yoga",
    "Marche collective",
    "Gym douce",
    "Méditation"
  ],
  "Échange de savoirs" => [
    "Cours de langue",
    "Atelier informatique",
    "Partage de compétences",
    "Discussion thématique"
  ],
  "Réunion habitants" => [
    "Réunion mensuelle",
    "Assemblée générale",
    "Point d'information",
    "Organisation d'événement"
  ]
}

reviews = [
  "Très bonne ambiance, les résidents ont beaucoup apprécié.",
  "Belle participation, à renouveler !",
  "Succès total, tout le monde était ravi.",
  "Quelques ajustements à prévoir pour la prochaine fois.",
  "Moment convivial et chaleureux.",
  "Les nouveaux résidents ont pu faire connaissance.",
  "Activité appréciée malgré la météo.",
  "Format à garder, très apprécié.",
  "Bonne participation des habitants.",
  "Très agréable moment de partage."
]

total_activities = 0

residences.each do |residence|
  # Generate activities for the last 6 months
  (1..180).each do |days_ago|
    # Not every day has an activity (roughly 40% of days)
    next unless rand < 0.4

    # Some days have multiple activities
    activities_count = (rand < 0.2) ? 2 : 1

    activities_count.times do
      activity_type = Activity::SUGGESTED_TYPES.sample
      descriptions = activity_descriptions[activity_type] || [activity_type]

      # Random time slot
      hour = [9, 10, 11, 14, 15, 16, 17, 18, 19, 20].sample
      starts_at = days_ago.days.ago.change(hour: hour, min: [0, 15, 30, 45].sample)
      duration = [1, 1.5, 2, 2.5, 3].sample
      ends_at = starts_at + duration.hours

      # Participants: varies by activity type
      base_participants = case activity_type
      when "Repas partagé", "Sortie culturelle"
        rand(8..20)
      when "Café/thé", "Sport/bien-être"
        rand(4..10)
      when "Atelier cuisine", "Jardinage", "Bricolage"
        rand(3..8)
      else
        rand(5..15)
      end

      Activity.create!(
        residence: residence,
        activity_type: activity_type,
        description: descriptions.sample,
        starts_at: starts_at,
        ends_at: ends_at,
        status: :completed,
        participants_count: base_participants,
        notify_residents: false,
        review: reviews.sample
      )
      total_activities += 1
    end
  end
  puts "✓ #{residence.activities.count} activités pour #{residence.name}"
end

# Add a few upcoming activities (not completed)
puts "\n📅 Création des activités à venir..."
residences.each do |residence|
  rand(2..5).times do |i|
    activity_type = Activity::SUGGESTED_TYPES.sample
    descriptions = activity_descriptions[activity_type] || [activity_type]

    starts_at = (i + 1).days.from_now.change(hour: [14, 16, 18, 20].sample)

    Activity.create!(
      residence: residence,
      activity_type: activity_type,
      description: descriptions.sample,
      starts_at: starts_at,
      ends_at: starts_at + 2.hours,
      status: :planned,
      notify_residents: false
    )
  end
end

puts "\n" + "=" * 50
puts "🎉 Seeds terminés !"
puts "=" * 50
puts "\n📊 Statistiques:"
puts "   • #{Residence.count} résidences"
puts "   • #{User.count} utilisateurs (1 admin + #{User.weaver.count} tisseurs)"
puts "   • #{Resident.count} résidents"
puts "   • #{Activity.count} activités (#{Activity.completed.count} terminées)"
puts "\n🔐 Comptes de connexion:"
puts "   Admin: admin@entrelacs.fr / password123"
puts "   Tisseurs: marie@, jean@, sophie@, pierre@, claire@entrelacs.fr / password123"

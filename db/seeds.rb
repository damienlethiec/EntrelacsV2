# frozen_string_literal: true

# Create admin user
admin = User.find_or_create_by!(email: "admin@entrelacs.fr") do |user|
  user.first_name = "Admin"
  user.last_name = "Entrelacs"
  user.password = "password123"
  user.role = :admin
end
puts "Admin créé: #{admin.email}"

# Create residences
residences_data = [
  {name: "Les Music'Halles", address: "15 rue de la Musique, 75010 Paris"},
  {name: "Le Jardin Partagé", address: "42 avenue des Fleurs, 69003 Lyon"},
  {name: "La Maison Solidaire", address: "8 place de la République, 33000 Bordeaux"}
]

residences = residences_data.map do |data|
  residence = Residence.find_or_create_by!(name: data[:name]) do |r|
    r.address = data[:address]
  end
  puts "Résidence créée: #{residence.name}"
  residence
end

# Create weavers for each residence
weavers_data = [
  {first_name: "Marie", last_name: "Dupont", email: "marie@entrelacs.fr", residence: residences[0]},
  {first_name: "Jean", last_name: "Martin", email: "jean@entrelacs.fr", residence: residences[1]},
  {first_name: "Sophie", last_name: "Bernard", email: "sophie@entrelacs.fr", residence: residences[2]}
]

weavers_data.each do |data|
  weaver = User.find_or_create_by!(email: data[:email]) do |user|
    user.first_name = data[:first_name]
    user.last_name = data[:last_name]
    user.password = "password123"
    user.role = :weaver
    user.residence = data[:residence]
  end
  puts "Tisseur créé: #{weaver.email} (#{weaver.residence.name})"
end

puts "\n--- Seeds terminés ---"
puts "Admin: admin@entrelacs.fr / password123"
puts "Tisseurs: marie@entrelacs.fr, jean@entrelacs.fr, sophie@entrelacs.fr / password123"

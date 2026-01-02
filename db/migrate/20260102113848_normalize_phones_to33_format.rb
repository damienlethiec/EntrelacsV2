class NormalizePhonesTo33Format < ActiveRecord::Migration[8.1]
  def up
    # Convertir les téléphones Users: 0612345678 -> +33612345678
    execute <<-SQL
      UPDATE users
      SET phone = '+33' || SUBSTRING(phone FROM 2)
      WHERE phone IS NOT NULL
        AND phone ~ '^0[1-9][0-9]{8}$'
    SQL

    # Convertir les téléphones Residents: 0612345678 -> +33612345678
    execute <<-SQL
      UPDATE residents
      SET phone = '+33' || SUBSTRING(phone FROM 2)
      WHERE phone IS NOT NULL
        AND phone ~ '^0[1-9][0-9]{8}$'
    SQL
  end

  def down
    # Convertir les téléphones Users: +33612345678 -> 0612345678
    execute <<-SQL
      UPDATE users
      SET phone = '0' || SUBSTRING(phone FROM 4)
      WHERE phone IS NOT NULL
        AND phone ~ '^\\+33[1-9][0-9]{8}$'
    SQL

    # Convertir les téléphones Residents: +33612345678 -> 0612345678
    execute <<-SQL
      UPDATE residents
      SET phone = '0' || SUBSTRING(phone FROM 4)
      WHERE phone IS NOT NULL
        AND phone ~ '^\\+33[1-9][0-9]{8}$'
    SQL
  end
end

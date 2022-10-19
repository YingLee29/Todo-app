# frozen_string_literal: true

ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 0")
(ActiveRecord::Base.connection.tables - %w[schema_migrations]).each do |table_name|
  ActiveRecord::Base.connection.execute("TRUNCATE #{table_name}")
end
ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 1")

ActiveStorage::Attachment.all.each(&:purge)

Dir[Rails.root.join("db/seeds/*.rb")].each { |seed| load seed }

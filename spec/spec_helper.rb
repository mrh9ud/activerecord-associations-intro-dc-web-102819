require_relative '../config/environment'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database  => "db/playlister-test.db"
)

DB = ActiveRecord::Base.connection

# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'default'

  config.before do
    reset_database
  end
end

def reset_database

  DB.tables.each do |table|
    DB.execute("DROP TABLE #{table}")
  end

  Dir[File.join(File.dirname(__FILE__), "../migrations", "*.rb")].each do |f| 
    require f
    migration = Kernel.const_get(f.split("/").last.split(".rb").first.gsub(/\d+/, "").split("_").collect{|w| w.strip.capitalize}.join())
    migration.migrate(:up)
  end

end

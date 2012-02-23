require "active_support/dependencies"

module TableMe

  mattr_accessor :app_root

  # Yield self on setup for nice config blocks
  def self.setup
    yield self
  end

end

# Require our engine
require "table_me/engine"

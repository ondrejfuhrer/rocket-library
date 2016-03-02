# config/initializers/state_machine_patch.rb
# See https://github.com/pluginaweek/state_machine/issues/251
# Stathe machine
module StateMachine
  # Extensions for integrations of state machine
  module Integrations
    # ActiveModel extension that fixes the non-public around_validation error
    module ActiveModel
      send :public, :around_validation
    end
  end
end
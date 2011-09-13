require 'facter'
require 'puppet'

class Facts
  def get_local_facts
    Facter.to_hash
  end
end

class NameMappings < ActiveRecord::Base
  before_create :fix_name

  def fix_name
    self.name = get_player_name self.name
  end

  def get_player_name unsafe_name
    return unsafe_name.gsub(/[^a-zA-Z0-9_\- ]/, "").gsub(/[\-_]/, " ").downcase.strip.gsub(' ','_')
  end

  def self.find_by_name player_name 
    player_name  = get_player_name player_name 
    find_by(:name => player_name)
  end
end

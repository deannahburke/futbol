require 'csv'
require_relative 'game'
require_relative 'team'
require_relative 'game_team'
require_relative './season_stats'
require_relative './game_stats'
require_relative './league_stats'
require_relative './team_stats'

class DataReader

  attr_reader :games,
              :teams,
              :game_teams

  def initialize(file_paths)
    @games = create_objects(file_paths[:games], Game)
    @teams = create_objects(file_paths[:teams], Team)
    @game_teams = create_objects(file_paths[:game_teams], GameTeam) #or whatever we call it
  end

  def create_objects(file_name, object)
    objects = []
    CSV.foreach(file_name, headers: true, header_converters: :symbol) do |row|
      total_data = object.new(row)
      objects << total_data
    end
    objects
  end
end

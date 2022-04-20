require 'csv'
require_relative 'game'
require_relative 'team'
require_relative 'game_team'
require_relative './data_finder'
require_relative './season_stats'
require_relative './game_stats'

class StatTracker
  include DataFinder
  include SeasonStats
  include GameStats

  def self.from_csv(locations)
    StatTracker.new(locations)
  end

###### GAME STATISTICS - Deannah

  def highest_total_score
    @games.map {|game| game.away_goals + game.home_goals}.max
  end

  def lowest_total_score
    @games.map {|game| game.away_goals + game.home_goals}.min
  end

  def percentage_home_wins
    home_wins = @games.find_all { |game| game.home_goals > game.away_goals}
    find_percentage(home_wins)
  end

  def percentage_visitor_wins
    visitor_wins = @games.find_all { |game| game.away_goals > game.home_goals}
    find_percentage(visitor_wins)
  end

  def percentage_ties
    total_ties = @games.find_all { |game| game.away_goals == game.home_goals}
    find_percentage(total_ties)
  end

  def count_of_games_by_season
    @games.group_by { |total| total.season }.transform_values do |values| values.count
    end
  end

  def average_goals_per_game
    total_goals = @games.map {|game| game.away_goals + game.home_goals}
    average = (total_goals.sum.to_f / @games.count).round(2)
  end

  def average_goals_by_season
    average_goals = {}
    count_of_goals_by_season.each do |season, goals|
      average_goals[season] = (goals.to_f / count_of_games_by_season[season]).round(2)
    end
    average_goals
  end

  ## TEAM STATISTICS

  def team_info(id)
    info = Hash.new
    @teams.each do |team|
      if team.team_id == id
        info["team_id"] = team.team_id
        info["franchise_id"] = team.franchise_id
        info["team_name"] = team.team_name
        info["abbreviation"] = team.abbr
        info["link"] = team.link
      end
    end
    info
  end

  def most_goals_scored(id)
    all_games_by_team(id).map { |game| game.goals.to_i }.max
  end

  def fewest_goals_scored(id)
    all_games_by_team(id).map { |game| game.goals.to_i }.min
  end

  def best_season(id)
    max_season = track_season_results(id).max_by { |k, v| v.count("WIN") / v.count.to_f}[0]
    @games.find { |game| game.season[0..3] == max_season }.season
  end

  def worst_season(id)
    min_season = track_season_results(id).min_by { |k, v| v.count("WIN") / v.count.to_f}[0]
    @games.find { |game| game.season[0..3] == min_season }.season
  end

  def average_win_percentage(id)
    wins = all_games_by_team(id).select { |game| game if game.result == "WIN" }
    (wins.count.to_f / (all_games_by_team(id).count)).round(2)
  end

  def favorite_opponent(id)
    opponents = Hash.new
    @teams.each do |team|
      if team.team_id != id
        opponents[team.team_name] = win_percentage_vs(team.team_id, id)
      end
    end
    opponents.each{|k, v| opponents.delete(k) if !opponents[k].is_a?(Float)}
    opponents.sort_by{|k, v| v}.first[0]
  end

  def rival(id)
    opponents = Hash.new
    @teams.each do |team|
      if team.team_id != id
        opponents[team.team_name] = win_percentage_vs(team.team_id, id)
      end
    end
    opponents.each{|k, v| opponents.delete(k) if !opponents[k].is_a?(Float)}
    opponents.sort_by{|k, v| v}.last[0]
  end

####### SEASON STATISTICS : All methods return Strings - Team Name || Head Coach

  def winningest_coach(season)
# Name of the Coach with the best win percentage for the season
    coach_results("WIN", season).to_a.sort_by { |number| number[1] }.last[0]
  end

  def worst_coach(season)
# Name of the Coach with the worst win percentage for the season
    coach_results("LOSS", season).to_a.sort_by { |number| number[1] }.first[0]
  end

  def most_accurate_team(season)
# Name of the Team with the best ratio of shots to goals for the season
    team_name_from_id(shot_accuracy(season).last[0])
  end

  def least_accurate_team(season)
# Name of the Team with the worst ratio of shots to goals for the season
    team_name_from_id(shot_accuracy(season).first[0])
  end

  def most_tackles(season)
# Name of the Team with the most tackles in the season
    team_name_from_id(teams_by_tackles(season).last[0])
  end

  def fewest_tackles(season)
# Name of the Team with the fewest tackles in the season
    team_name_from_id(teams_by_tackles(season).first[0])
  end

########## LEAGUE STATISTICS - Jenn

  def count_of_teams
    @teams.count
  end

  def best_offense
    @teams.find { |team| team.team_id == average_score_by_team.sort_by{|k, v| v}.last[0] }.team_name
  end

  def worst_offense
    @teams.find { |team| team.team_id == average_score_by_team.sort_by{|k, v| v}.first[0] }.team_name
  end

  def highest_scoring_visitor
    scoring_team("away", "highest")
  end

  def lowest_scoring_visitor
    scoring_team("away", "lowest")
  end

  def highest_scoring_home_team
    scoring_team("home", "highest")
  end

  def lowest_scoring_home_team
    scoring_team("home", "lowest")
  end

  def average_goals_by_season
    average_goals = {}
    count_of_goals_by_season.each { |season, goals| average_goals[season] = (goals.to_f / count_of_games_by_season[season]).round(2) }
    average_goals
  end

##HELPER METHODS - LEAGUE STATISTICS

  def scoring_team(hoa, hol)
    if hol == "lowest"
      @teams.find { |team| team.team_id == average_score_by_team(hoa).sort_by{|k, v| v}.first[0] }.team_name
    elsif hol == "highest"
      @teams.find { |team| team.team_id == average_score_by_team(hoa).sort_by{|k, v| v}.last[0] }.team_name
    end
  end

  def games_by_team(home_or_away =nil)
    games_by_team_hash = {}
    @game_teams.each do |game|
      if home_or_away == nil
        if games_by_team_hash[game.team_id].nil?
          games_by_team_hash[game.team_id] = { goals: game.goals, number_of_games: 1 }
        else
          games_by_team_hash[game.team_id][:goals] += game.goals
          games_by_team_hash[game.team_id][:number_of_games] += 1
        end
      else
        if games_by_team_hash[game.team_id].nil? && game.hoa == home_or_away
          games_by_team_hash[game.team_id] = { goals: game.goals, number_of_games: 1 }
        elsif game.hoa == home_or_away
          games_by_team_hash[game.team_id][:goals] += game.goals
          games_by_team_hash[game.team_id][:number_of_games] += 1
        end
      end
    end
    games_by_team_hash
  end

  def average_score_by_team(home_or_away =nil)
    average_hash = {}
    if home_or_away == nil
      games_by_team.each { |key, value| average_hash[key] = value[:goals].to_f / value[:number_of_games] }
    else
      games_by_team(home_or_away).each { |key, value| average_hash[key] = value[:goals].to_f / value[:number_of_games] }
    end
    average_hash
  end

  # Team Statistcs Helper Methods

  def track_season_results(id)
    track_season_results = {}
    all_games_by_team(id).each do |game|
      if track_season_results[game.game_id[0..3]].nil?
        track_season_results[game.game_id[0..3]] = [game.result]
      else
        track_season_results[game.game_id[0..3]] << game.result
      end
    end
    track_season_results
  end

  def win_percentage_vs(id1, id2)
    wins = 0.0
    total_games_played = @games.find_all{|game|
      (game.home_team_id == id1 && game.away_team_id == id2) || (game.home_team_id == id2 && game.away_team_id == id1)}
    @games.each do |game|
      if game.home_team_id == id1 && game.away_team_id == id2 && game.home_goals > game.away_goals
        wins += 1.0
      elsif game.away_team_id == id1 && game.home_team_id == id2 && game.away_goals > game.home_goals
        wins += 1.0
      else
      end
    end
    (wins / total_games_played.count).round(2) / 2
  end

  def all_games_by_team(id)
    @game_teams.select {|game| game.team_id == id}
  end

end

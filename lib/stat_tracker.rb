require_relative './data_reader'

class StatTracker < DataReader
  include SeasonStats
  include GameStats
  include LeagueStats
  include TeamStats

  def self.from_csv(locations)
    StatTracker.new(locations)
  end

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
    count_of_goals_by_season.each { |season, goals| average_goals[season] = (goals.to_f / count_of_games_by_season[season]).round(2) }
    average_goals
  end

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
    opponent_win_percentages(id).sort_by{|k, v| v}.first[0]
  end

  def rival(id)
    opponent_win_percentages(id).sort_by{|k, v| v}.last[0]
  end

  def winningest_coach(season)
    coach_results("WIN", season).to_a.sort_by { |number| number[1] }.last[0]
  end

  def worst_coach(season)
    coach_results("LOSS", season).to_a.sort_by { |number| number[1] }.first[0]
  end

  def most_accurate_team(season)
    team_name_from_id(shot_accuracy(season).last[0])
  end

  def least_accurate_team(season)
    team_name_from_id(shot_accuracy(season).first[0])
  end

  def most_tackles(season)
    team_name_from_id(teams_by_tackles(season).last[0])
  end

  def fewest_tackles(season)
    team_name_from_id(teams_by_tackles(season).first[0])
  end

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
end

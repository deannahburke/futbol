require_relative './data_reader'

module TeamStats
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

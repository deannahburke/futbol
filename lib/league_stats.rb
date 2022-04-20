require_relative './data_finder'

module LeagueStats

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

end

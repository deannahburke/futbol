require_relative './data_finder'

module SeasonStats

  ## Find season from games
  def games_in_season(season)
    @game_teams.find_all { |game| game.game_id[0..3] == season[0..3] }
  end

  ## Find teams from id
  def team_name_from_id(id)
    @teams.find { |team| team.team_id == id }.team_name
  end

  ## Helper method to check team tackles
  def teams_by_tackles(season)
    teams = Hash.new
    games_in_season(season).each do |game|
      if teams[game.team_id].nil?
        teams[game.team_id] = game.tackles.to_i
      else
        teams[game.team_id] += game.tackles.to_i
      end
    end
    teams.sort_by { |team, number| number }
  end

  ##  Helper method that checks shot accuracy of all teams by a given season
  def shot_accuracy(season)
    teams = Hash.new
    games_in_season(season).each do |game|
      if teams[game.team_id].nil?
        teams[game.team_id] = { goals: game.goals.to_f, shots: game.shots.to_f }
      else
        teams[game.team_id][:goals] += game.goals.to_f
        teams[game.team_id][:shots] += game.shots.to_f
      end
    end
    teams.map { |team, count| [team,  count[:goals] / count[:shots]] }.sort_by { |team| team[1] }
  end

  def coach_results(result, season)
    coaches = []
    win_loss_hash = games_in_season(season).group_by { |win_loss| win_loss.result[0..].to_s}
    win_loss_hash.each do |k, v|
      if k == result
        v.each do |coach|
          coaches << coach.head_coach
        end
      end
    end
    coach_hash = coaches.group_by { |coach| coach[0..]}.transform_values { |v| v.count}
  end

end

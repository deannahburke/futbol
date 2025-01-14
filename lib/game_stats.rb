require_relative './data_reader'

module GameStats
  def find_percentage(total)
    (total.count / @games.count.to_f).round(2)
  end

  def count_of_goals_by_season
    goals_by_season = {}
    @games.each do |game|
      if goals_by_season[game.season].nil?
        goals_by_season[game.season] = game.home_goals + game.away_goals
      else
        goals_by_season[game.season] += game.home_goals + game.away_goals
      end
    end
    goals_by_season
  end
end

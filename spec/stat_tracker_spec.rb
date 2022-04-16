require './spec/spec_helper'

RSpec.describe StatTracker do

  before(:all) do
    # game_path = './data/games_fixture.csv'
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    # game_teams_path = './data/game_teams_fixture.csv'
    game_teams_path = './data/game_teams.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(locations)
  end


  it "exists" do
    expect(@stat_tracker).to be_a(StatTracker)
  end

  it "finds highest_total_score" do
    expect(@stat_tracker.highest_total_score).to eq(11)
  end

  it "finds lowest_total_score" do
    expect(@stat_tracker.lowest_total_score).to eq(0)
  end

  it "returns the number of teams" do
    expect(@stat_tracker.count_of_teams).to eq(32)
  end

  it "returns a hash of the games played and goals by each team" do
    expected_array = [
                      "3", "6", "5", "17", "16", "9", "8", "30", "26",
                      "19", "24", "2", "15", "20", "14", "28", "4", "21",
                      "25", "13", "18", "10", "29", "52", "54", "1", "23",
                      "12", "27", "7", "22", "53"
                    ]
    expect(@stat_tracker.all_games_by_team.keys).to eq(expected_array)
  end

  it "returns a hash of the average number of goals scored across all games for each team" do
    expected_hash =  {
                      "1" => 1.9352051835853132, "10" => 2.1066945606694563,
                      "12" => 2.0436681222707422,"13" => 2.0581896551724137,
                      "14" => 2.2203065134099615, "15" => 2.212121212121212,
                      "16" => 2.1647940074906367, "17" => 2.0593047034764824,
                      "18" => 2.146198830409357, "19" => 2.106508875739645,
                      "2" => 2.184647302904564, "20" => 2.0676532769556024,
                      "21" => 2.0658174097664546, "22" => 2.0467091295116773,
                      "23" => 1.9722222222222223, "24" => 2.1954022988505746,
                      "25" => 2.2243186582809225, "26" => 2.0841487279843443,
                      "27" => 2.023076923076923, "28" => 2.186046511627907,
                      "29" => 2.166315789473684, "3" => 2.1261770244821094,
                      "30" => 2.1155378486055776, "4" => 2.0377358490566038,
                      "5" => 2.286231884057971, "52" => 2.173277661795407,
                      "53" => 1.8902439024390243, "54" => 2.343137254901961,
                      "6" => 2.2627450980392156, "7" => 1.8362445414847162,
                      "8" => 2.0461847389558234, "9" => 2.105476673427992
                    }
    expect(@stat_tracker.all_average_score_by_team).to eq(expected_hash)
  end

  it "returns the name of the team with best offense" do
    expect(@stat_tracker.best_offense).to eq("Reign FC")
  end

  it "returns the name of the team with worst offense" do
    expect(@stat_tracker.worst_offense).to eq("Utah Royals FC")
  end

  it "returns a hash of away games played by each team" do
    expected_array = [
                      "3", "6", "5", "17", "16", "9", "8", "30", "26",
                      "19", "24", "2", "15", "20", "14", "28", "4", "21",
                      "25", "13", "18", "10", "29", "52", "54", "1", "12",
                      "23", "22", "7", "27", "53"
                    ]
    expect(@stat_tracker.games_by_team("away").keys).to eq(expected_array)
  end

  it "returns a hash of the average number of goals scored across all away games for each team" do
    expected_hash = {
                    "1" => 1.896551724137931, "10" => 1.9541666666666666,
                    "12" => 2.017467248908297, "13" => 1.9525862068965518,
                    "14" => 2.1235521235521237, "15" => 2.2045454545454546,
                    "16" => 2.0977443609022557, "17" => 2.0404858299595143,
                    "18" => 2.0505836575875485, "19" => 2.043307086614173,
                    "2" => 2.0950413223140494, "20" => 1.9324894514767932,
                    "21" => 1.9148936170212767, "22" => 2.0296610169491527,
                    "23" => 1.935897435897436, "24" => 2.143410852713178,
                    "25" => 2.1218487394957983, "26" => 2.02734375,
                    "27" => 1.8461538461538463, "28" => 2.127906976744186,
                    "29" => 2.1218487394957983, "3" => 2.1503759398496243,
                    "30" => 2.007936507936508, "4" => 1.9665271966527196,
                    "5" => 2.1824817518248176, "52" => 2.0418410041841004,
                    "53" => 1.8475609756097562, "54" => 2.0980392156862746,
                    "6" => 2.2450592885375493, "7" => 1.8777292576419213,
                    "8" => 2.0080321285140563, "9" => 2.0080645161290325
                  }
    expect(@stat_tracker.average_score_by_team("away")).to eq(expected_hash)
  end

  it "returns the name of the highest scoring visitor" do
    expect(@stat_tracker.highest_scoring_visitor).to eq("FC Dallas")
  end

  it "returns the name of the lowest scoring visitor" do
    expect(@stat_tracker.lowest_scoring_visitor).to eq("San Jose Earthquakes")
  end

  #not sure an efficient way to test this
  it "returns a hash of home games played by each team" do
    expect(@stat_tracker.games_by_team("home").keys.count).to eq(32)
  end

  it "returns a hash of the average number of home goals scored across all seasons for each team" do
    expected_hash = {
                      "1" => 1.974025974025974, "10" => 2.2605042016806722,
                      "12" => 2.069868995633188, "13" => 2.163793103448276,
                      "14" => 2.3155893536121672, "15" => 2.2196969696969697,
                      "16" => 2.2313432835820897, "17" => 2.0785123966942147,
                      "18" => 2.2421875, "19" => 2.1699604743083003,
                      "2" => 2.275, "20" => 2.2033898305084745,
                      "21" => 2.2161016949152543, "22" => 2.0638297872340425,
                      "23" => 2.0085470085470085, "24" => 2.246212121212121,
                      "25" => 2.3263598326359833, "26" => 2.1411764705882352,
                      "27" => 2.2, "28" => 2.244186046511628,
                      "29" => 2.210970464135021, "3" => 2.1018867924528304,
                      "30" => 2.224, "4" => 2.1092436974789917,
                      "5" => 2.3884892086330933, "52" => 2.3041666666666667,
                      "53" => 1.9329268292682926, "54" => 2.588235294117647,
                      "6" => 2.280155642023346, "7" => 1.794759825327511,
                      "8" => 2.0843373493975905, "9" => 2.204081632653061
                    }
    expect(@stat_tracker.average_score_by_team("home")).to eq(expected_hash)
  end

  it "returns the name of the highest scoring home team" do
    expect(@stat_tracker.highest_scoring_home_team).to eq("Reign FC")
  end

  it "returns the lowest scoring home team" do
    expect(@stat_tracker.lowest_scoring_home_team).to eq("Utah Royals FC")
  end

## SEASON STAT TESTS - Tested on actual dataset, NOT the fixtures

  it "lists games by season" do

    expect(@stat_tracker.games_in_season("2012")).to be_a(Array)
  end


  it "checks winningest coach" do

    expect(@stat_tracker.winningest_coach("20132014")).to eq "Claude Julien"
  end

  it "checks worst coach" do

    expect(@stat_tracker.worst_coach("20132014")).to eq "Peter Laviolette"
  end

  it "checks shot accuracy of teams by season" do
    expected = [
                ["9", 0.2638888888888889],["13", 0.2641509433962264],
                ["23", 0.26655629139072845],["7", 0.2682445759368836],
                ["3", 0.27007299270072993],["12", 0.2733224222585925],
                ["28", 0.2739541160593792],["15", 0.2819614711033275],
                ["26", 0.28327228327228327],["17", 0.28780487804878047],
                ["27", 0.28907563025210087],["4", 0.292259083728278],
                ["18", 0.2938053097345133],["52", 0.29411764705882354],
                ["2", 0.2947019867549669],["8", 0.29685157421289354],
                ["22", 0.2980769230769231],["25", 0.30015082956259426],
                ["29", 0.3003194888178914],["30", 0.30363036303630364],
                ["5", 0.30377906976744184],["16", 0.3042362002567394],
                ["1", 0.3060428849902534],["6", 0.3064066852367688],
                ["14", 0.3076923076923077],["19", 0.31129032258064515],
                ["10", 0.31307550644567217],["21", 0.31484502446982054],
                ["20", 0.3166023166023166],["24", 0.3347763347763348]
              ]

    expect(@stat_tracker.shot_accuracy("20132014")).to eq(expected)
  end

  it "checks most accurate team" do

    expect(@stat_tracker.most_accurate_team("20132014")).to eq "Real Salt Lake"
    expect(@stat_tracker.most_accurate_team("20142015")).to eq "Toronto FC"
  end

  it "checks least accurate team" do

    expect(@stat_tracker.least_accurate_team("20132014")).to eq "New York City FC"
    expect(@stat_tracker.least_accurate_team("20142015")).to eq "Columbus Crew SC"
  end

  it "checks teams by total tackles within a season" do
    expected = [
                ["1", 1568], ["18", 1611],
                ["20", 1708], ["23", 1710],
                ["22", 1751], ["14", 1774],
                ["17", 1783], ["30", 1787],
                ["12", 1807], ["25", 1820],
                ["16", 1836], ["13", 1860],
                ["15", 1904], ["28", 1931],
                ["7", 1992], ["19", 2087],
                ["2", 2092], ["27", 2173],
                ["8", 2211], ["21", 2223],
                ["52", 2313], ["9", 2351],
                ["4", 2404], ["6", 2441],
                ["5", 2510], ["24", 2515],
                ["10", 2592], ["3", 2675],
                ["29", 2915], ["26", 3691]
              ]

    expect(@stat_tracker.teams_by_tackles("20132014")). to eq (expected)
  end

  it "checks most tackles" do

    expect(@stat_tracker.most_tackles("20132014")).to eq "FC Cincinnati"
    expect(@stat_tracker.most_tackles("20142015")).to eq "Seattle Sounders FC"
  end

  it "checks least tackles" do

    expect(@stat_tracker.fewest_tackles("20132014")).to eq "Atlanta United"
    expect(@stat_tracker.fewest_tackles("20142015")).to eq "Orlando City SC"
  end

end

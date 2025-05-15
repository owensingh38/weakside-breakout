SELECT 
    game_title,
    game_id,
    game_date,
    venue,
    venue_location,
    away_team_abbr,
    home_team_abbr,
    event_num,
    "period",
    seconds_elapsed,
    speed_from_last,
    strength_state,
    event_type,
    "description",
    event_team_abbr as team,
    event_player_1_name as skater,
    event_player_2_name as skater_2,
    event_player_3_name as skater_3,
    shot_type,
    zone_code,
    x_adj as x,
    y_adj as y,
    away_score,
    home_score,
    away_on_1,away_on_2,away_on_3,away_on_4,away_on_5,away_goalie,away_coach,
    home_on_1,home_on_2,home_on_3,home_on_4,home_on_5,home_goalie,home_coach,
    offwing,
    xG

FROM read_parquet(
    "C:\Users\owenb\OneDrive\Desktop\Owen\Python Projects\Hockey Analytics\WSBA\wsba_hockey\release\wsba_hockey\src\wsba_hockey\pbp\parquet\*.parquet"
    );
    
SELECT 
    * 
FROM read_csv([
    'https://f005.backblazeb2.com/file/weakside-breakout/game_log/wsba_nhl_20102011_game_log.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/game_log/wsba_nhl_20112012_game_log.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/game_log/wsba_nhl_20122013_game_log.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/game_log/wsba_nhl_20132014_game_log.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/game_log/wsba_nhl_20142015_game_log.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/game_log/wsba_nhl_20152016_game_log.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/game_log/wsba_nhl_20162017_game_log.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/game_log/wsba_nhl_20172018_game_log.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/game_log/wsba_nhl_20182019_game_log.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/game_log/wsba_nhl_20192020_game_log.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/game_log/wsba_nhl_20202021_game_log.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/game_log/wsba_nhl_20212022_game_log.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/game_log/wsba_nhl_20222023_game_log.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/game_log/wsba_nhl_20232024_game_log.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/game_log/wsba_nhl_20242025_game_log.csv'
    ], union_by_name = true)
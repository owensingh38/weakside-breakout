SELECT 
    * 
FROM read_csv([
    'https://f005.backblazeb2.com/file/weakside-breakout/team/wsba_nhl_20102011_team.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/team/wsba_nhl_20112012_team.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/team/wsba_nhl_20122013_team.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/team/wsba_nhl_20132014_team.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/team/wsba_nhl_20142015_team.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/team/wsba_nhl_20152016_team.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/team/wsba_nhl_20162017_team.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/team/wsba_nhl_20172018_team.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/team/wsba_nhl_20182019_team.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/team/wsba_nhl_20192020_team.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/team/wsba_nhl_20202021_team.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/team/wsba_nhl_20212022_team.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/team/wsba_nhl_20222023_team.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/team/wsba_nhl_20232024_team.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/team/wsba_nhl_20242025_team.csv'
    ], union_by_name = true)
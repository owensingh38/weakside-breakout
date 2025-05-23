SELECT 
    * 
FROM read_csv([
    'https://f005.backblazeb2.com/file/weakside-breakout/skater/wsba_nhl_20102011_skater.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/skater/wsba_nhl_20112012_skater.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/skater/wsba_nhl_20122013_skater.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/skater/wsba_nhl_20132014_skater.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/skater/wsba_nhl_20142015_skater.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/skater/wsba_nhl_20152016_skater.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/skater/wsba_nhl_20162017_skater.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/skater/wsba_nhl_20172018_skater.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/skater/wsba_nhl_20182019_skater.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/skater/wsba_nhl_20192020_skater.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/skater/wsba_nhl_20202021_skater.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/skater/wsba_nhl_20212022_skater.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/skater/wsba_nhl_20222023_skater.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/skater/wsba_nhl_20232024_skater.csv',
    'https://f005.backblazeb2.com/file/weakside-breakout/skater/wsba_nhl_20242025_skater.csv'
    ], union_by_name = true)
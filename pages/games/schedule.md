---
title: Schedule
hide_title: true
---

```sql games
SELECT
    CASE
        WHEN gameState IN ('OFF', 'FINAL') THEN 'Final' ELSE estStartTime || ' EST'
    END as gameStatus,

    CASE WHEN
        season_type = 2 THEN 'Regular Season' else 'Playoffs'
    END as span,
    CASE 
        WHEN "awayTeam.score" > "homeTeam.score" THEN ("awayTeam.score"::INT||'-'||"homeTeam.score"::INT||' '||away_team_abbr) 
        
        WHEN "homeTeam.score" > "awayTeam.score" THEN ("homeTeam.score"::INT||'-'||"awayTeam.score"::INT||' '||home_team_abbr)
        ELSE ("awayTeam.score"::INT||'-'||"homeTeam.score"::INT)
    END as score,
    'https://nhl.com'||gameCenterLink as gamecenter,
    CASE WHEN
        gameState IN ('OFF','FINAL') THEN (
        'https://weakside-breakout-game-stats.share.connect.posit.cloud/?game_id='|| id::INT) ELSE NULL
    END as game_stats,
    *
FROM schedule
WHERE
    season = '${inputs.season_options.value}'
```

```sql seasons
SELECT DISTINCT
	season
FROM schedule
WHERE
    season > 20092010
```

<div style="margin: 10px;">
    <div style="text-align: center;">
		<b><h1 style="font-size:50px">Schedule</h1></b>
        <h1>Search for dates or teams with the search bar.</h1>
	</div>
    <div>
        <Dropdown
		data={seasons}
		name=season_options
		value=season
		title=Season
		defaultValue={[20242025]}
	/>
    <DataTable data={games} rows=20 search=true rowShading=true rowNumbers=true headerColor=#0000ff headerFontColor=white downloadable=false sort='date desc'>
        <Column id=date align=center />
        <Column id=venue.default align=center title="Venue"/>
		<Column id=gameStatus align=center title="Game State"/>
		<Column id=span align=center />
        <Column id=awayTeam.darkLogo
         align=center contentType="image" height=20px title="Logo"/>
        <Column id=away_team_abbr align=center title="Away"/>
		<Column id=homeTeam.darkLogo
         align=center contentType="image" height=20px title="Logo"/>
        <Column id=home_team_abbr align=center title="Home"/>
        <Column id=score align=center />
		<Column id=gameOutcome.lastPeriodType align=center title="Period Type"/>
        <Column id=gamecenter align=center contentType='link' linkLabel='GameCenter' openInNewTab=true/>
        <Column id=game_stats align=center contentType='link' linkLabel='Game Stats' openInNewTab=true/>
    </DataTable>
    </div>
</div>
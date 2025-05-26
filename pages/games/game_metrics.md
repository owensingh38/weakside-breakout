---
title: Game Metrics
hide_title: true
---

```sql plays
SELECT 
    CASE
        WHEN event_type IN ('missed-shot','shot-on-goal','goal') THEN "description" || ' - xG: ' || SUBSTRING(("xG"*100),1,5) || '%'
        ELSE "description"
    END as "description",
    CASE
        WHEN xG IS NULL THEN 1
        WHEN xG <.1 THEN 0.25
        ELSE (xG*3)
    END as size,
    info.teamLogo as logo,
    names.Player as "name",
    *
FROM 
    pbp
LEFT JOIN info
    ON pbp.team=info.triCode AND pbp.season=info.seasonId
LEFT JOIN names
    ON pbp.skater_id=names.ID
WHERE
    game_title = '${inputs.game_options.value}'
AND
    event_type IN ${inputs.event_options.value}
AND
    strength_state IN ${inputs.strength_options.value}
AND
    team IS NOT NULL
```

```sql timelines
SELECT
    team,seconds_elapsed,
    SUM(CASE WHEN event_type='goal' THEN 1 ELSE 0 END) OVER (PARTITION by team ORDER BY seconds_elapsed) as Goals,
    SUM(CASE WHEN event_type IN ('shot-on-goal','goal') THEN 1 ELSE 0 END) OVER (PARTITION by team ORDER BY seconds_elapsed) as Shots,
    SUM(CASE WHEN event_type IN ('missed-shot','shot-on-goal','goal') THEN 1 ELSE 0 END) OVER (PARTITION by team ORDER BY seconds_elapsed) as Fenwick,
    SUM(xG) OVER (PARTITION by team ORDER BY seconds_elapsed) as xGoals
FROM ${plays} p
```

```sql link
SELECT DISTINCT
    '/games/' || game_id as link
FROM pbp
WHERE
    game_title = '${inputs.game_options.value}'
```

```sql dates
SELECT DISTINCT 
	game_date
FROM pbp
```

```sql games
SELECT DISTINCT 
	game_title
FROM pbp
WHERE
    game_date = '${inputs.date.value}'
```

```sql events
SELECT DISTINCT 
	event_type
FROM pbp
WHERE
    event_type NOT IN ('change','challenge','EGPID','delayed-penalty','shootout-complete')
AND
    team IS NOT NULL
```

```sql strengths
SELECT DISTINCT 
	strength_state
FROM pbp
WHERE strength_state IN (
    '0v1',
    '1v0',
    '3v3',
    '3v4',
    '3v5',
    '3v6',
    '4v3',
    '4v4',
    '4v5',
    '4v6',
    '5v3',
    '5v4',
    '5v5',
    '5v6',
    '6v3',
    '6v4',
    '6v5'
)
```

```sql strengths_2
SELECT DISTINCT 
	Strength
FROM game_log
```

```sql team_summary
SELECT
    p.*,info.teamLogo as logo
FROM
    (SELECT
        team as Team, 
        venue,
        season,
        SUM(CASE WHEN event_type IN ('goal') THEN 1 ELSE 0 END) as Goals,
        SUM(CASE WHEN event_type IN ('shot-on-goal','goal') THEN 1 ELSE 0 END) as Shots,
        SUM(CASE WHEN event_type IN ('missed-shot','shot-on-goal','goal') THEN 1 ELSE 0 END) as Fenwick,
        SUM(xG) as xG,
        SUM(CASE WHEN event_type IN ('giveaway') THEN 1 ELSE 0 END) as Giveaways,
        SUM(CASE WHEN event_type IN ('takeaway') THEN 1 ELSE 0 END) as Takeaways,
        SUM(CASE WHEN event_type IN ('hit') THEN 1 ELSE 0 END) as Hits
    FROM pbp as p
    WHERE game_title = '${inputs.game_options.value}'
    AND strength_state IN ${inputs.strength_options.value}
    GROUP BY team, venue, season, game_id) as p
LEFT JOIN info
    ON p.team=info.triCode AND p.season=info.seasonId
ORDER BY
    venue asc
```

```sql selected_game
SELECT DISTINCT
    game_id
FROM pbp
WHERE
    game_title = '${inputs.game_options.value}'
```

```sql event_string
SELECT
    STRING_AGG(event_type, ',') as string
FROM
    (SELECT DISTINCT event_type FROM pbp WHERE event_type IN ${inputs.event_options.value})
```

```sql strength_string
SELECT
    STRING_AGG(strength_state, ',') as string
FROM
    (SELECT DISTINCT strength_state FROM pbp WHERE strength_state IN ${inputs.strength_options.value})
```

```sql score
SELECT
    team,
    game_date,
    venue as "status",
    SUM(CASE WHEN event_type IN ('goal') THEN 1 ELSE 0 END) as goals
FROM pbp
WHERE
    game_id = '${selected_game[0].game_id}'
AND
    team != '0'
GROUP BY
    team, game_date, "status"
ORDER BY
    "status" asc
```

```sql away_stats
SELECT
   (A1+A2) as "A",
	'/players/' || ID as playerLink,
	*
FROM game_log
WHERE
   Game = '${selected_game[0].game_id}'
AND
   Team = '${team_summary[0].Team}'
AND
   Strength='${inputs.strength_options_2.value}'
```

```sql home_stats
SELECT
   (A1+A2) as "A",
	'/players/' || ID as playerLink,
	*
FROM game_log
WHERE
   Game = '${selected_game[0].game_id}'
AND
   Team = '${team_summary[1].Team}'
AND
   Strength='${inputs.strength_options_2.value}'
```

<h1>Play-by-Play</h1>

<DateInput
    name=date
    data={dates}
    dates=game_date
    defaultValue="2025-05-01"
/>

<Dropdown
    data={games}
    name=game_options
    value=game_title
	title=Game
/>

<Dropdown
    data={events}
    name=event_options
    value=event_type
	title=Event
    multiple=true
    selectAllByDefault=true
/>

<Dropdown
    data={strengths}
    name=strength_options
    value=strength_state
	title=Strength
    multiple=true
    selectAllByDefault=true
/>

<iframe height="400" width="100%" frameborder="no" src="https://01970553-81f3-99bd-2841-5908e7e4106b.share.connect.posit.cloud/?game_id={selected_game[0].game_id}&event_type={event_string[0].string}&strength_state={strength_string[0].string}"></iframe>
<br>
<DataTable data={team_summary} rows=50 rowShading=true headerColor=#0000ff headerFontColor=white downloadable=false>
    <Column id=logo align=center contentType=image height=20px/>
    <Column id=Team align=center />
    <Column id=Goals align=center/>
    <Column id=Shots align=center/>
	<Column id=Fenwick align=center/>
    <Column id=xG align=center title="xG"/>
    <Column id=Giveaways align=center/>
    <Column id=Takeaways align=center/>
    <Column id=Hits align=center/>
</DataTable>

<br>
<h1>Game Stats</h1>

<Dropdown name=data_options defaultValue=1>
	<DropdownOption valueLabel="Plays" value=1 />
	<DropdownOption valueLabel="Timelines" value=2 />
    <DropdownOption valueLabel="Skater Stats" value=3 />
</Dropdown>


{#if inputs.data_options.value==3}
    <Dropdown name=type title=Type defaultValue=1>
        <DropdownOption valueLabel="Individual" value=1 />
        <DropdownOption valueLabel="On-Ice" value=2 />
    </Dropdown>

    <Dropdown
        data={strengths_2}
        name=strength_options_2
        value=Strength
        title=Strength
        defaultValue='5v5'
    />

    <h1 style="font-size:90%;">{score[0].team} Stats</h1>

    {#if inputs.type.value == 1}
        <DataTable data={away_stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white link=playerLink sort=Player downloadable=false>
            <Column id=Headshot contentType=image height=20px/>
            <Column id=Player/>
            <Column id=ID title='ID'/>
            <Column id=Position />
            <Column id=TOI title='TOI'/>
            <Column id=Gi align=center title="G"/>
            <Column id=A1 align=center />
            <Column id=A2 align=center />
            <Column id=A align=center />
            <Column id=P align=center />
            <Column id=Fi align=center title="iFF"/>
            <Column id=xGi align=center title="ixG"/>
            <Column id=Give align=center />
            <Column id=Take align=center />	
            <Column id=Penl align=center />
            <Column id=Draw align=center />	
            <Column id=PIM align=center title="PIM"/>	
            <Column id=Block align=center title="Blocks"/>
        </DataTable>

        <h1 style="font-size:90%;">{score[1].team} Stats</h1>
        <DataTable data={home_stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white link=playerLink sort=Player downloadable=false>
            <Column id=Headshot contentType=image height=20px/>
            <Column id=Player/>
            <Column id=ID title='ID'/>
            <Column id=Position />
            <Column id=TOI title='TOI'/>
            <Column id=Gi align=center title="G"/>
            <Column id=A1 align=center />
            <Column id=A2 align=center />
            <Column id=A align=center />
            <Column id=P align=center />
            <Column id=Fi align=center title="iFF"/>
            <Column id=xGi align=center title="ixG"/>
            <Column id=Give align=center />
            <Column id=Take align=center />	
            <Column id=Penl align=center />
            <Column id=Draw align=center />	
            <Column id=PIM align=center title="PIM"/>	
            <Column id=Block align=center title="Blocks"/>
        </DataTable>
        {:else }
        <DataTable data={away_stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white link=playerLink sort=Player downloadable=false>
            <Column id=Headshot contentType=image height=20px/>
            <Column id=Player/>
            <Column id=ID title='ID'/>
            <Column id=Position />
            <Column id=TOI title='TOI'/>
            <Column id=GF align=center title="GF"/>
            <Column id=GA align=center title="GA"/>
            <Column id=FF align=center title="FF"/>
            <Column id=FA align=center title="FA"/>
            <Column id=xGF align=center title="xGF"/>
            <Column id=xGA align=center title="xGA"/>
            <Column id=GF% align=center title="GF%" fmt='##.00%' />
            <Column id=FF% align=center title="FF%" fmt='##.00%' />
            <Column id=xGF% align=center title="xGF%" fmt='##.00%' />
        </DataTable>
        <h1 style="font-size:90%;">{score[1].team} Stats</h1>
        <DataTable data={home_stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white link=playerLink sort=Player downloadable=false>
            <Column id=Headshot contentType=image height=20px/>
            <Column id=Player/>
            <Column id=ID title='ID'/>
            <Column id=Position />
            <Column id=TOI title='TOI'/>
            <Column id=GF align=center title="GF"/>
            <Column id=GA align=center title="GA"/>
            <Column id=FF align=center title="FF"/>
            <Column id=FA align=center title="FA"/>
            <Column id=xGF align=center title="xGF"/>
            <Column id=xGA align=center title="xGA"/>
            <Column id=GF% align=center title="GF%" fmt='##.00%' />
            <Column id=FF% align=center title="FF%" fmt='##.00%' />
            <Column id=xGF% align=center title="xGF%" fmt='##.00%' />
        </DataTable>
        {/if}
{:else }
{#if inputs.data_options.value==2}
    <Dropdown name=timeline_options defaultValue="Goals">
        <DropdownOption valueLabel="Goals" value="Goals" />
        <DropdownOption valueLabel="Shots" value="Shots"/>
        <DropdownOption valueLabel="Fenwick" value="Fenwick" />
        <DropdownOption valueLabel="xGoals" value="xGoals" />
    </Dropdown>

    <LineChart
        data={timelines}
        x=seconds_elapsed
        y={inputs.timeline_options.value}
        series=team
        handleMissing=connect
        xAxisTitle=true
        yAxisTitle={inputs.timeline_options.value}
        seriesColors={{'ANA': '#F47A38', 'ATL': '#5C88DA', 'BOS': '#FFB81C', 'BUF': '#003087', 'CGY': '#D2001C', 'CAR': '#CE1126', 'CHI': '#CF0A2C', 'COL': '#6F263D', 'CBJ': '#002654', 'DAL': '#006847', 'DET': '#CE1126', 'EDM': '#041E42', 'FLA': '#C8102E', 'LAK': '#A2AAAD', 'MIN': '#154734', 'MTL': '#AF1E2D', 'NSH': '#FFB81C', 'NJD': '#CE1126', 'NYI': '#00539B', 'NYR': '#0038A8', 'OTT': '#DA1A32', 'PHI': '#F74902', 'PHX': '#8C2633', 'PIT': '#FCB514', 'SJS': '#006D75', 'STL': '#002F87', 'TBL': '#002868', 'TOR': '#00205B', 'VAN': '#00205B', 'WSH': '#C8102E', 'WPG': '#041E42', 'ARI': '#8C2633', 'VGK': '#B4975A', 'SEA': '#001628', 'UTA': '#69B3E7'}}
    />
{:else }
    <DataTable data={plays} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white sort=event_num compact=true downloadable=false>
        <Column id=event_num align=center title="#"/>
        <Column id=period align=center/>
        <Column id=seconds_elapsed align=center title="Seconds"/>
        <Column id=strength_state align=center/>
        <Column id=event_type align=center title="Event"/>
        <Column id=description align=center/>
        <Column id=logo align=center contentType=image height=20px/>
        <Column id=team align=center/>
        <Column id=name align=center title="Player"/>
        <Column id=shot_type align=center/>
        <Column id=zone_code align=center/>
        <Column id=away_score align=center/>
        <Column id=home_score align=center/>
        <Column id=xG align=center title="xG"/>
    </DataTable>
{/if}
{/if}
---
title: Game Stats
hide_title: true
---

```sql logos
SELECT DISTINCT
    team,
    venue,
    info.teamLogo as Logo,
FROM pbp
LEFT JOIN info
    ON pbp.team=info.triCode AND pbp.season=info.seasonId
WHERE
    game_id = '${params.game_id}'
AND
    team != '0'
ORDER BY
    venue asc
```

```sql score
SELECT
    team,
    game_date,
    venue as "status",
    SUM(CASE WHEN event_type IN ('goal') THEN 1 ELSE 0 END) as goals
FROM pbp
WHERE
    game_id = '${params.game_id}'
AND
    team != '0'
GROUP BY
    team, game_date, "status"
ORDER BY
    "status" asc
```

```sql scoring_summary
SELECT
    "period",
    team,
    strength_state,
    info.teamLogo as logo,
    seconds_elapsed,
    CASE
        WHEN event_type IN ('missed-shot','shot-on-goal','goal') THEN "description" || ' - xG: ' || SUBSTRING(("xG"*100),1,5) || '%'
        ELSE "description"
    END as "description",
    away_score,
    home_score
FROM pbp
LEFT JOIN info
    ON pbp.team=info.triCode AND pbp.season=info.seasonId
WHERE
    game_id = '${params.game_id}'
AND
    event_type IN ('goal')
```

```sql strengths
SELECT DISTINCT
    Strength
FROM game_log
```

```sql team_summary
SELECT
    '/games/' || game_id as gameLink,
    team as Team,
    venue,
    SUM(CASE WHEN event_type IN ('goal') THEN 1 ELSE 0 END) as Goals,
    SUM(CASE WHEN event_type IN ('shot-on-goal','goal') THEN 1 ELSE 0 END) as Shots,
    SUM(CASE WHEN event_type IN ('missed-shot','shot-on-goal','goal') THEN 1 ELSE 0 END) as Fenwick,
    SUM(xG) as xG,
    SUM(CASE WHEN event_type IN ('giveaway') THEN 1 ELSE 0 END) as Giveaways,
    SUM(CASE WHEN event_type IN ('takeaway') THEN 1 ELSE 0 END) as Takeaways,
    SUM(CASE WHEN event_type IN ('hit') THEN 1 ELSE 0 END) as Hits
FROM pbp
WHERE
    game_id = '${params.game_id}'
AND
    team != '0'
GROUP BY team, venue, game_id
ORDER BY
   venue asc
```

```sql bio
SELECT DISTINCT
    Player,ID,Position,'/players/' || ID as playerLink,'https://assets.nhle.com/mugs/nhl/latest/' || SUBSTRING(ID,1,8) || 'png' as Headshot
FROM names
```

```sql away_stats
SELECT
   (A1+A2) as "A",
	'/players/' || ID as playerLink,
	*
FROM game_log
WHERE
   Game = '${params.game_id}'
AND
   Team = '${team_summary[0].Team}'
AND
   Strength='${inputs.strength_options.value}'
```

```sql home_stats
SELECT
   (A1+A2) as "A",
	'/players/' || ID as playerLink,
	*
FROM game_log
WHERE
   Game = '${params.game_id}'
AND
   Team = '${team_summary[1].Team}'
AND
   Strength='${inputs.strength_options.value}'
```

<div style="display:flex; justify-content: space-between;">
<h1>   </h1>
<Image
    url={logos[0].Logo}
    height=80
/>
<h1 style="font-size:60px;">{score[0].goals}</h1>
<h1 style="font-size:60px;">-</h1>
<h1 style="font-size:60px;">{score[1].goals}</h1>
<Image
    url={logos[1].Logo}
    height=80
/>
<h1>   </h1>
</div>
<center><h1>{score[0].game_date} - Final</h1></center>
<br>
<DataTable data={team_summary} rows=50 rowShading=true headerColor=#0000ff headerFontColor=white sort=venue downloadable=false>
    <Column id=Team align=center />
    <Column id=Shots align=center/>
    <Column id=Fenwick align=center/>
    <Column id=xG align=center title="xG"/>
    <Column id=Giveaways align=center/>
    <Column id=Takeaways align=center/>
    <Column id=Hits align=center/>
</DataTable>
<br>
<h1>Scoring Summary</h1>
<DataTable data={scoring_summary} rows=12 rowShading=true compact=true sort=seconds_elapsed headerColor=#0000ff headerFontColor=white downloadable=false>
    <Column id=period align=center/>
    <Column id=seconds_elapsed align=center title='Time'/>
    <Column id=strength_state align=center/>
    <Column id=logo align=center contentType=image height=15px title="Team"/>  
    <Column id=description align=center/>
    <Column id=away_score align=center/>
    <Column id=home_score align=center/>
</DataTable>
<br>
<h1>Player Stats</h1>
<Dropdown
    data={strengths}
    name=strength_options
    value=Strength
    title=Strength
    defaultValue='5v5'
/>

<Dropdown name=type title=Type defaultValue=1>
	<DropdownOption valueLabel="Individual" value=1 />
	<DropdownOption valueLabel="On-Ice" value=2 />
</Dropdown>


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
	<Column id=xGi/Fi align=center title="ixG/iFF"/>
	<Column id=Gi/xGi align=center title="G/ixG"/>
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
	<Column id=xGi/Fi align=center title="ixG/iFF"/>
	<Column id=Gi/xGi align=center title="G/ixG"/>
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
    <Column id=xGF/FF align=center title="xGF/FF"/>
    <Column id=xGA/FA align=center title="xGA/FA"/>
    <Column id=GF/xGF align=center title="GF/xGF"/>
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
    <Column id=xGF/FF align=center title="xGF/FF"/>
    <Column id=xGA/FA align=center title="xGA/FA"/>
    <Column id=GF/xGF align=center title="GF/xGF"/>
    <Column id=GF% align=center title="GF%" fmt='##.00%' />
	<Column id=FF% align=center title="FF%" fmt='##.00%' />
    <Column id=xGF% align=center title="xGF%" fmt='##.00%' />
</DataTable>
{/if}
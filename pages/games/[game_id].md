---
title: Game Stats
hide_title: true
---

```sql logos
SELECT DISTINCT
    team,
    venue,
    info.teamLogo as Logo,
FROM sample_pbp
LEFT JOIN info
    ON sample_pbp.team=info.triCode AND sample_pbp.season=info.seasonId
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
FROM sample_pbp
WHERE
    game_id = '${params.game_id}'
AND
    team != '0'
GROUP BY
    team, game_date, "status"
ORDER BY
    "status" asc
```

```sql plays
SELECT
    game_id,
    event_num,
    "period",
    seconds_elapsed,
    event_type,
    CASE
        WHEN event_type IN ('missed-shot','shot-on-goal','goal') THEN "description" || ' - xG: ' || SUBSTRING(("xG"*100),1,5) || '%'
        ELSE "description"
    END as "description",
    CASE WHEN
        strength_state NOT IN ('5v5','5v4','4v5') THEN 'Other'
        ELSE strength_state
    END as strength_state,
    team,
    venue,
    skater_id,
    skater_id_2,
    skater_id_3,
    shot_type,
    zone_code,
    x_adj as x,
    y_adj as y,
    away_score,
    home_score,
    away_on_1_id,away_on_2_id,away_on_3_id,away_on_4_id,away_on_5_id,away_on_6_id,away_goalie_id,
    home_on_1_id,home_on_2_id,home_on_3_id,home_on_4_id,home_on_5_id,home_on_6_id,home_goalie_id,
    seconds_since_last,
    penalty_duration,
    xG,
    CASE
        WHEN xG IS NULL THEN 1
        WHEN xG <.1 THEN 0.25
        ELSE (xG*3)
    END as size
FROM 
    sample_pbp
WHERE
    game_id = '${params.game_id}'
AND
    event_type != 'change'
AND
    strength_state IN ${inputs.strength_options.value}
AND
    team IS NOT NULL
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
FROM sample_pbp
LEFT JOIN info
    ON sample_pbp.team=info.triCode AND sample_pbp.season=info.seasonId
WHERE
    game_id = '${params.game_id}'
AND
    event_type IN ('goal')
```

```sql strengths
SELECT DISTINCT 
	CASE WHEN
        strength_state NOT IN ('5v5','5v4','4v5') THEN 'Other'
        ELSE strength_state
    END as strength_state
FROM sample_pbp
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
FROM sample_pbp
WHERE
    game_id = '${params.game_id}'
AND
    team != '0'
GROUP BY team, venue, game_id
```

```sql bio
SELECT DISTINCT
    Player,ID,Position,'/players/' || ID as playerLink,'https://assets.nhle.com/mugs/nhl/latest/' || SUBSTRING(ID,1,8) || 'png' as Headshot
FROM names
```

```sql indv_1
SELECT
    skater_id,
    venue,
    SUM(CASE WHEN event_type IN ('goal') THEN 1 ELSE 0 END) as G,
    SUM(CASE WHEN event_type IN ('shot-on-goal','goal') THEN 1 ELSE 0 END) as iSF,
    SUM(CASE WHEN event_type IN ('missed-shot','shot-on-goal','goal') THEN 1 ELSE 0 END) as iFF,
    SUM(IFNULL(xG,0)) as ixG,
    SUM(CASE WHEN event_type IN ('giveaway') THEN 1 ELSE 0 END) as GIVE,
    SUM(CASE WHEN event_type IN ('takeaway') THEN 1 ELSE 0 END) as "TAKE",
    SUM(CASE WHEN event_type IN ('hit') THEN 1 ELSE 0 END) as HF,
    SUM(CASE WHEN event_type IN ('penalty') THEN 1 ELSE 0 END) as PENL,
    SUM(IFNULL(penalty_duration,0)) as PIM
FROM ${plays}
WHERE
    game_id = '${params.game_id}'
AND
    skater_id != '0'
GROUP BY
    skater_id,venue
```

```sql indv_2
SELECT
    skater_id_2,
    venue,
    SUM(CASE WHEN event_type IN ('goal') THEN 1 ELSE 0 END) as A1
FROM ${plays}
WHERE
    game_id = '${params.game_id}'
AND
    skater_id_2 != '0'
AND
    event_type = 'goal'
GROUP BY
    skater_id_2,venue
```

```sql indv_3
SELECT
    skater_id_3,
    venue,
    SUM(CASE WHEN event_type IN ('goal') THEN 1 ELSE 0 END) as A2,
FROM ${plays}
WHERE
    game_id = '${params.game_id}'
AND
    skater_id_3 != '0'
AND
    event_type = 'goal'
GROUP BY
    skater_id_3,venue
```

```sql indv_4
SELECT
    skater_id_2,
    CASE WHEN venue='away' THEN 'home' ELSE 'away' END as venue,
    SUM(CASE WHEN event_type IN ('hit') THEN 1 ELSE 0 END) as HA,
    SUM(CASE WHEN event_type IN ('penalty') THEN 1 ELSE 0 END) as DRAW,
FROM ${plays}
WHERE
    game_id = '${params.game_id}'
AND
    skater_id_2 != '0'
AND
    event_type IN ('hit','penalty')
GROUP BY
    skater_id_2,venue
```

```sql indv
SELECT 
    b.Player,
    b.Position,
    b.playerLink,
    b.Headshot,
    one.*,
    s.Team,
    IFNULL(two.A1,0) as A1,IFNULL(three.A2,0) as A2,IFNULL(four.HA,0) as HA,IFNULL(four.DRAW,0) as DRAW,
    (one.G+IFNULL(two.A1,0)+IFNULL(three.A2,0)) as P,
FROM ${indv_1} as one
LEFT JOIN ${indv_2} as two
    ON one.skater_id=two.skater_id_2
LEFT JOIN ${indv_3} as three
    ON one.skater_id=three.skater_id_3
LEFT JOIN ${indv_4} as four
    ON one.skater_id=four.skater_id_2
LEFT JOIN ${bio} as b
    ON one.skater_id=b.ID
LEFT JOIN ${score} as s
    ON one.venue=s."status"
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
    <Column id=seconds_elapsed align=center/>
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
    value=strength_state
	title=Strength
    multiple=true
    selectAllByDefault=true
/>

<h1 style="font-size:90%;">{score[0].team} Stats</h1>
<DataTable data={indv.where("Position NOT IN ('G') AND venue = 'away'")} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white link=playerLink sort=Player downloadable=false>
    <Column id=Headshot contentType=image height=20px/>
    <Column id=Player />
    <Column id=skater_id title='ID'/>
    <Column id=Position />
    <Column id=G />
    <Column id=A1 />
    <Column id=A2 />
    <Column id=P />
    <Column id=iSF title='iSF'/>
    <Column id=iFF title='iFF'/>
    <Column id=ixG title='ixG' />
    <Column id=GIVE />
    <Column id=TAKE />
    <Column id=HF title='HF' />
    <Column id=HA title='HA' />
    <Column id=PENL />
    <Column id=DRAW />
    <Column id=PIM title='PIM' />
</DataTable>

<h1 style="font-size:90%;">{score[1].team} Stats</h1>
<DataTable data={indv.where("Position NOT IN ('G') AND venue = 'home'")} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white link=playerLink sort=Player downloadable=false>
    <Column id=Headshot contentType=image height=20px/>
    <Column id=Player />
    <Column id=skater_id title='ID'/>
    <Column id=Position />
    <Column id=G />
    <Column id=A1 />
    <Column id=A2 />
    <Column id=P />
    <Column id=iSF title='iSF'/>
    <Column id=iFF title='iFF'/>
    <Column id=ixG title='ixG' />
    <Column id=GIVE />
    <Column id=TAKE />
    <Column id=HF title='HF' />
    <Column id=HA title='HA' />
    <Column id=PENL />
    <Column id=DRAW />
    <Column id=PIM title='PIM' />
</DataTable>
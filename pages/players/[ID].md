---
title: Player Stats
---

```sql info
SELECT DISTINCT
   Position,
   Handedness as Hand,
   "Height (in)",
   "Weight (lbs)",
   SUBSTRING(Birthday,1,10) as Birthdate,
   Nationality
FROM skater
WHERE
   ID = '${params.ID}'
LIMIT
   1
```

```sql stats
SELECT
   Season::INT as "Season",
   (A1+A2) as "A",
   ((A1+A2)/TOI)*60 as "A/60",
   '/players/' || ID as playerLink,
   *
FROM skater
WHERE
   ID = '${params.ID}'
```

```sql shot_profile
SELECT
    'Shot Rate' as metric, ("INDV-SR"*100) as value
FROM skater
WHERE
   ID = '${params.ID}' 
AND
   Season = '${inputs.shot_season.value}'
AND
   Team = '${inputs.shot_team.value}'
UNION ALL
SELECT
    'Shot Quality' as metric, ("INDV-SQ"*100) as value
FROM skater
WHERE
   ID = '${params.ID}' 
AND
   Season = '${inputs.shot_season.value}'
AND
   Team = '${inputs.shot_team.value}'
UNION ALL
SELECT
    'Finishing' as metric, ("INDV-FN"*100) as value
FROM skater
WHERE
   ID = '${params.ID}' 
AND
   Season = '${inputs.shot_season.value}'
AND
   Team = '${inputs.shot_team.value}'
UNION ALL
SELECT
    'Goal Induction' as metric, ("LiGIn-P"*100) as value
FROM skater
WHERE
   ID = '${params.ID}' 
AND
   Season = '${inputs.shot_season.value}'
AND
   Team = '${inputs.shot_team.value}'
```

```sql seasons
SELECT DISTINCT 
	SUBSTRING("Season",1,8) as "Season"
FROM skater s
WHERE
   ID = '${params.ID}' 
```

```sql teams
SELECT DISTINCT 
	Team
FROM skater s
WHERE
   ID = '${params.ID}' 
AND
   Season = '${inputs.shot_season.value}'
```

# <center> <Value data={stats} column=Player /> </center>

<DataTable data={info}/>

<h1>Basic Stats</h1>
<DataTable data={stats} rows=50 rowShading=true headerColor=#0000ff headerFontColor=white>
   <Column id=Season align=center fmt='####-####' />
   <Column id=Age align=center />
   <Column id=Team align=center />
   <Column id=GP align=center title="GP"/>
   <Column id=TOI align=center title="TOI" fmt='#,###.#0' />
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

<h1>Shot Profile and Offensive Contribution</h1>
<h3 style="font-size:70%;">Percentiles at 5v5 and relative to player position</h3>
<Dropdown
    data={seasons}
    name=shot_season
    value=Season
	 title=Season
    defaultValue="20242025"
/>

<Dropdown
    data={teams}
    name=shot_team
    value=Team
	 title=Team
/>

<BarChart 
    data={shot_profile}
    x=metric
    y=value
    swapXY=true
/>
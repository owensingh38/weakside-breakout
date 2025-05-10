---
queries:
   - player_stats: player_stats.sql
---

# {params.ID}

```sql player_stats_filtered
select * from ${player_stats}
where ID = '${params.ID}'
```

<DataTable data={player_stats_filtered}/>

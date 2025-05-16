---
queries:
   - teams: teams.sql
---

# {params.Team}

```sql teams_filtered
select * from ${teams}
where Team = '${params.Team}'
```

<DataTable data={teams_filtered}/>

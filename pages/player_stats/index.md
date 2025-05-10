---
title: Player_stats
queries:
   - player_stats: player_stats.sql
---

Click on an item to see more detail


```sql player_stats_with_link
select *, '/player_stats/' || ID as link
from ${player_stats}
```

<DataTable data={player_stats_with_link} link=link/>

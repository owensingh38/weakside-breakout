SELECT * FROM (
    VALUES
        ('blocked-shot'),
        ('missed-shot'),
        ('shot-on-goal'),
        ('goal'),
        ('hit'),
        ('giveaway'),
        ('takeaway'),
        ('penalty'),
        ('faceoff')
) as t(event_type)
select count(1) as count1,cast(login_datetime as date) as date from uw_login_log  where mode_of_login=4 and cast(login_datetime as date)>'2025-02-08'
group by cast(login_datetime as date)
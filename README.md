myslog
======

MySQL slow query log parser

Install
-------

```
gem install myslog
```

Usage
-----

```ruby
myslog = MySlog.new

text = <<-EOF
# Time: 111003 14:17:38
# User@Host: root[root] @ localhost []
# Query_time: 0.000270  Lock_time: 0.000097 Rows_sent: 1  Rows_examined: 0
SET timestamp=1317619058;
SELECT * FROM life;
EOF

records = myslog.parse(text)
```

`records` is Array of Hash

```ruby
record = records.first

record[:time]          #=> Time(20111003 14:17:38)
record[:user]          #=> "root[root]"
record[:host]          #=> "localhost"
record[:host_ip]       #=> ""
record[:query_time]    #=> 0.000270
record[:lock_time]     #=> 0.000097
record[:rows_sent]     #=> 1
record[:rows_examined] #=> 0
record[:sql]           #=> "SET timestamp=1317619058; SELECT * FROM life;"
```

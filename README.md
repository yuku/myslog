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

logs = myslog.parse(text)
```

`logs` is Array of Hash

```ruby
log = logs.first

log[:time]          #=> Time
log[:user]          #=> "root[root]"
log[:host]          #=> "localhost"
log[:host_ip]       #=> ""
log[:query_time]    #=> 0.000270
log[:lock_time]     #=> 0.000097
log[:rows_sent]     #=> 1
log[:rows_examined] #=> 0
log[:sql]           #=> "SET timestamp=1317619058; SELECT * FROM life;"
```

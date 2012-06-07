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

f = open("mysql-slow-query.log")
lines = f.read.split("\n")
f.close

logs = myslog.parse(lines)
```

`logs` is Array of Hash

```ruby
log = logs.first

log[:date]
log[:user]
log[:host]
log[:host_ip]
log[:query_time]
log[:lock_time]
log[:rows_sent]
log[:rows_examined]
log[:sql]
```

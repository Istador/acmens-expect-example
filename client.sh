#!/usr/bin/expect -f

# timeout: 30m (DNS propagation might take very long)
set timeout 1800

# arguments
set CSR  [lindex $argv 0]
set CRT  [lindex $argv 1]

# check error
proc check_error { id } {
  set waitval [wait -i $id]
  set exval [lindex $waitval 3]
  if { $exval != 0 } { exit $exval }
}

# eof, timeout and check_error
proc expect_eof { id } {
  set spawn_id $id
  expect {
    eof {
      check_error $id
    }
    timeout {
      puts "##  timeout"
      exit 1
    }
  }
}

# start acmens
spawn ./acmens.sh "$CSR" "$CRT"
set acmens $spawn_id

# skip agreement
expect {
  "Do you agree to the Let's Encrypt Subscriber Agreement\r" {}
  timeout {
    puts "##  timeout"
    exit 1
  }
}
send -i $acmens "yes\r"

# loop till eof
set RUN     1
set DOMAIN  ""
set FILE    ""
set CONTENT ""
set MODE    "http"
while { $RUN == 1 } {
  set spawn_id $acmens
  expect {
    "$DOMAIN verified!" {
      if { $MODE == "http" } {
        spawn ./remove.sh "$DOMAIN" "$FILE"
        set remove $spawn_id
        expect_eof $remove
      }
    }
    -regexp {(?n)^URL: http://([^/]+)/\.well-known/acme-challenge/([a-zA-Z0-9_-]+)[^a-zA-Z0-9_-]*$} {
      set DOMAIN $expect_out(1,string)
      set FILE   $expect_out(2,string)
    }
    -regexp {(?n)^Please update your DNS for [^a-zA-Z0-9\._-]([a-zA-Z0-9\._-]+)[^a-zA-Z0-9\._-] to have the following TXT record:\r*$} {
      set DOMAIN $expect_out(1,string)
    }
    -regexp {(?n)^_acme-challenge    IN    TXT \( [^a-zA-Z0-9_-]([a-zA-Z0-9_-]+)[^a-zA-Z0-9_-] \)\r*$} {
      set CONTENT $expect_out(1,string)
    }
    -regexp {(?n)^File contents: [^a-zA-Z0-9_-]+([a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+)[^a-zA-Z0-9_-]+$} {
      set CONTENT $expect_out(1,string)
    }
    "Press Enter when you've got the file hosted on your server..." {
      puts ""
      set MODE "http"
      spawn ./host.sh "$DOMAIN" "$FILE" "$CONTENT"
      set host $spawn_id
      expect_eof $host
      send -i $acmens "\r"
    }
    "Press Enter when the TXT record is updated on the DNS..." {
      puts ""
      set MODE "dns"
      spawn ./dns.sh "$DOMAIN" "$CONTENT"
      set dns $spawn_id
      expect_eof $dns
      send -i $acmens "\r"
    }
    timeout {
      puts "##  timeout"
      exit 1
    }
    eof {
      set RUN 0
    }
  }
}

# exit with real exit code
check_error $acmens
exit 0

#!/bin/sh
echo
echo
echo
echo '####################################################################'
for x in /proc/sys/fs/file-max; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/kernel/pid_max; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/kernel/sched_migration_cost_ns; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/kernel/sched_autogroup_enabled; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_slow_start_after_idle; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_no_metrics_save; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_abort_on_overflow; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_window_scaling; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_tw_reuse; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/vm/dirty_background_ratio; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/vm/dirty_ratio; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_rfc1337; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_sack; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_fack; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_workaround_signed_windows; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_timestamps; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_syncookies; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_syn_retries; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_synack_retries; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_orphan_retries; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_retries2; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/ip_local_port_range; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/core/netdev_max_backlog; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/core/somaxconn; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_max_tw_buckets; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_max_syn_backlog; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_mtu_probing; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_fin_timeout; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_keepalive_time; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_keepalive_intvl; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_keepalive_probes; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/ip_no_pmtu_disc; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/core/rmem_default; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/core/wmem_default; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/core/optmem_max; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/core/rmem_max; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/core/wmem_max; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_fastopen; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_rmem; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_wmem; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_adv_win_scale; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/core/default_qdisc; do echo -ne "$x "`cat $x`"\n"; done
for x in /proc/sys/net/ipv4/tcp_congestion_control; do echo -ne "$x "`cat $x`"\n"; done
echo '####################################################################'
echo
echo
echo

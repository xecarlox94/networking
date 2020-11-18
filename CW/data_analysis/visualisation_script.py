# To add a new cell, type '# %%'
# To add a new markdown cell, type '# %% [markdown]'
# %%
import tracefile as tr


dv_dfs = [tr.get_df("top2_s.tr"), tr.get_df("top2_m.tr"), tr.get_df("top2_l.tr")]
ls_dfs = [tr.get_df("top1_s.tr"), tr.get_df("top1_m.tr"), tr.get_df("top1_l.tr")]


# %%
tr.plot_dfs(dv_dfs, ls_dfs, tr.total_dropped_packet, "Total Dropped Packets", "Packets")


# %%
tr.plot_dfs(dv_dfs, ls_dfs, tr.packet_delivery_ratio, "Packet Delivery Ratio", "Ratio")


# %%
tr.plot_dfs(dv_dfs, ls_dfs, tr.packet_delivery_ratio, "Traffic Throughput", "Ratio")


# %%
tr.plot_dfs(dv_dfs, ls_dfs, tr.total_lost_packets, "Total Lost Packets", "Packets")


# %%
tr.plot_dfs(dv_dfs, ls_dfs, tr.routing_overhead, "Network Routing Overhead", "Packets")


# %%




# To add a new cell, type '# %%'
# To add a new markdown cell, type '# %% [markdown]'
# %%
import tracefile as tr


# jupiter notebook: main_jupiter_notebook.ipynb
# file to import: tracefile.py
# python script: main.py

dv_dfs = [tr.get_df("Scenario_X_nodes_DV.tr"), tr.get_df("Scenario_Y_nodes_DV.tr"), tr.get_df("Scenario_Z_nodes_DV.tr")]
ls_dfs = [tr.get_df("Scenario_X_nodes_LS.tr"), tr.get_df("Scenario_Y_nodes_LS.tr"), tr.get_df("Scenario_Z_nodes_LS.tr")]


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



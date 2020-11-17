import pandas as pd 
import numpy as np
import matplotlib.pyplot as plt
plt.rcParams.update({'font.size': 25})

# filter a python list and return a numpy array
def filter(dfs, fn):
    arr = []
    for i in range(len(dfs)):
        arr.append(fn(dfs[i]))
    return np.array(arr)


# plot distance vector and link state dataframes, according to which function given
def plot_dfs(dv_dfs, ls_dfs, fn, title, y_label):
    x = np.array([5, 10, 15])
    

    y1 = filter(dv_dfs, fn)
    y2 = filter(ls_dfs, fn)

    _, ax = plt.subplots(figsize=(25,10))

    plt.xticks(range(1, x[len(x) -1]+1, 1))

    ax.plot(x, y1, label='Distance Vector', marker="D")

    ax.plot(x, y2, label='Link State', marker="D")

    plt.title(title)

    plt.ylabel(y_label)

    plt.xlabel("Number of nodes")

    ax.legend()
    plt.show()



# read tr file and return a pandas data frame
def get_df(filename):
    df = pd.read_csv(filename, sep=" ", names=["event", "time", "src_node", "dst_node", "packet_type", "packet_size", "delete" ,"flags", "fragment_id", "src_address", "dst_address", "seq_number", "packet_id"])

    return df.drop([df.columns[6]], axis=1)



# calculate packet delivery ratio
def packet_delivery_ratio(df):
    amnt_sent = len(df[df['event'] == '+'])
    amnt_rcvd = len(df[df['event'] == 'r'])
    return amnt_rcvd / amnt_sent


# calculate total dropped packet number
def total_dropped_packet(df):
    return len(df[df['event'] == 'd'])


# calculate total lost packets number
def total_lost_packets(df):
    amnt_sent = len(df[df['event'] == '+'])
    amnt_rcvd = len(df[df['event'] == 'r'])
    return amnt_sent - amnt_rcvd

# calculate network throughput
def throughput(df):
    total_rcvd = df[df['event'] == 'r']['packet_size'].sum()
    total_sent = df[df['event'] == '+']['packet_size'].sum()
    throughput = (total_rcvd / total_sent) * 100
    return throughput

# calculating network routing overhead
def routing_overhead(df):
    return len(df[df['packet_type'] == 'rtProtoDV'])
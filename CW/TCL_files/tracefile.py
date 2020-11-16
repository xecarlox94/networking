import pandas as pd 

def get_df(filename):
    df = pd.read_csv(filename, sep=" ", names=["event", "time", "src_node", "dst_node", "packet_type", "packet_size", "delete" ,"flags", "fragment_id", "src_address", "dst_address", "seq_number", "packet_id"])

    return df.drop([df.columns[6]], axis=1)



def packet_delivery_ratio(df):
    amnt_sent = len(df[df['event'] == '+'])
    amnt_rcvd = len(df[df['event'] == 'r'])

    return amnt_rcvd / amnt_sent




def total_dropped_packet(df):
    return len(df[df['event'] == 'd'])



def total_lost_packets(df):
    amnt_sent = len(df[df['event'] == '+'])
    amnt_rcvd = len(df[df['event'] == 'r'])

    return amnt_sent - amnt_rcvd



def throughput(df):
    total_rcvd = df[df['event'] == 'r']['packet_size'].sum()
    total_sent = df[df['event'] == '+']['packet_size'].sum()

    throughput = (total_rcvd / total_sent) * 100

    return throughput
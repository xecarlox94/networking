import pandas as pd 

def get_tracefile_df(filename):
    df = pd.read_csv(filename, sep=" ", names=["event", "time", "src_node", "dst_node", "packet_type", "packet_size", "delete" ,"flags", "fragment_id", "src_address", "dst_address", "seq_number", "packet_id"])

    return df.drop([df.columns[6]], axis=1)
import io
import pandas as pd
import requests
if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_api(*args, **kwargs):
    year='2020'
    months=['10','11','12']
    full_df=pd.DataFrame()
    for i in months:
        url = f'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_{year}-{i}.csv.gz'
        df=pd.read_csv(url, compression='gzip')
        full_df= pd.concat([full_df, df], ignore_index=True)
        print(f'{i} dataframe shape',df.shape,'full dataframe',full_df.shape)
    return full_df


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'

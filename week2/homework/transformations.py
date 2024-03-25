import pandas as pd
if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(data, *args, **kwargs):
    print(data.columns)
    data.columns = data.columns.str.lower()

    print (len(data[data['passenger_count']==0]))
    print (len(data[data['trip_distance']==0]))
    data=data[data['passenger_count']>0]
    data=data[data['trip_distance']>0]

    data.lpep_pickup_datetime= pd.to_datetime(data.lpep_pickup_datetime)
    data.lpep_dropoff_datetime= pd.to_datetime(data.lpep_dropoff_datetime)
    data['lpep_pickup_date']=data['lpep_pickup_datetime'].dt.date
    data['lpep_dropoff_date']=data['lpep_dropoff_datetime'].dt.date

    print(data.shape)
    print(data.vendorid.value_counts())
    return data


@test
def test_output(output, *args) -> None:
    assert 'vendorid' in output.columns, 'vendorid does not exist'
    assert output['passenger_count'].isin([0]).sum()==0, 'There are rides with 0 passengers'
    assert output['trip_distance'].isin([0]).sum()==0, 'There are rides with 0 passengers'

-- SELECT THE COLUMNS INTERESTED FOR YOU
SELECT passenger_count,
       trip_distance,
       pulocationid,
       dolocationid,
       payment_type,
       fare_amount,
       tolls_amount,
       tip_amount,
       total_amount
FROM   `data-engineering-417912.ny_taxi.yellow_tripdata_partitioned`
WHERE  fare_amount != 0;

-- CREATE A ML TABLE WITH APPROPRIATE TYPECREATE OR replace TABLE `data-engineering-417912.ny_taxi.yellow_tripdata_ml`
                        (
                            `passenger_count` integer,
                            `trip_distance` float64,
                            `pulocationid` string,
                            `dolocationid` string,
                            `payment_type` string,
                            `fare_amount` float64,
                            `tolls_amount` float64,
                            `tip_amount` float64,
                            `total_amount` float64
                        )
                        AS
                        (
                        SELECT passenger_count,
                            trip_distance,
                            cast(pulocationid AS string),
                            cast(dolocationid AS string),
                            cast(payment_type AS string),
                            fare_amount,
                            tolls_amount,
                            tip_amount,
                            total_amount
                        FROM   `data-engineering-417912.ny_taxi.yellow_tripdata_partitioned`
                        WHERE  fare_amount != 0
                        );

-- CREATE MODEL WITH DEFAULT SETTINGCREATE
OR
replace model `data-engineering-417912.ny_taxi.tip_model` options (model_type='RANDOM_FOREST_REGRESSOR', input_label_cols=['total_amount'], data_split_method='AUTO_SPLIT') ASSELECT *
FROM   `data-engineering-417912.ny_taxi.yellow_tripdata_ml`
WHERE  tip_amount IS NOT NULL;

-- CHECK FEATURESSELECT *
FROM   ml.feature_info(model `data-engineering-417912.ny_taxi.tip_model`);

-- EVALUATE THE MODELSELECT *
FROM   ml.evaluate(model `data-engineering-417912.ny_taxi.tip_model`,
       (
              SELECT *
              FROM   `data-engineering-417912.ny_taxi.yellow_tripdata_ml`
              WHERE  tip_amount IS NOT NULL ));

-- PREDICT THE MODELSELECT *
FROM   ml.predict(model `data-engineering-417912.ny_taxi.tip_model`,
       (
              SELECT *
              FROM   `data-engineering-417912.ny_taxi.yellow_tripdata_ml`
              WHERE  tip_amount IS NOT NULL ));

-- PREDICT AND EXPLAINSELECT *
FROM   ml.explain_predict(model `data-engineering-417912.ny_taxi.tip_model`,
       (
              SELECT *
              FROM   `data-engineering-417912.ny_taxi.yellow_tripdata_ml`
              WHERE  tip_amount IS NOT NULL ), struct(3 AS top_k_features));

-- HYPER PARAM TUNNINGCREATE
OR
replace model `data-engineering-417912.ny_taxi.tip_hyperparam_model` options (model_type='linear_reg', input_label_cols=['tip_amount'], data_split_method='AUTO_SPLIT', num_trials=5, max_parallel_trials=2, l1_reg=hparam_range(0, 20), l2_reg=hparam_candidates([0, 0.1, 1, 10])) ASSELECT *
FROM   `taxi-rides-ny.nytaxi.yellow_tripdata_ml`
WHERE  tip_amount IS NOT NULL;
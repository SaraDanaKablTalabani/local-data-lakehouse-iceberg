from pyspark.sql import SparkSession
from pyspark.sql import functions as F


def create_table(spark):

    df = (
        spark.read
        .option("header", True)
        .option("inferSchema", True)
        .csv("/opt/spark/apps/assets/cars.csv")
    )

    #  Step 1: Clean + filter
    df_clean = (
        df
        .filter(F.col("price") > 30000)
        .filter(F.col("year") > 2015)
    )

    #  Step 2: Add columns
    df_enriched = (
        df_clean
        .withColumn("price_with_tax", F.col("price") * 1.1)
        .withColumn("car_age", 2025 - F.col("year"))
    )

    #  Step 3: Aggregate
    df_final = (
        df_enriched
        .groupBy("brand")
        .agg(F.avg("price").alias("avg_price"))
    )

    #  Write result
    df_final.write \
        .format("iceberg") \
        .mode("overwrite") \
        .saveAsTable("catalog_iceberg.schema_iceberg.cars")


if __name__ == "__main__":
    spark = SparkSession.builder.appName("CarsPipeline").getOrCreate()
    create_table(spark)

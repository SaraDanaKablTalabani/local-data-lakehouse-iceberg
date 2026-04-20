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
        .filter(F.col("Price") > 30000)
        .filter(F.col("Model_Year") > 2015)
    )

    # Step 2: Add columns
    df_enriched = (
        df_clean
        .withColumn("price_with_tax", F.col("Price") * 1.1)
        .withColumn("car_age", 2025 - F.col("Model_Year"))
    )

    #  Step 3: Aggregate
    df_final = (
        df_enriched
        .groupBy("brand")
        .agg(F.avg("Price").alias("avg_price"))
    )

    #  WRITE 1: Detailed table
    df_enriched.write \
        .format("iceberg") \
        .mode("overwrite") \
        .saveAsTable("catalog_iceberg.schema_iceberg.cars_detailed")

    #  WRITE 2: Aggregated table
    df_final.write \
        .format("iceberg") \
        .mode("overwrite") \
        .saveAsTable("catalog_iceberg.schema_iceberg.cars_summary")


if __name__ == "__main__":
    spark = SparkSession.builder \
        .appName("CarsPipeline") \
        .getOrCreate()

    create_table(spark)

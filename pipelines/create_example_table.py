from pyspark.sql import SparkSession


def create_table(spark: SparkSession) -> None:


    df = (
        spark.read
        .option("header", True)
        .option("inferSchema", True)
        .csv("/opt/spark/apps/assets/cars.csv")
        .limit(5)
    )



    #df = (
     #   spark.read
     #   .option("header", True)
      #  .option("inferSchema", True)
      #  .csv("/opt/spark/apps/assets/cars.csv")
   # )

    df.write \
        .format("iceberg") \
        .mode("overwrite") \
        .saveAsTable("catalog_iceberg.schema_iceberg.cars")


if __name__ == "__main__":
    spark = SparkSession.builder \
        .appName("CarsPipeline") \
        .getOrCreate()

    create_table(spark)

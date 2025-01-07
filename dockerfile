# Baseado na imagem oficial do Airflow
FROM apache/airflow:2.7.0

# Instala o dbt Core e o adaptador para Snowflake
RUN pip install dbt-core dbt-snowflake


# Define o usuário padrão como 'airflow'
USER airflow
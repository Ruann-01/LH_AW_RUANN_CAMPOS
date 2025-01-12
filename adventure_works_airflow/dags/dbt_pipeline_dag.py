from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.utils.dates import days_ago

# Configurações básicas da DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
}

with DAG(
    'dbt_pipeline_dag',
    default_args=default_args,
    description='Executa a modelagem em dbt diariamente',
    schedule_interval='0 6 * * *',  # Executa todos os dias às 06:00
    start_date=days_ago(1),  # Sempre próximo da data atual sem ajustes manuais
    catchup=False,
) as dag:

    # Testa os modelos dbt
    dbt_test = BashOperator(
        task_id='dbt_test',
        bash_command='cd /mnt/d/Documents/Desafios_Indicium/LH_AW_RUANN_CAMPOS/adventure_works_dbt_modeling && dbt test'
    )

    # Executa as transformações dbt
    dbt_run = BashOperator(
        task_id='dbt_run',
        bash_command='cd /mnt/d/Documents/Desafios_Indicium/LH_AW_RUANN_CAMPOS/adventure_works_dbt_modeling && dbt run'
    )

    # Dependências entre as tarefas
    dbt_test >> dbt_run

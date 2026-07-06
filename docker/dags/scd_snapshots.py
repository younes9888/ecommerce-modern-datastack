from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

default_args = {
    "owner": "airflow",
    "retries": 1,
    "retry_delay": timedelta(minutes=1),
}

with DAG(
    dag_id="dbt_pipeline",
    start_date=datetime(2026, 7, 1),
    schedule="@daily",
    catchup=False,
) as dag:

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command="""
        cd /opt/airflow/ecommerce_dbt
        dbt run --profiles-dir /home/airflow/.dbt
        """
    )

    dbt_snapshot = BashOperator(
        task_id="dbt_snapshot",
        bash_command="""
        cd /opt/airflow/ecommerce_dbt
        dbt snapshot --profiles-dir /home/airflow/.dbt
        """
    )

    dbt_run >> dbt_snapshot
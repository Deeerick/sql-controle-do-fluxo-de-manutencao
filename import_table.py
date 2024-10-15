import cx_Oracle
import pyodbc
from config import TABELA_ORIGEM, TABELA_DESTINO, USER, PASSWORD, HOST_ORACLE, HOST_SQL, SERVER, TRUSTED_CONNECTION


def conn_oracle():
    try:
        conn_oracle = cx_Oracle.connect(USER, PASSWORD, HOST_ORACLE)
        return conn_oracle
    except cx_Oracle.DatabaseError as e:
        print(f"Erro ao conectar ao Oracle: {e}")
        return None


def conn_sql():
    try:
        conn_sql = pyodbc.connect(f"DRIVER={{SQL server Native Client 11.0}};SERVER={
                                  SERVER};DATABASE={HOST_SQL};Truested_Connection={TRUSTED_CONNECTION}")
        return conn_sql
    except pyodbc.DatabaseError as e:
        print(f"Erro ao conectar ao SQL Server: {e}")
        return None


def main():
    connection = conn_oracle()

    if connection is None:
        print(f'Erro ao conectar ao Oracle')
        return

    try:
        cursor = connection.cursor()

        # Comando SQL
        sql_query = f"SELECT COUNT(*) FROM {TABELA_ORIGEM}"

        # Executa o comando SQL
        cursor.execute(sql_query)
        result = cursor.fetchone()
        formatted_result = f"{result[0]:,}".replace(",", ".")
        print(f"Total de registro na tabela {
              TABELA_ORIGEM}: {formatted_result}")

    except cx_Oracle.DatabaseError as e:
        print(f"Erro ao executar a consulta: {e}")

    finally:
        # Fecha o cursor e a conexão
        print("Fechando cursor e conexão")
        cursor.close()
        connection.close()


if __name__ == '__main__':
    main()

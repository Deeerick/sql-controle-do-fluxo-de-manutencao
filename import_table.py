import cx_Oracle
import pyodbc
from tqdm import tqdm
from models.config import TABELA_ORIGEM, TABELA_DESTINO
from models.engine import conn_oracle, conn_sql


def main():
    con_oracle = conn_oracle()
    con_sql = conn_sql()

    if con_oracle is None:
        print('Erro ao conectar ao Oracle')
        return

    if con_sql is None:
        print('Erro ao conectar ao SQL Server')
        return

    try:
        oracle_cursor = con_oracle.cursor()
        sql_cursor = con_sql.cursor()

        # Seleciona todos os dados da tabela Oracle com barra de progresso
        oracle_cursor.execute(f"SELECT * FROM {TABELA_ORIGEM}")
        rows = []
        for row in tqdm(oracle_cursor, desc="Selecionando dados", unit="linha"):
            rows.append(row)

        # Insere os dados na tabela SQL Server com barra de progresso
        for row in tqdm(rows, desc="Migrando dados", unit="linha"):
            placeholders = ', '.join(['?'] * len(row))
            sql_query = f"INSERT INTO {TABELA_DESTINO} VALUES ({placeholders})"
            sql_cursor.execute(sql_query, row)

        con_sql.commit()
        print(f"Dados migrados de {TABELA_ORIGEM} para {
              TABELA_DESTINO} com sucesso.")

    except (cx_Oracle.DatabaseError, pyodbc.DatabaseError) as e:
        print(f"Erro ao migrar os dados: {e}")

    finally:
        # Fecha os cursores e as conexões
        print("Fechando cursores e conexões")
        oracle_cursor.close()
        con_oracle.close()
        sql_cursor.close()
        con_sql.close()


if __name__ == '__main__':
    main()

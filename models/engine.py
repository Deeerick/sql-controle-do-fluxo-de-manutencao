import cx_Oracle
import pyodbc
from models.config import USER, PASSWORD, HOST_ORACLE, HOST_SQL, SERVER, TRUSTED_CONNECTION


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

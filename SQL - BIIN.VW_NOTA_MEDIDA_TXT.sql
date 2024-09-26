SELECT
    /* Nota */
    nota.NOTA AS nota_NOTA,
    nota.TIPO_NOTA AS nota_TIPO_NOTA,
    nota.TEXTO_BREVE AS nota_TEXTO_BREVE,
    nota.STATUS_SISTEMA AS nota_STATUS_SISTEMA,
    nota.STATUS_USUARIO AS nota_STATUS_USUARIO,
    nota.ORDEM AS nota_ORDEM,
    nota.LOCAL_INSTALACAO AS nota_LOCAL_INSTALACAO,
    nota.EQUIPAMENTO AS nota_EQUIPAMENTO,
    nota.AUTOR_NOTA AS nota_AUTOR_NOTA,
    nota.DATA_CRIACAO AS nota_DATA_CRIACAO,
    nota.SALA AS nota_SALA,
    nota.DATA_ENCERRAMENTO AS nota_DATA_ENCERRAMENTO,
    /* Medida */
    medida.NUMERO_NOTA AS medida_NUMERO_NOTA,
    medida.NUMERO_INTERNO_MEDIDA AS medida_NUMERO_INTERNO_MEDIDA,
    medida.NUMERO_MEDIDA AS medida_NUMERO_MEDIDA,
    medida.NUMERO_INTERNO_PARTE AS medida_NUMERO_INTERNO_PARTE,
    medida.CODIGO_CODE_MEDIDA AS medida_CODIGO_CODE_MEDIDA,
    medida.TEXTO_BREVE_MEDIDA AS medida_TEXTO_BREVE_MEDIDA,
    medida.TEXTO_STATUS_SISTEMA AS medida_TEXTO_STATUS_SISTEMA,
    medida.TEXTO_STATUS_USUARIO AS medida_TEXTO_STATUS_USUARIO,
    medida.NUMERO_OBJETO AS medida_NUMERO_OBJETO,
    medida.CODIGO_PARCEIRO_FUNCAO AS medida_CODIGO_PARCEIRO_FUNCAO,
    medida.CODIGO_PARCEIRO_RESPONSAVEL AS medida_CODIGO_PARCEIRO_RESPONSAVEL,
    medida.CODIGO_CATALOGO_MEDIDA AS medida_CODIGO_CATALOGO_MEDIDA,
    medida.INDICADOR_MARCACAO_ELIMINACAO AS medida_INDICADOR_MARCACAO_ELIMINACAO,
    medida.NUMERO_ORDEM_MANUNTECAO AS medida_NUMERO_ORDEM_MANUNTECAO,
    medida.CODIGO_CENTRO_SAP_LOCALIZACAO AS medida_CODIGO_CENTRO_SAP_LOCALIZACAO,
    medida.CODIGO_LOCALIZACAO AS medida_CODIGO_LOCALIZACAO,
    medida.INDICADOR_EXISTE_TEXTO_LONGO AS medida_INDICADOR_EXISTE_TEXTO_LONGO,
    medida.CODIGO_USUARIO_CRIACAO AS medida_CODIGO_USUARIO_CRIACAO,
    medida.DATA_CRIACAO AS medida_DATA_CRIACAO,
    medida.CODIGO_USUARIO_MODIFICACAO AS medida_CODIGO_USUARIO_MODIFICACAO,
    medida.DATA_MODIFICACAO AS medida_DATA_MODIFICACAO,
    medida.DATA_CONCLUSAO_PLANEJADA AS medida_DATA_CONCLUSAO_PLANEJADA,
    medida.CODIGO_USUARIO_CONCLUSAO AS medida_CODIGO_USUARIO_CONCLUSAO,
    medida.DATA_CONCLUSAO AS medida_DATA_CONCLUSAO,
    /* Texto longo */
    txt_longo.TELO_CD_OBJETO AS txt_longo_TELO_CD_OBJETO,
    txt_longo.TELO_TX_LINHA AS txt_longo_TELO_TX_LINHA,
    /* Status */
    status.HISO_CD_OBJETO AS status_HISO_CD_OBJETO,
    status.PH AS status_PH,
    status.MSUC AS status_MSUC,
    status.ELIM AS status_ELIM,
    status.CANC AS status_CANC
FROM
    [BD_UNBCDIGITAL].[biin].[nota_manutencao] AS nota
    LEFT JOIN [BD_UNBCDIGITAL].[biin].[nota_manutencao_medida] AS medida ON nota.NOTA = medida.NUMERO_NOTA
    LEFT JOIN [BD_UNBCDIGITAL].[biin].[texto_longo_medida] AS txt_longo ON medida.NUMERO_OBJETO = txt_longo.TELO_CD_OBJETO
    LEFT JOIN (
        SELECT
            *
        FROM
            (
                SELECT
                    HISO_CD_OBJETO,
                    HISO_TX_BREVE_STATUS,
                    HISO_DT_MODIFICACAO_STATUS
                FROM
                    [BD_UNBCDIGITAL].[biin].[historico_status_medida]
                WHERE
                    HISO_IN_STATUS_INATIVO IS NULL
                    AND HISO_TX_BREVE_STATUS IN ('MSUC', 'PH', 'ELIM', 'CANC')
            ) AS SourceTable PIVOT (
                MAX(HISO_DT_MODIFICACAO_STATUS) FOR HISO_TX_BREVE_STATUS IN ([MSUC], [PH], [ELIM], [CANC])
            ) AS PivotTable
            /* Adicionando o alias da subconsulta PIVOT */
    ) AS status ON status.HISO_CD_OBJETO = medida.NUMERO_OBJETO
WHERE
    nota.TIPO_NOTA = 'ZR';

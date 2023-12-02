#select * FROM pib_municipios;
#select * FROM fpibmunicipios;

#####
#SELECT DISTINCT xtab.* from (
SELECT 
	(select idTempo from dTEmpo where dTempo.ano = pm.Ano) as idTempo,
	(select idUF from dUF where dUF.UF = pm.Sigla_da_Unidade_da_Federacao) as idUF,
    (select idMunicipio from dmunicipio where dmunicipio.municipio = pm.nome_do_municipio) as idMunicipio
	pm.
FROM pib_municipios pm;
#order by pm.Nome_do_Municipio asc) xtab;
######



/*
drop procedure pInsertPibMunicipios;

DELIMITER $$
CREATE PROCEDURE pInsertPibMunicipios()
BEGIN
    DECLARE done BOOL DEFAULT FALSE;
    
    DECLARE v_idTempo int;
    DECLARE v_idUF int;
    DECLARE v_municipio text;
    
    DECLARE v_valor_adc_bruto_primario double;
    DECLARE v_valor_adc_bruto_secundario double;
    DECLARE v_valor_adc_bruto_terciario double;
    DECLARE v_valor_adc_bruto_outros double;
    DECLARE v_valor_impostos_subsidios double;
    DECLARE v_valor_produto_interno_bruto double;
    DECLARE v_valor_produto_interno_bruto_per_capita double;

    -- Declare o cursor
    DECLARE testeCur CURSOR FOR (
    SELECT distinct
	(select idUF from dUF where dUF.UF = pm.Sigla_da_Unidade_da_Federacao) as idUF,
        pm.Nome_do_Municipio
	FROM pib_municipios pm
	order by pm.Nome_do_Municipio asc
    );
	
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN testeCur;
    inserir: LOOP
        FETCH testeCur INTO v_idUF, v_municipio;

        IF done THEN
            LEAVE inserir;
        END IF;

        INSERT INTO dmunicipio(idUF,municipio) VALUES (v_idUF, v_municipio);
    END LOOP;


    CLOSE testeCur;
END$$
DELIMITER ;

call pInsertMunicipios();
select * from dmunicipio;

*/
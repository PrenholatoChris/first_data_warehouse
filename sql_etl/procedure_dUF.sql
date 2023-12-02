/*
SELECT distinct pm.ano as ano FROM pib_municipios pm;
select * from dTempo;
select * FROM pib_municipios pm;

select DISTINCT xtab.* from (
        SELECT DISTINCT pib_municipios.Sigla_da_Unidade_da_Federacao as unidade FROM pib_municipios
        union all 
			SELECT DISTINCT tributos_estaduais.id_uf AS unidade FROM tributos_estaduais ) xtab
	order by unidade asc;
    
    
     UNION ALL
			SELECT DISTINCT tributos_estaduais.id_uf AS unidade,
				tributos_estaduais tributos_estaduais 
*/

    select * FROM tributos_estaduais;


drop procedure pInsertUF;

DELIMITER $$
CREATE PROCEDURE pInsertUF()
BEGIN
    DECLARE done BOOL DEFAULT FALSE;
    DECLARE v_UF text;
    DECLARE v_estado text;
    DECLARE v_regiao text;

    -- Declare o cursor
    DECLARE testeCur CURSOR FOR (
    SELECT DISTINCT pib_municipios.Sigla_da_Unidade_da_Federacao as unidade ,
			pib_municipios.Nome_da_Unidade_da_Federacao as estado,
            pib_municipios.Nome_da_Grande_Regiao as regiao FROM pib_municipios
		order by unidade asc);
	
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN testeCur;
    inserir: LOOP
        FETCH testeCur INTO v_UF, v_estado, v_regiao;

        IF done THEN
            LEAVE inserir;
        END IF;

        INSERT INTO dUF(UF,estado, regiao) VALUES (v_UF,v_estado,v_regiao);
    END LOOP;


    CLOSE testeCur;
END$$
DELIMITER ;

call pInsertUF();
select * from dUF;

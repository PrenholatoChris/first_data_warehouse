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

select * FROM pib_municipios;

SELECT count(*) from (select distinct
	(select idUF from dUF where dUF.UF = pm.Sigla_da_Unidade_da_Federacao) as idUF,
		pm.Nome_da_Grande_Regiao as regiao,
        pm.Nome_do_Municipio
FROM pib_municipios pm
	order by pm.Nome_do_Municipio asc) xtab;



SELECT distinct
	(select idUF from dUF where dUF.UF = pm.Sigla_da_Unidade_da_Federacao) as idUF,
		pm.Nome_da_Grande_Regiao as regiao,
        pm.Nome_do_Municipio
FROM pib_municipios pm
	order by pm.Nome_do_Municipio asc;

drop procedure pInsertMunicipios;

DELIMITER $$
CREATE PROCEDURE pInsertMunicipios()
BEGIN
    DECLARE done BOOL DEFAULT FALSE;
    DECLARE v_idUF int;
    declare v_municipio text;

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


#select * FROM pib_municipios;
#select * FROM fpibmunicipios;

select (select idUF from dUF where duf.UF = pm.Sigla_da_Unidade_da_Federacao) as idUF,
	(select idmunicipio from dmunicipio 
		where dmunicipio.municipio=pm.Nome_do_Municipio
          and dmunicipio.idUF = (select idUF from dUF where duf.UF = pm.Sigla_da_Unidade_da_Federacao)) as idmunicipio,
	pm.* 
from pib_municipios pm
where pm.Nome_do_Municipio like 'Bom Jesus';

#####
#SELECT DISTINCT xtab.* from (
SELECT 
	(select idTempo from dTempo where dTempo.ano = pm.Ano) as idTempo,
	(select idUF from dUF where dUF.UF = pm.Sigla_da_Unidade_da_Federacao) as idUF,
    (select idmunicipio from dmunicipio 
		where dmunicipio.municipio=pm.Nome_do_Municipio
          and dmunicipio.idUF = (select idUF from dUF where duf.UF = pm.Sigla_da_Unidade_da_Federacao)) as idmunicipio,
	pm.Valor_adicionado_bruto_da_Agropecuaria as primario,
    pm.Valor_adicionado_bruto_da_Industria as secundario,
    pm.Valor_adicionado_bruto_dos_Servicos as terciario,
    pm.`Valor_adicionado_bruto_da_Administracao._defesa` as outros,
    pm.Valor_adicionado_bruto_total as adicionado_total,
    pm.`Impostos._liquidos_de_subsidios` as impostos,
    pm.Produto_Interno_Bruto as pib,
    pm.Produto_Interno_Bruto_per_capita as pib_per_capita
FROM pib_municipios pm;
#order by pm.Nome_do_Municipio asc) xtab;
######




drop procedure pInsertFPib;

DELIMITER $$
CREATE PROCEDURE pInsertFPib()
BEGIN
    DECLARE done BOOL DEFAULT FALSE;
    
    DECLARE v_idTempo int;
    DECLARE v_idUF int;
    DECLARE v_idmunicipio text;
    
    DECLARE v_valor_adc_bruto_primario double;
    DECLARE v_valor_adc_bruto_secundario double;
    DECLARE v_valor_adc_bruto_terciario double;
    DECLARE v_valor_adc_bruto_outros double;
    DECLARE v_valor_adc_bruto_total double;
    DECLARE v_valor_impostos_subsidios double;
    DECLARE v_valor_produto_interno_bruto double;
    DECLARE v_valor_produto_interno_bruto_per_capita double;

    -- Declare o cursor
    DECLARE testeCur CURSOR FOR (
    SELECT  
		(select idTempo from dTempo where dTempo.ano = pm.Ano) as idTempo,
		(select idUF from dUF where dUF.UF = pm.Sigla_da_Unidade_da_Federacao) as idUF,
		(select idmunicipio from dmunicipio 
			where dmunicipio.municipio=pm.Nome_do_Municipio
			  and dmunicipio.idUF = (select idUF from dUF where duf.UF = pm.Sigla_da_Unidade_da_Federacao)) as idmunicipio,
		pm.Valor_adicionado_bruto_da_Agropecuaria as primario,
		pm.Valor_adicionado_bruto_da_Industria as secundario,
		pm.Valor_adicionado_bruto_dos_Servicos as terciario,
		pm.`Valor_adicionado_bruto_da_Administracao._defesa` as outros,
		pm.Valor_adicionado_bruto_total as adicionado_total,
		pm.`Impostos._liquidos_de_subsidios` as impostos,
		pm.Produto_Interno_Bruto as pib,
		pm.Produto_Interno_Bruto_per_capita as pib_per_capita
	FROM pib_municipios pm);
	
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN testeCur;
    inserir: LOOP
        FETCH testeCur INTO v_idTempo, v_idUF, v_idmunicipio, v_valor_adc_bruto_primario, v_valor_adc_bruto_secundario, v_valor_adc_bruto_terciario, v_valor_adc_bruto_outros,
        v_valor_adc_bruto_total, v_valor_impostos_subsidios, v_valor_produto_interno_bruto, v_valor_produto_interno_bruto_per_capita;

        IF done THEN
            LEAVE inserir;
        END IF;

        INSERT INTO fpib(
			idtempo, 
			iduf, 
            idmunicipio,
            valor_adicionado_bruto_primario,
            valor_adicionado_bruto_secundario,
            valor_adicionado_bruto_terciario,
            valor_adicionado_bruto_outros,
            valor_adicionado_bruto_total,
            valor_impostos_liquidos_de_subsidios,
            valor_produto_interno_bruto,
            valor_produto_interno_bruto_per_capita
            ) values 
			(v_idTempo, v_idUF, v_idmunicipio, v_valor_adc_bruto_primario, v_valor_adc_bruto_secundario, v_valor_adc_bruto_terciario,
				v_valor_adc_bruto_outros, v_valor_adc_bruto_total, v_valor_impostos_subsidios, v_valor_produto_interno_bruto, 
				v_valor_produto_interno_bruto_per_capita
			);
    END LOOP;
    CLOSE testeCur;
END$$
DELIMITER ;

call pInsertFPib();
select count(*) from fpib;


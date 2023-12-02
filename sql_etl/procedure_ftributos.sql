SELECT 
	(select idTempo from dTempo where dTempo.ano = te.ano2) as idTempo,
	(select idUF from dUF where dUF.UF = te.id_uf) as idUF,
	sum(te.va_icms_primario) as primario,
	sum(te.va_icms_secundario) as secundario,
	sum(te.va_icms_terciario) as terciario,
	sum(te.va_icms_energia) as energia,
	sum(te.va_icms_combustiveis) as combustiveis,
	sum(te.va_icms_divida_ativa) as dividas,
	sum(te.va_icms_outras) as outras,
	sum(te.va_icms_total) as total,
	sum(te.va_outros_tributos_total) as outros_tributos_total,
	sum(te.va_receita_tributaria_total) as receita_total
FROM tributos_estaduais te
group by idTempo, idUF;

drop procedure pInsertFTributos;

DELIMITER $$
CREATE PROCEDURE pInsertFTributos()
BEGIN
    DECLARE done BOOL DEFAULT FALSE;
    
    DECLARE v_idTempo int;
    DECLARE v_idUF int;
    
    DECLARE v_primario double;
    DECLARE v_secundario double;
    DECLARE v_terciario double;
    DECLARE v_energia double;
    DECLARE v_combustiveis double;
    DECLARE v_dividas double;
    DECLARE v_icms_outras double;
    DECLARE v_icms_total double;
    DECLARE v_outros_tributos_total double;
    DECLARE v_receita_total double;

    -- Declare o cursor
    DECLARE testeCur CURSOR FOR (
		SELECT 
			(select idTempo from dTempo where dTempo.ano = te.ano2) as idTempo,
			(select idUF from dUF where dUF.UF = te.id_uf) as idUF,
			sum(te.va_icms_primario) as primario,
			sum(te.va_icms_secundario) as secundario,
			sum(te.va_icms_terciario) as terciario,
			sum(te.va_icms_energia) as energia,
			sum(te.va_icms_combustiveis) as combustiveis,
			sum(te.va_icms_divida_ativa) as dividas,
			sum(te.va_icms_outras) as outras,
			sum(te.va_icms_total) as total,
			sum(te.va_outros_tributos_total) as outros_tributos_total,
			sum(te.va_receita_tributaria_total) as receita_total
		FROM tributos_estaduais te
        group by idTempo, idUF
	);
	
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN testeCur;
    inserir: LOOP
        FETCH testeCur INTO v_idTempo, v_idUF, v_primario, v_secundario, v_terciario, v_energia, v_combustiveis,
				v_dividas, v_icms_outras, v_icms_total, v_outros_tributos_total, v_receita_total;

        IF done THEN
            LEAVE inserir;
        END IF;

        INSERT INTO ftributos(
			idtempo, 
			iduf, 
            valor_icms_primario,
            valor_icms_secundario,
            valor_icms_terciario,
            valor_icms_energia,
            valor_icms_combustivel,
            valor_icms_dividas_ativas,
            valor_icms_outras,
            valor_icms_total,
            valor_outros_tributos_total,
            valor_receita_tributaria_total
		) values 
			(	v_idTempo, v_idUF, v_primario, v_secundario, v_terciario, v_energia, v_combustiveis,
				v_dividas, v_icms_outras, v_icms_total, v_outros_tributos_total, v_receita_total
			);
    END LOOP;
    CLOSE testeCur;
END$$
DELIMITER ;


call pInsertFTributos();
select count(*) from ftributos;


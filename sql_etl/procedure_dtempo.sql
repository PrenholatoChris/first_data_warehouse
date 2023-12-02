#SELECT distinct pm.ano as ano FROM pib_municipios pm;
#select * from dTempo;

DELIMITER $$

CREATE PROCEDURE teste()
BEGIN
    DECLARE done BOOL DEFAULT FALSE;
    DECLARE v_ano INT;

    -- Declare o cursor
    DECLARE testeCur CURSOR FOR 
        SELECT DISTINCT pm.ano AS ano FROM pib_municipios pm;

    -- Trate o caso em que não há mais linhas
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Abra o cursor
    OPEN testeCur;

    -- Loop para inserir valores na tabela dTempo
    inserir: LOOP
        FETCH testeCur INTO v_ano;

        -- Sai do loop se não houver mais linhas
        IF done THEN
            LEAVE inserir;
        END IF;

        -- Faça algo com o valor, por exemplo, inserir na tabela dTempo
        INSERT INTO dTempo(Ano) VALUES (v_ano);
    END LOOP;

    -- Feche o cursor
    CLOSE testeCur;
END$$

DELIMITER ;


call teste();

select * from dtempo;
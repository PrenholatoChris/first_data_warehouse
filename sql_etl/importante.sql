/*
dTempo
	IdTempo
	Ano

dMunicipio
	idMunicipio
	idUF
	Região
	TipoRegião
	Municipio

dUF
	idUF
	UF
	Estado

fImpostosEstaduais
	#IdTempo
	#UF
	ICMSPrimario
	ICMSSecundário
	ICMSTerciário
	IPVA
	OutrasTaxas
	ICMSTotal
	TotalDeOutrosTributos
	ReceitaTributáriaTotal

fPibMunicipios
	#IdTempo
	#UF
	#idMunicipio
	ValorPibIndustria
	ValorPibServiços
	ValorPibAdm
	ValorPib
	ValorPibPerCapita
    */

drop table fpibmunicipios;
drop table fimpostosestaduais;
drop table dMunicipio;
drop table dUF;
drop table dtempo;

CREATE TABLE dTempo( idTempo int auto_increment, Ano int, primary key(idTempo));
CREATE TABLE dUF( idUF int auto_increment, UF text, regiao text, estado text, primary key(idUF));
CREATE TABLE dMunicipio( idMunicipio int auto_increment, idUF int, municipio text, primary key(idMunicipio), foreign key (idUF) references dUF(idUF));
CREATE TABLE fPibMunicipios ( idTempo int,
	idUF int, idMunicipio int,
    `valor_adicionado_bruto_primario` double DEFAULT 0,
    `valor_adicionado_bruto_da_secundario` double DEFAULT 0,
	`valor_adicionado_bruto_terciario` double DEFAULT 0,
    `valor_adicionado_bruto_outros` double DEFAULT 0,
	`valor_adicionado_bruto_total` double DEFAULT 0,
    `valor_impostos_liquidos_de_subsidios` double DEFAULT 0,
    `valor_produto_interno_bruto` double DEFAULT 0,
	`valor_produto_interno_bruto_per_capita` double DEFAULT 0, 
	foreign key(idTempo) references dTempo(idTempo),
	foreign key(idUF) references dUF(idUF), 
	foreign key(idMunicipio) references dMunicipio(idMunicipio)
);

CREATE TABLE fImpostosEstaduais(
	idTempo int, idUF int,
	`valor_icms_primario` int DEFAULT 0,
	`valor_icms_secundario` int DEFAULT 0,
	`valor_icms_terciario` int DEFAULT 0,
	`valor_icms_energia` int DEFAULT 0,
	`valor_icms_combustivel` int DEFAULT 0,
	`valor_icms_dividas_ativas` int DEFAULT 0,
	`valor_icms_outras` int DEFAULT 0,
	`valor_icms_total` int DEFAULT 0,
	`valor_outros_tributos_ipva` int DEFAULT 0,
	`valor_outros_tributos_taxas` int DEFAULT 0,
	`valor_outros_tributos_outros` int DEFAULT 0,
	`valor_outros_tributos_total` int DEFAULT 0,
	`valor_receita_tributaria_total` int DEFAULT 0,
	foreign key(idTempo) references dTempo(idTempo),
	foreign key(idUF) references dUF(idUF)
);


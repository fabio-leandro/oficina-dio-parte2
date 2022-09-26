/*Criando tabela clientes*/
CREATE TABLE IF NOT EXISTS clientes(
	idCliente SERIAL PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	cpf VARCHAR(11) UNIQUE NOT NULL,
	endereco VARCHAR(120) NOT NULL
);

INSERT INTO clientes VALUES(1,'Fábio de Oliveira','53876850002','Rua Brasil,22 - Bairro Soracaba, SP-BR');
INSERT INTO clientes VALUES(2,'Paula Moreira','30946457042','Rua São Paulo, 23 - Bairro Rio de Janeiro, RJ-BR');
INSERT INTO clientes VALUES(3,'Cristina Carla','68296167000','Rua Sacramento, 45 - Bairro Metro, BH-MG');

INSERT INTO clientes VALUES (4,'Melissa Carmen','64053371031','Rua Vinte e cinco de Marco');
INSERT INTO clientes VALUES (5, 'Marta Rocha','26045957024','Rua Vila Isabel');
INSERT INTO clientes VALUES (6, 'Monica Vieira', '67887889014','Rua Mercantil');
INSERT INTO clientes VALUES (7, 'Marcelo Caldeira','56356576057','Rua Menino Feliza');
INSERT INTO clientes VALUES (8, 'Mizael Vilela','57790675036','Rua Casa Branca');
INSERT INTO clientes VALUES (9, 'Plinio Mota','91239280009','Rua Centenario');
INSERT INTO clientes VALUES (10, 'Bruno Francisco','52641468026','Rua Sergipe');

SELECT * FROM clientes;

/*Criando tabela Veiculos*/
CREATE TABLE IF NOT EXISTS veiculos(
	idVeiculo SERIAL PRIMARY KEY,
	descricao VARCHAR(50) NOT NULL,
	placa VARCHAR(7) NOT NULL,
	cor VARCHAR(20) NOT NULL,
	id_cliente INTEGER NOT NULL,
	FOREIGN KEY (id_cliente) REFERENCES clientes (idCliente)
);
INSERT INTO veiculos VALUES(1,'Fiat Strada','WER3445','Branco',1);
INSERT INTO veiculos VALUES(2,'Hyundai HB20','GHR5678','Vermelho',2);
INSERT INTO veiculos VALUES(3,'Chevrolet Onix','ZYT7889','Azul',3);

ALTER TABLE veiculos ADD CONSTRAINT constraint_unique_placa UNIQUE (placa);

INSERT INTO veiculos VALUES(4,'Volkswagen T-Cross','TGG2345','Preto',4);
INSERT INTO veiculos VALUES(5,'Jeep Compass','YYY2123','Verde',5);
INSERT INTO veiculos VALUES(6,'Fiat Cronos','RRQ2246','Branco',6);
INSERT INTO veiculos VALUES(7,'Hyundai Creta','CSS1290','Vermelho',7);
INSERT INTO veiculos VALUES(8,'Chevrolet Tracker','AZX3434','Prata',8);
INSERT INTO veiculos VALUES(9,'Renault Kwid','DDB7788','Branco',9);
INSERT INTO veiculos VALUES(10,'Fiat Pulse','HHH5568','Prata',10);


SELECT * FROM veiculos;
SELECT * FROM clientes;

SELECT c.nome, c.cpf, c.endereco, v.descricao, v.placa, v.cor
FROM clientes as c
INNER JOIN veiculos as v
ON c.idCliente = v.id_cliente;

/*Criando tabela ordensServicos*/
CREATE TYPE STATUS_ORDEM AS ENUM('Analise','Oficina','Aguardando Pecas','Pronto');
CREATE TABLE IF NOT EXISTS ordens(
	idOrdem SERIAL PRIMARY KEY,
	status STATUS_ORDEM default 'Analise',
	dataEmissao DATE NOT NULL default CURRENT_DATE,
	dataConclusao DATE,
	formaPagamento VARCHAR(30) NOT NULL,
	id_veiculo INTEGER NOT NULL,
	FOREIGN KEY (id_veiculo) REFERENCES veiculos (idVeiculo)
);

SELECT * FROM ordens;

INSERT INTO ordens VALUES (1,default,default,null,'Débito à Vista',1);
INSERT INTO ordens VALUES (2,default,default,null,'Crédito à Vista',2);
INSERT INTO ordens VALUES (3,default,default,null,'Crédito 3x',3);

UPDATE ordens set dataEmissao = '2022-09-01';
UPDATE ordens set dataConclusao = '2022-09-22' WHERE idOrdem IN (1,2);
UPDATE ordens set dataConclusao = '2022-09-12' WHERE idOrdem = 3;

INSERT INTO ordens VALUES (4,default,default,null,'Débito à Vista',4);
INSERT INTO ordens VALUES (5,default,default,null,'Crédito à Vista',5);
INSERT INTO ordens VALUES (6,default,default,null,'Crédito 3x',6);
INSERT INTO ordens VALUES (7,default,default,null,'Débito à Vista',7);
INSERT INTO ordens VALUES (8,default,default,null,'Crédito à Vista',8);
INSERT INTO ordens VALUES (9,default,default,null,'Crédito 3x',9);
INSERT INTO ordens VALUES (10,default,default,null,'Crédito 3x',10);

UPDATE ordens set dataEmissao = '2022-09-12' WHERE idOrdem IN (4,5,6,7,8,9,10);
UPDATE ordens set dataConclusao = '2022-09-12' WHERE idOrdem IN (4,5,6,7,8,9,10);
SELECT * FROM ordens;


/*Criando tabela servicos*/
CREATE TABLE IF NOT EXISTS servicos(
	idServico SERIAL PRIMARY KEY,
	descricao VARCHAR(50) NOT NULL,
	preco FLOAT NOT NULL
);
INSERT INTO servicos VALUES (1,'Manutencao em motor',350.00);
INSERT INTO servicos VALUES (2, 'Pintura', 1000.00);
INSERT INTO servicos VALUES (3, 'Lataria',600.00);


SELECT * FROM servicos;

/*Colocando servicos nas ordens*/
CREATE TABLE IF NOT EXISTS ordens_servicos (
	id_ordens INTEGER NOT NULL,
	id_servicos INTEGER NOT NULL,
	FOREIGN KEY (id_ordens) REFERENCES ordens (idOrdem),
	FOREIGN KEY (id_servicos) REFERENCES servicos (idServico)
);

INSERT INTO ordens_servicos VALUES (1, 1);
INSERT INTO ordens_servicos VALUES (2,2);
INSERT INTO ordens_servicos VALUES (3,3);

INSERT INTO ordens_servicos VALUES (4,1);
INSERT INTO ordens_servicos VALUES (5,1);
INSERT INTO ordens_servicos VALUES (6,1);
INSERT INTO ordens_servicos VALUES (7,1);
INSERT INTO ordens_servicos VALUES (8,1);
INSERT INTO ordens_servicos VALUES (9,1);
INSERT INTO ordens_servicos VALUES (10,1);


SELECT * FROM ordens;
SELECT * FROM servicos;

SELECT o.idOrdem as Nr_Ordem, o.status, o.dataEmissao, o.dataConclusao, o.formaPagamento, s.descricao as Servico, s.preco
FROM ordens as o
INNER JOIN ordens_servicos as os
ON o.idOrdem = os.id_ordens
INNER JOIN servicos as s
ON os.id_servicos = s.idServico;

/*Criando tabela mecanicos*/
CREATE TYPE TIPOS_ESPECIALIDADES AS ENUM('Motor','Pintura','Lataria');
CREATE TABLE IF NOT EXISTS mecanicos(
	idMecanico SERIAL PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	cpf VARCHAR(11) NOT NULL UNIQUE,
	endereco VARCHAR(120) NOT NULL,
	especialidade TIPOS_ESPECIALIDADES NOT NULL
);

INSERT INTO mecanicos VALUES (1, 'Zé Silvério','34029693008','Rua Risoto, 67 - Bairro Rango, Belo Horizonte MG','Motor');
INSERT INTO mecanicos VALUES (2,'Paulo Pinto','57059105093','Rua Cabelo, 68, - Bairro Coral, Belo Horizonte MG','Pintura');
INSERT INTO mecanicos VALUES (3,'Camila Cruz','48986526034','Rua Belo Ouro, 79 - Bairro Vinho Tinho, Belo Horizonte MG','Lataria');

SELECT * FROM mecanicos;
SELECT * FROM ordens;

/*Criando tabela mecanicos_ordens*/
CREATE TABLE IF NOT EXISTS mecanicos_ordens (
	id_ordens INTEGER NOT NULL,
	id_mecanicos INTEGER NOT NULL,
	FOREIGN KEY (id_ordens) REFERENCES ordens (idOrdem),
	FOREIGN KEY (id_mecanicos) REFERENCES mecanicos (idMecanico)
);

/*Colocando mecanicos nas ordens*/
INSERT INTO mecanicos_ordens VALUES (1,1);
INSERT INTO mecanicos_ordens VALUES (2,2);
INSERT INTO mecanicos_ordens VALUES (3,3);

INSERT INTO mecanicos_ordens VALUES (4,1);
INSERT INTO mecanicos_ordens VALUES (5,1);
INSERT INTO mecanicos_ordens VALUES (6,1);
INSERT INTO mecanicos_ordens VALUES (7,1);
INSERT INTO mecanicos_ordens VALUES (8,1);
INSERT INTO mecanicos_ordens VALUES (9,1);
INSERT INTO mecanicos_ordens VALUES (10,1);

SELECT * FROM ordens;
SELECT * FROM mecanicos;

SELECT o.idOrdem as Nr_Ordem, o.status, o.dataEmissao, o.dataConclusao, o.formaPagamento,
me.nome as Mecanico, me.especialidade
FROM ordens as o
INNER JOIN mecanicos_ordens as mo
ON o.idOrdem = mo.id_ordens
INNER JOIN mecanicos as me
ON mo.id_mecanicos = me.idMecanico;


/*Criando tabela pecas*/
CREATE TABLE IF NOT EXISTS pecasProdutos (
	idPecaProduto SERIAL PRIMARY KEY,
	descricao VARCHAR(50) NOT NULL,
	preco FLOAT NOT NULL,
	quantidade INTEGER NOT NULL
);


INSERT INTO pecasProdutos VALUES (1,'Óleo do motor',34.92, 20);
INSERT INTO pecasProdutos VALUES (2,'Mangueira Filtro',51.36, 56);
INSERT INTO pecasProdutos VALUES (3, 'Suporte Motor', 929.90, 3);
INSERT INTO pecasProdutos VALUES (4,'Tinta Veicular', 156.00, 12);
INSERT INTO pecasProdutos VALUES (5, 'Caixa Externa', 216.31, 8);

UPDATE pecasProdutos SET quantidade = 3  WHERE idPecaProduto = 1;
UPDATE pecasProdutos SET quantidade = 1  WHERE idPecaProduto IN (2,3,4,5);

SELECT * FROM pecasProdutos;

/*Criando tabela ordens_pecas_produtos*/
CREATE TABLE IF NOT EXISTS ordens_pecas_produtos(
	id_ordens INTEGER NOT NULL,
	id_pecas_produtos INTEGER NOT NULL,
	FOREIGN KEY (id_ordens) REFERENCES ordens (idOrdem),
	FOREIGN KEY (id_pecas_produtos) REFERENCES pecasProdutos (idPecaProduto)
);

/*Colocando pecas produtos nas ordens*/
INSERT INTO ordens_pecas_produtos VALUES (1,1);
INSERT INTO ordens_pecas_produtos VALUES (1,2);
INSERT INTO ordens_pecas_produtos VALUES (1,3);
INSERT INTO ordens_pecas_produtos VALUES (2,4);
INSERT INTO ordens_pecas_produtos VALUES (3,5);

INSERT INTO ordens_pecas_produtos VALUES (4,1);
INSERT INTO ordens_pecas_produtos VALUES (5,1);
INSERT INTO ordens_pecas_produtos VALUES (6,1);
INSERT INTO ordens_pecas_produtos VALUES (7,1);
INSERT INTO ordens_pecas_produtos VALUES (8,1);
INSERT INTO ordens_pecas_produtos VALUES (9,1);
INSERT INTO ordens_pecas_produtos VALUES (10,1);

SELECT * FROM ordens;
SELECT * FROM pecasProdutos;

SELECT o.idOrdem as Nr_Ordem, o.status, o.dataEmissao, o.dataConclusao, o.formaPagamento,  pp.descricao as Produtos_Pecas,
pp.preco as Preco_Produtos, pp.quantidade as Qtd_Produtos
FROM ordens as o
INNER JOIN ordens_pecas_produtos as opp
ON o.idOrdem = opp.id_ordens
INNER JOIN pecasProdutos as pp
ON opp.id_pecas_produtos = pp.idPecaProduto;

												/*Outras consultas */

/*Formatando preco peca*/
SELECT o.idOrdem as Nr_Ordem, o.status, o.dataEmissao, o.dataConclusao, o.formaPagamento,  pp.descricao as Produtos_Pecas,
to_char(pp.preco,'L9G999G990D99') as Preco_Produtos, pp.quantidade as Qtd_Produtos
FROM ordens as o
INNER JOIN ordens_pecas_produtos as opp
ON o.idOrdem = opp.id_ordens
INNER JOIN pecasProdutos as pp
ON opp.id_pecas_produtos = pp.idPecaProduto;

/*Coluna derivada para status do servico*/
SELECT o.idOrdem as Nr_Ordem, o.status, o.dataEmissao, o.dataConclusao, o.formaPagamento, s.descricao as Servico, 
to_char(s.preco,'L9G999G990D99') as Preco_Servico,
CASE
    WHEN o.dataConclusao >= o.dataEmissao THEN 'SERVICO CONCLUIDO'
	ELSE 'PENDENTE'
END AS "Status_Servico"
FROM ordens as o
INNER JOIN ordens_servicos as os
ON o.idOrdem = os.id_ordens
INNER JOIN servicos as s
ON os.id_servicos = s.idServico;

/*Coluna derivada para novo preço para quantidade de produtos igual a 1*/
SELECT o.idOrdem as Nr_Ordem, o.status, o.dataEmissao, o.dataConclusao, o.formaPagamento,  pp.descricao as Produtos_Pecas,
to_char(pp.preco,'L9G999G990D99') as Preco_Produtos, pp.quantidade as Qtd_Produtos,
CASE
    WHEN pp.quantidade = 1 THEN to_char(pp.preco * 1.05,'L9G999G990D99')
	ELSE to_char(pp.preco,'L9G999G990D99') 
END AS "Novo Preco"
FROM ordens as o
INNER JOIN ordens_pecas_produtos as opp
ON o.idOrdem = opp.id_ordens
INNER JOIN pecasProdutos as pp
ON opp.id_pecas_produtos = pp.idPecaProduto;


/*Ordenando por data de conclusao*/
SELECT o.idOrdem as Nr_Ordem, o.status, o.dataEmissao, o.dataConclusao, o.formaPagamento,  pp.descricao as Produtos_Pecas,
to_char(pp.preco,'L9G999G990D99') as Preco_Produtos, pp.quantidade as Qtd_Produtos,
CASE
    WHEN pp.quantidade = 1 THEN to_char(pp.preco * 1.05,'L9G999G990D99')
	ELSE to_char(pp.preco,'L9G999G990D99') 
END AS "Novo Preco"
FROM ordens as o
INNER JOIN ordens_pecas_produtos as opp
ON o.idOrdem = opp.id_ordens
INNER JOIN pecasProdutos as pp
ON opp.id_pecas_produtos = pp.idPecaProduto
ORDER BY o.dataConclusao;

/*HAVING E GROUP BY*/
SELECT * FROM pecasProdutos;
SELECT descricao, SUM(quantidade)
FROM pecasProdutos
GROUP by descricao
HAVING SUM(quantidade) > 1;































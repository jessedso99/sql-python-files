-- C:\Users\jesse\Desktop\PASTAS\testesql\RESOLUCAO
use DATABASE_IC;
-- show tables
SELECT * FROM INFORMATION_SCHEMA.TABLES;
-- desc tables
EXEC sp_help PRODUTO;

--1.	Monte um script SQL que retorne o TOP 10 dos produtos mais vendidos (por valor) no ano de 2019.
	--	a.	O resultado deve conter as colunas:
	--	i.	Código do produto;
	--	ii.	Nome do produto;
	--	iii.	Valor vendido;
SELECT TOP 10 a.ID_PRODUTO, c.NOME, ROUND(SUM(a.QUANTIDADE* b.PRECO), 2) AS 'Valor Total'
	FROM VENDA AS a JOIN PRODUTO_PRECO AS b ON b.ID_PRODUTO = a.ID_PRODUTO JOIN PRODUTO AS c ON a.ID_PRODUTO  = c.ID_PRODUTO 
	WHERE YEAR(a.PERIODO) = '2019' 
	GROUP BY a.ID_PRODUTO, c.NOME 
	ORDER BY 'Valor Total' DESC;

--2.	Monte um script SQL que retorne o TOP 10 dos produtos mais vendidos (por unidade) no ano de 2018.
	--a.	O resultado deve conter as colunas:
	--i.	Código do produto;
	--ii.	Nome do produto;
	--iii.	Quantidade vendida;
SELECT TOP 10 a.ID_PRODUTO, c.NOME, SUM(a.QUANTIDADE) AS 'Quantidade Total'
	FROM VENDA AS a JOIN PRODUTO AS c ON a.ID_PRODUTO = c.ID_PRODUTO 
	WHERE YEAR(a.PERIODO) = '2018' 
	GROUP BY a.ID_PRODUTO, c.NOME 
	ORDER BY 'Quantidade Total' DESC;

--3.	Monte um script SQL que retorne o preço médio de cada produto no ano de 2019.
	--a.	O resultado deve conter as colunas:
	--i.	Código do produto;
	--ii.	Nome do produto;
	--iii.	Preço médio;
SELECT a.ID_PRODUTO, c.NOME, ROUND(AVG(a.PRECO), 2) as 'Preço médio' 
	FROM PRODUTO_PRECO AS a JOIN PRODUTO AS c ON a.ID_PRODUTO = c.ID_PRODUTO  
	WHERE YEAR(a.PERIODO) = '2018' 
	GROUP BY a.ID_PRODUTO, c.NOME
	ORDER BY 'Preço médio' DESC;

--4.	Monte um script SQL que retorne qual grade de produtos menos vendeu (por unidade) no ano de 2018.
	--a.	O resultado deve conter as colunas:
	--i.	Código da grade de produtos;
	--ii.	Quantidade vendida;
SELECT TOP 1 a.CODIGO_GRADE, SUM(b.QUANTIDADE) AS 'Quantidade Total' 
	FROM PRODUTO_GRADE AS a JOIN VENDA AS b ON a.ID_PRODUTO = b.ID_PRODUTO 
	WHERE YEAR(b.PERIODO) = '2018' 
	GROUP BY a.CODIGO_GRADE 
	ORDER BY 'Quantidade Total' ASC;

--5.	Monte um script SQL que retorne qual grade de produtos mais vendeu (por valor) em cada ano que existirem vendas.
	--a.	O resultado deve conter as colunas:
	--i.	Ano da venda;
	--ii.	Código da grade;
	--iii.	Valor Vendido;
SELECT TOP 2 YEAR(b.PERIODO), c.CODIGO_GRADE, ROUND(SUM(a.QUANTIDADE* b.PRECO), 2) AS 'Valor Total' 
	FROM PRODUTO_GRADE AS c JOIN VENDA AS a ON c.ID_PRODUTO = a.ID_PRODUTO JOIN PRODUTO_PRECO AS b ON c.ID_PRODUTO = b.ID_PRODUTO 
	GROUP BY YEAR(b.PERIODO), c.CODIGO_GRADE 
	ORDER BY 'Valor Total' DESC;

--6.	Monte um script SQL que retorne qual foi o preço médio de cada produto da grade de produtos de código “GRADE - TIPO 4” durante o 1º semestre de 2019.
	--a.	O resultado deve conter as colunas:
	--i.	Código do Produto;
	--ii.	Nome do produto;
	--iii.	Preço médio;
SELECT a.ID_PRODUTO, b.NOME, ROUND(AVG(c.PRECO), 2) AS 'Média de Preços' 
	FROM PRODUTO_GRADE AS a JOIN PRODUTO AS b ON a.ID_PRODUTO = b.ID_PRODUTO JOIN PRODUTO_PRECO AS c ON a.ID_PRODUTO = C.ID_PRODUTO 
	WHERE a.CODIGO_GRADE = 'GRADE - TIPO 4' AND c.PERIODO BETWEEN '2019-01-01' AND '2019-06-30'
	GROUP BY a.ID_PRODUTO, b.NOME
	ORDER BY a.ID_PRODUTO ASC;

-- REVISAR 7
--7.	Monte um script que retorne qual produto teve a menor quantidade de venda em cada grade de produtos durante o segundo semestre de 2018.
	--a.	O resultado deve conter as colunas:
	--i.	Código da grade de produtos;
	--ii.	Código do produto;
	--iii.	Nome do produto;
	--iv.	Quantidade vendida;
SELECT a.CODIGO_GRADE, MAX(d.QUANTIDADE) AS 'MIN QUANTIDADE', a.ID_PRODUTO, b.NOME --INTO #teste1
	FROM PRODUTO_GRADE AS a JOIN PRODUTO AS b ON a.ID_PRODUTO = b.ID_PRODUTO JOIN PRODUTO_PRECO AS c ON a.ID_PRODUTO = c.ID_PRODUTO JOIN VENDA AS d ON c.ID_PRODUTO = d.ID_PRODUTO 
	WHERE c.PERIODO BETWEEN '2018-06-01' AND '2018-12-31' 
	GROUP BY a.CODIGO_GRADE, a.ID_PRODUTO, b.NOME 
	ORDER BY a.CODIGO_GRADE, 'MIN QUANTIDADE' ASC;
--select * from #teste1;
--DROP TABLE #teste1;
--select CODIGO_GRADE, MAX([MIN QUANTIDADE]) from #teste1 group by CODIGO_GRADE;
WITH teste3 AS (SELECT*, ROW_NUMBER() OVER(PARTITION BY CODIGO_GRADE ORDER BY CODIGO_GRADE DESC) AS qnt3 FROM #teste1)
SELECT* FROM teste3 WHERE qnt3 = 1;

--solucao 2
WITH min_qnt AS (SELECT*, ROW_NUMBER() OVER(PARTITION BY CODIGO_GRADE ORDER BY CODIGO_GRADE) AS qnt 
	FROM (SELECT a.CODIGO_GRADE, MAX(d.QUANTIDADE) AS 'MIN QUANTIDADE', a.ID_PRODUTO, b.NOME 
	FROM PRODUTO_GRADE AS a JOIN PRODUTO AS b ON a.ID_PRODUTO = b.ID_PRODUTO JOIN PRODUTO_PRECO AS c ON a.ID_PRODUTO = c.ID_PRODUTO JOIN VENDA AS d ON c.ID_PRODUTO = d.ID_PRODUTO 
	WHERE c.PERIODO BETWEEN '2018-06-01' AND '2018-12-31' 
	GROUP BY a.CODIGO_GRADE, a.ID_PRODUTO, b.NOME) AS teste)
SELECT* FROM min_qnt WHERE qnt = 1;

-- TESTE
	WHILE @cont > 0
		BEGIN
			PRINT @cont;
		SET @cont = @cont - 1;
	END;
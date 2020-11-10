-------------------------------------------------------------------------------------------------------------------
-- Consulta inicial das receitas e dos ingredientes

SELECT r.codigo as "Cód. Rec.", r.nome as "Nome Receita", 
	   i.nome as "Nome Ingrediente", 
	   ri.quantidade as "Qtd.", ri.unidade as "Unidade"
FROM Receita r
INNER JOIN ReceitaIngrediente ri ON ri.codigo_receita = r.codigo
INNER JOIN Ingrediente i ON ri.codigo_ingrediente = i.codigo

-------------------------------------------------------------------------------------------------------------------
-- Regra 1: A primeira regra é adicionar na aplicação o modo de preparo da receita.

CREATE TABLE ReceitaModoPerparo
(
    codigo integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    codigo_ingrediente integer,
    descricao character varying(50),
    CONSTRAINT cnstr_cod_igrtip UNIQUE (codigo),
    CONSTRAINT fk_ingrediente_tipo 
		FOREIGN KEY (codigo_ingrediente)
        	REFERENCES Ingrediente (codigo)
)

-------------------------------------------------------------------------------------------------------------------
-- Regra 2: A segunda é adicionar o tipo do alimento; exemplo: feijão preto, branco carioca e por aí vai.

CREATE TABLE IngredienteTipo
(
    codigo integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    codigo_ingrediente integer,
    descricao character varying(50),
    CONSTRAINT cnstr_cod_igrtip UNIQUE (codigo),
    CONSTRAINT fk_ingrediente_tipo 
		FOREIGN KEY (codigo_ingrediente)
        	REFERENCES Ingrediente (codigo)
)

-------------------------------------------------------------------------------------------------------------------
-- Adicionando alguns tipos de ingredientes

INSERT INTO IngredienteTipo (codigo_ingrediente, descricao) VALUES (1, 'Preto');
INSERT INTO IngredienteTipo (codigo_ingrediente, descricao) VALUES (1, 'Branco');
INSERT INTO IngredienteTipo (codigo_ingrediente, descricao) VALUES (1, 'Carioca');
INSERT INTO IngredienteTipo (codigo_ingrediente, descricao) VALUES (1, 'Fradinho');
INSERT INTO IngredienteTipo (codigo_ingrediente, descricao) VALUES (1, 'Corda');
INSERT INTO IngredienteTipo (codigo_ingrediente, descricao) VALUES (1, 'Jalo');

INSERT INTO IngredienteTipo (codigo_ingrediente, descricao) VALUES (6, 'Integral');
INSERT INTO IngredienteTipo (codigo_ingrediente, descricao) VALUES (6, 'Desnatado');
INSERT INTO IngredienteTipo (codigo_ingrediente, descricao) VALUES (6, 'Semi-Desnatado');

INSERT INTO IngredienteTipo (codigo_ingrediente, descricao) VALUES (8, 'Mascavo');
INSERT INTO IngredienteTipo (codigo_ingrediente, descricao) VALUES (8, 'Refinado');
INSERT INTO IngredienteTipo (codigo_ingrediente, descricao) VALUES (8, 'Cristal');

-------------------------------------------------------------------------------------------------------------------
-- Adicionando a coluna 'codigo_ingrediente_tipo' para armazenar o código do tipo do ingrediente 

ALTER TABLE ReceitaIngrediente
ADD COLUMN codigo_ingrediente_tipo integer;

-------------------------------------------------------------------------------------------------------------------
-- Adicionando a chave-estrangeira que fará o relacionamento entre as tabelas ReceitaIngrediente e IngredienteTipo

ALTER TABLE ReceitaIngrediente
ADD CONSTRAINT fk_receita_tipo_ingrediente 
	FOREIGN KEY (codigo_ingrediente_tipo)
        REFERENCES IngredienteTipo (codigo);
		
-------------------------------------------------------------------------------------------------------------------
-- Alterando alguns registros, adicionando o código do tipo do ingrediente

UPDATE ReceitaIngrediente 
SET codigo_ingrediente_tipo = 1 WHERE codigo = 1;

UPDATE ReceitaIngrediente 
SET codigo_ingrediente_tipo = 9 WHERE codigo = 6;

UPDATE ReceitaIngrediente 
SET codigo_ingrediente_tipo = 12 WHERE codigo = 10;


-------------------------------------------------------------------------------------------------------------------
-- Consulta final das receitas e seus respectivos modos de preparos

SELECT r.Nome, rmp.ordem as "Passo", rmp.Descricao 
FROM receita r
INNER JOIN receitamodoperparo rmp ON r.codigo = rmp.codigo_receita
ORDER BY r.codigo, "Passo"

-------------------------------------------------------------------------------------------------------------------
-- Consulta final das receitas, ingredientes e tipo de ingrediente

SELECT r.codigo as "Cód. Rec.", r.nome as "Nome Receita", 
	   i.nome as "Nome Ingrediente", 
	   it.descricao as "Tipo Ingrediente",
	   ri.quantidade as "Qtd.", ri.unidade as "Unidade"
FROM Receita r
INNER JOIN ReceitaIngrediente ri ON ri.codigo_receita = r.codigo
INNER JOIN Ingrediente i ON ri.codigo_ingrediente = i.codigo
LEFT JOIN IngredienteTipo it on it.codigo = ri.codigo_ingrediente_tipo

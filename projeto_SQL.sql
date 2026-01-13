Pergunta 1: Qual região tem mais mulheres recebendo a remuneração mais alta segundo a pesquisa?
Resposta: Sudeste
Query:
SELECT regiao_onde_mora,
       genero, 
       faixa_salarial,
       COUNT (*) AS total_mulheres
FROM vw_analise_demografica_2022
WHERE genero = 'Feminino'
AND faixa_salarial IS NOT NULL
AND regiao_onde_mora IS NOT NULL
GROUP BY regiao_onde_mora,
         genero,
         faixa_salarial
ORDER BY total_mulheres DESC


_____________________________________________________________________________

Pergunta 2: Entre os profissionais com nível superior, quais são as 5 áreas de formação mais comuns
Resposta: 
- Graduação/Bacharelado em Computação/Engenharia de Software/Sistemas de Informação/TI
- Pós-graduação em Computação/Engenharia de Software/Sistemas de Informação/TI
- Graduação/Bacharelado em Outras Engenharias
- Pós-graduação em Outras Engenharias
- Pós-graduação em Economia/Administração/Contabilidade/Finanças/Negócios

Query:
SELECT nivel_ensino,
       area_de_formacao,
       COUNT(*) AS profissionais
FROM vw_analise_demografica_2022
WHERE area_de_formacao IS NOT NULL
AND nivel_ensino NOT IN ('Estudante de Graduação', 'Não tenho graduação formal', 'Prefiro não informar')
GROUP BY nivel_ensino, area_de_formacao
ORDER BY profissionais DESC
LIMIT 5

_____________________________________________________________________________

Pergunta 3: Qual é a representatividade de cada grupo étnico e de gênero em cargos de liderança da área de dados?
Resposta:
SELECT cargo_como_gestor, cor_raca_etnia, genero, COUNT(*) AS total_lideres
FROM state_of_data_2022
WHERE genero IS NOT NULL
AND cargo_como_gestor IN ('Chapter Lead', 'Chefe de Secretaria', 'Diretor/VP', 'Gerente/Head', 'LIder', 'Supervisor/Coordenador', 'Sócio ou C-level (CEO, CDO, CIO, CTO etc')
GROUP BY cor_raca_etnia, genero
ORDER BY cor_raca_etnia, genero

_______________________________________________________________________________________________________________________________________________________________________________________

Pergunta 4: Qual é a diferença na distribuição salarial entre profissionais de dados com menos de 5 anos de experiência, comparando aqueles com e sem graduação formal?
Resposta:"Graduação formal"	"8218.332075471699"
"Sem graduação formal"	"6228.833333333333"

SELECT nivel_ensino,
 CASE WHEN nivel_ensino = 'Não tenho graduação formal' THEN 'Sem graduação formal'
      WHEN nivel_ensino = 'Prefiro não informar' THEN 'Sem graduação formal'
 ELSE 'Graduação Formal'
 END AS nivel_ensino, faixa_salarial, anos_experiencia_na_area_dados
 FROM vw_analise_demografica_2022
 GROUP by nivel_ensino
 ORDER BY anos_experiencia_na_area_dados
 LIMIT 5

SELECT 'Sem graduação formal' AS graduacao, AVG(sal.ponto_medio_faixa_salarial) AS salario_medio
FROM state_of_data_2022 AS dados
LEFT JOIN vw_experiencia_area_dados AS exp ON dados.anos_experiencia_na_area_dados = exp.anos_experiencia_na_area_dados
LEFT JOIN vw_media_salarial_por_faixa AS sal ON dados.faixa_salarial = sal.faixa_salarial
WHERE nivel_ensino IN ('Não tenho graduação formal', 'Prefiro não informar')
AND exp.media_experiencia_em_anos <= 5

UNION

SELECT 'Graduação formal' AS graduacao, AVG(sal.ponto_medio_faixa_salarial) AS salario_medio
FROM state_of_data_2022 AS dados
LEFT JOIN vw_experiencia_area_dados AS exp ON dados.anos_experiencia_na_area_dados = exp.anos_experiencia_na_area_dados
LEFT JOIN vw_media_salarial_por_faixa AS sal ON dados.faixa_salarial = sal.faixa_salarial
WHERE nivel_ensino NOT IN ('Não tenho graduação formal', 'Prefiro não informar')
AND exp.media_experiencia_em_anos <= 5

_________________________________________________________________________________________________________________________
--Qual a porcentagem de homens e mulheres em cargos de liderança que não têm formação superior?
Resposta:
Mulheres = 22,2%
Homens = 77,7%

SELECT cargo_como_gestor, genero, nivel_ensino,
COUNT(*) AS total_lideres
FROM state_of_data_2022 
WHERE genero IS NOT NULL
AND cargo_como_gestor IN ('Chapter Lead', 'Chefe de Secretaria', 'Diretor/VP', 'Gerente/Head', 'LIder', 'Supervisor/Coordenador', 'Sócio ou C-level (CEO, CDO, CIO, CTO etc')
AND nivel_ensino IN ('Estudante de Graduação', 'Não tenho graduação formal')
GROUP BY genero
ORDER BY genero

__________________________________________________________________________________________________________________________________________________________________________________
-- Com base na pergunta anterior, há uma diferença na faixa salarial entre gêneros?


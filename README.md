# LH_AW_RUANN_CAMPOS

## Desafio Final Adventure Works

Este repositório contém as etapas desenvolvidas para o **Desafio Final Adventure Works**, incluindo extração, transformação, modelagem e orquestração dos dados. Abaixo, estão descritos os principais diretórios e suas respectivas funcionalidades:

### Estrutura do Repositório

1. **`adventure_works_meltano`**  
   Contém toda a parte de extração e carregamento dos dados:
   - **Extração:** Realizada a partir das fontes utilizando o Meltano.  
   - **Loader:** Ingestão dos dados no Data Warehouse (Snowflake).  
   - Configurações desenvolvidas para garantir a integração eficiente.

2. **`adventure_works_dbt_modeling`**  
   Contém a modelagem e transformação dos dados utilizando o dbt-core:
   - **Modelagem:** Construção de modelos dimensionais, tabelas fato e agregações.
   - **Transformação:** Implementação de transformações e validações de dados.
   - **Testes:** Testes desenvolvidos para garantir a integridade e qualidade dos dados transformados.

3. **`adventure_works_airflow`**  
   Contém a orquestração das tarefas com o Apache Airflow:
   - **DAGs:** Automação das execuções diárias de pipelines de transformação e testes.  
   - **Configuração:** Arquivos `docker-compose.yml` e `Dockerfile` utilizados para gerenciar e configurar os serviços.

### Observações
Para mais detalhes sobre as soluções implementadas,  consulte os arquivos contidos neste repositório e também o relatório geral deste projeto.

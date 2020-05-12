# Desafio IBGE - Nomes no Brasil

Com base na aplicação web 'Nomes no Brasil' do IBGE (https://www.ibge.gov.br/censo2010/apps/nomes), este app foi criado para representar sua versão 'old school'.

A estrutura deste app nada mais é do que Ruby puro e algumas chamadas na API do IBGE.

Links da documentação da API usada:
https://servicodados.ibge.gov.br/api/docs/localidades?versao=1
https://servicodados.ibge.gov.br/api/docs/censos/nomes?versao=2

# Passo a passo para executar o app
1. No repósitorio do projeto clonado, dê `bundle`
2. Em seguida, rode `rake db:migrate` para criar o banco
3. Rode `rake db:seed` para popular o banco
4. Por fim, execute `ruby main.rb` para abrir o app

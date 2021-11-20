# Remote Authetication Use Case

> ## Caso de sucesso
1. Sistema valida os dados (api recebe os dados que precisa para logar)
2. sistema faz uma requisição para a URL da API de login
3. Sistema valida os dados recebidos da API
4. sistema entrega os dados da conta do usuário

> ## Exceção - URL inválida
1. sistema retorna uma mensagem de erro inesperado

> ## Exceção - Dados inválidos
1. sistema retorna uma mensagem de erro inesperado

> ## Exceção - Resposta inválida
1. sistema retorna uma mensagem de erro inesperado

> ## Exceção - Falha no servidor
1. sistema retorna uma mensagem de erro inesperado

> ## Exceção - Credenciais inválidas
1. sistema retorna uma mensagem de erro informando que as credenciais estão erradas
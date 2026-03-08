*** Settings***

Resource    ../resources/keywords.resource

Suite Setup    Create Session    alias=iqs    url=${BASE_URL}

*** Test Cases ***
TC1:realizar autenticação com usuário válido
    [Tags]    valid
   
    ${response}    POST /auth     PostAuthValid.json    200
    Validate Json    ${response}    CreateTokenValid.json

TC2:realizar autenticação com usuário inválido
    [Tags]    Invalid
      
    ${response}    POST /auth    PostAuthInvalid.json    200
    Validate Json    ${response}    CreateTokenInvalid.json
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Funcionario where

import Import

-- INCLUIR

formFuncionario :: Form (Funcionario, Text)
formFuncionario = renderBootstrap $ (,)
    <$> (Funcionario 
        <$> areq emailField "E-mail:" Nothing
        <*> areq passwordField "Senha:" Nothing)
    <*> areq passwordField "Confirmação:" Nothing

getFuncionarioR :: Handler Html
getFuncionarioR = do 
    (widget,enctype) <- generateFormPost formFuncionario
    msg <- getMessage
    defaultLayout $ do
        addStylesheet $ StaticR css_bootstrap_css
        [whamlet|
            $maybe mensagem <- msg
                ^{mensagem}
            <form action=@{FuncionarioR} method=post>
                ^{widget}
                <input type="submit" value="cadastrar">
               <br><br>
               <a href=@{HomeR} class="btn btn-primary btn-sm active" role="button" aria-pressed="true">Principal
               &nbsp;&nbsp;&nbsp;&nbsp;
               <a href=@{TodosFuncionariosR} class="btn btn-primary btn-sm active" role="button" aria-pressed="true">Lista Todos
        |]

postFuncionarioR :: Handler Html
postFuncionarioR = do
    ((res,_),_) <- runFormPost formFuncionario
    case res of
        FormSuccess (funcionario,confirmacao) -> do
            if (funcionarioSenha funcionario) == confirmacao then do
                runDB $ insert funcionario
                redirect HomeR
            else do
                setMessage [shamlet|<h2> Usuario e senha nao batem|]
                redirect FuncionarioR
        _ -> redirect HomeR


getTodosFuncionariosR :: Handler Html
getTodosFuncionariosR = do 
    funcionarios <- runDB $ selectList [] [Asc FuncionarioId]
    defaultLayout $ do
        addStylesheet $ StaticR css_bootstrap_css
        $(whamletFile "templates/funcionario.hamlet")

-- LISTA PERFIL ÚNICO

getFuncionarioPerfilR :: FuncionarioId -> Handler Html
getFuncionarioPerfilR funcid = do 
    funcionario <- runDB $ get404 funcid
    defaultLayout $ do 
        addStylesheet $ StaticR css_bootstrap_css
        [whamlet|
            <h1>
                Nome #{funcionarioEmail funcionario}
                
            <br><br><a href=@{TodosFuncionariosR} class="btn btn-primary btn-sm active" role="button" aria-pressed="true">Voltar
        |]

-- APAGAR

postFuncionarioApagarR :: FuncionarioId -> Handler Html
postFuncionarioApagarR funcid = do
    runDB $ get404 funcid
    runDB $ delete funcid
    redirect TodosFuncionariosR

-- ALTERAR
--
-- ERRO, ver com professor
--
{-
getFuncionarioAlteraR :: FuncionarioId -> Handler Html
getFuncionarioAlteraR funcid = do
    funcionario <- runDB $ get404 funcid
    (widget,enctype) <- generateFormPost (formFuncionario $ Just funcionario)
    defaultLayout $ do
        addStylesheet $ StaticR css_bootstrap_css
        [whamlet|
            <form action=@{FuncionarioAlteraR funcid} method=post>
                ^{widget}
                <input type="submit" value="atualizar">
                <br><br><a href=@{TodosFuncionariosR} class="btn btn-primary btn-sm active" role="button" aria-pressed="true">Voltar
        |]

postFuncionarioAlteraR :: FuncionarioId -> Handler Html
postFuncionarioAlteraR funcid = do
    funcionario <- runDB $ get404 funcid
    ((res,_),_) <- runFormPost (formFuncionario $ Just funcionario) 
    case res of
        FormSuccess funcionarioNovo -> do
            runDB $ replace funcid funcionarioNovo
            redirect TodosFuncionariosR
        _ -> redirect HomeR
-}

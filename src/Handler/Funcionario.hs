{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Funcionario where

import Import

-- INCLUIR

formFuncionario :: Maybe Funcionario -> Form Funcionario
formFuncionario mFuncionario = renderBootstrap $ Funcionario 
    <$> areq textField "Nome: " (fmap funcionarioNome mFuncionario)
    <*> areq textField "Senha: " (fmap funcionarioSenha mFuncionario)


getFuncionarioR :: Handler Html
getFuncionarioR = do 
    (widget,enctype) <- generateFormPost (formFuncionario Nothing)
    defaultLayout $ do
        addStylesheet $ StaticR css_bootstrap_css
        [whamlet|
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
    ((res,_),_) <- runFormPost (formFuncionario Nothing)
    case res of
        FormSuccess funcionario -> do
            runDB $ insert funcionario
            redirect FuncionarioR
        _ -> redirect HomeR

-- LISTAR TODOS    

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
                Nome #{funcionarioNome funcionario}
                
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

{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Funcionario where

import Import
import Database.Persist.Postgresql



-- INCLUIR

formFuncionario :: Form (Funcionario, Text)
formFuncionario = renderBootstrap $ (,)
    <$> (Funcionario 
        <$> areq emailField "E-mail:" Nothing
        <*> areq passwordField "Senha:" Nothing)
    <*> areq passwordField "Confirmação:" Nothing

formFuncionarioAlt :: Maybe Funcionario -> Form Funcionario
formFuncionarioAlt mFuncionario = renderBootstrap $ Funcionario
    <$> areq emailField "E-mail:" (fmap funcionarioEmail mFuncionario)
    <*> areq passwordField "Senha:" (fmap funcionarioSenha mFuncionario)

getFuncionarioR :: Handler Html
getFuncionarioR = do 
    (widget,enctype) <- generateFormPost formFuncionario
    msg <- getMessage
    defaultLayout $ do
        addStylesheet $ StaticR css_bootstrap_css
        [whamlet|
        
        <div class="container table-responsive">
          <table class="table">
           <tr>
               <td height="50px">
           <tr>
               <td width="380px"  height="80px">
        
               <td align="center" style="background-color:skyblue">
                   <img width="100" height="100"src=@{StaticR imgs_user_jpg}>

                   
               <td width="380px">
               
          <table class="table">       
           <tr>
               <td width="2500px"  height="80px">
               
               <td class="container text-center" style="background-color:skyblue">
                   $maybe mensagem <- msg
                      ^{mensagem}
                <br>
                
                    <form action=@{FuncionarioR} method=post>
                         ^{widget}
                          &nbsp;&nbsp;
                             <button type="submit button" class="btn btn-primary btn-block">
                               CADASTRAR FUNCUINÁRIO
                          &nbsp;&nbsp;
                          
                    <a href=@{TodosFuncionariosR} type="button" class="btn btn-primary btn-block">
                               LISTAR FUNCIONÁRIOS                       
                    &nbsp;&nbsp;      
                    <a href=@{HomeR} type="button" class="btn btn-primary btn-block">
                               VOLTAR
                     
              <td width="2500px">      
                        
        |]
        

postFuncionarioR :: Handler Html
postFuncionarioR = do
    ((res,_),_) <- runFormPost formFuncionario
    case res of
        FormSuccess (funcionario,confirmacao) -> do
            if (funcionarioSenha funcionario) == confirmacao then do
                _ <- ($) runDB $ insert funcionario
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
                Email:  #{funcionarioEmail funcionario}
                
            <br><br><a href=@{TodosFuncionariosR} class="btn btn-primary btn-sm active" role="button" aria-pressed="true">Voltar
        |]

-- APAGAR

postFuncionarioApagarR :: FuncionarioId -> Handler Html
postFuncionarioApagarR funcid = do
    _ <- ($) runDB $ get404 funcid
    _ <- ($) runDB $ delete funcid
    redirect TodosFuncionariosR

-- ALTERAR

getFuncionarioAlteraR :: FuncionarioId -> Handler Html
getFuncionarioAlteraR funcid = do
    funcionario <- runDB $ get404 funcid
    (widget,enctype) <- generateFormPost (formFuncionarioAlt $ Just funcionario)
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
    ((res,_),_) <- runFormPost (formFuncionarioAlt $ Just funcionario) 
    case res of
        FormSuccess funcionarioNovo -> do
            _ <- ($) runDB $ replace funcid funcionarioNovo
            redirect TodosFuncionariosR
        _ -> redirect HomeR


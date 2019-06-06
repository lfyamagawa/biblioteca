{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Cliente where

import Import
import Database.Persist.Postgresql

formCliente :: Maybe Cliente -> Form Cliente
formCliente mCliente = renderBootstrap $ Cliente 
    <$> areq textField "Nome: " (fmap clienteNome mCliente)
    <*> areq textField "RG: " (fmap clienteRg mCliente)
    <*> areq textField "CPF: " (fmap clienteCpf mCliente)
    <*> areq textField "Endereco: " (fmap clienteEndereco mCliente)
    <*> areq textField "Telefone: " (fmap clienteTelefone mCliente)

getClienteR :: Handler Html
getClienteR = do 
    (widget,enctype) <- generateFormPost (formCliente Nothing)
    defaultLayout $ do
        addStylesheet $ StaticR css_bootstrap_css
        [whamlet|
        
        
         <div class="container table-responsive">
          <table class="table">
           <tr>
               <td height="50px">
           <tr>
               <td width="395px"  height="80px">
        
               <td align="center" style="background-color:skyblue">
                   <img width="100" height="100"src=@{StaticR imgs_user_jpg}>

               <td width="395px">
               
          <table class="table">       
           <tr>
               <td width="2500px"  height="80px">
               
               <td class="container text-center" style="background-color:skyblue">

                <br>
                
                    <form action=@{ClienteR} method=post>
                         ^{widget}
                          &nbsp;&nbsp;
                             <button type="submit button" class="btn btn-primary btn-block">
                               CADASTRAR CLIENTE
                          &nbsp;&nbsp;
                          
                    <a href=@{TodosClientesR} type="button" class="btn btn-primary btn-block">
                               LISTAR CLIENTES                       
                    &nbsp;&nbsp;      
                    <a href=@{HomeR} type="button" class="btn btn-primary btn-block">
                               VOLTAR
                     
              <td width="2500px">      
                        
        |]

postClienteR :: Handler Html
postClienteR = do
    ((res,_),_) <- runFormPost (formCliente Nothing)
    case res of
        FormSuccess cliente -> do
            _ <- ($) runDB $ insert cliente
            redirect ClienteR
        _ -> redirect HomeR
    
getTodosClientesR :: Handler Html
getTodosClientesR = do 
    clientes <- runDB $ selectList [] [Asc ClienteId]
    defaultLayout $ do
        addStylesheet $ StaticR css_bootstrap_css
        $(whamletFile "templates/cliente.hamlet")

getClientePerfilR :: ClienteId -> Handler Html
getClientePerfilR cliid = do 
    cliente <- runDB $ get404 cliid
    defaultLayout $ do 
        addStylesheet $ StaticR css_bootstrap_css
        [whamlet|
            <h1>
                 <center>Cliente #{clienteNome cliente}
            <div>
                <center>RG: #{clienteRg cliente}
            <div>
                <center>CPF: #{clienteCpf cliente}
            <div>
                <center>Endereco: #{clienteEndereco cliente}
            <div>
                <center>Telefone: #{clienteTelefone cliente}
                <br><br>
                <a href=@{TodosClientesR} class="btn btn-primary btn-sm active" role="button" aria-pressed="true">Voltar
        |]

postClienteApagarR :: ClienteId -> Handler Html
postClienteApagarR cliid = do
    _ <- ($) runDB $ get404 cliid
    _ <- ($) runDB $ delete cliid
    redirect TodosClientesR

getClienteAlteraR :: ClienteId -> Handler Html
getClienteAlteraR cliid = do
    cliente <- runDB $ get404 cliid
    (widget,enctype) <- generateFormPost (formCliente $ Just cliente)
    defaultLayout $ do
        addStylesheet $ StaticR css_bootstrap_css
        [whamlet|
            <form action=@{ClienteAlteraR cliid} method=post>
                ^{widget}
                <center><input type="submit" value="Atualizar">
                <br><br>
                <center><a href=@{TodosClientesR} class="btn btn-primary btn-sm active" role="button" aria-pressed="true">Voltar
        |]

postClienteAlteraR :: ClienteId -> Handler Html
postClienteAlteraR cliid = do
    cliente <- runDB $ get404 cliid
    ((res,_),_) <- runFormPost (formCliente $ Just cliente) 
    case res of
        FormSuccess clienteNovo -> do
            _ <- ($) runDB $ replace cliid clienteNovo
            redirect TodosClientesR
        _ -> redirect HomeR

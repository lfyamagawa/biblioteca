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
        [whamlet|
            <form action=@{ClienteR} method=post>
                ^{widget}
                <input type="submit" value="cadastrar">
        |]

postClienteR :: Handler Html
postClienteR = do
    ((res,_),_) <- runFormPost (formCliente Nothing)
    case res of
        FormSuccess cliente -> do
            runDB $ insert cliente
            redirect ClienteR
        _ -> redirect HomeR
    
getTodosClientesR :: Handler Html
getTodosClientesR = do 
    clientes <- runDB $ selectList [] [Asc ClienteNome]
    defaultLayout $(whamletFile "templates/cliente.hamlet")

getClientePerfilR :: ClienteId -> Handler Html
getClientePerfilR cliid = do 
    cliente <- runDB $ get404 cliid
    defaultLayout $ do 
        [whamlet|
            <h1>
                Cliente #{clienteNome cliente}
            <div>
                RG: #{clienteRg cliente}
            <div>
                CPF: #{clienteCpf cliente}
            <div>
                Endereco: #{clienteEndereco cliente}
            <div>
                Telefone: #{clienteTelefone cliente}
        |]

postClienteApagarR :: ClienteId -> Handler Html
postClienteApagarR cliid = do
    runDB $ get404 cliid
    runDB $ delete cliid
    redirect TodosClientesR

getClienteAlteraR :: ClienteId -> Handler Html
getClienteAlteraR cliid = do
    cliente <- runDB $ get404 cliid
    (widget,enctype) <- generateFormPost (formCliente $ Just cliente)
    defaultLayout $ do
        [whamlet|
            <form action=@{ClienteAlteraR cliid} method=post>
                ^{widget}
                <input type="submit" value="atualizar">
        |]

postClienteAlteraR :: ClienteId -> Handler Html
postClienteAlteraR cliid = do
    cliente <- runDB $ get404 cliid
    ((res,_),_) <- runFormPost (formCliente $ Just cliente) 
    case res of
        FormSuccess clienteNovo -> do
            runDB $ replace cliid clienteNovo
            redirect TodosClientesR
        _ -> redirect HomeR

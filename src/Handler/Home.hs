{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Home where

import Import
import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3)

getHomeR :: Handler Html
getHomeR = do
    sess <- lookupSession "_ID"
    defaultLayout $ do
        addStylesheet $ StaticR css_bootstrap_css
        [whamlet|
            $maybe sessao <- sess
                Ola #{sessao}
            $nothing
                <h2 class>Biblioteca
            <ul>
                <li>
                    <a href=@{FuncionarioR}>
                        Cadastro de Funcionario
                <li>
                    <a href=@{TodosFuncionariosR}>
                        Listar Funcionarios
                <li>
                    <a href=@{ClienteR}>
                        Cadastro de Cliente
                <li>
                    <a href=@{TodosClientesR}>
                        Listar Clientes
 
                $maybe _ <- sess
                    <li>
                        <form action=@{LogoutR} method=post>
                            <input type="submit" value="Sair">
                $nothing
                    <li>
                        <a href=@{LoginR}>
                            Entrar
        |] 

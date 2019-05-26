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
                        Cadastro de funcionarios
                <li>
                    <a href=@{TodosFuncionariosR}>
                        Listar Funcionarios
                $maybe _ <- sess
                    <li>
                        <form action=@{LogoutR} method=post>
                            <input type="submit" value="Sair">
                $nothing
                    <li>
                        <a href=@{LoginR}>
                            Entrar
        |] 

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
                <h3>Gestão de bibliotecas
                Ola #{sessao}
            $nothing
                <h3>Gestão de bibliotecas
            <ul>
                    <br><h4>------- Funcionário ---------</h4>
                <li>
                    <a href=@{FuncionarioR}>
                        Cadastro de Funcionario
                <li>
                    <a href=@{TodosFuncionariosR}>
                        Listar Funcionarios
                    <h4>------- Clientes ---------</h4>
                <li>
                    <a href=@{ClienteR}>
                        Cadastro de Cliente
                <li>
                    <a href=@{TodosClientesR}>
                        Listar Clientes
                    <h4>------- Livros ---------</h4>
                <li>
                    <a href=@{LivroR}>
                        Cadastro de Livro
                <li>
                    <a href=@{TodosLivrosR}>
                        Listar Livros
                     <h4>------- Emprestimo ---------</h4>
                <li>
                    <a href=@{EmprestimoR}>
                        Cadastro de empréstimo
                <li>
                    <a href=@{TodosEmprestimosR}>
                        Listar Empréstimos
                    <h4>------- Login/Logout -------</h4>
                $maybe _ <- sess
                    <form action=@{LogoutR} method=post>
                        <input type="submit" value="Sair">
                $nothing
                    <a href=@{LoginR}>
                        Entrar
        |] 

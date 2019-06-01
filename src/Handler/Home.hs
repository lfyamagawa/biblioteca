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
                <h4><center><strong>Gestão de bibliotecas
                <h5><center><strong>Ola #{sessao}
            $nothing
                <h3>Gestão de bibliotecas
            <ul class="list-group">
                    <br><center><h4>------- Funcionário ---------</h4>
                <li class="list-group-item">
                    <center><a href=@{FuncionarioR}>
                        <center>Cadastro de Funcionario
                <li class="list-group-item">
                    <center><a href=@{TodosFuncionariosR}>
                        <center>Listar Funcionarios
                    <center><h4>------- Clientes ---------</h4>
                <li class="list-group-item">
                    <center><a href=@{ClienteR}>
                        <center>Cadastro de Cliente
                <li class="list-group-item">
                    <center><a href=@{TodosClientesR}>
                        <center>Listar Clientes
                    <center><h4>------- Livros ---------</h4>
                <li class="list-group-item">
                    <center><a href=@{LivroR}>
                        <center>Cadastro de Livro
                <li class="list-group-item">
                    <center><a href=@{TodosLivrosR}>
                        <center>Listar Livros
                    <center><h4>------ Emprestimos/Devolucoes</h4>
                <li class="list-group-item">
                    <center><a href=@{TodosEmprestimoR}>
                        <center>Emprestar Livros
                <li class="list-group-item">
                    <center><a href=@{TodosDevolucaoR}>
                        <center>Devolucao de Livros
                   <center><h4>------- Login/Logout -------</h4>
                $maybe _ <- sess
                    <form action=@{LogoutR} method=post>
                        <input type="submit" value="Sair">
                $nothing
                    <center><a href=@{LoginR}>
                        Entrar
        |] 

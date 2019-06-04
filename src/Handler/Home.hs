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

        <div class="container text-center" style="background-color:black">
            $maybe sessao <- sess
                <h1><strong><font color="white">GESTÃO DE BIBLIOTECAS
                <br>
                <font color="white"><p class="text-right">Olá: #{sessao}
                <table>
                    <tr>
                       <td class="col col-sm-12">
                           <strong><font color="white"><p class="text-right">Logout:  
                       
                       <td>
                           <form action=@{LogoutR} method=post>
                               <button class="btn btn-sm active" type="submit"  role="button" aria-pressed="true">
                                  <font color="black">Sair                         
            $nothing
                <h1><strong><font color="white">GESTÃO DE BIBLIOTECAS
                <br>
         
                <table>
                    <tr>
                       <td class="col col-sm-12">
                           <strong><font color="white"><p class="text-right">Login:  
                       <td>
                           <a href=@{LoginR} class="btn btn-danger btn-sm active" type="submit"  role="button" aria-pressed="true">
                              <strong><font color="white">Entrar 
            <br>          

       
            
        <table class="container text-center">
            <thead style="background-color:black">
                <tr>
                   <br>
                   <th>
                      <center><h4><strong><font color="white">FUNCIONÁRIOS
                   <th>
                      <center><h4><strong><font color="white">CLIENTE
                   
            <tbody>
                <tr>
                   <td>
                     <br>
                        <a href=@{FuncionarioR}>
                          <h5><strong><font color="black">Cadastro de Funcionario
                   <td>
                     <br>
                        <a href=@{ClienteR}>
                          <h5><strong><font color="black">Cadastro de Cliente
                          
                <tr>          
                   <td>
                        <a href=@{TodosFuncionariosR}>
                          <h5><strong><font color="black">Listar Funcionarios
                   <td>
                        <a href=@{TodosClientesR}>
                          <h5><strong><font color="black">Listar Clientes
               
        <table class="container text-center">
            <thead style="background-color:black">
                <tr>
                   <br>
                   <th>
                      <center><h4><strong><font color="black">__________________<font color="white">LIVROS<font color="black">__________________
                   <th>
                      <center><h4><strong><font color="white">EMPRÉSTIMOS E DEVOLUÇÕES
                   
            <tbody>
                <tr>
                   <td>
                     <br>
                        <a href=@{LivroR}>
                          <h5><strong><font color="black">Cadastro de Livros
                   <td>
                     <br>
                        <a href=@{TodosEmprestimoR}>
                          <h5><strong><font color="black">Empréstimo de Livro

                <tr>          
                   <td>
                        <a href=@{TodosLivrosR}>
                          <center><h5><strong><font color="black">Listar Livros
                   <td>
                        <a href=@{TodosDevolucaoR}>
                          <center><h5><strong><font color="black">Devolução de Livros
        
        <br>                  

        <section class="title-content container" style="background-image: @{StaticR imgs_biblio_jpg}"> 
                        <br>
                        <center><font color="navy"><strong><h1 class="title-text">Biblioteca Virtual
                        <br>
        <br>                
                                  
        |] 

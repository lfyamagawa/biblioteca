{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Livro where

import Import
import Database.Persist.Postgresql

formLivro :: Maybe Livro -> Form Livro
formLivro mLivro = renderBootstrap $ Livro 
    <$> areq textField "Titulo: " (fmap livroTitulo mLivro)
    <*> areq textField "Autor: " (fmap livroAutor mLivro)
    <*> areq textField "Publicacao: " (fmap livroPublicacao mLivro)
    <*> areq textField "Descricao: " (fmap livroDescricao mLivro)
    <*> areq textField "Assunto: " (fmap livroAssunto mLivro)

getLivroR :: Handler Html
getLivroR = do 
    (widget,enctype) <- generateFormPost (formLivro Nothing)
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
                   <img width="100" height="100"src=@{StaticR imgs_book_png}>

               <td width="395px">
               
          <table class="table">       
           <tr>
               <td width="2500px"  height="80px">
               
               <td class="container text-center" style="background-color:skyblue">

                <br>
                
                    <form action=@{LivroR} method=post>
                         ^{widget}
                          &nbsp;&nbsp;
                             <button type="submit button" class="btn btn-primary btn-block">
                               CADASTRAR LIVRO
                          &nbsp;&nbsp;
                          
                    <a href=@{TodosLivrosR} type="button" class="btn btn-primary btn-block">
                               LISTAR LIVROS                       
                    &nbsp;&nbsp;      
                    <a href=@{HomeR} type="button" class="btn btn-primary btn-block">
                               VOLTAR
                     
              <td width="2500px">      
                        
 
        |]

postLivroR :: Handler Html
postLivroR = do
    ((res,_),_) <- runFormPost (formLivro Nothing)
    case res of
        FormSuccess livro -> do
            _ <- ($) runDB $ insert livro
            redirect LivroR
        _ -> redirect HomeR
    
getTodosLivrosR :: Handler Html
getTodosLivrosR = do 
    livros <- runDB $ selectList [] [Asc LivroId]
    defaultLayout $ do
        addStylesheet $ StaticR css_bootstrap_css
        $(whamletFile "templates/livro.hamlet")

getLivroPerfilR :: LivroId -> Handler Html
getLivroPerfilR livid = do 
    livro <- runDB $ get404 livid
    defaultLayout $ do 
        addStylesheet $ StaticR css_bootstrap_css
        [whamlet|
            <h1>
                Livro #{livroTitulo livro}
            <div>
                Autor: #{livroAutor livro}
            <div>
                Publicacao: #{livroPublicacao livro}
            <div>
                Descricao: #{livroDescricao livro}
            <div>
                Assunto: #{livroAssunto livro}

            <br><br><a href=@{TodosLivrosR} class="btn btn-primary btn-sm active" role="button" aria-pressed="true">Voltar
        |]

postLivroApagarR :: LivroId -> Handler Html
postLivroApagarR livid = do
    _ <- ($) runDB $ get404 livid
    _ <- ($) runDB $ delete livid
    redirect TodosLivrosR

getLivroAlteraR :: LivroId -> Handler Html
getLivroAlteraR livid = do
    livro <- runDB $ get404 livid
    (widget,enctype) <- generateFormPost (formLivro $ Just livro)
    defaultLayout $ do
        addStylesheet $ StaticR css_bootstrap_css
        [whamlet|
            <form action=@{LivroAlteraR livid} method=post>
                ^{widget}
                <input type="submit" value="Atualizar">
                <br><br><a href=@{TodosLivrosR} class="btn btn-primary btn-sm active" role="button" aria-pressed="true">Voltar
        |]

postLivroAlteraR :: LivroId -> Handler Html
postLivroAlteraR livid = do
    livro <- runDB $ get404 livid
    ((res,_),_) <- runFormPost (formLivro $ Just livro) 
    case res of
        FormSuccess livroNovo -> do
            _ <- ($) runDB $ replace livid livroNovo
            redirect TodosLivrosR
        _ -> redirect HomeR

    

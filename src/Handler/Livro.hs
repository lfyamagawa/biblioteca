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
    <*> areq boolField "Emprestado: " (fmap livroEmprestado mLivro)

getLivroR :: Handler Html
getLivroR = do 
    (widget,enctype) <- generateFormPost (formLivro Nothing)
    defaultLayout $ do
        addStylesheet $ StaticR css_bootstrap_css
        [whamlet|
            <form action=@{LivroR} method=post>
                <h3>Cadastro de Livro</h3>
                <br><h3>-------------------</h3><br>
                ^{widget}
                <input type="submit" value="cadastrar">
                <br><br>
                <a href=@{HomeR} class="btn btn-primary btn-sm active" role="button" aria-pressed="true">Principal
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a href=@{TodosLivrosR} class="btn btn-primary btn-sm active" role="button" aria-pressed="true">Lista Todos
        |]

postLivroR :: Handler Html
postLivroR = do
    ((res,_),_) <- runFormPost (formLivro Nothing)
    case res of
        FormSuccess livro -> do
            runDB $ insert livro
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
            <div>
                Emprestado: #{livroEmprestado livro}

            <br><br><a href=@{TodosLivrosR} class="btn btn-primary btn-sm active" role="button" aria-pressed="true">Voltar
        |]

postLivroApagarR :: LivroId -> Handler Html
postLivroApagarR livid = do
    runDB $ get404 livid
    runDB $ delete livid
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
            runDB $ replace livid livroNovo
            redirect TodosLivrosR
        _ -> redirect HomeR

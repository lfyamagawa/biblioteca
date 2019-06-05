{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Emprestimo where

import Import
import Database.Persist.Postgresql

formEmprestimo :: Maybe Emprestimo -> Form Emprestimo
formEmprestimo mEmprestimo = renderBootstrap $ Emprestimo 
    <$> areq intField "Cliente Id: " (fmap emprestimoCliid mEmprestimo)
    <*> areq intField "Livro Id: " (fmap emprestimoLivid mEmprestimo)
    <*> areq dayField "Data emprestimo: " (fmap emprestimoData_emp mEmprestimo)
    <*> areq dayField "Data Devolucao: " (fmap emprestimoData_dev mEmprestimo)

getEmprestimoR :: Handler Html
getEmprestimoR = do 
    (widget,enctype) <- generateFormPost (formEmprestimo Nothing)
    defaultLayout $ do
        addStylesheet $ StaticR css_bootstrap_css
        [whamlet|
            <form action=@{EmprestimoR} method=post>
                <h3>Cadastro de Emprestimo</h3>
                <br><h3>-------------------</h3><br>
                ^{widget}
                <input type="submit" value="cadastrar">
                <br><br>
                <a href=@{HomeR} class="btn btn-primary btn-sm active" role="button" aria-pressed="true">Principal
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a href=@{TodosEmprestimosR} class="btn btn-primary btn-sm active" role="button" aria-pressed="true">Lista Todos
        |]

postEmprestimoR :: Handler Html
postEmprestimoR = do
    ((res,_),_) <- runFormPost (formEmprestimo Nothing)
    case res of
        FormSuccess emprestimo -> do
            runDB $ insert emprestimo
            redirect EmprestimoR
        _ -> redirect HomeR
    
getTodosEmprestimosR :: Handler Html
getTodosEmprestimosR = do 
    emprestimos <- runDB $ selectList [] [Asc EmprestimoId]
    defaultLayout $ do
        addStylesheet $ StaticR css_bootstrap_css
        $(whamletFile "templates/emprestimo.hamlet")

getEmprestimoPerfilR :: EmprestimoId -> Handler Html
getEmprestimoPerfilR empid = do 
    emprestimo <- runDB $ get404 empid
    defaultLayout $ do 
        addStylesheet $ StaticR css_bootstrap_css
        [whamlet|
            <h1>
                Cliente ID #{emprestimoCliid emprestimo}
            <div>
                Livro ID: #{emprestimoLivid emprestimo}
            <div>
                Data Emprestimo: #{emprestimoData_emp emprestimo}
            <div>
                Data Devolucao: #{emprestimoData_dev emprestimo}
            <br><br><a href=@{TodosEmprestimosR} class="btn btn-primary btn-sm active" role="button" aria-pressed="true">Voltar
        |]

postEmprestimoApagarR :: EmprestimoId -> Handler Html
postEmprestimoApagarR empid = do
    runDB $ get404 empid
    runDB $ delete empid
    redirect TodosEmprestimosR

getEmprestimoAlteraR :: EmprestimoId -> Handler Html
getEmprestimoAlteraR empid = do
    emprestimo <- runDB $ get404 empid
    (widget,enctype) <- generateFormPost (formEmprestimo $ Just emprestimo)
    defaultLayout $ do
        addStylesheet $ StaticR css_bootstrap_css
        [whamlet|
            <form action=@{EmprestimoAlteraR empid} method=post>
                ^{widget}
                <input type="submit" value="Atualizar">
                <br><br><a href=@{TodosEmprestimosR} class="btn btn-primary btn-sm active" role="button" aria-pressed="true">Voltar
        |]

postEmprestimoAlteraR :: EmprestimoId -> Handler Html
postEmprestimoAlteraR empid = do
    emprestimo <- runDB $ get404 empid
    ((res,_),_) <- runFormPost (formEmprestimo $ Just emprestimo) 
    case res of
        FormSuccess emprestimoNovo -> do
            runDB $ replace empid emprestimoNovo
            redirect TodosEmprestimosR
        _ -> redirect HomeR

{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Emprestimo where

import Import
import Database.Persist.Postgresql
import Database.Persist
import Database.Persist.Sql

formEmpr :: LivroId -> Form Emprestimo
formEmpr livid = renderBootstrap $ Emprestimo
    <$> areq (selectField cliLista) "Cliente: " Nothing
    <*> pure livid
    <*> areq dayField "Data Emprestimo: " Nothing
    <*> areq dayField "Data Devolucao: " Nothing

cliLista = do
    entidades <- runDB $ selectList [] [Asc ClienteNome]
    optionsPairs $ fmap (\ent -> (clienteNome $ entityVal ent, entityKey ent)) entidades


getTodosEmprestimoR :: Handler Html
getTodosEmprestimoR = do
    let sql = "SELECT ?? FROM livro LEFT JOIN emprestimo ON livro.id=emprestimo.livid \
            \WHERE emprestimo.data_emp IS NULL;"
    livros <- runDB $ rawSql sql []
    defaultLayout $(whamletFile "templates/emprestimos.hamlet")

getEmprestarClienteR :: LivroId -> Handler Html
getEmprestarClienteR livid = do
    runDB $ get404 livid
    msg <- getMessage
    (widget,enctype) <- generateFormPost (formEmpr livid)
    defaultLayout $ do
        addStylesheet $ StaticR css_bootstrap_css
        [whamlet|
            $maybe mensagem <- msg
                ^{mensagem}
            <form action=@{EmprestarClienteR livid} method=post enctype=#{enctype}>
                <h2>#{show $ fromSqlKey livid}
                ^{widget}
                <input type="submit" value="Cadastrar">
                <a href=@{HomeR} class="btn btn-primary btn-sm active" role="button" aria-pressed="true">Principal
        |]

postEmprestarClienteR :: LivroId -> Handler Html
postEmprestarClienteR livid = do
    ((res,_),_) <- runFormPost (formEmpr livid)
    case res of
        FormSuccess empr -> do
            _ <- runDB $ insert empr
            setMessage [shamlet|
                 <h3> Emprestimo cadastrado com sucesso
            |]
            redirect (EmprestarClienteR livid)
        _ -> redirect HomeR



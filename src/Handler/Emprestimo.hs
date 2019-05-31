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

getTodosEmprestimoR :: Handler Html
getTodosEmprestimoR = do
    let sql = "SELECT ?? FROM livro LEFT JOIN emprestimo ON livro.id=emprestimo.livid \
            \WHERE emprestimo.data_emp IS NULL;"
    livros <- runDB $ rawSql sql []
    defaultLayout $(whamletFile "templates/emprestimos.hamlet")

getEmprestarClienteR :: LivroId -> Handler Html
getEmprestarClienteR livid = do
    defaultLayout $ do
        [whamlet|
            Oi
        |]

postEmprestarClienteR :: LivroId -> Handler Html
postEmprestarClienteR livid = do
    defaultLayout $ do
        [whamlet|
            Oi
        |]



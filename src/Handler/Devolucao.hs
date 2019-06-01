{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Devolucao where

import Import
import Database.Persist.Postgresql
import Database.Persist
import Database.Persist.Sql


getTodosDevolucaoR :: Handler Html
getTodosDevolucaoR = do
    -- let sql_ = "SELECT ??,??,??,??,?? FROM emprestimo \
    --    \INNER JOIN cliente ON emprestimo.cliid=cliente.id \
    --    \INNER JOIN livro ON emprestimo.livid=livro.id \
    --    \WHERE emprestimo.data_emp IS NOT NULL;"
    let sql_ = "SELECT ?? FROM emprestimo \
        \INNER JOIN cliente ON emprestimo.cliid=cliente.id \
        \INNER JOIN livro ON emprestimo.livid=livro.id \
        \WHERE emprestimo.data_emp IS NOT NULL;"
    devolucoes <- runDB $ rawSql sql_ []
    defaultLayout $(whamletFile "templates/devolucoes.hamlet")

postDevolverApagarR :: EmprestimoId -> Handler Html
postDevolverApagarR empid = do
    runDB $ get404 empid
    runDB $ delete empid
    redirect TodosDevolucaoR


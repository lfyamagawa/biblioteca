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
    let sql_ = "SELECT ?? FROM emprestimo \
        \RIGHT JOIN cliente ON emprestimo.cliid=cliente.id \
        \RIGHT JOIN livro ON emprestimo.livid=livro.id \
        \WHERE emprestimo.data_emp IS NOT NULL;"
    devolucoes <- runDB $ rawSql sql_ []
    defaultLayout $ do
        addStylesheet $ StaticR css_bootstrap_css
        $(whamletFile "templates/devolucoes.hamlet")

postDevolverApagarR :: EmprestimoId -> Handler Html
postDevolverApagarR empid = do
    _ <- ($) runDB $ get404 empid
    _ <- ($) runDB $ delete empid
    redirect TodosDevolucaoR


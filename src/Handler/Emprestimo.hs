{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Emprestimo where

import Import
import Database.Persist.Postgresql
import Database.Persist.Sql

getTodosEmprestimoR :: Handler Html
getTodosEmprestimoR = do
    --let sql = "SELECT * FROM \"livro\" LEFT JOIN \"emprestimo\" ON l.id = e.livid WHERE e.data_emp IS NULL;"
    livros <- runDB $ rawSql sql []
    defaultLayout $(whamletFile "templates/emprestimos.hamlet")
        where sql = "SELECT id \
            \FROM livro \
            \LEFT JOIN emprestimo ON livro.id=emprestimo.livid \
            \WHERE emprestimo.data_emp IS NULL;"


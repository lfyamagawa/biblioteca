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
    defaultLayout $ do
        addStylesheet $ StaticR css_bootstrap_css
        $(whamletFile "templates/emprestimos.hamlet")

getEmprestarClienteR :: LivroId -> Handler Html
getEmprestarClienteR livid = do
    _ <- ($) runDB $ get404 livid
    msg <- getMessage
    (widget,enctype) <- generateFormPost (formEmpr livid)
    defaultLayout $ do
        addStylesheet $ StaticR css_bootstrap_css
        [whamlet|
        
        <div class="container table-responsive">
          <table class="table">
           <tr>
               <td height="50px">
           <tr>
               <td width="350px"  height="80px">
        
               <td align="center" style="background-color:steelblue">
                   <img width="100" height="100"src=@{StaticR imgs_emprestar_png}>
                   
               <td width="350px">
               
          <table class="table">       
           <tr>
               <td width="2500px"  height="80px">
               
               <td class="container text-center" style="background-color:skyblue">
                   $maybe mensagem <- msg
                        ^{mensagem}
                <br>
                     <form action=@{EmprestarClienteR livid} method=post enctype=#{enctype}>
                        <h2>#{show $ fromSqlKey livid}
                            ^{widget}
                              &nbsp;&nbsp;
                                 <button type="submit button" class="btn btn-primary btn-block">
                                   EMPRESTAR
                              &nbsp;&nbsp;       
                    
                     <a href=@{HomeR} type="button" class="btn btn-primary btn-block">
                                   VOLTAR
                     
              <td width="2500px">      
                        
        |]
        
        
        
        
        
        


postEmprestarClienteR :: LivroId -> Handler Html
postEmprestarClienteR livid = do
    ((res,_),_) <- runFormPost (formEmpr livid)
    case res of
        FormSuccess empr -> do
            _ <- ($) runDB $ insert empr
            setMessage [shamlet|
                 <h3> Emprestimo cadastrado com sucesso
            |]
            redirect (EmprestarClienteR livid)
        _ -> redirect HomeR



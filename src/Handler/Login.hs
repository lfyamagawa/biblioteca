{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Login where

import Import
import Database.Persist.Postgresql

formLogin :: Form Funcionario
formLogin = renderBootstrap $ Funcionario 
        <$> areq emailField "E-mail:" Nothing
        <*> areq passwordField "Senha: " Nothing
    
getLoginR :: Handler Html
getLoginR = do 
    (widget,enctype) <- generateFormPost formLogin
    msg <- getMessage
    defaultLayout $ do
        addStylesheet $ StaticR css_bootstrap_css
        [whamlet|
        
        <div class="container table-responsive">
          <table class="table">
           <tr>
               <td height="50px">
           <tr>
               <td width="400px"  height="80px">
        
               <td align="center" style="background-color:steelblue">
                   <img width="100" height="100"src=@{StaticR imgs_login_jpg}>
                   
               <td width="400px">
               
          <table class="table">       
           <tr>
               <td width="2500px"  height="80px">
               
               <td class="container text-center" style="background-color:skyblue">
                   $maybe mensagem <- msg
                      ^{mensagem}
                <br>
    
                    <form action=@{LoginR} method=post>
                         ^{widget}
                          &nbsp;&nbsp;
                             <button type="submit button" class="btn btn-primary btn-block">
                               ENTRAR
                          &nbsp;&nbsp;       
                
                    <a href=@{HomeR} type="button" class="btn btn-primary btn-block">
                               VOLTAR
                     
              <td width="2500px">      
                        
        |]



postLoginR :: Handler Html
postLoginR = do
    ((res,_),_) <- runFormPost formLogin
    case res of
        FormSuccess (Funcionario "root@root123.com" "root") -> do 
            setSession "_ID" "root"
            redirect AdminR
        FormSuccess funcionario -> do
            funBanco <- runDB $ getBy $ UniqueRestEmail (funcionarioEmail funcionario)
            case funBanco of 
                Just funcionarioValido -> do 
                    if ((funcionarioSenha funcionario) == (funcionarioSenha $ entityVal funcionarioValido)) then do 
                        setSession "_ID" (funcionarioEmail $ entityVal funcionarioValido)
                        redirect HomeR
                    else do
                        setMessage [shamlet|
                            <h1>
                                Senha invalida
                        |]
                        redirect LoginR
                        
                Nothing -> do
                    setMessage [shamlet|
                        Usuario nao encontrado
                    |]
                    redirect LoginR
        _ -> redirect HomeR
    
postLogoutR :: Handler Html
postLogoutR = do 
    deleteSession "_ID"
    redirect HomeR
    
getAdminR :: Handler Html
getAdminR = do 
    defaultLayout $ do 
        addStylesheet $ StaticR css_bootstrap_css
        [whamlet|
            <h2>
                BEM-VINDO ADMIN!!!
            <br><br>
            <a href=@{HomeR} class="btn btn-primary btn-sm active" role="button" aria-pressed="true">Principal
                
        |]

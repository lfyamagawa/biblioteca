{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Login where

import Import
-- import Database.Persist.Postgresql

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
            $maybe mensagem <- msg
                ^{mensagem}
            <form action=@{LoginR} method=post>
                ^{widget}
                <input type="submit" value="entrar">
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

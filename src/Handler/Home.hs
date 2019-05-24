{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Home where

import Import
import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3)

getHomeR :: Handler Html
getHomeR = do
    defaultLayout $ do
        addStylesheet $ StaticR css_bootstrap_css
        [whamlet|
            <div class="container">
                <!-- <div class="alert alert-primary" role="alert"> -->
                <span class="badge badge-pill badge-success">
                    Sucesso
        |]

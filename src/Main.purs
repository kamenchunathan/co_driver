module Main where

import Prelude

import AppM (runAppM)
import Component.Router (Query(..))
import Component.Router as Router
import Data.Maybe (Maybe(..))
import Data.Route (routeCodec)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class.Console (log)
import Halogen as H
import Halogen.Aff (awaitBody, runHalogenAff)
import Halogen.VDom.Driver (runUI)
import Routing.Duplex (parse)
import Routing.PushState (makeInterface, matchesWith)

main :: Effect Unit
main = runHalogenAff do
  log "Shikamoo wadau, app yaanza"
  body <- awaitBody
  let rootComponent = H.hoist runAppM Router.component
  nav <- H.liftEffect makeInterface
  halogenIO <- runUI rootComponent nav body

  void $ H.liftEffect $ matchesWith
    (parse routeCodec)
    ( \old new -> do
        H.liftEffect $ log $ "old route: " <> (show old) <> " new route: " <> (show new)
        when (old /= Just new) $ launchAff_ do
          _resp <- halogenIO.query $ H.mkTell $ Navigate new
          pure unit
    )
    nav


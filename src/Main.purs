module Main where

import Prelude

import AppM (runAppM)
import Component.Router (Query(..))
import Component.Router as Router
import Data.Either (Either(..), hush)
import Data.List (index)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Route (Route(..), routeCodec)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class.Console (log, logShow)
import Halogen as H
import Halogen.Aff (awaitBody, runHalogenAff)
import Halogen.VDom.Driver (runUI)
import Routing.Duplex (parse)
import Routing.Parser as RouteParser
import Routing.PushState (makeInterface, matchesWith)
import Routing.Types (RoutePart(..))
import Web.Event.Event (EventType(..), preventDefault, target)
import Web.Event.EventTarget (addEventListener, eventListener)
import Web.HTML.HTMLAnchorElement (fromEventTarget, toHTMLHyperlinkElementUtils)
import Web.HTML.HTMLElement (toEventTarget)
import Web.HTML.HTMLHyperlinkElementUtils (href, pathname)

main :: Effect Unit
main = runHalogenAff do
  log "Shikamoo wadau, app yaanza"
  body <- awaitBody
  let rootComponent = H.hoist runAppM Router.component
  nav <- H.liftEffect makeInterface
  halogenIO <- runUI rootComponent nav body

  H.liftEffect do
    listener <- eventListener \e -> do
      case (target e) of
        Just t -> do
          case (fromEventTarget t) of
            Just achorTag -> do
              uri <- href $ toHTMLHyperlinkElementUtils achorTag
              path <- pathname $ toHTMLHyperlinkElementUtils achorTag
              log $ "link clicked: " <> uri
              case index (RouteParser.parse identity uri) 2 of
                Just (Path "localhost:5173") -> do
                  preventDefault e
                  launchAff_ $ void $ halogenIO.query $ H.mkTell $ LocalLinkClicked $ fromMaybe NotFound $ hush$ parse routeCodec path
                _ -> pure unit

            Nothing -> pure unit
        -- navigate nav 
        Nothing -> pure unit

    addEventListener (EventType "click") listener false (toEventTarget body)

  let
    onUrlChange =
      ( matchesWith
          (parse routeCodec)
          ( \old new -> do
              H.liftEffect $ log $ "old route: " <> (show old) <> " new route: " <> (show new)
              when (old /= Just new) $ launchAff_ do
                void $ halogenIO.query $ H.mkTell $ Navigate new
          )
          nav
      )
  void $ H.liftEffect onUrlChange


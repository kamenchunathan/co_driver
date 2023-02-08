module Page.Game where

import Prelude

import Data.Route (Route)
import Effect.Class (class MonadEffect)
import Effect.Console (log)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Web.Event.Event (Event)

type State =
  { game_id :: String
  }

initialState :: String -> State
initialState game_id = { game_id }

data Action
  = LogState
  | NoOp

data PageAction
  = NavigateTo Route Event
  | PrintState

handleAction :: forall m. MonadEffect m => Action -> H.HalogenM State Action () PageAction m Unit
handleAction = case _ of
  LogState -> H.raise PrintState
  NoOp -> H.liftEffect $ log "Game NoOp: Put something here instead"

render :: forall cs m. State -> H.ComponentHTML Action cs m
render { game_id } = HH.div []
  [ HH.p [] [ HH.text "Game Page" ]
  , HH.div
      []
      [ HH.h3 [] [ HH.text $ "Game: " <> game_id ]
      , HH.text "game will start soon"
      , HH.button [ HE.onClick \_ -> LogState ] [ HH.text "log state" ]
      ]
  ]

component :: forall q m. MonadEffect m => H.Component q String PageAction m
component = H.mkComponent
  { initialState
  , render
  , eval: H.mkEval H.defaultEval { handleAction = handleAction }
  }

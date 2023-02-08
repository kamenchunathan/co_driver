module Page.Home where

import Prelude

import Data.Route (Route(..))
import Effect.Class (class MonadEffect)
import Effect.Console (log)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Web.Event.Event (Event)
import Web.UIEvent.MouseEvent (toEvent)

type State = {}

initialState :: forall input. input -> State
initialState _ = {}

data Action
  = SelectGame Event String
  | NoOp

data PageAction =
  NavigateTo Route Event

handleAction :: forall m. MonadEffect m => Action -> H.HalogenM State Action () PageAction m Unit
handleAction = case _ of
  SelectGame e g -> H.raise $ NavigateTo (Game g) e

  NoOp -> H.liftEffect $ log "NoOp: Put something here instead"

render :: forall cs m. State -> H.ComponentHTML Action cs m
render _ = HH.div []
  [ HH.p [] [ HH.text "Home page" ]
  , HH.div
      []
      [ HH.a
          [ HP.class_ $ H.ClassName "bg-red-500"
          , HP.href "/wow"
          ]
          [ HH.text "Push State routing doesn't work with anchor tags" ]
      ]
  , HH.div
      []
      [ HH.h3 [] [ HH.text "Texting out pushstate nave with buttons and events" ]
      , HH.button
          [ HE.onClick \e -> SelectGame (toEvent e) "23" ]
          [ HH.text "Go to game 1" ]
      ]
  ]

component :: forall q m. MonadEffect m => H.Component q Unit PageAction m
component = H.mkComponent
  { initialState
  , render
  , eval: H.mkEval H.defaultEval { handleAction = handleAction }
  }

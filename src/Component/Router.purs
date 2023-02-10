module Component.Router (component, Query(..)) where

import Prelude

import Data.Maybe (Maybe(..), fromMaybe)
import Data.Route (Route(..))
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect)
import Halogen as H
import Halogen.HTML as HH
import Navigate (class Navigate, navigate)
import Page.Game as GamePage
import Page.Home as HomePage
import Page.NotFound as NotFound
import Page.Wow as Wow
import Routing.PushState (PushStateInterface)
import Type.Proxy (Proxy(..))

type AppState =
  { current_route :: Maybe Route
  , nav :: PushStateInterface
  }

initialState :: PushStateInterface -> AppState
initialState nav =
  { current_route: Nothing
  , nav
  }

data Action
  = Initialize
  | HandleHomePageAction HomePage.PageAction
  | HandleGamePageAction GamePage.PageAction

data Query a
  = Navigate Route a
  | LocalLinkClicked Route a

type ChildSlots =
  ( homePage :: forall query. H.Slot query HomePage.PageAction Unit
  , gamePage :: forall query. H.Slot query GamePage.PageAction Unit
  )

handleAction
  :: forall o m
   . MonadEffect m
  => MonadAff m
  => Navigate m
  => Action
  -> H.HalogenM AppState Action ChildSlots o m Unit
handleAction = case _ of
  Initialize -> pure unit
  HandleHomePageAction (HomePage.NavigateTo page _) -> do
    st <- H.get
    when (st.current_route /= Just page) do
      navigate st.nav page
  HandleGamePageAction (GamePage.NavigateTo page _) -> do
    st <- H.get
    when (st.current_route /= Just page) do
      navigate st.nav page

handleQuery :: forall a o m. MonadEffect m => Navigate m => Query a -> H.HalogenM AppState Action ChildSlots o m (Maybe a)
handleQuery = case _ of
  Navigate route a -> do
    mRoute <- H.gets _.current_route
    when (mRoute /= Just route) $ H.modify_ _ { current_route = Just route }
    pure (Just a)
  LocalLinkClicked route a -> do
    nav <- H.gets _.nav
    navigate nav route
    pure (Just a)

render :: forall m. MonadAff m => AppState -> H.ComponentHTML Action ChildSlots m
render st = case fromMaybe NotFound st.current_route of
  Home -> HH.slot (Proxy :: _ "homePage") unit HomePage.component unit HandleHomePageAction
  Game game_id -> HH.slot (Proxy :: _ "gamePage") unit GamePage.component game_id HandleGamePageAction
  Wow -> Wow.render
  NotFound -> NotFound.render

component :: forall o m. MonadAff m => Navigate m => H.Component Query PushStateInterface o m
component = H.mkComponent
  { initialState
  , render
  , eval: H.mkEval H.defaultEval
      { handleAction = handleAction
      , handleQuery = handleQuery
      , initialize = Just Initialize
      }

  }

module Page.Wow where

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

render :: forall a cs m. H.ComponentHTML a cs m
render =
  HH.div []
    [ HH.h1 [] [ HH.text "Wow" ]
    , HH.div
        []
        [ HH.text "Say wow"
        , HH.span
            []
            [ HH.a
                [ HP.href "/" ]
                [ HH.text "Home Page" ]
            ]
        ]
    ]


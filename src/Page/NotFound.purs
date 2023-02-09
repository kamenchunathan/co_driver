module Page.NotFound where

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

render :: forall a cs m. H.ComponentHTML a cs m
render =
  HH.div []
    [ HH.h1 [] [ HH.text "Page Not found" ]
    , HH.div
        []
        [ HH.text "The Page you're looking for cannot be found. We all get lost go back to the "
        , HH.span
            []
            [ HH.a
                [ HP.href "/" ]
                [ HH.text "Home Page" ]
            ]
        ]
    ]


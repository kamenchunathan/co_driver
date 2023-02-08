{ name = "my-project"
, dependencies =
  [ "aff"
  , "console"
  , "effect"
  , "foreign"
  , "halogen"
  , "maybe"
  , "prelude"
  , "routing"
  , "routing-duplex"
  , "web-events"
  , "web-uievents"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}

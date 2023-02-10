{ name = "my-project"
, dependencies =
  [ "aff"
  , "console"
  , "effect"
  , "either"
  , "foreign"
  , "halogen"
  , "lists"
  , "maybe"
  , "prelude"
  , "routing"
  , "routing-duplex"
  , "web-events"
  , "web-html"
  , "web-uievents"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}

module ListInlay exposing (main)

import Debug
import Html exposing (Attribute, Html, a, div, h4, text)
import Html.App as App
import Html.Attributes exposing (attribute, class, href, id, property)
import Html.Events exposing (on, onClick, onWithOptions)
import Json.Decode as Jd
import Json.Encode as Je


main =
  App.beginnerProgram
    { model = model
    , update = update
    , view = view
    }

-- MODEL

type alias Model =
  { message : String }

model : Model
model =
  { message = "" }

-- UPDATE

type Msg
  = Test


update : Msg -> Model -> Model
update msg model =
  case msg of
    Test -> { model | message = "Hello" }


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ div [] [ text <| toString model ]
    , div
      [ class "panel-group"
      , id "accordion"
      , attribute "role" "tablist"
      , attribute "aria-multiselectable" "true"
      ]
      [ div
        [ class "panel panel-default" ]
        [ div
          [ class "panel-heading"
          , id "headingOne"
          , aProperty "role" "tab"
          , attribute "role" "tab"
          ]
          [ h4
            [ class "panel-title" ]
            [ a
              [ attribute "role" "button"
              , attribute "data-toggle" "collapse"
              , attribute "data-parent" "#accordion"
              , href "#collapseOne"
              , attribute "aria-expanded" "true"
              , attribute "aria-controls" "collapseOne"
              , onClick Test
              ]
              [ text "Collapsible Group Item #1" ]
            ] -- collapse btn one
          ] -- head collapse grp one
        , div
          [ id "collapseOne"
          , class "panel-collapse collapse"
          , attribute "role" "tabpanel"
          , attribute "aria-labelledby" "headingOne"
          ]
          [ div [ class "panel-body" ]
            [ text model.message ]
          ] -- grp one body
        ] -- panel collapse grp one
      ] -- panel grp
    ]


aProperty : String -> String -> Attribute msg
aProperty name value =
  property name (Je.string value)


{-- They ain't working :/.
showInlay : Msg -> Attribute Msg
showInlay msg =
  on "shown.bs.collapse" (Jd.succeed msg)

showCollapse : Msg -> Attribute Msg
showCollapse msg =
  onWithOptions "show.bs.collapse" { stopPropagation = True, preventDefault = True } (Jd.succeed msg)
--}

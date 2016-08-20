module ListInlay exposing (main)

import Debug
import Html exposing (Attribute, Html, a, br, button, div, h4, li, span, text, ul)
import Html.App as App
import Html.Attributes exposing (attribute, class, href, id, property, type')
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

type alias Entry =
  { id : Int
  , name : String
  , address : String
  }

type alias Model =
  { entries : List Entry }

model : Model
model =
  { entries = [ {id = 1, name = "Henry Lexington", address = "Nordwalk St."}
              , {id = 2, name = "Jordan Yellow", address = "Civic Blvd" }
              ]
  }

-- UPDATE

type Msg
  = Test


update : Msg -> Model -> Model
update msg model =
  case msg of
    Test -> model


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ (viewEntries model.entries) ]


viewEntries : List Entry -> Html Msg
viewEntries es =
  div
    [ class "panel-group container-fluid"
    , id "accordion"
    , attribute "role" "tablist"
    , attribute "aria-multiselectable" "true"
    ]
    (List.map viewEntry es)


viewEntry : Entry -> Html Msg
viewEntry e =
  div
    [ class "panel panel-default row" ]
    [ div
      [ class "panel-heading col-sm-12"
      , id <| "entry-" ++ (toString e.id)
      , attribute "role" "tab"
      ]
      [ div [ class "panel-title" ]
        [ div [ class "row", id <| "entryValues-" ++ (toString e.id) ]
          [ div [ class "col-xs-12 col-sm-6" ]
            [ text "Name:"
            , br [] []
            , text e.name
            ]
          , div [ class "col-xs-12 col-sm-6" ]
            [ text "Address:"
            , br [] []
            , text e.address
            ]
          ]
        , div [ class "row", id <| "entryOps-" ++ (toString e.id) ]
          [ div [ class "col-xs-12 col-sm-6" ]
            [ text <| "Some information about entry-" ++ (toString e.id) ]
          , div [ class "col-xs-12 col-sm-6" ]
            [ span
              []
              [ button [ class "btn-xs btn-info" ]
                [ span [ class "glyphicon glyphicon-pencil" ] [] ]
              , button
                [ class "btn-xs btn-info"
                , attribute "role" "button"
                , attribute "data-toggle" "collapse"
                , attribute "data-parent" "#accordion"
                , attribute "data-target" <| "#entryInfo-" ++ (toString e.id)
                , attribute "aria-expanded" "false"
                , attribute "aria-controls" <| "entryInfo-" ++ (toString e.id)
                , type' "button"
                ]
                [ span [ class "glyphicon glyphicon-info-sign" ] [] ]
              , button [ class "btn-xs btn-danger" ]
                [ span [ class "glyphicon glyphicon-remove" ] [] ]
              ]
            ]
          ]
          , div
            [ class "row panel-collapse collapse"
            , id <| "entryInfo-" ++ (toString e.id)
            , attribute "role" "tabpanel"
            , attribute "aria-labelledby" <| "entryValues-" ++ (toString e.id)
            ]
            [ div
              [ class "panel-body col-xs-12 col-sm-12" ]
              [ text "Entry Detail" ]
            ]
          ] 
        ]
      ]

module ListInlay exposing (main)

import Debug
import Html exposing (Attribute, Html, a, br, button, div, h4, li, span, text, ul)
import Html.App as App
import Html.Attributes exposing (attribute, class, href, id, property, type')
import Html.Events exposing (onClick)
import Http
import Json.Decode as Jd exposing ((:=))
import Json.Encode as Je
import Maybe exposing (withDefault)
import Task


main =
  App.program
    { init = init
    , update = update
    , view = view
    , subscriptions = \_ -> Sub.none
    }


-- MODEL

type alias Entry =
  { id : Int
  , name : String
  , address : String
  , details : Maybe String
  }


newEntry : Entry
newEntry =
  { id = -1
  , name = ""
  , address = ""
  , details = Nothing
  }


type alias Model =
  { entries : List Entry }


init : (Model, Cmd Msg)
init =
  ( {--{ entries = [ { id = 1
                , name = "Henry Lexington"
                , address = "Nordwalk St."
                , details = Nothing
                }
              , { id = 2
                , name = "Jordan Yellow"
                , address = "Civic Blvd"
                , details = Nothing
                }
              ]
    }--}
    { entries = [] }
  , fetchEntries
  )


-- TASK

fetchEntries : Cmd Msg
fetchEntries =
  let
    url =
      "http://127.0.0.1:5000/entries"
    task =
      Http.get decodeEntries url
  in
    Task.perform FetchEntriesFail FetchEntriesSucceed task


fetchDetails : Int -> Cmd Msg
fetchDetails id =
  let
    url =
      "http://127.0.0.1:5000/entries/" ++ (toString id)
    task =
      Http.get decodeEntry url
  in
    Task.perform FetchDetailsFail FetchDetailsSucceed task


decodeEntries : Jd.Decoder (List Entry)
decodeEntries =
  Jd.list decodeEntry


decodeEntry : Jd.Decoder Entry
decodeEntry =
  Jd.object4
    Entry
    ("id" := Jd.int)
    ("name" := Jd.string)
    ("address" := Jd.string)
    (Jd.maybe <| "details" := Jd.string)


-- UPDATE

type Msg
  = Remove Int
  | Details Int
  | FetchEntriesFail Http.Error
  | FetchEntriesSucceed (List Entry)
  | FetchDetailsFail Http.Error
  | FetchDetailsSucceed Entry


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Remove id ->
      let
        entries =
          removeEntry model.entries id
      in
        ( { model | entries = entries }, Cmd.none )
  
    Details id ->
      let
        cmd =
          if hasDetails <| getEntry model.entries id then
            Cmd.none
          else
            fetchDetails id
      in
        ( model, cmd )

    FetchEntriesFail err ->
      ( model, Cmd.none )

    FetchEntriesSucceed es ->
      ( { model | entries = es }, Cmd.none )

    FetchDetailsFail err ->
      ( model, Cmd.none )

    FetchDetailsSucceed entry ->
      let
        entries =
          removeEntry model.entries entry.id
      in
        ( { model | entries = List.sortBy .id <| entry :: entries }, Cmd.none )


removeEntry : List Entry -> Int -> List Entry
removeEntry es id =
  List.filter (\e -> e.id /= id) es


getEntry : List Entry -> Int -> Entry
getEntry es id =
  let
    filtered =
      List.filter (\e -> e.id == id) es
  in
    case List.head filtered of
      Just e -> e
      Nothing -> newEntry


hasDetails : Entry -> Bool
hasDetails e =
  case e.details of
    Just _ -> True
    Nothing -> False


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ (viewEntries model.entries)
    , text <| toString model
    ]


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
                --, attribute "data-parent" "#accordion"
                , attribute "data-target" <| "#entryInfo-" ++ (toString e.id)
                , attribute "aria-expanded" "false"
                , attribute "aria-controls" <| "entryInfo-" ++ (toString e.id)
                , type' "button"
                , onClick <| Details e.id
                ]
                [ span [ class "glyphicon glyphicon-info-sign" ] [] ]
              , button [ class "btn-xs btn-danger", onClick <| Remove e.id  ]
                [ span [ class "glyphicon glyphicon-remove" ] [] ]
              ]
            ]
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
          [ text <| withDefault "" e.details ]
        ]
    ]

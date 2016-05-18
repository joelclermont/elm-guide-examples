module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Http
import Task
import Json.Decode as Json


main : Program Never
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscription
        }



-- MODEL


type alias Model =
    { topic : String
    , gifUrl : String
    , errorMessage : String
    }



-- UPDATE


type Msg
    = MorePlease
    | ChangeTopic String
    | FetchSucceed String
    | FetchFail Http.Error


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MorePlease ->
            ( model, getRandomGif model.topic )
            
        ChangeTopic newTopic ->
            ( { model | topic = newTopic }, Cmd.none )

        FetchSucceed newUrl ->
            ( Model model.topic newUrl "", Cmd.none )

        FetchFail error ->
            ( { model | errorMessage = (toString error) }, Cmd.none )


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let
        url =
            "http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
    in
        Task.perform FetchFail FetchSucceed (Http.get decodeGifUrl url)


decodeGifUrl : Json.Decoder String
decodeGifUrl =
    Json.at [ "data", "image_url" ] Json.string



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ topicSelect model.topic
        , img [ src model.gifUrl ] []
        , button [ onClick MorePlease ] [ text "More Please!" ]
        , div [] [ text model.errorMessage ]
        ]


topicSelect : String -> Html Msg
topicSelect topic =
    select [ Html.Events.onInput ChangeTopic ]
    [ option [] [ text "dog" ]
    , option [] [ text "cat" ]
    , option [] [ text "Macgyver" ]
    ]

-- SUBSCRIPTIONS


subscription : Model -> Sub Msg
subscription model =
    Sub.none



-- INIT


init : ( Model, Cmd Msg )
init =
    ( Model "cats" "./images/waiting.gif" "", Cmd.none )

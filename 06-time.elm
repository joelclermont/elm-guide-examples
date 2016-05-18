module Main exposing (..)

import Html exposing (Html, div, button)
import Html.App as App
import Html.Events exposing (onClick)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)


main : Program Never
main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { time : Time
    , paused : Bool
    }


type ClockHand
    = SecondHand
    | MinuteHand
    | HourHand


init : ( Model, Cmd Msg )
init =
    ( Model 0 False, Cmd.none )



-- UPDATE


type Msg
    = Tick Time
    | Pause


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Tick newTime ->
            ( { model | time = newTime }, Cmd.none )

        Pause ->
            ( { model | paused = not model.paused }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.paused then
        Sub.none
    else
        Time.every second Tick



-- VIEW


view : Model -> Html Msg
view model =
    let
        buttonText =
            if model.paused then
                "Resume"
            else
                "Pause"
    in
        div []
            [ svg [ viewBox "0 0 100 100", width "300px" ]
                [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
                , drawHand model.time SecondHand
                , drawHand model.time MinuteHand
                , drawHand model.time HourHand
                ]
            , button [ onClick Pause ] [ text buttonText ]
            , div [] [ text (toString model.time) ]
            ]


drawHand : Time -> ClockHand -> Svg.Svg msg
drawHand currentTime unit =
    case unit of
        SecondHand ->
            let
                angle =
                    turns (Time.inMinutes currentTime)
            in
                line [ x1 "50", y1 "50", x2 (handX angle 40), y2 (handY angle 40), stroke "#023963" ] []

        MinuteHand ->
            let
                angle =
                    turns (Time.inHours currentTime)
            in
                line [ x1 "50", y1 "50", x2 (handX angle 38), y2 (handY angle 38), stroke "#FF0000" ] []

        HourHand ->
            let
                angle =
                    turns ((Time.inHours currentTime) / 12)
            in
                line [ x1 "50", y1 "50", x2 (handX angle 25), y2 (handY angle 25), stroke "#00FF00" ] []


handX : Float -> Float -> String
handX angle length =
    toString (50 + length * sin angle)


handY : Float -> Float -> String
handY angle length =
    toString (50 - length * cos angle)

module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Random exposing (..)


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
    { dieFace1 : Int
    , dieFace2 : Int
    }



-- UPDATE


type Msg
    = Roll
    | NewFace ( Int, Int )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, Random.generate NewFace (pair (Random.int 1 6) (Random.int 1 6)) )

        NewFace ( newFace1, newFace2 ) ->
            ( Model newFace1 newFace2, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        dieSrc1 =
            dieFaceImage model.dieFace1

        dieSrc2 =
            dieFaceImage model.dieFace2
    in
        div []
            [ img [ src dieSrc1 ] []
            , img [ src dieSrc2 ] []
            , button [ onClick Roll ] [ text "Roll" ]
            ]


dieFaceImage : Int -> String
dieFaceImage dieValue =
    ("./images/dice-" ++ (toString dieValue) ++ ".png")



-- SUBSCRIPTIONS


subscription : Model -> Sub Msg
subscription model =
    Sub.none



-- INIT


init : ( Model, Cmd Msg )
init =
    ( Model 1 1, Cmd.none )

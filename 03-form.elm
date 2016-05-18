module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import String exposing (..)
import Char exposing (..)


main : Program Never
main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias ValidationError =
    ( String, String )


type alias Model =
    { name : String
    , age : String
    , password : String
    , passwordAgain : String
    , validationError : ValidationError
    }


model : Model
model =
    Model "" "" "" "" ( "green", "" )



-- UPDATE


type Msg
    = Name String
    | Age String
    | Password String
    | PasswordAgain String
    | Validate


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Age age ->
            { model | age = age }

        Password password ->
            { model | password = password }

        PasswordAgain password ->
            { model | passwordAgain = password }

        Validate ->
            { model | validationError = validate model }


validate : Model -> ValidationError
validate model =
    if Result.withDefault -1 (String.toInt model.age) == -1 then
        ( "red", "Enter a valid age" )
    else if model.password /= model.passwordAgain then
        ( "red", "Passwords do not match!" )
    else if length model.password < 8 then
        ( "red", "Password must be at least 8 characters" )
    else if not (any isDigit model.password) then
        ( "red", "Password must contain a number" )
    else if not (any isUpper model.password) then
        ( "red", "Password must contain an uppercase letter" )
    else if not (any isLower model.password) then
        ( "red", "Password must contain a lowercase letter" )
    else
        ( "green", "OK" )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ type' "text", placeholder "Name", onInput Name ] []
        , input [ type' "text", placeholder "Age", onInput Age ] []
        , input [ type' "password", placeholder "Password", onInput Password ] []
        , input [ type' "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
        , button [ onClick Validate ] [ text "Submit" ]
        , viewValidation model
        ]


viewValidation : Model -> Html msg
viewValidation model =
    let
        ( color, message ) =
            model.validationError
    in
        div [ style [ ( "color", color ) ] ] [ text message ]

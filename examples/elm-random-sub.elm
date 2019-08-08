module Main exposing (Model, main, subscriptions)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Random
import Time


diceRollInterval =
    2000


numberOfRolls =
    10


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { dieResult : Int
    , rollsToComplete : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 1 0, Cmd.none )


type Msg
    = StartRoll
    | Roll Time.Posix
    | NewResult Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StartRoll ->
            ( { model | rollsToComplete = numberOfRolls }
            , Cmd.none
            )

        Roll _ ->
            if model.rollsToComplete > 0 then
                ( { model | rollsToComplete = model.rollsToComplete - 1 }
                , Random.generate NewResult (Random.int 1 6)
                )

            else
                ( model, Cmd.none )

        NewResult result ->
            ( { model | dieResult = result }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.rollsToComplete of
        0 ->
            Sub.none

        _ ->
            Time.every (toFloat (diceRollInterval // model.rollsToComplete)) Roll


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text (String.fromInt model.dieResult) ]
        , button [ onClick StartRoll ] [ text "Roll" ]
        ]

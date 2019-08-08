module Main exposing (Model, main, subscriptions)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Process
import Random
import Task


diceRollInterval =
    1200


numberOfRolls =
    12


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
    = StartRolling
    | Roll
    | NewResult Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StartRolling ->
            update Roll { model | rollsToComplete = numberOfRolls }

        Roll ->
            ( model
            , Random.generate NewResult (Random.int 1 6)
            )

        NewResult result ->
            if model.rollsToComplete > 0 then
                ( Model result (model.rollsToComplete - 1)
                , Task.perform (always Roll) (Process.sleep (toFloat (diceRollInterval // (model.rollsToComplete - 1))))
                )

            else
                ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


rollingMessage : Model -> Html Msg
rollingMessage model =
    text
        (if model.rollsToComplete == 0 then
            "Rolling done!"

         else
            "Rolling the dice..."
        )


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text (String.fromInt model.dieResult) ]
        , button [ onClick StartRolling ] [ text "Roll" ]
        , div [] [ rollingMessage model ]
        ]

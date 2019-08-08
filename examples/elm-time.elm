module Main exposing (Model, main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Task
import Time



-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { zone : Time.Zone
    , time : Time.Posix
    , running : Bool
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Time.utc (Time.millisToPosix 0) True
    , Task.perform AdjustTimeZone Time.here
    )



-- UPDATE


type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone
    | RunningTogled


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )

        RunningTogled ->
            ( { model | running = not model.running }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.running of
        True ->
            Time.every 1000 Tick

        False ->
            Sub.none



-- VIEW


padWithZeros : Int -> String
padWithZeros number =
    if number < 10 then
        "0" ++ String.fromInt number

    else
        String.fromInt number


renderButton : Model -> Html Msg
renderButton model =
    button [ onClick RunningTogled ]
        [ text
            (case model.running of
                True ->
                    "Stop clock"

                False ->
                    "Resume clock"
            )
        ]


view : Model -> Html Msg
view model =
    let
        hour =
            padWithZeros (Time.toHour model.zone model.time)

        minute =
            padWithZeros (Time.toMinute model.zone model.time)

        second =
            padWithZeros (Time.toSecond model.zone model.time)
    in
    div []
        [ h1 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]
        , renderButton model
        ]
